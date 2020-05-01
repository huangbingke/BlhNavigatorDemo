//
//  NVBaseNavigator+Login.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVBaseNavigator.h"

NS_ASSUME_NONNULL_BEGIN

@interface NVBaseNavigator (Login)

/**
 显示登陆窗口
 */
- (BOOL)showLogin;

- (BOOL)handleLoginAction:(NVURLAction *)urlAction;
- (BOOL)handleNeedsLoginAction:(NVURLAction *)urlAction withController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
