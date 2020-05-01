//
//  BlhBaseViewController.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "BlhBaseViewController.h"

@interface BlhBaseViewController ()

@end

@implementation BlhBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
}

- (BOOL)shouldShow:(NVURLAction *)urlAction {
    return YES;
}

+ (BOOL)isSingleton {
    return NO;
}

+ (BOOL)needsLogin:(NVURLAction *)urlAction {
    return NO;
}

- (BOOL)isModalView {
    return NO;
}

- (BOOL)handleWithURLAction:(NVURLAction *)urlAction {
    return YES;
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
