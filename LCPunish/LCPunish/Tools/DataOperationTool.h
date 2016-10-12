//
//  DataOperationTool.h
//  Punish
//
//  Created by YuChangLin on 16/9/26.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderDBManager.h"

@interface DataOperationTool : NSObject

/**
 初始化表
 
 @param tableName 表名
 @param keys      字段
 */
+ (void)initTableWithTableName:(NSString*)tableName keys:(NSArray*)keys;

/**
 查询
 
 @param tableName 表名
 @param where     范围
 
 @return 数组类型数据
 */
+ (NSArray*)queryTableWithTableName:(NSString*)tableName where:(NSArray*)where;

/**
 添加数据

 @param tabelName 表名
 @param dict      需要填充的数据

 @return 状态
 */
+ (BOOL)insertToTable:(NSString*)tabelName  dict:(NSDictionary*)dict;

/**
 删除数据
 
 @param tabelName 表名
 @param dict      需要删除的数据
 
 @return 删除状态
 */
+ (BOOL)deleteToTable:(NSString*)tabelName  dict:(NSDictionary*)dict;

/**
 更新表
 
 @param tabelName 表名
 @param dict      需要更新的数据
 @param where     范围
 
 @return 更新结果状态
 */
+ (BOOL)updateWithTableName:(NSString *)tabelName dict:(NSDictionary*)dict where:(NSArray*)where;
@end
