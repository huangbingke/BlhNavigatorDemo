//
//  BlhHomeViewController.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "BlhHomeViewController.h"
#import "NVNavigator.h"

@interface BlhHomeViewController ()

@end

@implementation BlhHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Home";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    button.backgroundColor = UIColor.redColor;
}

- (void)click:(UIButton *)btn {
    NSString *url = @"blhqimeng://homeNext?tagName=aaaa&pid=snsjajn";
    [[NVNavigator navigator] openURLString:url fromViewController:nil];
//    [self openURLString:url];
//    HomeNextViewController *vc = [[HomeNextViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
