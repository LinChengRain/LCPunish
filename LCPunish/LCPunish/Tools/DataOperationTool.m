//
//  DataOperationTool.m
//  Punish
//
//  Created by YuChangLin on 16/9/26.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "DataOperationTool.h"
#import "MacroDefinitionFile.h"


@implementation DataOperationTool

#pragma mark - 表操作
/**
 初始化表

 @param tableName 表名
 @param keys      字段
 */
+ (void)initTableWithTableName:(NSString *)tableName keys:(NSArray *)keys
{
    //创建表
    BOOL exist = [[OrderDBManager intance] isExistWithTableName:tableName];
    
    if (!exist) {
        
        //默认建立主键id
        //keys 数据存放要求@[字段名称1,字段名称2]
        BOOL result = [[OrderDBManager intance] createTableWithTableName:tableName keys:keys];//建表语句
        if (result) {
            
            NSLog(@"%@---创表成功",tableName);
        } else {
            NSLog(@"%@---创表失败",tableName);
        }
    }
}
/**
 添加数据
 
 @param tabelName 表名
 @param dict      需要填充的数据
 
 @return 状态
 */
+ (BOOL)insertToTable:(NSString *)tabelName  dict:(NSDictionary *)dict
{
    //插入
    BOOL result = [[OrderDBManager intance] insertIntoTableName:tabelName Dict:dict];
    
    if (result) {
//        [MBProgressHUD showSuccess:@"添加成功！"];
        NSLog(@"%@---插入成功",tabelName);
        return YES;

    }else{
//        [MBProgressHUD showError:@"添加失败！"];
        NSLog(@"%@---插入失败",tabelName);
        return NO;
    }
}

/**
 查询

 @param tableName 表名
 @param where     范围

 @return 数组类型数据
 */
+ (NSArray*)queryTableWithTableName:(NSString*)tableName where:(NSArray*)where
{

    NSArray *dataArr =  [[OrderDBManager intance] queryWithTableName:tableName];
    return dataArr;
}

/**
 更新表

 @param tabelName 表名
 @param dict      需要更新的数据
 @param where     范围

 @return 更新结果状态
 */
+ (BOOL)updateWithTableName:(NSString *)tabelName dict:(NSDictionary *)dict where:(NSArray *)where
{
   BOOL result = [[OrderDBManager intance] updateWithTableName:tabelName valueDict:dict where:where];
    
    if (result){
        NSLog(@"更新成功！");
        return YES;
    }else{
        NSLog(@"更新失败！");
        return NO;
    }
}
/**
 删除数据

 @param tabelName 表名
 @param dict      需要删除的数据

 @return 删除状态
 */
+ (BOOL)deleteToTable:(NSString *)tabelName dict:(NSDictionary *)dict
{
    // 模型转化
    NSMutableArray *deleArr = [NSMutableArray arrayWithCapacity:0];
    
    if ([tabelName isEqualToString:MEMBER_TABLE])
    {
        //setupMember
        deleArr =  [self setupMemberTableToArrayWithDic:dict];
        
    }else if([tabelName isEqualToString:PunishMessage_TABLE])
    {
        //PunishMessage
        deleArr =  [self setupPunishMessageTableToArrayWithDic:dict];
    }else if ([tabelName isEqualToString:Punish_TABLE])
    {
        //Punish_TABLE
        deleArr =  [self setupPunishTableToArrayWithDic:dict];
    }
    
    BOOL result = [[OrderDBManager intance] deleteWithTableName:tabelName where:deleArr];
    
    if (result){
        NSLog(@"%@---删除成功！",tabelName);
//        [MBProgressHUD showSuccess:@"删除成功!"];
        return YES;
    }else{
//        [MBProgressHUD showSuccess:@"删除失败!"];
        NSLog(@"%@---删除失败！",tabelName);
        return NO;
    }
}
#pragma mark - Delete 模型转化
/************************模型转化***********************/
/**
 模型转化  MEMBER_TABLE数据

 @param dic 需要删除的数据

 @return 配置好的数据格式
 */
+ (NSMutableArray*)setupMemberTableToArrayWithDic:(NSDictionary*)dic
{
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
    return deleArr;
}

/**
 模型转化  PunishMessage_TABLE数据
 
 @param dic 需要删除的数据
 
 @return 配置好的数据格式
 */
+ (NSMutableArray*)setupPunishMessageTableToArrayWithDic:(NSDictionary*)dic
{
    NSString *punishMessage = dic[@"punishMessage"];
    NSString *isSelected = [NSString stringWithFormat:@"%@",dic[@"isChecked"]];
    //  格式@[@"key",@"=",@"value",@"key",@"=",@"value"];
    NSMutableArray *deleArr = [NSMutableArray arrayWithCapacity:0];
    [deleArr addObject:@"punishMessage"];
    [deleArr addObject:@"="];
    [deleArr addObject:punishMessage];
    
    [deleArr addObject:@"isSelected"];
    [deleArr addObject:@"="];
    [deleArr addObject:isSelected];
    
    NSLog(@"%@",deleArr);
    return deleArr;
}
/**
 模型转化  Punish_TABLE数据
 
 @param dic 需要删除的数据
 
 @return 配置好的数据格式
 */
+ (NSMutableArray*)setupPunishTableToArrayWithDic:(NSDictionary*)dic
{
    NSMutableArray *deleArr = [NSMutableArray arrayWithCapacity:0];
    
    [deleArr addObject:@"punishTime"];
    [deleArr addObject:@"="];
    [deleArr addObject:dic[@"punishTime"]];
    
    [deleArr addObject:@"department"];
    [deleArr addObject:@"="];
    [deleArr addObject:dic[@"department"]];
    
    [deleArr addObject:@"username"];
    [deleArr addObject:@"="];
    [deleArr addObject:dic[@"username"]];
    
    NSLog(@"%@",deleArr);
    

    return deleArr;
}

@end
