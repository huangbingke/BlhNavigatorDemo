//
//  BlhHomeNextViewController.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "BlhHomeNextViewController.h"

@interface BlhHomeNextViewController ()

@end

@implementation BlhHomeNextViewController

- (BOOL)handleWithURLAction:(NVURLAction *)urlAction {
    NSString *tagName = [urlAction objectForKey:@"tagName"];
    NSString *pid = [urlAction objectForKey:@"pid"];
    if (!tagName.length && !pid.length) {
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"homeNext";
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
