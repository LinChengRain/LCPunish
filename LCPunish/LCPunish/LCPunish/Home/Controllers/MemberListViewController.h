//
//  MemberListViewController.h
//  Punish
//
//  Created by YuChangLin on 16/9/14.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    MemberDepartmentTypeYFB = 0, //研发部
    MemberDepartmentTypeCSB = 1, //测试部
    MemberDepartmentTypeDSB = 2, //电商部
    MemberDepartmentTypeYDKF = 3,  //移动开发部
    MemberDepartmentTypeSCB = 4,  //市场部
    MemberDepartmentTypeCPTY = 5,  //产品体验部
    MemberDepartmentTypeXZB = 6,  //行政部
    MemberDepartmentTypeXMWX = 7,  //项目外协
    MemberDepartmentTypeSXS = 8,  //实习生
    MemberDepartmentTypeYXB = 8,  //运营部
    
} MemberDepartmentType;

@interface MemberListViewController : UIViewController

@end
