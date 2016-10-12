//
//  HistoryViewController.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "HistoryViewController.h"
#import "PunishMessageModel.h"

#import "MacroDefinitionFile.h"

#import "ModelObject.h"

#import "PunishCell.h"

#import "DataOperationTool.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentCount;//当前数组中元素个数
}
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //加载视图
    [self initSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self queryWithPunishMessage];
    
    
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

- (void)queryWithPunishMessage
{
    //查询所有结果
    NSArray *arr =  [self queryPunishMessage];
    
    if (arr.count != self.dataArray.count) {
        
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        
        NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:arr.count];
        //数据填充到数组中
        for (NSDictionary* dic in arr) {
            PunishMessageModel *model = [[PunishMessageModel alloc] initWithDataDic:dic];
            
            [dataArr addObject:model];
        }
        //时间排序
        NSMutableArray *reverseArr = [NSMutableArray arrayWithArray:[[dataArr reverseObjectEnumerator] allObjects]];
        
        self.dataArray = reverseArr;
        [self.tableView reloadData];
    }
}
-(NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
#pragma mark - Draw UI
- (void )initSubviews
{
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 100;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PunshCell";
    
    PunishCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PunishCell" owner:nil options:nil]lastObject];
        
    }
    //传递数据
    PunishMessageModel *model = self.dataArray[indexPath.row];
    cell.username.text = model.username;
    cell.department.text = model.department;
    cell.punishMessage.text = model.punishMessage;
    cell.punishTime.text = model.punishTime;
    
    return cell;
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        PunishMessageModel *model = self.dataArray[indexPath.row];
        
        
        //模型转换
        NSDictionary *dic = [ModelObject getObjectData:model];
        //删除对应数据
        BOOL result =  [self delectPunishDatasource:dic];
        if (result)
        {
            //删除数据
            [self.dataArray removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

#pragma mark - FMDB
- (NSArray *)queryPunishMessage
{

    NSArray *arr = [DataOperationTool queryTableWithTableName:Punish_TABLE where:nil];
    return arr;
}

/**
 删除数据
 
 @param dic 数据
 */
- (BOOL)delectPunishDatasource:(NSDictionary*)dic
{
    
    BOOL result =  [DataOperationTool deleteToTable:Punish_TABLE dict:dic];
    return result;

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
