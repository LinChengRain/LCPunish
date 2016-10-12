//
//  LCCustomListView.h
//  Punish
//
//  Created by YuChangLin on 16/9/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTriangleHeight 8.0
#define kTriangleWidth 10.0
#define kPopOverLayerCornerRadius 5.0

@class LCCustomListView;
typedef NS_ENUM(NSUInteger, AlignStyle) {
    AlignStyleCenter,
    AlignStyleLeft,
    AlignStyleRight,
};

@protocol LCCustomListViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(LCCustomListView *)pView;
- (void)popOverViewDidDismiss:(LCCustomListView *)pView;

// for normal use
- (void)popOverView:(LCCustomListView *)pView didClickMenuIndex:(NSInteger)index;


@end

@interface LCCustomListView : UIView

@property (nonatomic,   weak) id<LCCustomListViewDelegate> delegate;
// you can set custom view or custom viewController
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;


@property (nonatomic, strong) UIColor *containerBackgroudColor;

+ (instancetype)popOverView;

// for normal use, you can set titles, it will show as a tableview
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles;


- (void)showFrom:(UIView *)from alignStyle:(AlignStyle)style;

- (void)dismiss;
@end
