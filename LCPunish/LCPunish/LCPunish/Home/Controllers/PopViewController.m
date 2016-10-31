//
//  PopViewController.m
//  LCPunish
//
//  Created by qunqu on 16/10/31.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "PopViewController.h"
#import "NextViewController.h"
#import "STPopup.h"

@interface PopViewController ()
@property (nonatomic, strong)UILabel *label;
@end

@implementation PopViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"摇一摇";
        self.contentSizeInPopup = CGSizeMake(300, 200);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
    
    [self.view addSubview:self.label];
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.label.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 20);
    
    self.label.text = _messageStr;
}

- (UILabel *)label{
    
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor redColor];
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:20];
    }
    return _label;
}
- (void)nextBtnDidTap
{
    NextViewController *nextVC = [NextViewController new];
    //传递数据
    nextVC.dataArray = self.dataArray;
    nextVC.messageStr = self.messageStr;
    [self.popupController pushViewController:nextVC animated:YES];
}

- (void)setMessageStr:(NSString *)messageStr
{
    _messageStr = messageStr;
    
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
