//
//  BlhMineViewController.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "BlhMineViewController.h"
#import "NVNavigator.h"

@interface BlhMineViewController ()

@end

@implementation BlhMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Mine";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    button.backgroundColor = UIColor.cyanColor;
}

- (void)click:(UIButton *)btn {
    NSString *url = @"blhqimeng://mineNext?tagName=aaaa";
    [[NVNavigator navigator] openURLString:url fromViewController:nil];
//    [self openURLString:url];
//    MineNextViewController *vc = [[MineNextViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
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
