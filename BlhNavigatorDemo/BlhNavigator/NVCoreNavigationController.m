//
//  NVCoreNavigationController.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVCoreNavigationController.h"
#import "NVURLAction.h"

@interface NVCoreNavigationController ()

@end

@implementation NVCoreNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!animated && viewController.urlAction.animation == NVNaviAnimationNone) {
        // 无动画
        [super pushViewController:viewController animated:animated];
        _inAnimating = NO;
        return;
    }
    
    _inAnimating = YES;
    [super pushViewController:viewController animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_inAnimating = NO;
    });
    
    // 修正push控制器tabbar上移问题---自己添加代码
}

- (void)pushViewController:(UIViewController *)viewController withAnimation:(BOOL)animated {
    if (!animated) {
        // 无动画
        [super pushViewController:viewController animated:animated];
        _inAnimating = NO;
        return;
    }
    [self pushViewController:viewController animated:animated];
}


@end
