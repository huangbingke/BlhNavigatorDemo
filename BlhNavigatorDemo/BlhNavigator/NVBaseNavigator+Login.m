//
//  NVBaseNavigator+Login.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVBaseNavigator+Login.h"
#import "NVNavigatorViewControllerProtocal.h"

static NVURLAction *gWaitLoginURLAction = nil;

@interface NVBaseNavigator (Private)

- (BOOL)isLogined;
- (UIViewController *)handleOpenURLAction:(NVURLAction *)urlAction;
- (BOOL)inBlockMode;

@end

@implementation NVBaseNavigator (Login)

- (BOOL)isLoginURLAction:(NVURLAction *)action {
    return [@[@"login", @"weblogin"] containsObject:[action.url host]];
}

- (NVURLAction *)loginGotoURLAction:(NVURLAction *)originURLAction {
    NSString *gotoURL = [originURLAction objectForKey:@"goto"];
    return [NVURLAction actionWithURLString:gotoURL];
}

- (BOOL)showLogin {
    
#warning 这里拦截登录后，弹出自己的登录界面
    // UIViewController --> 换成自己的loginVC
    UIViewController *__loginController = [self creatLoginViewControllerWithTarget:self cancelAction:@selector(cancelLoginAction)];
    if (!__loginController || ![__loginController isKindOfClass:UIViewController.class]) {
        return NO;
    }
    [self.mainNavigationController presentViewController:__loginController animated:YES completion:nil];
    
    return YES;
}

- (void)cancelLoginAction {
    // do something after logout or cancel
}

- (BOOL)handleLoginAction:(NVURLAction *)urlAction {
    // handle login host
    if (![self isLoginURLAction:urlAction]) {
        return NO;
    }
    if ([self isLogined]) {
        // get goto urlaction
        [self handleOpenURLAction:[self loginGotoURLAction:urlAction]];
        return NO;
    }
    
    if ([self inBlockMode]) {
        // already showing login, in model mode, the url action showed add to _urlActionWaitingList
        [self handleOpenURLAction:urlAction];
    } else {
        // show login
        if ([self showLogin]) {
            gWaitLoginURLAction = [self loginGotoURLAction:urlAction];
        }
    }
    return YES;
}

- (BOOL)handleNeedsLoginAction:(NVURLAction *)urlAction withController:(UIViewController *)controller {
    
    if ([[controller class] respondsToSelector:@selector(needsLogin:)]) {
        if ([[controller class] needsLogin:urlAction]) {
            if (![self isLogined]) {
                if ([self inBlockMode]) {
                    // already showing login, in model mode, the url action showed add to _urlActionWaitingList
                    [self handleOpenURLAction:urlAction];
                } else {
                    // show login
                    if ([self showLogin]) {
                        gWaitLoginURLAction = urlAction;
                    }
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (UIViewController *)creatLoginViewControllerWithTarget:(id)target cancelAction:(SEL)cancelAction {
    UIViewController *loginVC = [[UIViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    return navi;
}

@end
