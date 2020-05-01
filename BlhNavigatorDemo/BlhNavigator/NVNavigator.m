//
//  NVNavigator.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVNavigator.h"
#import "NSString+NavigatorExtension.h"

static NVNavigator *gNavigator = nil;

@interface NVBaseNavigator (Private)

- (UIViewController *)handleOpenURLAction:(NVURLAction *)urlAction;

@end

@interface NVNavigator ()

@end


@implementation NVNavigator {
    
}

+ (void)initialize {
    gNavigator = [[self alloc] init];
}

#pragma mark - public methods
+ (id)navigator {
    return gNavigator;
}

- (void)setMainNavigationController:(NVCoreNavigationController *)mainViewContorller {
    _mainNavigationController = mainViewContorller;
}

- (void)setHandleableURLScheme:(NSString *)scheme {
    _handleableURLScheme = scheme;
}

- (void)setFileNamesOfURLMapping:(NSArray *)fileNames {
    _fileNamesOfURLMapping = fileNames;
    
    [self loadPattern];
}

- (UIViewController *)openURL:(NSURL *)url fromViewController:(UIViewController *)controller {
    if (!url) {
        return nil;
    }
    return [self openURLAction:[NVURLAction actionWithURL:url] fromViewController:controller];
}

- (UIViewController *)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller {
    if (urlString.length < 1) {
        return nil;
    }
    
    // my fix 没有blhqimeng://  的h5链接 我们自己转码
    if ([urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https"]) {
        NSString *tempUrl = [urlString encodeStringByAddingPercentEscapes];
        urlString = tempUrl;
    }
    ////////////
    return [self openURLAction:[NVURLAction actionWithURL:[NSURL URLWithString:urlString]] fromViewController:controller];
}

- (UIViewController *)openURLAction:(NVURLAction *)urlAction fromViewController:(UIViewController *)controller {
    if (![urlAction isKindOfClass:[NVURLAction class]]) {
        NSLog(@"*****************[open url action error] urlAction(%@) is not a kind of NVURLAction", NSStringFromClass([urlAction class]));
        return nil;
    }
    return [self handleOpenURLAction:urlAction];
}

- (UIViewController *)openURLAction:(NVURLAction *)urlAction {
    return [self openURLAction:urlAction fromViewController:nil];
}

- (NSArray *)urlActions {
    if (self.mainNavigationController) {
        NSArray *viewControllers = [self.mainNavigationController viewControllers];
        if (viewControllers.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (UIViewController *controller in viewControllers) {
                if (controller.urlAction) {
                    [array addObject:controller.urlAction];
                } else {
                    [array addObject:[NSNull null]];
                }
            }
        }
    }
    return nil;
}

- (NSString *)description {
    if (self.mainNavigationController) {
        NSArray *viewControllers = [self.mainNavigationController viewControllers];
        if (viewControllers.count > 0) {
            NSMutableString *log = [NSMutableString stringWithString:@"NVNavigator ("];
            for (UIViewController *controller in viewControllers) {
                [log appendFormat:@"\n  %@ - %@", NSStringFromClass([controller class]), controller.urlAction];
            }
            [log appendString:@"\n)"];
            return log;
        }
    }
    return [super description];
}

/////////////////////////////////////////////////////////////////////////////
- (void)onMatchUnhandledURLAction:(NVURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:onMatchUnhandledURLAction:)]) {
        [self.delegate navigator:self onMatchUnhandledURLAction:urlAction];
    }
}

- (void)onMatchViewController:(UIViewController *)controller withURLAction:(NVURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:onMatchViewController:withURLAction:)]) {
        [self.delegate navigator:self onMatchViewController:controller withURLAction:urlAction];
    }
}

- (BOOL)shouldOpenURLAction:(NVURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:shouldOpenURLAction:)]) {
        return [self.delegate navigator:self shouldOpenURLAction:urlAction];
    }
    return YES;
}

- (void)willOpenURLAction:(NVURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:willOpenURLAction:)]) {
        [self.delegate navigator:self willOpenURLAction:urlAction];
    }
}

- (void)willOpenExternal:(NVURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:willOpenExternal:)]) {
        [self.delegate navigator:self willOpenExternal:urlAction];
    }
}

- (void)popCurrentUrlAnimated:(BOOL)animated {
    [[self mainNavigationController] popViewControllerAnimated:animated];
}

- (BOOL)isSchemeUrl:(NSString *)url
{
    return [url hasPrefix:self.handleableURLScheme];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIViewController (NVNavigator)

- (UIViewController *)openURLHost:(NSString *)urlHost {
    NSString *scheme = [[NVNavigator navigator] handleableURLScheme];
    if (scheme.length<1 || urlHost.length<1) {
        return nil;
    }
    return [[NVNavigator navigator] openURLString:[NSString stringWithFormat:@"%@://%@", scheme, urlHost] fromViewController:self];
}

- (UIViewController *)openURL:(NSURL *)url {
    return [[NVNavigator navigator] openURL:url fromViewController:self];
}

- (UIViewController *)openURLString:(NSString *)urlString {
    return [[NVNavigator navigator] openURLString:urlString fromViewController:self];
}

- (UIViewController *)openHttpURLString:(NSString *)httpURLString {
    NSString *scheme = [[NVNavigator navigator] handleableURLScheme];
    if (scheme.length<1 || httpURLString.length<1) {
        return nil;
    }
    return [[NVNavigator navigator] openURLString:[NSString stringWithFormat:@"%@://browser?url=%@", scheme, [httpURLString encodeStringByAddingPercentEscapes]] fromViewController:self];
}

- (void)openURLList:(NSArray *)urlList {
    NSString *scheme = [[NVNavigator navigator] handleableURLScheme];
    if (scheme.length<1 || urlList.count<1) {
        return;
    }
    NSMutableString *newUrlString = [NSMutableString stringWithFormat:@"%@://list?", scheme];
    for (int i = 1; i <= urlList.count; i++) {
        NSURL *url = urlList[i-1];
        NSString *urlString = nil;
        if ([url isKindOfClass:[NSURL class]]) {
            urlString = [url absoluteString];
        } else if ([url isKindOfClass:[NSString class]]) {
            urlString = (NSString *)url;
        } else {
            NSLog(@"openURLList error: %@ is not a kind of NSURL or NSString", url);
            return;
        }
        if (i != urlList.count) {
            [newUrlString appendFormat:@"url%d=%@&", i, [urlString encodeStringByAddingPercentEscapes]];
        } else {
            [newUrlString appendFormat:@"url%d=%@", i, [urlString encodeStringByAddingPercentEscapes]];
        }
    }
    [[NVNavigator navigator] openURLString:newUrlString fromViewController:self];
}

- (UIViewController *)openURLFormat:(NSString *)urlFormat, ... {
    if (urlFormat.length<1) {
        return nil;
    }
    va_list ap;
    va_start(ap, urlFormat);
    NSString *urlString = [[NSString alloc] initWithFormat:urlFormat arguments:ap];
    va_end(ap);
    return [[NVNavigator navigator] openURLString:urlString fromViewController:self];
}

- (UIViewController *)openURLAction:(NVURLAction *)urlAction {
    return [[NVNavigator navigator] openURLAction:urlAction fromViewController:self];
}

@end
