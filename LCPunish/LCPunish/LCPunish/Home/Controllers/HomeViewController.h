//
//  HomeViewController.h
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "LCBaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController : LCBaseViewController
{
    UILabel             *punishTitle;
    NSMutableArray      *punishArray;
    SystemSoundID        *sound;
}

@property (nonatomic, retain)UILabel *punishTitle;
@property (nonatomic)SystemSoundID *sound;

@end
