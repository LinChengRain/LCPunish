//
//  HomeViewController.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioTool.h"

//添加成员

#import "LCAlterView.h"

//分享
# import "WXApi.h"

//宏定义
#import "MacroDefinitionFile.h"
//惩罚信息模型
#import "ModelObject.h"

#import "DataOperationTool.h"

#import "PunishMessageModel.h"

#import "AddMoreViewController.h"

@interface HomeViewController ()<LCAlterViewDelegate,WXApiDelegate>{
    
    NSInteger index;       //选中的惩罚索引
    NSString *shareMessage;//要分享的内容
}
//@property (nonatomic ,strong) OrderDBManager *orderDBmanager;
@property (nonatomic, strong) LCAlterView *alterView;    //弹窗

@property (nonatomic, strong) UIImageView *upImage;       //背景图片

@property (nonatomic, strong) UIImageView *downImage;     //上一半手 的图片

@property (nonatomic, strong) UIView *upView;             //下一半手

@property (nonatomic, strong) UIView *downView;           //下一半手 的图片

@end

@implementation HomeViewController

@synthesize punishTitle;
@synthesize sound;
@synthesize alterView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initNavigationBar];
    
    [self initSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (punishArray.count > 0) {
        
        [punishArray removeAllObjects];
    }
    
    punishArray = [self queryPunishMessage];
}
-(void)initData
{
    punishArray = [[NSMutableArray alloc] initWithCapacity:0];
    //    self.orderDBmanager = [OrderDBManager intance];
    //创建惩罚信息的表
    [self initPunishTable];
    
    
}
#pragma mark - Draw UI
- (void)initNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"亲，准备好了吗，接收惩罚吧";
    self.navigationItem.titleView = titleLabel;
    
    
    //2 add
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"button_add_white"] forState:UIControlStateNormal];
    //    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)initSubviews
{
    [self uiConfig];
    
    //配置支持摇动
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    
}
- (void)uiConfig
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, KSCREEN_HEIGHT / 4 - 32, KSCREEN_WIDTH, KSCREEN_HEIGHT / 2 + 64)];
    image.image = [UIImage imageNamed:@"ShakeHideImg_women@2x.png"];
    [self.view addSubview:image];
    
    _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, (KSCREEN_HEIGHT - 64)/ 2)];
    _upView.backgroundColor = [UIColor blackColor];
    
    _upImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetHeight(_upView.frame) - KSCREEN_HEIGHT / 4, KSCREEN_WIDTH - 100, KSCREEN_HEIGHT / 4)];
    _upImage.image = [UIImage imageNamed:@"Shake_Logo_Up@2x.png"];
    
    [_upView addSubview:_upImage];
    [self.view addSubview:_upView];
    
    
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, KSCREEN_HEIGHT / 2 + 32, KSCREEN_WIDTH, KSCREEN_HEIGHT / 2 - 32)];
    _downView.backgroundColor = [UIColor blackColor];
    
    _downImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, 0, KSCREEN_WIDTH - 100, KSCREEN_HEIGHT / 4)];
    _downImage.image = [UIImage imageNamed:@"Down@2x.png"];
    
    [_downView addSubview:_downImage];
    [self.view addSubview:_downView];
}

#pragma mark - ClickAction
-(void)addBtnAction:(id)sender{
    
    AddMoreViewController *addMoreVC = [[AddMoreViewController alloc] init];
    [self.navigationController pushViewController:addMoreVC animated:YES];
}

#pragma mark - 摇晃
//开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //移除弹窗
    [alterView dismiss];
    
    //开始摇晃 设置动画
    [UIView animateWithDuration:1 animations:^{
        
        _upView.frame = CGRectMake(0, -((KSCREEN_HEIGHT - 64)/ 4), KSCREEN_WIDTH, KSCREEN_HEIGHT / 2 - 32);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 animations:^{
            
            _upView.frame = CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT / 2 - 32);
            
        }];
    }];
    
    [UIView animateWithDuration:1 animations:^{
        
        _downView.frame = CGRectMake(0, KSCREEN_HEIGHT / 2 + KSCREEN_HEIGHT / 4, KSCREEN_WIDTH, KSCREEN_HEIGHT / 2  - 32);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 animations:^{
            
            _downView.frame = CGRectMake(0, KSCREEN_HEIGHT / 2 + 32, KSCREEN_WIDTH, KSCREEN_HEIGHT / 2 - 32);
            
        }];
        
    }];
    //播放摇晃声音
    [AudioTool playMusic:@"1.mp3"];
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//振动效果
}
//取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}
//结束摇动
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if(event.subtype == UIEventSubtypeMotionShake)
    {
        NSInteger punishuNum = punishArray.count;
        index = arc4random() % punishuNum;
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//振动效果
        
        [self performSelector:@selector(alterAction) withObject:nil afterDelay:2];
    }
}

