//
//  BlhMainTabBarController.m
//  BlhNavigatorDemo
//
//  Created by 宋家蒙 on 2020/4/17.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "BlhMainTabBarController.h"
#import "BlhBaseNavigationController.h"
#import "BlhHomeViewController.h"
#import "BlhMineViewController.h"

@interface BlhMainTabBarController ()

@end

@implementation BlhMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupAllChildViewControllers];
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    // 解決pop Tabbar文字和图片上下移动问题
    [self.tabBar setTranslucent:NO];
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    BlhBaseNavigationController *aMainVC = [[BlhBaseNavigationController alloc] initWithRootViewController:[[BlhHomeViewController alloc] init]];
    [self setupChildViewController:aMainVC title:@"ModuleA" imageName:@"tab_setting_dis" selectedImageName:@"tab_setting"];
    
    BlhBaseNavigationController *bMainVC = [[BlhBaseNavigationController alloc] initWithRootViewController:[[BlhMineViewController alloc] init]];
    [self setupChildViewController:bMainVC title:@"ModuleB" imageName:@"tab_me_dis" selectedImageName:@"tab_me"];
    // 默认选择0
    self.selectedIndex = 0;
    
}


/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    [self addChildViewController:childVc];
}

+ (void)load{
    
    // TabBar未选中
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // TabBar选中
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blueColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
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
