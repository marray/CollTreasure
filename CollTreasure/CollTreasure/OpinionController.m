//
//  OpinionController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "OpinionController.h"
#import "TotalCountController.h"
#import "PersonalController.h"
#import "NewMessageController.h"
#import "RequestController.h"

@interface OpinionController ()<NSURLConnectionDataDelegate,UITextViewDelegate>{
    NSMutableData *_data;
    UILabel *lable;
}

@end

@implementation OpinionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mybar.barTintColor=[UIColor colorWithRed:0.73 green:0.58 blue:0.15 alpha:1];
    [_mybar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _mybar.translucent = NO;
    
    self.view.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.93];
    lable=[[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    lable.enabled=NO;
    lable.text=@"您的建议";
    lable.font=[UIFont systemFontOfSize:15.0f];
    lable.textColor=[UIColor lightGrayColor];
    [_myop addSubview:lable];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mybar.frame=CGRectMake(0, 0, 320, 75);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UItextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    if([_myop.text length]==0){
        [lable setHidden:NO];
    }else{
        [lable setHidden:YES];
    }
}


-(void)backOpinion:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 提交反馈意见
-(void)sendOp:(id)sender{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"use_id"];//根据键值取出name
    [self sendRequest:name];
}


-(void)sendRequest:(NSString *)useid{
    NSString *param=[NSString stringWithFormat:@"ad_uid=%@&ad_advice=%@",useid,_adviceContent.text];
    RequestController *requestcon=[[RequestController alloc]init];
    NSMutableURLRequest *request=[requestcon sendRequest:@"advice/insert" andParam:param];
    //创建连接
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    //启动连接
    [connection start];
    
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
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"status"];
    
    NSString *status=[NSString stringWithFormat:@"%@",weatherInfo];
    NSLog(@"%@",status);
    if([status isEqualToString:@"1"]){
        //不存在该用户
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交成功！感谢您的反馈！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        _adviceContent.text=@"";
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is:%@",error.localizedDescription);
}



@end
