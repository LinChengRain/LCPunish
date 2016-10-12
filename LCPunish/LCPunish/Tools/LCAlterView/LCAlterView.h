//
//  LCAlterView.h
//  ALterViewDemo
//
//  Created by YuChangLin on 16/9/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAlterView;

@protocol LCAlterViewDelegate <NSObject>
//@"username"],dic[@"department"
@required
-(void)selectAlterView:(LCAlterView*)alterView message:(NSString *)message  username:(NSString*)username department:(NSString*)department buttonIndex:(NSInteger)selectIndex ;

@end
@interface LCAlterView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title message:(NSString*)message;

@property (nonatomic, assign) id<LCAlterViewDelegate> delegate;

//从外面传进来的数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//弹出
- (void)show;

//隐藏
- (void)dismiss;
@end