- (void)alterAction
{
    NSDictionary *dic = punishArray[index];
    alterView = [[LCAlterView alloc] initWithFrame:self.view.bounds title:@"结果" message:dic[@"punishMessage"]];
    alterView.delegate = self;
    
    [alterView show];
    
    //获取成员名单数组
    NSArray* array = [[OrderDBManager intance] queryWithTableName:MEMBER_TABLE];//查询语句
    alterView.dataArray = [NSMutableArray arrayWithArray:array];
    
    
    NSLog(@"%@==%@",punishArray[index],dic[@"punishMessage"]);
    //    NSLog(@"成员名单%@",array);
}

#pragma mark - LCAlterViewDelegate

/**
 分享
 
 @param alterView   弹窗
 @param message     被罚者信息：username（department）
 @param username    被罚者
 @param department  部门
 @param selectIndex 分享／取消按钮
 */
-(void) selectAlterView:(LCAlterView *)alterView message:(NSString *)message username:(NSString *)username department:(NSString *)department buttonIndex:(NSInteger)selectIndex
{
    NSInteger number = selectIndex;
    
    //分享
    if (number == 1) {
        
        NSDictionary *dic = punishArray[index];
        NSString *punishMessage = dic[@"punishMessage"];
        //分享的内容
        shareMessage = @"";
        if (message.length != 0 ) {
            
            shareMessage = [NSString stringWithFormat:@"%@的摇一摇惩罚结果：%@",message,punishMessage];
        }else{
            shareMessage = [NSString stringWithFormat:@"摇一摇惩罚结果：%@",punishMessage];
        }
        
        //分享到微信
        //延迟调用，解决该警告：（Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.）
        
        [self performSelector:@selector(shareMessageToWechatWithMessage) withObject:nil afterDelay:0.5];
        
        
        PunishMessageModel *model = [[PunishMessageModel alloc] init];
        model.username = username;
        model.department = department;
        model.punishMessage = punishMessage;
        model.punishTime = [self currentTime];
        
        //转换成字典
        NSDictionary *dict = [ModelObject getObjectData:model];
        [self insertPunishTableWithMessage:dict];
    }
}
//分享文字类型
-(void)shareMessageToWechatWithMessage{
    
    SendMessageToWXReq *requset = [[SendMessageToWXReq alloc] init];
    requset.text = shareMessage;
    requset.bText = YES;
    requset.scene = WXSceneSession;   /**< 聊天界面    */
    [WXApi sendReq:requset];
}

#pragma mark - FMDB
- (void)initPunishTable
{
    //创建表
    [DataOperationTool initTableWithTableName:Punish_TABLE keys:KEYS_PUNISH];
}
- (void) insertPunishTableWithMessage:(NSDictionary*)dic
{
    //插入语句
    [DataOperationTool insertToTable:Punish_TABLE dict:dic];
}

/**
 获取表中数据

 @return 数据
 */
- (NSMutableArray*)queryPunishMessage
{
    NSArray *arr = [DataOperationTool queryTableWithTableName:PunishMessage_TABLE where:nil];
    
    NSLog(@"arr---%ld",arr.count);
    NSMutableArray *messageArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary*dic in arr) {
        //取出被选择的数据
        if ([dic[@"isSelected"] isEqualToString:@"1"]) {
            [messageArr addObject:dic];
            
        }
    }
    NSLog(@"messageArr---%ld",messageArr.count);
    
    return messageArr;
}
#pragma mark - Time
-(NSString*)currentTime{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSMutableString *newStr = [NSMutableString stringWithFormat:@"%@", dateString];
    [newStr replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [newStr replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    [newStr insertString:@"日" atIndex:10];
    NSLog(@"%@ === %@",dateString,newStr);
    
    return newStr;
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
