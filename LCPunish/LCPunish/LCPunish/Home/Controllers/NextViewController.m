//
//  NextViewController.m
//  LCPunish
//
//  Created by qunqu on 16/10/31.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "NextViewController.h"
#import "STPopup.h"

#import "ListTableView.h"

#import "ShareViewController.h"
@interface NextViewController ()<ListTableViewDelegate>{
    
    NSString *_userName;
    NSString *_departMent;
}

@property (nonatomic, strong)ListTableView *listView;
@property (nonatomic, strong) NSMutableArray *usersArray;////存放tableView中显示数据的数组
@property (nonatomic, strong) NSMutableArray * sourceArray;//数据源
@property (nonatomic, strong) NSMutableDictionary *memberDictionary;
//@property (nonatomic, strong) UILabel *label;

@end

@implementation NextViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"选择受罚者";
        self.contentSizeInPopup = CGSizeMake(300, 300);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.listView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.listView.dataArray = _usersArray;
    self.listView.sourceArray = _sourceArray;
    self.listView.memberDictionary = _memberDictionary;
}

- (ListTableView*)listView
{
    if (!_listView) {
        
        _listView = [[ListTableView alloc]initWithFrame: CGRectMake(0, 5, self.view.frame.size.width, 290)];
        _listView.delegate = self;
    }
    return _listView;
}
- (NSMutableArray*)usersArray{
    if (!_usersArray) {
        _usersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _usersArray;
}
- (NSMutableArray*)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sourceArray;
}
- (NSMutableDictionary*)memberDictionary{
    if (!_memberDictionary) {
        _memberDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _memberDictionary;
}
- (void)setMessageStr:(NSString *)messageStr
{
    _messageStr = messageStr;
}
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self loadData:dataArray];
}

#pragma mark - Click Action
- (void)nextBtnDidTap
{
    ShareViewController *nextVC = [ShareViewController new];
    //传递数据
    nextVC.department = _departMent;
    nextVC.messageStr = self.messageStr;
    nextVC.username = _userName;
    [self.popupController pushViewController:nextVC animated:YES];
}

#pragma mark - ListTableViewDelegate
- (void)listTableView:(ListTableView *)view userName:(NSString *)username department:(NSString *)department
{
    //搜索完之后，将搜索框移除
    if (self.listView.searchController.active) {
        self.listView.searchController.active = NO;
        [self.listView.searchController.searchBar removeFromSuperview];
    }
    
    
    //保存数据
    _userName = username;
    _departMent = department;
    
    [self nextBtnDidTap];
}
#pragma mark - LoadData
- (void)loadData:(NSArray*)array{
    
    for (int i = 0;i < array.count;i++) {
        
        NSDictionary *dic = array[i];
        NSString *string = dic[@"department"];
        //清除空格
        NSString *str = [self delSpaceAndNewline:string];
        //1 作为tableView数据源
        NSMutableArray *memberArray = [self.memberDictionary objectForKey:str];
        if (memberArray == nil) {
            
            //如果列表为空，则为区id创建一个新的数组
            memberArray = [NSMutableArray array];
            [self.memberDictionary setObject:memberArray forKey:str];
        }
        [memberArray addObject:dic];
        
        //2 保存数据为作为搜索数据源
        NSString *username = dic[@"username"];
        NSString *newStr = [NSString stringWithFormat:@"%@:%@",string,username];
        [self.sourceArray addObject:newStr];
    }
    
    NSArray *values = [self.memberDictionary allValues];
    for (NSArray *arr in values) {
        
        [self.usersArray addObject:arr];
    }
    
}

#pragma mark - clearSpace
- (NSString *)delSpaceAndNewline:(NSString *)string;{
    
    
    
    NSMutableString *mutStr = [NSMutableString stringWithString:string];
    
    NSRange range = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
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
