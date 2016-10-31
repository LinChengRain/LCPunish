//
//  ListTableView.m
//  Punish
//
//  Created by qunqu on 16/10/25.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "ListTableView.h"
#import "MacroDefinitionFile.h"

@interface ListTableView ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>{
    
    NSMutableArray *selectedArr;//控制列表是否被打开

}

@property (nonatomic, strong) UITableView *tableView;

//存放搜索列表中显示数据的数组
@property (strong,nonatomic) NSMutableArray  *searchList;

@end
@implementation ListTableView
- (void)dealloc{
    
    self.searchList = nil;
    self.searchController = nil;
    
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}
#pragma mark - View
- (void)initSubviews{
    selectedArr=[[NSMutableArray alloc]init];
    
    [self addSubview:self.tableView];
}
#pragma mark - Lazy Load
-(UITableView*)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
//        _tableView.backgroundColor = [UIColor redColor];
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.tableFooterView = [[UIView alloc]init];
        //将搜索框设置为tableView的组头
        _tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _tableView;
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

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
}
- (void)setMemberDictionary:(NSMutableDictionary *)memberDictionary
{
    _memberDictionary = memberDictionary;
    
    [self.tableView reloadData];
}
- (void)setSourceArray:(NSMutableArray *)sourceArray
{
    _sourceArray = sourceArray;
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
    NSArray *arr = [_memberDictionary allKeys];
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
    
    NSString *username = @"";
    NSString *department = @"";

    if (self.searchController.active) {
        
        NSString*string = self.searchList[indexPath.row];
        NSArray *arr = [string componentsSeparatedByString:@":"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:arr[1] forKey:@"username"];
        [dic setObject:arr[0] forKey:@"department"];
        username = arr[1];
        department = arr[0];
        
    }else{
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section]];
        if (arr.count > 0) {
            NSDictionary *dic = arr[indexPath.row];
            username = dic[@"username"];
            department = dic[@"department"];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(listTableView:userName:department:)]) {

        [self.delegate listTableView:self userName:username department:department];
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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}
@end
