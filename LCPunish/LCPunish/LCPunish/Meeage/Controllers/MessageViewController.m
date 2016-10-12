//
//  MessageViewController.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "MessageViewController.h"

#import "MacroDefinitionFile.h"
//添加惩罚信息
#import "AddMessageViewController.h"
//数据库
//#import "OrderDBManager.h"

#import "PunishMessageCell.h"

#import "ModelObject.h"

#import "MessageModel.h"

#import "MBProgressHUD+MJ.h"

//具体数据库操作
#import "DataOperationTool.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *sureBtn;
    NSMutableArray *groupArr;//控制列表是否被打开
    NSMutableDictionary *memberDictionary;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UITableView *tableView;



@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self initNavigationBar];
    
    [self initSubviews];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataArray.count >0) {
        
        [self.dataArray removeAllObjects];
        [memberDictionary removeAllObjects];
        
    }
    
    NSArray *array = [self queryPunishMessage];
    
    for (int i = 0;i < array.count;i++) {
        
        NSDictionary *dic = array[i];
        NSString *string = dic[@"type"];
        
        NSMutableArray *memberArray = [memberDictionary objectForKey:string];
        if (memberArray == nil) {
            
            //如果列表为空，则为区id创建一个新的数组
            memberArray = [NSMutableArray array];
            [memberDictionary setObject:memberArray forKey:string];
        }
        [memberArray addObject:dic];
    }
    
    NSArray *values = [memberDictionary allValues];
    
    for (NSArray *arr in values) {
        
        NSMutableArray *arr_type = [NSMutableArray arrayWithCapacity:0];
        for (int  i = 0; i < arr.count; i++) {
            
            MessageModel *model = [[MessageModel alloc] init];
            NSDictionary *dic = arr[i];
            model.punishMessage = dic[@"punishMessage"];
            if ([dic[@"isSelected"] isEqualToString:@"1"]) {
                model.isChecked = YES;
            }else{
                model.isChecked = NO;
            }
            model.type = dic[@"type"];
            [arr_type addObject:model];
        }
        [self.dataArray addObject:arr_type];
        
    }

    [self.tableView reloadData];
}
#pragma mark - Load Data
- (void)loadData
{
    //实例化数据库
    //    self.orderDBManager = [OrderDBManager intance];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    memberDictionary = [[NSMutableDictionary alloc] init];
    groupArr = [[NSMutableArray alloc] init];
}
#pragma mark - Draw UI
- (void)initNavigationBar
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 50, 40);
    
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    sureBtn = editButton;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"button_add_white"] forState:UIControlStateNormal];
    //    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}
