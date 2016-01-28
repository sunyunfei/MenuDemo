//
//  ViewController.m
//  MenuDemo
//
//  Created by 孙云 on 16/1/28.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"
#import "Menu.h"
static CGFloat const locaX = 15;
static CGFloat const locaY = 15;
@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *menuArray;//菜单数据
@property (nonatomic,strong) NSMutableArray *sMenuArray;//选中的数据
@property (nonatomic,weak  ) UIView         *dataView;//数据区域
@property (nonatomic,weak  ) UIView         *selectedView;//选中的区域
@property (nonatomic,weak  ) UITextField    *field;//输入菜单项
@property (nonatomic,weak  ) UIButton       *chooseBtn;//选定按钮
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"尝试输入试试"];
    self.menuArray = [NSMutableArray arrayWithArray:array];
    self.sMenuArray = [NSMutableArray array];
    //加载数据区域
    [self loadDataView];
    [self loadSelectedView];
    [self loadField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  创建
 */
- (void)loadDataView
{
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height /2 + 30, self.view.frame.size.width, self.view.frame.size.height /2 - 30)];
    dataView.backgroundColor = [UIColor colorWithRed:0.883 green:1.000 blue:0.967 alpha:1.000];
    [self.view addSubview:dataView];
    self.dataView = dataView;
    
    [self loadData:self.dataView whatArray:self.menuArray];
}
/**
 *  选定的区域
 */
- (void)loadSelectedView
{
    UIView *selectedview = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height / 2 - 20)];
    [self.view addSubview:selectedview];
    self.selectedView = selectedview;
    
    [self loadData:selectedview whatArray:self.sMenuArray];
}
/**
 *  加载输入框
 */
- (void)loadField
{
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height / 2, 200, 30)];
    field.delegate = self;
    field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:field];
    self.field = field;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(220, self.view.frame.size.height / 2, 95, 30);
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"提交菜单项" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor
                           colorWithRed:0.949
                           green:1.000
                           blue:0.700
                           alpha:1.000];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.chooseBtn = btn;
}
/**
 *  提交按钮事件
 */
- (void)submit
{
    //判断输入框是否有内容
    if (![self.field.text isEqualToString:@""]) {
        //加入到菜单数组中显示
        [self.menuArray addObject:self.field.text];
        for (UIView *view in [self.dataView subviews]) {
            [view removeFromSuperview];
        }
        [self loadData:self.dataView whatArray:self.menuArray];
    }else
    {
        NSLog(@"输入为空");
    }
}
/**
 *  数据显示
 */
- (void)loadData:(UIView *)bgView whatArray:(NSMutableArray *)array
{
   __block CGFloat weakX = locaX;
   __block CGFloat weakY = locaY;
    for(int i = 0;i < array.count;i++)
    {
        [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            //创建按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+1;
            //判断是否是选中的数组
            BOOL isS = NO;
            if (array.count == self.sMenuArray.count) {
                isS = YES;
                for(int i=0; i<array.count;i++)
                {
                    NSString *str1 = array[i];
                    NSString *str2 = self.sMenuArray[i];
                    if (![str1 isEqualToString:str2]) {
                        isS = NO;
                        break;
                    }
                }
            }
            if (isS == YES) {
                btn.tag = i+1+100;
            }
            [btn setTitle:array[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
            //计算btn的宽度
            CGSize btnSize = [array[i] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            CGFloat btnW = btnSize.width + 2 * locaX;
            CGFloat btnH = 30;
            //判断一下按钮是否超出
            if ((weakX + btnW) >= self.view.frame.size.width - locaX) {
                weakX = locaX;
                weakY +=btnH + 5;
            }
            
            btn.frame = CGRectMake(weakX, weakY, btnW, btnH);
            
            //判断下一次xy位置
            weakX += btnW + locaX;
            if (weakX >= self.view.frame.size.width - locaX) {
                weakX = locaX;
                weakY += btnH + 5;
            }
            [bgView addSubview:btn];
            btn.layer.cornerRadius = btn.frame.size.width /10;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.105].CGColor;
            
        } completion:^(BOOL finished) {
            
        }];
       
    }
}
/**
 *  按钮事件
 *
 *  @param sender <#sender description#>
 */
- (void)doSomething:(UIButton *)sender
{
    //判断按钮处于哪个区域
    if (sender.tag<100) {
        // 从menuarray取出这个数据放到smenuarray里面
        NSInteger index = sender.tag - 1;
        [self.sMenuArray addObject:self.menuArray[index]];
        [self.menuArray removeObjectAtIndex:index];
    }else
    {
        // 从smenuarray取出这个数据放到smenuarray里面
        NSInteger index = sender.tag - 1 - 100;
        [self.menuArray addObject:self.sMenuArray[index]];
        [self.sMenuArray removeObjectAtIndex:index];
    }
    //数据重新加载,把上一次数据显示去除
    for(UIView *view in [self.dataView subviews])
    {
        [view removeFromSuperview];
    }
    for (UIView *view in [self.selectedView subviews]) {
        [view removeFromSuperview];
    }
    [self loadData:self.dataView whatArray:self.menuArray];
    [self loadData:self.selectedView whatArray:self.sMenuArray];
}
/**
 *  系统代理
 *
 *  @param textField <#textField description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/**
 *  点击视图取消键盘
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in [self.view subviews]) {
        [view resignFirstResponder];
    }
}
@end
