//
//  LCAlterView.m
//  ALterViewDemo
//
//  Created by YuChangLin on 16/9/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "LCAlterView.h"

#import "LCCustomListView.h"

#import "AppDelegate.h"



#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT 568
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]

@interface LCAlterView ()<LCCustomListViewDelegate>
{
    NSInteger selectIndex;
}
//背景
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;
//标题
@property (nonatomic, strong) UILabel *title;
//子标题
@property (nonatomic, strong) UILabel *subTitle;
//线条
@property (nonatomic, strong) UILabel *line;
//受罚者
@property (nonatomic, strong) UILabel *nameTitle;
//tableView
@property (nonatomic, strong) LCCustomListView *tableView;
//关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
//分享按钮
@property (nonatomic, strong) UIButton *shareButton;

//数据源
@property (nonatomic, strong) UIButton *selectBtn;



@end

@implementation LCAlterView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化各种控件
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_backgroundView];

        _contentView = [[UIView alloc] initWithFrame:CGRectMake1(50, KSCREEN_HEIGHT/2 - 100, KSCREEN_WIDTH - 100, 120)];//KSCREEN_HEIGHT - 200
        
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        [self addSubview:_contentView];
        
        
        UIView *topbgView = [[UIView alloc] initWithFrame:CGRectMake1(0, 0, KSCREEN_WIDTH - 100, 30)];
        topbgView.backgroundColor = RGB(244, 88, 76);
        [_contentView addSubview:topbgView];
        
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, KSCREEN_WIDTH - 200, 30)];
        _title.font = [UIFont boldSystemFontOfSize:19];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor whiteColor];
        _title.text = title;
        [self.contentView addSubview:_title];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake1(20, CGRectGetMaxY(_title.frame), KSCREEN_WIDTH - 140, 50)];
        _subTitle.font = [UIFont systemFontOfSize:17];
        _subTitle.textColor = [UIColor redColor];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.numberOfLines = 0;
        _subTitle.text = message;
        [self.contentView addSubview:_subTitle];
        
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_subTitle.frame), KSCREEN_WIDTH - 100, 2)];
        _line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_line];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.frame = CGRectMake(0, 0, 30, 30);
        [self.contentView addSubview:_closeButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shareButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 50, 0, 50, 30);
        [self.contentView addSubview:_shareButton];
        
        _nameTitle = [[UILabel alloc] initWithFrame:CGRectMake1(0, CGRectGetMaxY(_line.frame) + 5,80, 30)];
//        _nameTitle.backgroundColor = [UIColor grayColor];
        _nameTitle.textColor = [UIColor grayColor];
        _nameTitle.font = [UIFont systemFontOfSize:17];
        _nameTitle.textAlignment = NSTextAlignmentCenter;
        _nameTitle.text = @"受罚者:";
        [self.contentView addSubview:_nameTitle];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake1(80, CGRectGetMaxY(_line.frame) + 7, KSCREEN_WIDTH - 80 - 100 - 10, 25);
//        [_selectBtn setBackgroundColor:[UIColor blueColor]];
        //设置圆角
        _selectBtn.layer.masksToBounds = YES;
        _selectBtn.layer.cornerRadius = 4;
        _selectBtn.layer.borderWidth = 1;
        _selectBtn.layer.borderColor = [UIColor redColor].CGColor;
        [_selectBtn setTitle:@"点击选择伙伴" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
    }
    return self;
}
//-(UITableView*)tableView{
//
//    if (_tableView == nil) {
//        
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(130, CGRectGetMaxY(self.contentView.frame), KSCREEN_WIDTH - 180, 150) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor redColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.showsVerticalScrollIndicator = NO;
//
//    }
//    return _tableView;
//}
-(LCCustomListView*)tableView{
    if (_tableView == nil) {
        
 
    _tableView = [[LCCustomListView alloc]initWithBounds:CGRectMake(130, CGRectGetMaxY(self.contentView.frame), KSCREEN_WIDTH - 180, 150) titleMenus:self.dataArray];
    _tableView.containerBackgroudColor = [UIColor greenColor];
    _tableView.delegate = self;
    [_tableView showFrom:_selectBtn alignStyle:AlignStyleCenter];
           }
    return _tableView;
}

#pragma mark pop和dismiss

- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    //动画效果入场
    self.contentView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.contentView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss {
    //动画效果出场
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)shareBtnAction{

    //获取选中的名单
    NSString *title = @"";
    NSString *username = @"";
    NSString *department = @"";
    //判断是否选择了受罚伙伴
    if (![_selectBtn.titleLabel.text isEqualToString:@"点击选择伙伴"]) {
        // 选中的成员
        NSDictionary* dic = self.dataArray[selectIndex];
        username = dic[@"username"];
        department = dic[@"department"];

        NSString *departmentStr = @"西安分公司";
        
        if ([department isEqualToString:departmentStr]) {
            
            title = [NSString stringWithFormat:@"%@",username];
        }else{
        
            title = [NSString stringWithFormat:@"%@(%@)",username,department];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(selectAlterView: message: username:department:buttonIndex:)]) {
    
        [self.delegate selectAlterView:self message:title username:username department:department buttonIndex:1];
    }
    
    //移除
    [self dismiss];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.contentView]) {
//        [self dismiss];
    }
}
-(void)selectBtnAction:(UIButton*)sender{
    
        [self addSubview:self.tableView];

}
#pragma mark- CustomPopOverViewDelegate
- (void)popOverView:(LCCustomListView *)pView didClickMenuIndex:(NSInteger)index
{
    //获取选中的名单
    NSDictionary*dic = self.dataArray[index];
    NSString *title = dic[@"username"];
    [_selectBtn setTitle:title forState:UIControlStateNormal];
    
    CGRect frame =  self.tableView.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.5 animations:^{
        
        
        self.self.tableView.frame = frame;
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }];
    
    NSLog(@"select menu title is: %@",self.dataArray[index]);
    
    //保存索引
    selectIndex = index;
}

CG_INLINE CGRect CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    
    AppDelegate *myDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    CGRect rect;
    
    rect.origin.x = x ;
    rect.origin.y = y ;
    
    rect.size.width = width ;
    rect.size.height = height * myDelegate.autoSizeScaleY;
    
    return rect;
    
}

@end
