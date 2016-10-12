//
//  MemberListViewController.m
//  Punish
//
//  Created by YuChangLin on 16/9/14.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "MemberListViewController.h"
#import "MacroDefinitionFile.h"
//#import "OrderDBManager.h"
#import "DepartmentModel.h"
#import "MemberModel.h"

#import "DataOperationTool.h"

@interface MemberListViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *selectedArr;//控制列表是否被打开
    NSMutableDictionary *memberDictionary;
}

@property (nonatomic, strong) NSMutableArray *dataArray;//数据源
@property (nonatomic, strong) NSArray * memberArray;//数据源
@property (nonatomic, strong) UITableView *tableView;//数据源
@end

@implementation MemberListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initSubview];
    
    [self customNavigationBarItems];
}
#pragma mark - Load Data
- (void) initData
{
    selectedArr=[[NSMutableArray alloc]init];
    memberDictionary = [[NSMutableDictionary alloc] init];
    
    //获取成员名单数组

    NSArray *array = [DataOperationTool queryTableWithTableName:MEMBER_TABLE where:nil];
    
    for (int i = 0;i < array.count;i++) {
        
        NSDictionary *dic = array[i];
        NSString *string = dic[@"department"];
        //清除空格
        NSString *str = [self delSpaceAndNewline:string];
        NSMutableArray *memberArray = [memberDictionary objectForKey:str];
        if (memberArray == nil) {
            
            //如果列表为空，则为区id创建一个新的数组
            memberArray = [NSMutableArray array];
            [memberDictionary setObject:memberArray forKey:str];
        }
        [memberArray addObject:dic];
    }
    
    NSArray *values = [memberDictionary allValues];
    for (NSArray *arr in values) {
        
        [self.dataArray addObject:arr];
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
-(void)initSubview{

    [self.view addSubview:self.tableView];
}
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
    self.navigationItem.title = @"成员";
    
    //3 color
    self.view.backgroundColor = RGB(210, 210, 210);
}
-(UITableView*)tableView{

    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
#pragma mark - Click  Action
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnOpenList:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",sender.tag-10000];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)section];
    if ([selectedArr containsObject:indexStr]) {
        
        NSArray *arr = self.dataArray[section];
         return arr.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Member_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    // Configure the cell...
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSArray *arr = self.dataArray[indexPath.section];
    
    //传递数据
    //只需要给当前分组展开的section 添加用户信息即可
    if ([selectedArr containsObject:indexStr]) {

    NSDictionary*dic = arr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"username"];
    cell.detailTextLabel.text = [dic objectForKey:@"department"];
    }
    return cell;
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
    if ([selectedArr containsObject:string]) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 41;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  
       return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section]];
        
         //删除数据
        BOOL result = [self delectDatasource:arr[indexPath.row]];
        if (result) {
            
            [arr removeObjectAtIndex:indexPath.row];
            
            NSMutableArray *newArray = [self.dataArray mutableCopy];
            [newArray replaceObjectAtIndex:indexPath.section withObject:arr];
            self.dataArray = newArray;
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
       
}
#pragma mark - FMDB
//删除
- (BOOL)delectDatasource:(NSDictionary*)dic
{
    BOOL result = [DataOperationTool deleteToTable:MEMBER_TABLE dict:dic];
    
    return result;
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
@end
