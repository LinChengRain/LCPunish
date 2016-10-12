//
//  LCMainTabBarViewController.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "LCMainTabBarViewController.h"

#import "LCNavigationViewController.h"

#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "MessageViewController.h"

#import "MacroDefinitionFile.h"

@interface LCMainTabBarViewController ()

@end

@implementation LCMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置子视图控制器
    [self addAllChildViewControllers];
}

/** 添加所有子控制器 */
- (void) addAllChildViewControllers
{
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildViewController:home title:@"首页" normalImage:@"tabbar_home" selectImage:@"tabbar_home_selected"];
    
    HistoryViewController *history = [[HistoryViewController alloc] init];
    [self addChildViewController:history title:@"历史" normalImage:@"tabbar_message_center" selectImage:@"tabbar_message_center_selected"];
    
    MessageViewController *message = [[MessageViewController alloc] init];
    [self addChildViewController:message title:@"信息" normalImage:@"tabbar_profile" selectImage:@"tabbar_profile_selected"];
    
}

-(void)addChildViewController:(UIViewController *)controller title:(NSString*)title normalImage:(NSString*)imageName selectImage:(NSString*)selectImageName
{
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
    // 被选中时图标
    // 如果是iOS7，不要渲染被选中的tab图标（iOS7中会自动渲染成为蓝色）
    UIImage *selectedImage = [UIImage imageNamed:selectImageName];
    if (iOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    controller.tabBarItem.selectedImage = selectedImage;
    self.tabBar.tintColor = [UIColor orangeColor];
    // 添加子控制器
    LCNavigationViewController *mainNavigationVC = [[LCNavigationViewController alloc] initWithRootViewController:controller];
    [self addChildViewController:mainNavigationVC];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
