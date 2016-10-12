//
//  LCNavigationViewController.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "LCNavigationViewController.h"
#import "MacroDefinitionFile.h"

@interface LCNavigationViewController ()

@end

@implementation LCNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/** 类初始化的时候调用 */
+ (void)initialize {
    // 初始化导航栏样式
    [self initNavigationBarTheme];
}

/** 重写push方法 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果不是根控制器，隐藏TabBar
    if (self.viewControllers.count > 0) {
        // 注意这里不是self（navigationController），是push出来的ViewContoller隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 最后一定要调用父类的方法
    [super pushViewController:viewController animated:animated];
}

/** 统一设置导航栏样式 */
+ (void) initNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:RGB(20, 155, 213)];
    //设置导航栏标题颜色
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



