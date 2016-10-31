//
//  AddMoreViewController.m
//  Punish
//
//  Created by YuChangLin on 16/9/13.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "AddMoreViewController.h"
//列表
#import "MemberListViewController.h"
//数据库管理
//#import "OrderDBManager.h"
//宏定义
#import "MacroDefinitionFile.h"
//添加成员视图
#import "AddView.h"

#import "MBProgressHUD+MJ.h"

#import "DataOperationTool.h"


@interface AddMoreViewController ()<AddViewDelegate>

@property (nonatomic, strong) AddView *addView;

//@property (nonatomic, strong)OrderDBManager *orderDBmanager;

@property (nonatomic, strong) UILabel *alterLabel;
@end

@implementation AddMoreViewController

- (void)dealloc{
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.alterLabel.text = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customNavigationBarItems];
    
  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initSubviews];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.addView removeFromSuperview];
    self.addView = nil;
}
#pragma mark - Draw UI
-(void)customNavigationBarItems
{
    //1 back
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 28)];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 3, 70, 25)];
    [backButton setImage:[UIImage imageNamed:@"backNav"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
    [leftview addSubview:backButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftview];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    //2 title
    self.navigationItem.title = @"添加新成员";
    
    //3 list

//    UIButton *listButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
//    [listButton setTitle:@"成员列表" forState:UIControlStateNormal];
//    [listButton addTarget:self action:@selector(memberListAction)  forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:listButton];

    
    //4 color
    self.view.backgroundColor = RGB(240, 240, 240);
}

- (void)initSubviews
{
    [self.view addSubview:self.alterLabel];

    [self.view addSubview:self.addView];
}
-(AddView*)addView
{
    if (_addView == nil) {
        
        _addView = [[[NSBundle mainBundle] loadNibNamed:@"AddView" owner:self options:nil]lastObject];
        _addView.frame = CGRectMake(0, 100, KSCREEN_WIDTH, 300);
        //设置代理
        _addView.delegate = self;
        
    }
    return _addView;
}
-(UILabel*)alterLabel{
    
    if (_alterLabel == nil) {
        _alterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 36)];
        _alterLabel.textColor = [UIColor redColor];
        _alterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alterLabel;
}
#pragma mark - Click Action
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushBackToMessber" object:nil];
}
-(void)memberListAction
{
    MemberListViewController *memberVC = [[MemberListViewController alloc] init];
    [self.navigationController pushViewController:memberVC animated:YES];
}

#pragma mark - AddViewDelegate
-(void)addViewWithView:(AddView *)view username:(NSString *)username department:(NSString *)department
{
    //转换成字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setValue:username forKey:@"username"];
    [dic setValue:department forKey:@"department"];

    //添加到数据库
    [self addMessageWithDic:dic];
}
-(void)addViewWithView:(AddView *)view selectShowList:(BOOL)showList
{
    if (showList) {
        return;
    }else{
    
    }
}

-(void)addMessageWithDic:(NSDictionary*)dic{
    
    //创表
    [DataOperationTool initTableWithTableName:MEMBER_TABLE keys:KEYS];
    BOOL result = [DataOperationTool insertToTable:MEMBER_TABLE dict:dic];
    
    NSString *resultMessage;
    if (result) {
        NSLog(@"插入成功");
        resultMessage = @"添加成功！";
        
        [_addView.username resignFirstResponder];
        _addView.username.text = @"";
        _addView.department.text = @"";
        
            
    } else {
        NSLog(@"插入失败");
        resultMessage = @"添加失败！";
    }
    
    [UIView animateWithDuration:1 animations:^{
      self.alterLabel.text = @"";
    } completion:^(BOOL finished) {
      self.alterLabel.text = resultMessage;
    }];
    

}
@end
