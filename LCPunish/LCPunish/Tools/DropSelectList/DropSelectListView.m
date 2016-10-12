//
//  DropSelectListView.m
//  LCDropSelectList
//
//  Created by YuChangLin on 16/10/11.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "DropSelectListView.h"

@interface DropSelectListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *dropArrow;


@property (nonatomic, assign) CGFloat heightDrop;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DropSelectListView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:[UIColor blackColor ]];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark - Draw UI
- (void)initSubviews
{
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    button.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dropdownClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    self.button = button;
    
    //向下列表（图标）
    UIButton *dropArrow = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
    [dropArrow setImage:[UIImage imageNamed:[NSString stringWithFormat:@"DropSelectList.bundle/dropSelectList.png"]] forState:UIControlStateNormal];
    CGFloat vInset = self.bounds.size.height / 5;
    CGFloat hInset = self.bounds.size.height / 8;
    dropArrow.imageEdgeInsets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
    [dropArrow addTarget:self action:@selector(dropdownClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:dropArrow];
    self.dropArrow = dropArrow;
    
    
    //下拉框设置
    if (!_listItems) {
        [button setTitle:@" " forState:UIControlStateNormal];
    }
    CGFloat fontsize = ( button.bounds.size.height * 3.0f / 7.0f);
    [button.titleLabel setFont:[UIFont systemFontOfSize:(CGFloat)fontsize]];
    
    [self addSubview:self.tableView];
}
-(UITableView*)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _button.bounds.size.height, CGRectGetWidth(self.bounds), 0)];
        _tableView.layer.borderWidth = 1.0;
        _tableView.layer.borderColor = [[UIColor blackColor] CGColor];
        _tableView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _tableView.rowHeight = _button.bounds.size.height;
        _tableView.dataSource = self;
        _tableView.delegate = self;

    }
    return _tableView;
}

#pragma mark - Action
-(void)dropdownClick:(id)sender{
    if (!_maxRows) {
        self.heightDrop = _listItems.count > 5 ? (5 * self.tableView.rowHeight + .2f * self.button.bounds.size.height) : (self.tableView.rowHeight * _listItems.count + .2f * self.button.bounds.size.height);
    }
    if (self.tableView.frame.size.height == 0) {
        [self.tableView reloadData];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.25 animations:^{
            [weakSelf.tableView setFrame:CGRectMake(0,weakSelf.tableView.frame.origin.y, weakSelf.tableView.frame.size.width, weakSelf.heightDrop)];
            
            CGRect frameTemp = weakSelf.frame;
            frameTemp.size.height = weakSelf.button.frame.size.height + weakSelf.heightDrop;
            weakSelf.frame = frameTemp;
            [weakSelf.superview bringSubviewToFront:weakSelf];
        }completion:^(BOOL finished){
            
        }];
    }else{
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.25 animations:^{
            [weakSelf.tableView setFrame:CGRectMake(0,weakSelf.tableView.frame.origin.y, weakSelf.tableView.frame.size.width, 0)];
            CGRect frameTemp = weakSelf.frame;
            frameTemp.size.height = weakSelf.button.frame.size.height + 0;
            weakSelf.frame = frameTemp;
        }completion:^(BOOL finished){
            
        }];
    }
}

#pragma mark - UITableView Delegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"DropSelectList_Cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];;
    cell.textLabel.text = _listItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dropdownClick:self.dropArrow];
    NSString *btnTitle = _listItems[indexPath.row];
    [self.button setTitle:btnTitle forState:UIControlStateNormal];
    
    if (self.ClickDropDown) {
        self.ClickDropDown(indexPath.row);
    }
}

- (void)closeMenu {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.tableView setFrame:CGRectMake(0,weakSelf.tableView.frame.origin.y, weakSelf.tableView.frame.size.width, 0)];
        CGRect frameTemp = weakSelf.frame;
        frameTemp.size.height = weakSelf.button.frame.size.height + 0;
        weakSelf.frame = frameTemp;
    }completion:^(BOOL finished){
        
    }];
    
}

- (void)reloadData {
    self.maxRows = self.listItems.count;
    self.defaultTitle = self.listItems[0];
    [self.tableView reloadData];
}
#pragma mark - cell分割线填满
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Setter Getter
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0 ? true : false;
}

- (void)setMaxRows:(NSInteger)maxRows {
    _maxRows = maxRows;
    if (!_maxRows) {
        _maxRows = _listItems.count;
    }
    if (_maxRows <= _listItems.count) {
        self. heightDrop = self.tableView.rowHeight * _maxRows + .2f * self.button.bounds.size.height;
    }else{
        self.heightDrop = self.tableView.rowHeight * _listItems.count + .2f * self.button.bounds.size.height;
    }
}

- (void)setArrowImage:(UIImage *)arrowImage {
    _arrowImage = arrowImage;
    [self.dropArrow setImage:arrowImage forState:UIControlStateNormal];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
    self.tableView.layer.borderColor = _borderColor.CGColor;
}

-(void)setListItems:(NSArray *)listItems{
    _listItems = listItems;
    [self.button setTitle:@"" forState:UIControlStateNormal];
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self.button setTitleColor:_textColor forState:UIControlStateNormal];
}

- (void)setDefaultTitle:(NSString *)defaultTitle {
    _defaultTitle = defaultTitle;
    [self.button setTitle:_defaultTitle forState:UIControlStateNormal];
}

- (void)setComBackgroundColor:(UIColor *)comBackgroundColor {
    _comBackgroundColor = comBackgroundColor;
    self.button.backgroundColor = _comBackgroundColor;
    self.dropArrow.backgroundColor = _comBackgroundColor;
}

- (void)setTitleSize:(NSInteger)titleSize {
    self.button.titleLabel.font = [UIFont systemFontOfSize:titleSize];
}

- (void)setTestString:(NSString *)testString{
    _testString = testString;
    [self.button setTitle:_testString forState:UIControlStateNormal];
}

- (NSString *)value {
    return self.button.titleLabel.text;
}

@end
