//
//  DepartmentModel.h
//  Punish
//
//  Created by YuChangLin on 16/9/18.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseModel.h"

@class MemberModel;
@interface DepartmentModel : LCBaseModel

@property(nonatomic,copy) NSString *department;
@property(nonatomic,strong) MemberModel *member;

@end
