//
//  MemberListViewController.m
//  LCPunish
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

#import "AddMoreViewController.h"
#import "HomeViewController.h"

#import "AppDelegate.h"

#import "MBProgressHUD+MJ.h"

@interface MemberListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>{
    
    NSMutableArray *selectedArr;//控制列表是否被打开
    NSMutableDictionary *memberDictionary;
}

@property (nonatomic, strong) NSMutableArray *dataArray;////存放tableView中显示数据的数组

@property (nonatomic, strong) UITableView *tableView;
//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;
//存放搜索列表中显示数据的数组
@property (strong,nonatomic) NSMutableArray  *searchList;
@property (nonatomic, strong) NSMutableArray * sourceArray;//数据源

@end

@implementation MemberListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushBackToMessber" object:nil];
    
    self.searchList = nil;
    self.searchController = nil;
    
}
//搜索完之后，将搜索框移除
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubview];
    
    [self initData];
    
    [self customNavigationBarItems];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDataNotification) name:@"pushBackToMessber"
                                               object:nil];
    
    
    
}

#pragma mark - Load Data
- (void) initData
{
         [self loadData];
}
- (void)loadData{
    
    // 2016.9.26 改动：数据库的具体操作封装到DataOperationTool 中，以类方法进行调用
    //获取成员名单数组
    //    NSArray* array = [[OrderDBManager intance] queryWithTableName:MEMBER_TABLE];//查询语句
    NSArray *array = [DataOperationTool queryTableWithTableName:MEMBER_TABLE where:nil];
    
    for (int i = 0;i < array.count;i++) {
        
        NSDictionary *dic = array[i];
        NSString *string = dic[@"department"];
        //清除空格
        NSString *str = [self delSpaceAndNewline:string];
        //1 作为tableView数据源
        NSMutableArray *memberArray = [memberDictionary objectForKey:str];
        if (memberArray == nil) {
            
            //如果列表为空，则为区id创建一个新的数组
            memberArray = [NSMutableArray array];
            [memberDictionary setObject:memberArray forKey:str];
        }
        [memberArray addObject:dic];
        
        //2 保存数据为作为搜索数据源
        NSString *username = dic[@"username"];
        NSString *newStr = [NSString stringWithFormat:@"%@:%@",string,username];
        [self.sourceArray addObject:newStr];
    }
    
    NSArray *values = [memberDictionary allValues];
    for (NSArray *arr in values) {
        
        [self.dataArray addObject:arr];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        //隐藏
        [MBProgressHUD hideHUD];
    });
    
}
-(NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (UISearchController*)searchController{
    if (_searchController == nil) {
        //初始化UISearchController并为其设置属性
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        //设置代理对象
        _searchController.searchResultsUpdater = self;
        //设置搜索时，背景变暗色            _searchController.dimsBackgroundDuringPresentation = NO;
        //设置搜索时，背景变模糊
        _searchController.obscuresBackgroundDuringPresentation = NO;
        //隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = NO;
        //设置搜索框的frame
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        
    }
    return _searchController;
}
#pragma mark - Draw UI
-(void)initSubview{
    
    [self.view addSubview:self.tableView];
    
    
    selectedArr=[[NSMutableArray alloc]init];
    _sourceArray=[[NSMutableArray alloc]init];
    memberDictionary = [[NSMutableDictionary alloc] init];
}

-(void)customNavigationBarItems
{
    //1 add
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"button_add_white"] forState:UIControlStateNormal];
    //
    //    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //2 title
    self.navigationItem.title = @"成员";
    
    //3 color
    self.view.backgroundColor = RGB(210, 210, 210);
    
    
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
    
}

