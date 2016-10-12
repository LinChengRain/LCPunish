//
//  AddView.h
//  Punish
//
//  Created by qunqu on 16/9/13.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddView;
@protocol AddViewDelegate <NSObject>

-(void)addViewWithView:(AddView*)view username:(NSString*)username department:(NSString*)department;

-(void)addViewWithView:(AddView*)view selectShowList:(BOOL)showList;
@end

@interface AddView : UIView

@property (nonatomic, assign) id <AddViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (nonatomic, assign) BOOL showList;//是否弹出下拉列表

-(void)dimissResponseKeybord;
@end
