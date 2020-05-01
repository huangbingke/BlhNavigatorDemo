//
//  NVBaseNavigator.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVBaseNavigator.h"
#import "NVBaseNavigator+Login.h"
#import "NSArray+NavigatorFunctional.h"

@interface NVCoreNavigationController ()

- (void)pushViewController:(UIViewController *)viewController withAnimation:(BOOL)animated;

@end

@interface NVBaseNavigator ()

@end


@implementation NVBaseNavigator {
    NSTimer *_checkBlockTimer; // 检查堵塞模式消失的事件
}
@synthesize mainNavigationController = _mainNavigationController;
@synthesize handleableURLScheme = _handleableURLScheme;
@synthesize fileNamesOfURLMapping = _fileNamesOfURLMapping;

- (id)init {
    self = [super init];
    if (self) {
        _urlActionWaitingList = [NSMutableArray array];
        _handleableURLScheme = @"dianping";
    }
    return self;
}

- (BOOL)animating {
    return self.mainNavigationController.inAnimating;
}

- (BOOL)inBlockMode {
    return [self.mainNavigationController presentedViewController] || self.animating;
}

- (void)checkTimerBlockModeDismiss {
    if (_urlActionWaitingList.count < 1) {
        [_checkBlockTimer invalidate];
        _checkBlockTimer = nil;
        return;
    }
    if (![self inBlockMode]) {
        [_checkBlockTimer invalidate];
        _checkBlockTimer = nil;
        [self flush];
    }
}

- (UIViewController *)handleOpenURLAction:(NVURLAction *)urlAction {
    if (!urlAction || !urlAction.url || !_mainNavigationController) {
        return nil;
    }
    
    if ([self inBlockMode]) {
        // in block mode, url action will send to waiting list
        [_urlActionWaitingList addObject:urlAction];
        if (!_checkBlockTimer) {
            _checkBlockTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(checkTimerBlockModeDismiss) userInfo:nil repeats:YES];
        }
        return nil;
    }
    
    if (urlAction.openExternal) {
        [self willOpenExternal:urlAction];
        // 设备系统为IOS 10.0或者以上的
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:urlAction.url options:@{} completionHandler:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:urlAction.url];
#pragma clang diagnostic pop
        }
        return nil;
    }
    
    if (![self shouldOpenURLAction:urlAction]) {
        return nil;
    }
    
    [self willOpenURLAction:urlAction];
    
    NSURL *url = urlAction.url;
    NSString *scheme = url.scheme;
    // check unhandleable url scheme
    if (!([self.handleableURLScheme caseInsensitiveCompare:scheme] == NSOrderedSame)) {
        [self willOpenExternal:urlAction];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:urlAction.url];
#pragma clang diagnostic pop
        }
        return nil;
    }
    
    // check unhandled url host
    NVURLPattern *pattern = [self matchPatternWithURLAction:urlAction];
    if (!pattern) {
        [self onMatchUnhandledURLAction:urlAction];
        return nil;
    }
    
    urlAction.urlPattern = pattern;
    // check unhandled class
    UIViewController *controller = [self obtainControllerWithPattern:pattern];
    if (!controller) {
        [self onMatchUnhandledURLAction:urlAction];
        return nil;
    }
    // notify match view controller
    [self onMatchViewController:controller withURLAction:urlAction];
    
    // handle login action
    if ([self handleLoginAction:urlAction]) {
        // login action handled, so should no to continue
        return nil;
    }
    
    // handle needs login action
    if ([self handleNeedsLoginAction:urlAction withController:controller]) {
        // needs login action hanled, so should no to continue
        return nil;
    }
    
    // check should open viewcontroller
    if (![controller isKindOfClass:[UIViewController class]]) {
        return nil;
    }
    if ([controller respondsToSelector:@selector(shouldShow:)]) {
        if (![((id <NVNavigatorViewControllerProtocal>)controller) shouldShow:urlAction]) {
            return nil;
        }
    }
    // open view controller
    [self openViewController:controller withURLAction:urlAction];
    
    return controller;
}

- (void)openViewController:(UIViewController *)controller withURLAction:(NVURLAction *)urlAction {
    controller.urlAction = urlAction;
    BOOL isSingleton = NO;
    if ([[controller class] respondsToSelector:@selector(isSingleton)]) {
        isSingleton = [[controller class] isSingleton];
    }
    if ([controller respondsToSelector:@selector(handleWithURLAction:)]) {
        if (![((id<NVNavigatorViewControllerProtocal>)controller) handleWithURLAction:urlAction]) {
            // handleWithURLAction returns NO
            return;
        }
    }
    if (isSingleton) {
        [self pushSingletonViewController:controller withURLAction:urlAction];
    } else {
        [self pushViewController:controller withURLAction:urlAction];
    }
}

- (void)pushSingletonViewController:(UIViewController *)controller withURLAction:(NVURLAction *)urlAction {
    if (!controller) {
        return;
    }
    
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.mainNavigationController.viewControllers];
    if ([controllers DP_existObjectMatch:^BOOL(UIViewController *obj) {
        return (obj == controller);
    }]) {
        if (controller != [controllers lastObject]) {
            NVNaviAnimation animation = NVNaviAnimationNone;
            if (_urlActionWaitingList.count > 0) {
                animation = NVNaviAnimationNone;
            } else {
                animation = urlAction.animation;
            }
            [self.mainNavigationController popToViewController:controller animated:(animation!=NVNaviAnimationNone)];
        }
        else {
            [controller viewWillAppear:NO];
            [controller viewDidAppear:NO];
        }
    } else {
        [self pushViewController:controller withURLAction:urlAction];
    }
}