-(UITableView*)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.tableFooterView = [[UIView alloc]init];
        //将搜索框设置为tableView的组头
        _tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _tableView;
}
#pragma mark - Click  Action
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addBtnAction:(id)sender{
    
    AddMoreViewController *addMoreVC = [[AddMoreViewController alloc] init];
    [self.navigationController pushViewController:addMoreVC animated:YES];
}
#pragma mark - NSNotification
- (void)reloadDataNotification{
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
        [memberDictionary removeAllObjects];
    }
    [self loadData];
    
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
    if (self.searchController.active){
        return 1;
    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //如果searchController被激活就返回搜索数组的行数，否则返回数据数组的行数
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)section];
        if ([selectedArr containsObject:indexStr]) {
            
            NSArray *arr = self.dataArray[section];
            return arr.count;
        }
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Member_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    // Configure the cell...
    
    
    
    //如果搜索框被激活，就显示搜索数组的内容，否则显示数据数组的内容
    if (self.searchController.active) {
        NSString*string = self.searchList[indexPath.row];
        NSArray *arr = [string componentsSeparatedByString:@":"];
        cell.textLabel.text = arr[1];
        cell.detailTextLabel.text = arr[0];
    }else{
        
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        
        NSArray *arr = self.dataArray[indexPath.section];
        //传递数据
        //只需要给当前分组展开的section 添加用户信息即可
        if ([selectedArr containsObject:indexStr]) {
            
            NSDictionary*dic = arr[indexPath.row];
            cell.textLabel.text = [dic objectForKey:@"username"];
            cell.detailTextLabel.text = [dic objectForKey:@"department"];
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.searchController.active) {
        return nil;
    }
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
    if (self.searchController.active) {
        return 0;
    }
    return 41;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (self.searchController.active) {
     
     NSString*string = self.searchList[indexPath.row];
     NSArray *arr = [string componentsSeparatedByString:@":"];
     NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
     [dic setObject:arr[1] forKey:@"username"];
     [dic setObject:arr[0] forKey:@"department"];
     
     HomeViewController *moreVC = [[HomeViewController alloc] init];
     moreVC.nameDic = dic;
     [self.navigationController pushViewController:moreVC animated:YES];
     }else{
     
     NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section]];
     if (arr.count > 0) {
     NSDictionary *dic = arr[indexPath.row];
     
     HomeViewController *moreVC = [[HomeViewController alloc] init];
     moreVC.nameDic = dic;
     [self.navigationController pushViewController:moreVC animated:YES];
     }
     }
     */
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
#pragma mark - UISearchController
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //获取搜索框中用户输入的字符串
    NSString *searchString = [self.searchController.searchBar text];
    //指定过滤条件，SELF表示要查询集合中对象，contain[c]表示包含字符串，%@是字符串内容
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //如果搜索数组中存在对象，即上次搜索的结果，则清除这些对象
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //通过过滤条件过滤数据
    
    self.searchList= [NSMutableArray arrayWithArray:[self.sourceArray filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}
#pragma mark - FMDB
//删除
- (BOOL)delectDatasource:(NSDictionary*)dic
{
    BOOL result = [DataOperationTool deleteToTable:MEMBER_TABLE dict:dic];
    
    return result;
    // 2016.9.26 改动：数据库的具体操作封装到DataOperationTool 中，以类方法进行调用
    /*
     NSString * username = dic[@"username"];
     NSString * department = dic[@"department"];
     
     //  格式@[@"key",@"=",@"value",@"key",@"=",@"value"];
     NSMutableArray *deleArr = [NSMutableArray arrayWithCapacity:0];
     [deleArr addObject:@"username"];
     [deleArr addObject:@"="];
     [deleArr addObject:username];
     [deleArr addObject:@"department"];
     [deleArr addObject:@"="];
     [deleArr addObject:department];
     
     NSLog(@"%@",deleArr);
     
     BOOL result = [[OrderDBManager intance] deleteWithTableName:MEMBER_TABLE where:deleArr];
     
     if (result){
     NSLog(@"删除成功！");
     }else{
     NSLog(@"删除失败！");
     }
     */
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
