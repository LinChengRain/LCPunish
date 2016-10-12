//
//  PunishMessageModel.h
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "LCBaseModel.h"

@interface PunishMessageModel : LCBaseModel

@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *department;
@property (nonatomic , copy) NSString *punishMessage;
@property (nonatomic , copy) NSString *punishTime;

@end