- (void)pushViewController:(UIViewController *)controller withURLAction:(NVURLAction *)urlAction {
    // 如果是处理堵塞的页面，一次性压入所有页面，只有最后一个页面使用动画
    NVNaviAnimation animation = NVNaviAnimationNone;
    if (_urlActionWaitingList.count>0) {
        animation = NVNaviAnimationNone;
    } else {
        animation = urlAction.animation;
    }
    
    [self.mainNavigationController pushViewController:controller withAnimation:(animation!=NVNaviAnimationNone)];
}

- (void)flush {
    // push或开机时打开一个无效schema 此处会造成死循环 array和_urlActionWaitingList 是2个对象
    NSArray *array = _urlActionWaitingList;
    while (array.count > 0) {
        if ([self inBlockMode]) {
            if (!_checkBlockTimer) {
                _checkBlockTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(checkTimerBlockModeDismiss) userInfo:nil repeats:YES];
            }
            return;
        }
        if (_urlActionWaitingList.count > 0) {
            NVURLAction *urlAction = _urlActionWaitingList[0];
            [_urlActionWaitingList removeObject:urlAction];
            [self handleOpenURLAction:urlAction];
        }
    }
}

- (NVURLPattern *)matchPatternWithURLAction:(NVURLAction *)urlAction {
    if (urlAction.url.host.length < 1) {
        return nil;
    }
    
    NSString *host = urlAction.url.host;
    NSString *path = urlAction.url.path;
    NSString *key = [NSString stringWithFormat:@"%@%@", host, path];
    return [_urlMapping objectForKey:[key lowercaseString]];
}

- (Class)matchClassWithURLAction:(NVURLAction *)urlAction {
    NVURLPattern *pattern = [self matchPatternWithURLAction:urlAction];
    if (pattern) {
        return pattern.targetClass;;
    } else {
        return NULL;
    }
}

- (UIViewController *)obtainControllerWithPattern:(NVURLPattern *)pattern {
    if (pattern.targetClass == nil) return nil;
    Class class = pattern.targetClass;
    if ([class respondsToSelector:@selector(isSingleton)] && [class isSingleton]) {
        UIViewController *controller = [[self.mainNavigationController viewControllers] DP_match:^BOOL(UIViewController *controller) {
            return [controller isKindOfClass:class];
        }];
        return controller ?: [class new];
    }
    return [class new];
}

- (NSMutableDictionary *)loadPattern {
    if (_urlMapping) {
        [_urlMapping removeAllObjects];
    } else {
        _urlMapping = [NSMutableDictionary dictionary];
    }
    
    for (int i = 0; i < self.fileNamesOfURLMapping.count; i++) {
        NSString *fileName = self.fileNamesOfURLMapping[i];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (content) {
            NSArray *eachLine = [content componentsSeparatedByString:@"\n"];
            for (NSString *aString in eachLine) {
                NSString *lineString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (lineString.length < 1) {
                    // 空行
                    continue;
                }
                NSRange commentRange = [lineString rangeOfString:@"#"];
                if (commentRange.location == 0) {
                    // #在开头，表明这一行是注释
                    continue;
                }
                if (commentRange.location != NSNotFound) {
                    // 其后有注释，需要去除后面的注释
                    lineString = [lineString substringToIndex:commentRange.location];
                }
                if ([lineString rangeOfString:@":"].location != NSNotFound) {
                    NSString *omitString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSArray *kv = [omitString componentsSeparatedByString:@":"];
                    if (kv.count == 2) {
                        // got it
                        NSString *host = [kv[0] lowercaseString];
                        NSString *className = kv[1];
                        // DEBUG check
                        if (DEBUG) {
                            // check validate
                            if (host.length < 1) {
                                NSLog(@"[url mapping error] file(%@:%d) has no host!!!!", fileName, i);
                                continue;
                            }
                            if (className.length < 1) {
                                NSLog(@"[url mapping error] file(%@:%d) has no class name!!!!", fileName, i);
                                continue;
                            }

                            if (NSClassFromString(className) == NULL) {
                                NSLog(@"[url mapping error] class (%@) not exist!!!!", className);
                            }
                            if ([_urlMapping objectForKey:host]) {
                                NSLog(@"[url mapping error] host (%@) duplicate!!!!", host);
                            }
                        }
                        [_urlMapping setObject:[NVURLPattern patternWithClassName:className withKey:host] forKey:host];
                    }
                }
            }
        } else {
            NSLog(@"[url mapping error] file(%@) is empty!!!!", fileName);
        }
    }
    return _urlMapping;;
}

- (BOOL)isLogined {
#warning 根据自己app，反正是否登录标识(如：token.length) YES or NO
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - call subclass
- (void)onMatchUnhandledURLAction:(NVURLAction *)urlAction {
}

- (void)willOpenExternal:(NVURLAction *)urlAction {
}

- (void)onMatchViewController:(UIViewController *)controller withURLAction:(NVURLAction *)urlAction {
}

- (BOOL)shouldOpenURLAction:(NVURLAction *)urlAction {
    return YES;
}

- (void)willOpenURLAction:(NVURLAction *)urlAction {
}

@end
