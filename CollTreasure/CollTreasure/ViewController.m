//
//  ViewController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/11/27.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "ViewController.h"
#import "RegisterController.h"
#import "TotalCountController.h"
#import "PersonalController.h"
#import "NewMessageController.h"
#import "RequestController.h"
#import "APService.h"

@interface ViewController ()<NSURLConnectionDataDelegate>{
    dispatch_source_t _timer;
    NSMutableData *_data;//响应数据
    NSString *code;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _confirmbutton.backgroundColor=[UIColor colorWithRed:0.69 green:0.54 blue:0.08 alpha:1];
    _confirmbutton.layer.cornerRadius=5;
    
    [_registerbutton.layer setMasksToBounds:YES];
    [_registerbutton.layer setCornerRadius:5.0];
    [_registerbutton.layer setBorderWidth:1.0];
    [_registerbutton.layer setBorderColor:[[UIColor colorWithRed:0.7 green:0.7 blue:0.65 alpha:1] CGColor]];
    
    [_myimageview.layer setMasksToBounds:YES];
    [_myimageview.layer setCornerRadius:5.0];
    [_myimageview.layer setBorderWidth:1.0];
    [_myimageview.layer setBorderColor:[[UIColor colorWithRed:0.7 green:0.7 blue:0.65 alpha:1] CGColor]];
    
    
    //数字键盘
    _useid.keyboardType = UIKeyboardTypeNumberPad;
    _checkcode.keyboardType = UIKeyboardTypeNumberPad;

    //图片拉伸
//    UIImage *image = [UIImage imageNamed:@"yuanjiao.png"];
//    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
//    [_confirmbutton setBackgroundImage:image forState:UIControlStateNormal];
    
    
    [_useid addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_useid addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_checkcode addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_checkcode addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    [self setUpForDismissKeyboard];
//    NSString *str=[APService registrationID];
//    NSLog(@"序列号：%@",str);
    
}

#pragma mark 弹出错误提示
- (void)alertError:(NSString *)error
{
    // 1.弹框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)gotoRegister:(id)sender{
    RegisterController *registerController=[[RegisterController alloc]initWithNibName:@"registerone" bundle:nil];
    [self presentViewController:registerController animated:YES completion:nil];
}

-(void)getthecheckcode:(id)sender{
    //[self.view endEditing:YES];
    //1⃣️验证工号不为空
    //2⃣️验证工号是否存在
    //3⃣️发送验证码验证
    if(_useid.text.length==0){
        [self alertError:@"工号不能为空！"];
    }else{
        //按钮倒计时
        //发送请求
        //存储用户名ID
        [_getcheckcodebutton addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
        [self sendRequest:_useid.text];
        
    }

}

-(void) uselogin:(id)sender{
    if(_checkcode.text.length==0){
        [self alertError:@"请填写验证码！"];
    }else if(![_checkcode.text isEqualToString:code]){
        [self alertError:@"验证码输入有误！"];
        
    }else{
    
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
    
    dispatch_source_cancel(_timer);
        
    }
    
}



-(void)sendRequest:(NSString *)useid{
    RequestController *requestcon=[[RequestController alloc]init];
    ;
    NSString *param=[NSString stringWithFormat:@"u_id=%@&u_phoneid=%@",useid,[APService registrationID]];
    NSMutableURLRequest *request=[requestcon sendRequest:@"user/SendMessages" andParam:param];
    
    //创建连接
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    //启动连接
    [connection start];
    //[requestcon sendRequestAndJson:@"sendMessages" andParam:param];

}

#pragma mark - 连接代理方法
#pragma mark 开始响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data=[[NSMutableData alloc]init];
    
}

#pragma mark 接收响应数据（根据响应内容的大小此方法会被重复调用）
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //连续接收数据
    [_data appendData:data];
    
}

#pragma mark 数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //解析json数据
    NSError *error;
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:&error];
    NSString *message =[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"message"]];
    NSString *status=[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"status"]];
    
    NSLog(@"messages:%@",message);
    NSLog(@"status：%@", status );
    if([message isEqualToString:@"false"]){
        [self alertError:@"该工号不存在！"];
        dispatch_source_cancel(_timer);
        [_getcheckcodebutton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getcheckcodebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getcheckcodebutton.userInteractionEnabled = YES;
    }else{
        
        if([status isEqualToString:@"0"]){
            [self alertError:@"该工号未注册！"];
            dispatch_source_cancel(_timer);
            [_getcheckcodebutton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_getcheckcodebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _getcheckcodebutton.userInteractionEnabled = YES;
        }else{
            code=[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"obj"]];
        
            //存储工号到手机
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            //NSString *name =@”default string“;
            [defaults setObject:_useid.text forKey:@"use_id"];
        
        }
    }
    
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is:%@",error.localizedDescription);
}


-(void)startTime{
    __block int timeout=180; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getcheckcodebutton setTitle:@"请重新获取" forState:UIControlStateNormal];
                [_getcheckcodebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _getcheckcodebutton.userInteractionEnabled = YES;
            });
            code=0;
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 1000;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_getcheckcodebutton setTitle:[NSString stringWithFormat:@"%@ 秒",strTime] forState:UIControlStateNormal];
                [_getcheckcodebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _getcheckcodebutton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
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

//让键盘上移避免挡住输入框的内容
-(void)textFieldDidBeginEditing:(UITextField *)textField{   //开始编辑时，整体上移
    if (textField.tag==0) {
        [self moveView:-140];
    }
    if (textField.tag==1)
    {
        [self moveView:-260];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{     //结束编辑时，整体下移
    if (textField.tag==0) {
        [self moveView:140];
    }
    if (textField.tag==1)
    {
        [self moveView:260];
    }
}
-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