- (void)initSubviews
{
    
    [self.view addSubview:self.tableView];
    
}
- (UITableView*)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - ClickAction
-(void)addBtnAction:(id)sender{
    
    AddMessageViewController *addMessageVC = [[AddMessageViewController alloc] init];
    [self.navigationController pushViewController:addMessageVC animated:YES];
}
-(void)editAction:(UIButton*)sender
{
    if (!sender.selected) {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        //        sender.titleLabel.text = @"完成";
    }else{
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
        //        sender.titleLabel.text = @"编辑";
        
        //查询数据
        NSArray *arr = [self queryPunishMessage];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //更新数据
            [self updataMessage:arr];
            NSLog(@"%@---%zd",[NSThread currentThread],index);
            
            //回到主线程去更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        });
    }
    sender.selected = !sender.selected;
}
-(void)btnOpenList:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",sender.tag-10000];
    
    //数组groupArr里面存的数据和表头想对应，方便以后做比较
    if ([groupArr containsObject:string])
    {
        [groupArr removeObject:string];
    }
    else
    {
        [groupArr addObject:string];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)section];
    if ([groupArr containsObject:indexStr]) {
        
        NSArray *arr = self.dataArray[section];
        return arr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Message_Cell";
    PunishMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[PunishMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [cell.textLabel.font fontWithSize:17];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    NSArray*arr = self.dataArray[indexPath.section];
    MessageModel* model = arr[indexPath.row];
    cell.titleLabel.text =  model.punishMessage;
    [cell setChecked:model.isChecked];
    
    if (model.isChecked) {
        
        cell.useLabel.textColor = [UIColor redColor];
        cell.useLabel.text = @"已选中";
    }else{
        cell.useLabel.textColor = [UIColor grayColor];
        cell.useLabel.text = @"未选中";
    }
    
    
    __weak typeof(self) weakSelf = self;
    [cell returnDeleteBlock:^(PunishMessageCell *deleteCell,UIButton*btn) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 需要被操作的单元格
        NSIndexPath * path =  [strongSelf.tableView indexPathForCell:deleteCell];
        NSLog(@"index row%ld", path.row);
        
        NSMutableArray *arr = strongSelf.dataArray[path.section];
        MessageModel*messageModel = arr[path.row];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //模型转换
            NSDictionary *dic = [ModelObject getObjectData:messageModel];
            //删除表中数据
            BOOL result =   [strongSelf delectMessageWithTable:PunishMessage_TABLE message:dic];
            //            NSLog(@"%@---%zd",[NSThread currentThread],index);
            
            //删除成功
            if (result) {
                
                //移除数据源中该数据
                [arr removeObject:messageModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (arr.count == 0) {
                        [strongSelf.dataArray removeObject:arr];
                        [strongSelf.tableView reloadData];
                    }else{
                        //移除对应单元格
                        [strongSelf.tableView  deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    [MBProgressHUD showSuccess:@"删除成功！"];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showError:@"删除失败！"];
                });
            }
            
        });
        
    }];
    
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *arr = self.dataArray[indexPath.section];
        MessageModel *model = arr[indexPath.row];
        NSString *isSelected = [NSString stringWithFormat:@"%d",model.isChecked];
        NSDictionary * dic = [[NSDictionary alloc]init];
        [dic setValue:model.punishMessage forKey:@"punishMessage"];
        [dic setValue:isSelected forKey:@"isSelected"];
        //删除
        BOOL result = [self delectMessageWithTable:PunishMessage_TABLE message:dic];
        //删除成功
        if (result) {
            
            [arr removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [MBProgressHUD showSuccess:@"删除成功！"];
        }else{
            
            [MBProgressHUD showError:@"删除失败！"];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete |UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.dataArray objectAtIndex:indexPath.section];
    MessageModel* model = arr[indexPath.row];
    if ([sureBtn.titleLabel.text isEqualToString:@"完成"]) {
        
        PunishMessageCell *cell = (PunishMessageCell*)[tableView cellForRowAtIndexPath:indexPath];
        model.isChecked = !model.isChecked;
        [cell setChecked:model.isChecked];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([sureBtn.titleLabel.text isEqualToString:@"确定"]) {
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 41;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //获取所有标题
    NSArray *arr = [memberDictionary allKeys];
    //所有成员
    NSArray *member = self.dataArray[section];
    NSString *title = arr[section];
    
    //头视图背景
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor=RGB(245, 245, 245);
    
    //左侧标题
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    imageView.tag=20000+section;
    
    //更具当前是否展开设置图片
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([groupArr containsObject:string]) {
        imageView.image=[UIImage imageNamed:@"open.png"];
    }else{
        
        imageView.image=[UIImage imageNamed:@"close.png"];
    }
    [view addSubview:imageView];
    
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 80, 40)];
    rightLabel.textColor = [UIColor grayColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.text = [NSString stringWithFormat:@"(%ld名)",(unsigned long)member.count];
    [view addSubview:rightLabel];
    
    
    //添加一个button 用来监听点击分组，实现分组的展开关闭。
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, SCREEN_WIDTH, 40);
    btn.tag=10000+section;
    [btn addTarget:self action:@selector(btnOpenList:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:btn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = RGB(215, 215, 215);
    [view addSubview:lineView];
    
    return view;
}

#pragma mark - FMDB
/**
 惩罚信息
 */
- (void)initPunishMessageTable
{
    [DataOperationTool initTableWithTableName:PunishMessage_TABLE keys:KEYS_MESSAGE];
}
/**
 查询
 
 @return PunishMessage_TABLE中数据
 */
- (NSArray*)queryPunishMessage
{
    NSArray *arr = [DataOperationTool queryTableWithTableName:PunishMessage_TABLE where:nil];
    
    return arr;
}
//删除
- (BOOL)delectMessageWithTable:(NSString*)tableName message:(NSDictionary*)dic
{
    
    BOOL result =  [DataOperationTool deleteToTable:tableName dict:dic];
    return result;
}

/**
 更新PunishMessage_TABLE数据
 
 @param messageArr PunishMessage_TABLE中数据
 */
- (void)updataMessage:(NSArray*)messageArr
{
    //    NSArray *arr =  self.dataArray;
    //目的：更新PunishMessage_TABLE数据
    for (NSArray *arr in self.dataArray) {
        
        for (int i =0; i < arr.count; i++) {
            MessageModel *model = arr[i];
            NSString *isChecked = [NSString stringWithFormat:@"%d",model.isChecked];
            for (int j = 0; j<messageArr.count; j++) {
                NSMutableDictionary *messageDic = [NSMutableDictionary dictionaryWithDictionary:messageArr[j]];
                
                if (![isChecked isEqualToString:messageDic[@"isSelected"]] && [model.punishMessage isEqualToString:messageDic[@"punishMessage"]] &&[model.type isEqualToString:messageDic[@"type"]])
                {
                    NSMutableArray *requieArr = [NSMutableArray arrayWithCapacity:0];
                    [requieArr addObject:@"punishMessage"];
                    [requieArr addObject:@"="];
                    [requieArr addObject:model.punishMessage];
                    
                    [requieArr addObject:@"type"];
                    [requieArr addObject:@"="];
                    [requieArr addObject:model.type];
                    
                    
                    //更新字典
                    [messageDic setValue:isChecked forKey:@"isSelected"];
                    //更新数据
                    [DataOperationTool updateWithTableName:PunishMessage_TABLE dict:messageDic where:requieArr];
                    }
            }
        }
    }
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
