//
//  ListTableView.h
//  Punish
//
//  Created by qunqu on 16/10/25.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListTableView;

@protocol  ListTableViewDelegate<NSObject>

@required
- (void) listTableView:(ListTableView*)view userName:(NSString*)username department:(NSString *)department;

@end

@interface ListTableView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;////存放tableView中显示数据的数组

@property (nonatomic, strong)  NSMutableDictionary *memberDictionary;//数据源
@property (nonatomic, strong) NSMutableArray * sourceArray;//数据源

@property (nonatomic, assign) id<ListTableViewDelegate> delegate;
//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;
@end
