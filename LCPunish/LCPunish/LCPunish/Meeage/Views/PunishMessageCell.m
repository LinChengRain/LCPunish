//
//  PunishMessageCell.m
//  Punish
//
//  Created by YuChangLin on 16/9/22.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "PunishMessageCell.h"
#import "MacroDefinitionFile.h"

@interface PunishMessageCell()
@property (nonatomic , strong)UIButton *button;

@end
@implementation PunishMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}
- (void) initSubviews
{
    //1
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 20)];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    //2
    self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 100, 20)];
    self.useLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.useLabel];

    //3
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(SCREEN_WIDTH - 38,34, 20, 22);
    [self.button setImage:[UIImage imageNamed:@"cell_delete"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.button];
}
- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
        
        [UIView commitAnimations];
    }
    else
    {
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
    }
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        if (m_checkImageView == nil)
        {
            m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
            [self addSubview:m_checkImageView];
        }
        
        [self setChecked:m_checked];
        m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        m_checkImageView.alpha = 0.0;
        [self setCheckImageViewCenter:CGPointMake(23, CGRectGetHeight(self.bounds) * 0.5 + 2) alpha:1.0 animated:animated];
    }
    else
    {
        m_checked = NO;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundView = nil;
        
        if (m_checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5) alpha:0.0 animated:animated];
        }
    }
}


- (void)dealloc
{
    m_checkImageView = nil;
}


- (void) setChecked:(BOOL)checked
{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
}
- (void)deleteAction:(UIButton*)sender
{
    if (_block != nil) {
        
        _block(self,sender);
    }
}
- (void)returnDeleteBlock:(DeleteBlock)block
{
    _block = block;
}
@end
