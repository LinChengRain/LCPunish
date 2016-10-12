//
//  PunishCell.h
//  Punish
//
//  Created by YuChangLin on 16/9/21.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PunishCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *punishMessage;
@property (weak, nonatomic) IBOutlet UILabel *punishTime;

@end
