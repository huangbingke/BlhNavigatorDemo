//
//  NVNavigatorViewControllerProtocal.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVURLAction.h"

#ifndef NVNavigatorViewControllerProtocal_h
#define NVNavigatorViewControllerProtocal_h

@protocol NVNavigatorViewControllerProtocal <NSObject>

@optional
/**
 设置该页面是否需要显示
 例如try模块和list模块就是不需要展示的
 默认是YES
 */
- (BOOL)shouldShow:(NVURLAction *)urlAction;

/**
 页面是否是单例（即在导航堆栈中只会保留一个页面，当跳转到该页面的时候会将其堆栈之上的页面都pop掉）
 默认是NO
 */
+ (BOOL)isSingleton;

/**
 询问在进入该页面之前是否需要先登录
 默认是NO
 */
+ (BOOL)needsLogin:(NVURLAction *)urlAction;

/**
 设置该页面是不是modal方式的展示模式
 默认是NO
 */
- (BOOL)isModalView;

/**
 导航控制器将要显示页面前，会调用handleWithURLAction:方法
 */
- (BOOL)handleWithURLAction:(NVURLAction *)urlAction;

@end

#endif /* NVNavigatorViewControllerProtocal_h */
