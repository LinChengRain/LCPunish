//
//  DepartmentView.m
//  Punish
//
//  Created by qunqu on 16/9/19.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "DepartmentView.h"
#import "MacroDefinitionFile.h"

@interface DepartmentView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleMenus;

@end

@implementation DepartmentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        [self initSubviews];
    }
    return self;
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:[UIColor blackColor ]];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark - Draw UI
-(void)initSubviews
{

    [self addSubview:self.tableView];
}
-(UITableView*)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
    }
    return _tableView;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Department_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = RGB(240, 240, 240);
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中的标题
    NSString *title = self.dataArray[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(departmentView:selectIndex:selectTitle:)]) {
        
        [self.delegate departmentView:self selectIndex:indexPath.row selectTitle:title];
    }
    NSLog(@"第%ld个单元格:%@",indexPath.row,title);
    
}
//设置行线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)dismiss
{
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
