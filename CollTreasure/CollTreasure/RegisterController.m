//
//  RegisterController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/11/28.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "RegisterController.h"
#import "ViewController.h"
#import "RequestController.h"

@interface RegisterController ()<NSURLConnectionDataDelegate>{
    NSMutableData *_data;//响应数据
}
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    //数字键盘
    _useid.keyboardType = UIKeyboardTypeNumberPad;
    _tellphone.keyboardType=UIKeyboardTypeNumberPad;
    
    //图片圆角和边框
    [_myimageview.layer setMasksToBounds:YES];
    [_myimageview.layer setCornerRadius:5.0];
    [_myimageview.layer setBorderWidth:1.0];
    [_myimageview.layer setBorderColor:[[UIColor colorWithRed:0.7 green:0.7 blue:0.65 alpha:1] CGColor]];
    
    //按钮背景色和圆角
    _registerButton.backgroundColor=[UIColor colorWithRed:0.69 green:0.54 blue:0.08 alpha:1];
    _registerButton.layer.cornerRadius=5;
    
    //键盘上移
    [_useid addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_useid addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_usename addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_usename addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_tellphone addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_tellphone addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    //按任意键键盘退出
    [self setUpForDismissKeyboard];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 弹出错误提示
- (void)alertError:(NSString *)error
{
    // 1.弹框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)useregister:(id)sender{
    if(_useid.text.length==0){
        [self alertError:@"工号不能为空！"];
        
    }else if (_usename.text.length==0){
       [self alertError:@"姓名不能为空！"];
        
    }else{
        [self sendRequest];
    }
}

-(void)gotoLogin:(id)sender{
    ViewController *viewController=[[ViewController alloc]initWithNibName:@"login" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)sendRequest{
    RequestController *requestcon=[[RequestController alloc]init];
    NSString *param=[NSString stringWithFormat:@"u_id=%@&u_name=%@&u_phoneid=%@",_useid.text,_usename.text,@"DNPMH52RFNNL"];
    NSMutableURLRequest *request=[requestcon sendRequest:@"user/Exist" andParam:param];
    
    //创建连接
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    //启动连接
    [connection start];
    //[requestcon sendRequestAndJson:@"sendMessages" andParam:param];
    
}

#pragma mark - 连接代理方法
#pragma mark 开始响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"receive response.");
    _data=[[NSMutableData alloc]init];
    
}

#pragma mark 接收响应数据（根据响应内容的大小此方法会被重复调用）
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receive data.");
    //连续接收数据
    [_data appendData:data];
    
}

#pragma mark 数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"loading finish.");
    
    //解析json数据
    NSError *error;
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:&error];
    NSString *message =[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"message"]];
    NSString *status=[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"status"]];
    
    NSLog(@"messages:%@",message);
    NSLog(@"status：%@", status );
    if([message isEqualToString:@"false"]){
        if([status isEqualToString:@"1"]){
            [self alertError:@"该工号不存在！"];
        }else if([status isEqualToString:@"2"]){
            [self alertError:@"该工号与姓名不匹配！"];
        }
        
    }else{
        if([status isEqualToString:@"0"]){
            [self alertError:@"该工号已注册！"];
            ViewController *viewController=[[ViewController alloc]initWithNibName:@"login" bundle:nil];
            [self presentViewController:viewController animated:YES completion:nil];
        }else if([status isEqualToString:@"1"]){
            //登陆成功
            ViewController *viewController=[[ViewController alloc]initWithNibName:@"login" bundle:nil];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
    
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is:%@",error.localizedDescription);
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




@end
