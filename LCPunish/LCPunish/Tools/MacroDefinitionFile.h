//
//  MacroDefinitionFile.h
//  Punish
//
//  Created by qunqu on 16/9/13.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#ifndef MacroDefinitionFile_h
#define MacroDefinitionFile_h


// 测试用log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


// 判别是否iOS7或以上版本系统
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)
// 判别是否iOS8或以上版本系统
#define iOS8 ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)


#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]

//机型
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define MEMBER_TABLE  @"MemberTable"
#define Punish_TABLE  @"PunishTable"
#define PunishMessage_TABLE  @"PunishMessageTable" //惩罚内容
#define SelectMessage_TABLE  @"SelectMessageTable" //惩罚内容
//表字段
#define KEYS @[@"username",@"department"]  //姓名  部门
#define KEYS_PUNISH @[@"username",@"department",@"punishMessage",@"punishTime"]
#define KEYS_MESSAGE @[@"punishMessage",@"isSelected",@"type"]
#define KEYS_MESSAGE_Selected @[@"punishMessage",@"isSelected"]

#endif /* MacroDefinitionFile_h */
