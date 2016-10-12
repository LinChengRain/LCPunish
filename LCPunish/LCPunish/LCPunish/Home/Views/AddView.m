//
//  AddView.m
//  Punish
//
//  Created by YuChangLin on 16/9/13.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "AddView.h"
#import "DepartmentView.h"
#import "MacroDefinitionFile.h"

@interface AddView ()<UITextFieldDelegate,DepartmentViewDelegate>{


}

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic ,strong)DepartmentView *departmentView;
@end
@implementation AddView

-(void)awakeFromNib{
    [super awakeFromNib];
    //设置圆角
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 17;
    
    //设置代理
    self.username.delegate = self;
    self.department.delegate = self;
    [self.department addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
    
    self.showList = NO; //默认不显示下拉框
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _dataArr = @[@"服务",@"研发",@"教育"];
       
    }
    return self;
}
-(DepartmentView*)departmentView{
    if (_departmentView == nil) {
        _departmentView = [[DepartmentView alloc] initWithFrame:CGRectMake(93, 115, KSCREEN_WIDTH - 93 - 30, 150)];
        _departmentView.delegate = self;
        _departmentView.dataArray = [NSMutableArray arrayWithArray:_dataArr];
    }
    return _departmentView;
}
#pragma mark - Click Action
- (IBAction)sureBtn:(UIButton *)sender {
   
    [self saveMessage];
}
-(void)dropdown{
    [self.department resignFirstResponder];
    
    if (self.showList) {
        return;
    }else{
        
        [self addSubview:self.departmentView];
        
         self.showList = YES;//显示下拉框
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        
        CGRect frame =  self.departmentView.frame;
        frame.size.height = 150;
        
        [UIView animateWithDuration:0.3 animations:^{
            
           
            self.departmentView.frame = frame;
        }];
        
    }
}
#pragma mark - DepartmentViewDelegate
-(void)departmentView:(DepartmentView *)view selectIndex:(NSInteger)selectIndex selectTitle:(NSString *)title{
   
    self.department.text = title;
    
    CGRect frame =  self.departmentView.frame;
    frame.size.height = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.showList = NO;//不显示下拉框
        self.departmentView.frame = frame;
        
        [self.departmentView dismiss];
        
        [self.departmentView removeFromSuperview];
        self.departmentView = nil;
    }];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.department == textField) {
        return NO;
    }
    return YES;
}
-(void)saveMessage
{
    if (self.username.text.length == 0 || self.department.text.length == 0 ) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"姓名和部门不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alterView show];
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(addViewWithView:username:department:)]) {
        
        [self.delegate addViewWithView:self username:self.username.text department:self.department.text];
    }

}

-(void)dimissResponseKeybord{

    [self.username resignFirstResponder];

}
@end
