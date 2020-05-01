//
//  BlhBaseNavigationController.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "BlhBaseNavigationController.h"

@interface BlhBaseNavigationController ()

@end

@implementation BlhBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
