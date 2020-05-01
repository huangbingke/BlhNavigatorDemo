//
//  AppDelegate.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "AppDelegate.h"

#import "BlhBaseNavigationController.h"
#import "BlhMainTabBarController.h"
#import "NVNavigator.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self gotoMainViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)gotoMainViewController
{
    BlhMainTabBarController *tabBarController = [[BlhMainTabBarController alloc] init];
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    
    BlhBaseNavigationController *firstNav = (BlhBaseNavigationController *)tabBarController.viewControllers[0];
    [self setupNavigatorWithMainNavigationController:firstNav];
    
}

- (void)setupNavigatorWithMainNavigationController:(BlhBaseNavigationController *)navi {
    
    NVNavigator *navigator = [NVNavigator navigator];
    // 设置主导航器
    [navigator setMainNavigationController:navi];
    
    // 设置navigator可以处理的url scheme
    [navigator setHandleableURLScheme:@"blhqimeng"];
    
    // 绑定urlmapping文件
    [navigator setFileNamesOfURLMapping:@[@"urlmapping"]];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // 选择tab后，重新设置主导航控制器
//    [[NVNavigator navigator] setMainNavigationController:(BlhBaseNavigationController *)viewController];
    [self setupNavigatorWithMainNavigationController:(BlhBaseNavigationController *)viewController];
}

#pragma mark - ios 8.0
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    
    // 不需要判断scheme的方法，写在这里 ---- do something not match scheme👇
    
    // 没有同意过用户协议，则不走路由跳转（比如下载后，从未打开app）
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:BlhPrivacyKey] == NO) {
//        return NO;
//    }
    
    // 以下是需要blhqimeng的scheme才能进行，不需要判断的，请写在上面👆
    if (![url.scheme isEqualToString:@"blhqimeng"]) {
        return NO;
    }
    // tab不做跳转，只打开对应的界面 go/home/tab?name=xxx
    NSString *tabPath = [NSString stringWithFormat:@"%@%@", url.host, url.path];
    
    // 内部跳转链接
    NVURLAction *action = [NVURLAction actionWithURL:url];
    Class class = [[NVNavigator navigator] matchClassWithURLAction:action];
    if (class && ![tabPath isEqualToString:@"go/home/tab"]) {
        [[NVNavigator navigator] openURLAction:action];
    } else {
        // 获取对应的name(或者index)，返回到tabBar的index页面
        NSString *tabName = [action objectForKey:@"name"];
        // 例如下面这样
//        self.mainTabBarController.selectedIndex = 0;
//        [self.mainNavigationController popToRootViewControllerAnimated:NO];
        return NO;
    }
    return YES;
        
}

#pragma mark - ios 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    // 不需要判断scheme的方法，写在这里 ---- do something not match scheme👇
    
    // 没有同意过用户协议，则不走路由跳转（比如下载后，从未打开app）
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:BlhPrivacyKey] == NO) {
//        return NO;
//    }
    
    // 以下是需要blhqimeng的scheme才能进行，不需要判断的，请写在上面👆
    if (![url.scheme isEqualToString:@"blhqimeng"]) {
        return NO;
    }
    // tab不做跳转，只打开对应的界面 go/home/tab?name=xxx
    NSString *tabPath = [NSString stringWithFormat:@"%@%@", url.host, url.path];
    
    // 内部跳转链接
    NVURLAction *action = [NVURLAction actionWithURL:url];
    Class class = [[NVNavigator navigator] matchClassWithURLAction:action];
    if (class && ![tabPath isEqualToString:@"go/home/tab"]) {
        [[NVNavigator navigator] openURLAction:action];
    } else {
        // 获取对应的name(或者index)，返回到tabBar的index页面
        NSString *tabName = [action objectForKey:@"name"];
        // 例如下面这样
//        self.mainTabBarController.selectedIndex = 0;
//        [self.mainNavigationController popToRootViewControllerAnimated:NO];
        return NO;
    }
    return YES;
}

#pragma mark - iOS 9 通用链接 相关
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
