//
//  AddMessageViewController.m
//  LCPunish
//
//  Created by YuChangLin on 16/10/12.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import "AddMessageViewController.h"
#import "MacroDefinitionFile.h"

#import "UIPlaceholderTextView.h"

#import "MBProgressHUD+MJ.h"

#import "DataOperationTool.h"


#import "DropSelectListView.h"
@interface AddMessageViewController ()<UITextViewDelegate>{
    
    NSString *_type;
}

@property (nonatomic , strong) UIPlaceholderTextView *textView;

@property (nonatomic , strong) DropSelectListView *dropSelectListView;//下拉选择器
@property (nonatomic , strong) NSMutableArray*typeArray;

@end

@implementation AddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBarItems];
    
    [self loadData];
    
    [self initSubviews];
    

}
#pragma mark - Load Data
- (void)loadData
{
    _type = @"";
    _typeArray = [NSMutableArray arrayWithObjects:@"公司",@"部门", nil];
    
    //写入到本地
    NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"type.plist"];
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];  //读取数据
    NSLog(@"dic2 is:%@",dic2);
    
    NSArray *values = [dic2 allValues];
    if (values.count == 0) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_typeArray,@"type", nil];
        
        [dic writeToFile:filename atomically:YES];
        
    }else{
        
        [_typeArray removeAllObjects];
        [_typeArray addObjectsFromArray:[values firstObject]];
        
    }
    
}
#pragma mark - Draw UI
-(void)customNavigationBarItems
{
    //1 back
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 28)];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 3, 70, 25)];
    [backButton setImage:[UIImage imageNamed:@"backNav"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
    [leftview addSubview:backButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftview];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    //2 title
    self.navigationItem.title = @"添加内容";
    
}

- (void)initSubviews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.textView];
    
    UILabel *typeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textView.frame) + 20, 50, 30)];
    typeTitle.text = @"类型:";
    typeTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:typeTitle];
    
    [self.view addSubview:self.dropSelectListView];
    
    __weak typeof(self) weakSelf = self;
    self.dropSelectListView.ClickDropDown = ^(NSInteger index){
        
        NSString *type = weakSelf.dropSelectListView.listItems[index];
        NSLog(@"选择了-------------:%@",type);
        _type = type;
    };
    
    
    UIButton *moreSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreSelBtn.frame = CGRectMake(CGRectGetMaxX(self.dropSelectListView.frame) + 20, CGRectGetMaxY(self.textView.frame) + 22.5, 80, 25);
    [moreSelBtn setTitle:@"自定义类型" forState:UIControlStateNormal];
    [moreSelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    moreSelBtn.layer.cornerRadius = 5;
    [moreSelBtn setBackgroundColor:RGB(245, 101, 85)];
    moreSelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [moreSelBtn addTarget:self action:@selector(moreSelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreSelBtn];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, CGRectGetMaxY(self.textView.frame) + 200, SCREEN_WIDTH - 40, 40);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundColor:RGB(245, 101, 85)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20;
    
    [button addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    
}
-(UIPlaceholderTextView*)textView
{
    if (_textView == nil) {
        _textView = [[UIPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 100)];
        _textView.editable = YES;
        _textView.delegate = self;
        //        _textView.backgroundColor = [UIColor redColor];
        _textView.font = [UIFont systemFontOfSize:20];
        _textView.layer.masksToBounds = YES;
        //设置圆角
        _textView.layer.cornerRadius = 5.0;
        //设置边框宽度
        _textView.layer.borderWidth = 1.0;
        //设置边框颜色
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.placeholderColor = [UIColor lightGrayColor];
        _textView.placeholder = @"这一刻你想说什么......";
    }
    return _textView;
}

- (DropSelectListView*)dropSelectListView{
    if (_dropSelectListView == nil) {
        _dropSelectListView = [[DropSelectListView alloc] initWithFrame:CGRectMake(70 + 10, CGRectGetMaxY(self.textView.frame) + 22.5, 150, 25)];
        // 边框颜色
        _dropSelectListView.borderColor = [UIColor lightGrayColor];
        // 边框宽度
        _dropSelectListView.borderWidth = 1.0f;
        // 圆角
        _dropSelectListView.cornerRadius = 5;
        // 背景颜色
        _dropSelectListView.comBackgroundColor = [UIColor whiteColor];
        // 标题大小
        _dropSelectListView.titleSize = 14;
        // 设置数据源
        _dropSelectListView.listItems = _typeArray;
        // 设置最大列数
        _dropSelectListView.maxRows = 5;
        // 默认标题
        _dropSelectListView.defaultTitle = @"请选择类型：";
    }
    return _dropSelectListView;
}
#pragma mark - Click Action
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void )sureBtnAction:(UIButton*)sender
{
    
    if (self.textView.text.length == 0 || _type.length == 0 || [_type isEqualToString:_dropSelectListView.defaultTitle]) {
        
        [MBProgressHUD showError:@"信息输入不完整，请填写完整再次提交"];
        return;
    }
    //转换成字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString *message = self.textView.text;
    NSString *isSelected = @"0";
    NSString *type = _type;
    [dic setValue:message forKey:@"punishMessage"];
    [dic setValue:isSelected forKey:@"isSelected"];
    [dic setValue:type forKey:@"type"];
    [self insertPunishMessage:dic];
}

- (void)moreSelBtnAction
{
    [self inputMoreSelectType];
}

- (void)inputMoreSelectType{
    
    //关闭列表
    [self.dropSelectListView closeMenu];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入类型" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *typeTextField = alertController.textFields.firstObject;
        
        NSLog(@"类型名 = %@",typeTextField.text);
        
        [_typeArray addObject:typeTextField.text];
        
        
        //写入到本地
        NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"type.plist"];
        NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];  //读取数据
        NSLog(@"dic2 is:%@",dic2);
        
        //创建一个dic，写到plist文件里
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_typeArray,@"type",nil]; //写入数据
        [dic writeToFile:filename atomically:YES];
    }]];
    
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入类型";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - FMDB
// 2016.9.26 改动：数据库的具体操作封装到DataOperationTool 中，以类方法进行调用
- (void)insertPunishMessage:(NSDictionary *)messageDic
{
    //插入
    BOOL result = [DataOperationTool insertToTable:PunishMessage_TABLE  dict:messageDic];
    
    if (result) {
        
        NSLog(@"插入成功");
        self.textView.text = @"";
        //        [self.textView resignFirstResponder];
        
        [MBProgressHUD showSuccess:@"添加成功！"];
    }else{
        [MBProgressHUD showError:@"添加失败！"];
        NSLog(@"插入失败");
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    
    //关闭列表
    [self.dropSelectListView closeMenu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
