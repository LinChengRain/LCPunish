//
//  ShareViewController.m
//  LCPunish
//
//  Created by qunqu on 16/10/31.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "ShareViewController.h"
#import "STPopup.h"
#import "WXApi.h"
#import "DataOperationTool.h"
#import "MacroDefinitionFile.h"
#import "PunishMessageModel.h"
#import "ModelObject.h"

@interface ShareViewController ()

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ShareViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"分享到微信";
        self.contentSizeInPopup = CGSizeMake(300, 150);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化子视图
    [self initSubviews];
    //初始化表
    [self initPunishTable];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.messageLabel.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 60);
    self.messageLabel.text = _messageStr;
    self.usernameLabel.frame = CGRectMake(80, 100, self.view.frame.size.width - 40 - 100, 40);
    self.usernameLabel.text = [NSString stringWithFormat:@"%@(%@)",_username,_department];
    
}
- (void)initSubviews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnDidTap)];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 60, 40)];
    userLabel.font = [UIFont systemFontOfSize:17];
    userLabel.text = @"受罚者:";
    [self.view addSubview:userLabel];
    
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.usernameLabel];
}
- (UILabel *)messageLabel{
    
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        //        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor redColor];
        _messageLabel.font = [UIFont boldSystemFontOfSize:21];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}
- (UILabel *)usernameLabel{
    
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.textColor = [UIColor redColor];
        _usernameLabel.numberOfLines = 0;
        _usernameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _usernameLabel;
}
#pragma mark - Click Action
- (void)shareBtnDidTap
{
    //分享到微信
    [self performSelector:@selector(shareMessageToWechat) withObject:nil afterDelay:0.5];
    
    //模型转换
    PunishMessageModel *model = [[PunishMessageModel alloc] init];
    model.username = _username;
    model.department = _department;
    model.punishMessage = _messageStr;
    model.punishTime = [self currentTime];
    
    NSDictionary *dict = [ModelObject getObjectData:model];
    //存入数据库
    [self insertPunishTableWithMessage:dict];
}
#pragma mark - Share
//分享文字类型
-(void)shareMessageToWechat{
    
    NSString *shareMessage = [NSString stringWithFormat:@"%@(%@)的摇一摇惩罚结果:%@",_username,_department,_messageStr];
    
    SendMessageToWXReq *requset = [[SendMessageToWXReq alloc] init];
    requset.text = shareMessage;
    requset.bText = YES;
    requset.scene = WXSceneSession;   /**< 聊天界面    */
    BOOL result = [WXApi sendReq:requset];
    
    if (result) {
        NSLog(@"分享成功");
    }
    
    [self.popupController dismissWithCompletion:nil];
    
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
- (NSArray *)setUpDatasource{
    
    NSArray *array = [DataOperationTool queryTableWithTableName:MEMBER_TABLE where:nil];
    return array;
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

@end
