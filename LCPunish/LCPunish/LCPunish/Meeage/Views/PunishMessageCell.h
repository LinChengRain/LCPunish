//
//  PunishMessageCell.h
//  Punish
//
//  Created by YuChangLin on 16/9/22.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PunishMessageCell;
typedef void(^DeleteBlock)(PunishMessageCell *cell,UIButton*btn);

@interface PunishMessageCell : UITableViewCell
{
@private
        UIImageView*	m_checkImageView;
        BOOL			m_checked;
}
@property (nonatomic, copy) DeleteBlock block;

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *useLabel;

@property (nonatomic , strong)UIButton* btnEdit;
- (void) setChecked:(BOOL)checked;

- (void)returnDeleteBlock:(DeleteBlock)block;
@end
