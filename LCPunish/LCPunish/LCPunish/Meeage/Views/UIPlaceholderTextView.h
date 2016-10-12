//
//  UIPlaceholderTextView.h
//  Punish
//
//  Created by YuChangLin on 16/9/21.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceholderTextView : UITextView


@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

- (void)textChanged:(NSNotification * )notification;

@end
