//
//  AddColumViewController.m
//  CollTreasure
//
//  Created by Stefan on 14/12/29.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "AddColumViewController.h"
#import "TotalCountController.h"
#import "PersonalController.h"
#import "NewMessageController.h"
#import "cashInfo.h"
#import "Sqllib.h"

@interface AddColumViewController ()<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource>{
    NSArray *typeArray;//省份的数组
}

@end

@implementation AddColumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _confirmButton.backgroundColor=[UIColor blueColor];
    _barnumber.backgroundColor=[UIColor lightGrayColor];
    _money.backgroundColor=[UIColor lightGrayColor];
    _time.backgroundColor=[UIColor lightGrayColor];
    _type.backgroundColor=[UIColor lightGrayColor];
    
    _barnumber.keyboardType = UIKeyboardTypeNumberPad;
    _money.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self setUpForDismissKeyboard];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    _barnumber.text=[defaults objectForKey:@"barnumber"];
    
    //日期插件的不同各是选择
    _datepicker.datePickerMode = UIDatePickerModeDate;
    //日期选择中文字体
    _datepicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //日期格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dates = [dateFormatter stringFromDate:[NSDate new]];
    //默认值设置
    _time.text=[NSString stringWithFormat:@"%@",dates];
    //类型选择的数组
    typeArray = [NSArray arrayWithObjects:@"寄付",@"到付",@"代收货款", nil];
    _type.inputView = _selecttype;
    _time.inputView=_datepicker;
    _type.inputAccessoryView = _toolbar;
    _time.inputAccessoryView=_dateBar;
    _type.delegate = self;
    _selecttype.delegate = self;
    _selecttype.dataSource = self;
    _selecttype.frame = CGRectMake(0, 480, 320, 216);
    _datepicker.frame = CGRectMake(0, 480, 320, 216);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@" \n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:_selecttype];
    [alert.view addSubview:_datepicker];
    [self presentViewController:alert animated:YES completion:^{
        
    }];

  
}

- (void)alertError:(NSString *)error
{
    // 1.弹框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


//以下3个方法实现PickerView的数据初始化
//确定picker的轮子个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
   
    return [typeArray count];

}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [typeArray objectAtIndex:row];

}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger firstViewRow = [_selecttype selectedRowInComponent:0];
    NSString * firstString = [typeArray objectAtIndex:firstViewRow];
    NSString *textString = [[NSString alloc ] initWithFormat:@"%@", firstString];
    _type.text = textString;
}

//类型选择toolbar确定按钮事件
- (IBAction)selectButton:(id)sender {
    [_type endEditing:YES];
}

//日期选择的toolbar确定按钮事件
-(IBAction)selectConfirm:(id)sender{
   // NSString *datetime=[NSString stringWithFormat:@"%@",_datepicker.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *datetime = [dateFormatter stringFromDate:_datepicker.date];
    _time.text=datetime;
    NSLog(@"time:%@",datetime);
    [_time endEditing:YES];
}


-(void)addconfirm:(id)sender{
    
    if(_barnumber.text.length==0){
        [self alertError:@"请输入条码号！"];
    }else if(_barnumber.text.length!=12){
        [self alertError:@"您输入的条码号有误！"];
    }else if(_money.text.length==0){
        [self alertError:@"请输入金额！"];
    }else{
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *name = [defaults objectForKey:@"use_id"];//根据键值取出name
        cashInfo *cashinfo=[[cashInfo alloc]init];
        cashinfo.hbar=_barnumber.text;
        cashinfo.htype=_type.text;
        cashinfo.hmoney=_money.text;
        cashinfo.hdate=_datepicker.date;
        cashinfo.huid=name;
        Sqllib *sqlli=[[Sqllib alloc]init];
        [sqlli insertDataWithNumber:cashinfo];
        //[sqlli selectByUnique:@"236589074523" andtype:@"到付"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        [self back:_backButton];
    }
}

-(void)back:(id)sender{
    // [self dismissViewControllerAnimated:YES completion:nil];
    TotalCountController *totalCountController=[[TotalCountController alloc]initWithNibName:@"totalCount" bundle:nil];
    totalCountController.title=@"统计中心";
    PersonalController *personalController=[[PersonalController alloc]initWithNibName:@"personal" bundle:nil];
    personalController.title=@"个人中心";
    NewMessageController *newMessageController=[[NewMessageController alloc]initWithNibName:@"newMessage" bundle:nil];
    newMessageController.title=@"最新动态";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:totalCountController, newMessageController,personalController, nil];
    
    //    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"统计中心" image:[UIImage imageNamed:@"菜单栏选中状态.png"] selectedImage:[UIImage imageNamed:@"菜单栏选中状态.png"]];
    
    //    totalCountController.tabBarItem = item;
    //从UIViewController跳转到页面UITabBarController
    [self presentViewController:tabBarController animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按任意建退出键盘
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}



@end
