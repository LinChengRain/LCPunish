//
//  DepartmentView.h
//  Punish
//
//  Created by qunqu on 16/9/19.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DepartmentView;

@protocol DepartmentViewDelegate <NSObject>

- (void)departmentView:(DepartmentView*)view selectIndex:(NSInteger)selectIndex selectTitle:(NSString*)title;

@end

@interface DepartmentView : UIView

@property(nonatomic,assign)id<DepartmentViewDelegate> delegate;
@property(nonatomic, strong)NSMutableArray *dataArray;

-(void)dismiss;
@end
