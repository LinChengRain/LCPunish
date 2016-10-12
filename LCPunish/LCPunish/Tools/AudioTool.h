//
//  AudioTool.h
//  Punish
//
//  Created by YuChangLin on 16/9/10.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTool : NSObject

/**
 *  播放音乐
 *
 *  @param filename 音乐的文件名
 */
+ (BOOL)playMusic:(NSString *)filename;

@end
