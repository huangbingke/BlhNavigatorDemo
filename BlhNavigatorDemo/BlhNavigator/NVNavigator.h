//
//  NVNavigator.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVBaseNavigator.h"

@class NVNavigator;
@protocol NVNavigatorDelegate <NSObject>

@optional

/**
 询问是否应该打开urlAction
 @param urlAction 待打开的urlAction
 */
- (BOOL)navigator:(NVNavigator *)navigator shouldOpenURLAction:(NVURLAction *)urlAction;

/**
 将要打开urlAction
 @param urlAction 待打开的urlAction
 */
- (void)navigator:(NVNavigator *)navigator willOpenURLAction:(NVURLAction *)urlAction;

/**
 urlAction将要使用外部程序打开
 @param urlAction 将要外部打开的urlAction
 */
- (void)navigator:(NVNavigator *)navigator willOpenExternal:(NVURLAction *)urlAction;

/**
 遇到了无法处理的urlAction
 @param urlAction 无法处理的urlAction
 */
- (void)navigator:(NVNavigator *)navigator onMatchUnhandledURLAction:(NVURLAction *)urlAction;

/**
 找到了映射的Class
 */
- (void)navigator:(NVNavigator *)navigator onMatchViewController:(UIViewController *)controller withURLAction:(NVURLAction *)urlAction;

@end

@interface NVNavigator : NVBaseNavigator

@property (nonatomic, weak) id <NVNavigatorDelegate> delegate;

/**
 具体由不同的App来定义。
 一般在业务层中需要重载提供自定义的NVNavigator（使用NVInternal.h NVInternalSetNavigator），并且子类必须实现NVNavigator
 */
+ (NVNavigator *)navigator;

/**
 设置程序的主导航控制器
 所有的页面跳转都会在mainNavigationContorller中进行
 */
- (void)setMainNavigationController:(NVCoreNavigationController *)mainNavigationContorller;

/**
 设置可以处理的URL Scheme
 默认是：@"dianping"
 */
- (void)setHandleableURLScheme:(NSString *)scheme;

/**
 设置URL mapping文件名称
 url mapping文件只能是包含在工程项目中的文件
 例如：
 @[@"dpmapping.dat", @"dptuanmapping.dat"]
 */
- (void)setFileNamesOfURLMapping:(NSArray *)fileNames;


/////////////////////////////////////////////////////////////////////////////////////////

/**
 在当前的NVNavigator栈中打开新的URL，
 简写方法是: NVOpenURL(NSURL *url)
 
 例如：
 [[NVNavigator navigator] openURL:[NSURL URLWithString:@"dianping://shop?id=123"]]
 或
 NVOpenURL([NSURL URLWithString:@"dianping://shop?id=123"])
 */
- (UIViewController *)openURL:(NSURL *)url fromViewController:(UIViewController *)controller NS_DEPRECATED_IOS(2_0, 7_0,"Use - openURLString: fromViewController: 不规范的url为空时无法跳转");

/**
 在当前的NVNavigator栈中打开新的URL，
 简写方法是: NVOpenURLString(NSString *urlString)
 
 例如:
 [[NVNavigator navigator] openURLString:@"dianping://shop?id=123"]
 或
 NVOpenURL(@"dianping://shop?id=123")
 */
- (UIViewController *)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller;

/**
 在当前的NVNavigator栈中打开新的URL
 简写方法是: NVOpenURLAction(NVURLAction *urlAction)
 
 可以向NVURLAction中传入制定的参数，参数可以为integer, double, string, NVObject四种类型
 bool的参数可以用0和1表示
 如果希望传入任意对象，可以使用setAnyObject:forKey:方法
 
 URL中附带的参数和setXXX:forKey:所设置的参数等价，
 例如下面两种写法是等价的：
 NVURLAction *a = [NVURLAction actionWithURL:@"dianping://shop?id=1"];
 和
 NVURLAction *a = [NVURLAction actionWithURL:@"dianping://shop"];
 [a setInteger:1 forKey:@"id"]

 在获取参数时，调用[a integerForKey:@"id"]，返回值均为1
 */
- (UIViewController *)openURLAction:(NVURLAction *)urlAction fromViewController:(UIViewController *)controller;

- (UIViewController *)openURLAction:(NVURLAction *)urlAction;

- (void)popCurrentUrlAnimated:(BOOL)animated;

// my fix
- (BOOL)isSchemeUrl:(NSString *)url;

@end

@interface UIViewController (NVNavigator)

- (UIViewController *)openURLHost:(NSString *)urlHost;
- (UIViewController *)openURL:(NSURL *)url NS_DEPRECATED_IOS(2_0, 7_0,"Use - openURLString: 不规范的url为空时无法跳转");
- (UIViewController *)openURLString:(NSString *)urlString;
- (UIViewController *)openHttpURLString:(NSString *)httpURLString;
- (UIViewController *)openURLFormat:(NSString *)urlFormat, ...;
- (UIViewController *)openURLAction:(NVURLAction *)urlAction;
- (void)openURLList:(NSArray *)urlList;

@end


