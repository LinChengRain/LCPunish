//
//  DropSelectListView.h
//  LCDropSelectList
//
//  Created by YuChangLin on 16/10/11.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DropSelectListView : UIView


/* 圆角 */
@property (nonatomic ,assign)  CGFloat cornerRadius;
/* 边线宽度 */
@property (nonatomic ,assign)  CGFloat borderWidth;
/* 边线颜色 */
@property (nonatomic ,strong)  UIColor *borderColor;
/* 箭头图片 */
@property (nonatomic ,strong)  UIImage *arrowImage;
/* 文字颜色 */
@property (nonatomic ,strong)  UIColor *textColor;
/* 测试颜色 */
@property (nonatomic, copy)  NSString *testString;
/* 最大行数 */
@property (nonatomic, assign)  NSInteger maxRows;
/* 下拉数据源 */
@property (strong, nonatomic) NSArray *listItems;
/*  默认标题 */
@property (nonatomic, strong) NSString *defaultTitle;
/*  背景颜色 */
@property (nonatomic, strong) UIColor *comBackgroundColor;
/*  标题大小 */
@property (nonatomic, assign) NSInteger titleSize;
/* 下拉时选择的事件 */
@property (nonatomic, copy) void (^ClickDropDown)(NSInteger index);
/*  当前选项值 */
@property (nonatomic, copy, readonly) NSString *value;


- (void)reloadData;
/**
 *  关闭下拉菜单
 */
- (void)closeMenu;
@end
