//
//  AppDelegate.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "AppDelegate.h"

#import "LCMainTabBarViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "WXApi.h" //微信分享


#import "DataOperationTool.h"

#import "MacroDefinitionFile.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[LCMainTabBarViewController alloc] init];
    
    // 分享
    [WXApi registerApp:@"wx920f8eb7cc4385f8"];
    
    
    //配置数据库
    [self setupFMDBDataSource];
    
    [self setUpFrame];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    

    
    return YES;
}



/**
 配置数据库
 */
- (void) setupFMDBDataSource{
    

    // MEMBER_TABLE
    [DataOperationTool initTableWithTableName:MEMBER_TABLE keys:KEYS];
    //PunishMessage_TABLE
    [DataOperationTool initTableWithTableName:PunishMessage_TABLE keys:KEYS_MESSAGE];
    
    //填充数据
    [self insertIntoTable];
    
    //判断是不是第一次打开app
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
    }else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        NSLog(@"second launch");
    }
    
    
}
- (void) insertIntoTable{
    
    [self setupPunishMessageTableData];
    
    [self setupMemberTableData];
    
}
- (void) setUpFrame
{
    AppDelegate *myDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(KSCREEN_HEIGHT > 480){
        
        myDelegate.autoSizeScaleX = KSCREEN_WIDTH/320;
        
        myDelegate.autoSizeScaleY = KSCREEN_HEIGHT/568;
        
    }else{
        
        myDelegate.autoSizeScaleX = 1.0;
        
        myDelegate.autoSizeScaleY = 1.0;
    }
}


- (NSArray*)queryMemberTable
{
    NSArray *arr = [DataOperationTool queryTableWithTableName:MEMBER_TABLE where:nil];
    return arr;
}

- (NSArray*)queryPunishMessageTable
{
    
    NSArray *arr = [DataOperationTool queryTableWithTableName:PunishMessage_TABLE where:nil];
    
    return arr;
}
- (void)setupMemberTableData
{
    
    // MEMBER_TABLE 表数据为0时候再填充基本数据
    NSArray *tableArr = [self queryMemberTable];
    if (tableArr.count == 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //读取plist中数据
            NSString*plistPath =  [[NSBundle mainBundle] pathForResource:@"MemberList" ofType:@"plist"];
            NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
            
            for (int i = 0; i < arr.count;i++ ) {
                
                NSDictionary *dic = [arr objectAtIndex:i];
                
                BOOL result = [DataOperationTool insertToTable:MEMBER_TABLE dict:dic];
                if (!result) {
                    
                    NSLog(@"MEMBER_TABLE 第%d个数据插入失败",i);
                }else{
                    
                    NSLog(@"MEMBER_TABLE 第%d个数据插入成功",i);
                }
            }
        });
    }
}
- (void)setupPunishMessageTableData
{
    // PunishMessage_TABLE 表数据为0时候再填充基本数据
    NSArray *tableArr = [self queryPunishMessageTable];
    if (tableArr.count == 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //读取plist中数据
            NSString*plist_Path =  [[NSBundle mainBundle] pathForResource:@"PunishMessageList" ofType:@"plist"];
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plist_Path];
            NSArray *messageArr = [dic objectForKey:@"message"];
            
            
            for (int i = 0; i < messageArr.count;i++) {
                
                NSDictionary *dict = [messageArr objectAtIndex:i];
                
                //1 插入表
              BOOL result = [DataOperationTool insertToTable:PunishMessage_TABLE dict:dict];
                if (!result) {
                    NSLog(@"PunishMessage_TABLE 第%d个数据插入失败",i);
                }else{
                    NSLog(@"PunishMessage_TABLE 第%d个数据插入成功",i);
                }
            }
        });
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 重写appdelegate的两个方法
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [WXApi handleOpenURL:url delegate:self];
}
-(void) onResp:(BaseResp*)resp{
    
    //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    
    //使用UIAlertView 显示回调信息
    if (sendResp.errCode == 0) {
        NSString *  str = @"分享成功！";
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertview show];
        
        NSLog(@"%d==%@",resp.errCode,str);
    }
    
    
}

@end
