//
//  MessageModel.h
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "LCBaseModel.h"

@interface MessageModel : LCBaseModel

@property (nonatomic , copy) NSString *punishMessage;
@property (nonatomic , copy) NSString *type;
@property (nonatomic , assign) BOOL isChecked;

@end
