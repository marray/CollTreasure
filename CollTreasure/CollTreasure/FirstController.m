//
//  FirstController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/12/8.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "FirstController.h"
#import "TotalCountController.h"
#import "PersonalController.h"
#import "NewMessageController.h"
#import "ViewController.h"
#import "RequestController.h"

@interface FirstController ()<NSURLConnectionDataDelegate>{
    NSMutableData *_data;
}

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"1.png"],
                           [UIImage imageNamed:@"2.png"],
                           [UIImage imageNamed:@"3.png"],
                           [UIImage imageNamed:@"4.png"],nil];
    
    
    //[animationImageView initWithFrame:CGRectMake(0, 0, 131, 125)];
    _animationImageView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    _animationImageView.animationDuration = 1100.85;//设置动画时间
    _animationImageView.animationRepeatCount = 10;//设置动画次数 0 表示无限
    [_animationImageView startAnimating];//开始播放动画
    
}

//重写这个方法，对已经消失，或者被覆盖，或者已经隐藏了的视图做一些其他操作
-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"use_id"];//根据键值取出name
    [self enterLogin:name];
}

-(void)enterLogin:(NSString *)useid{
    if(useid==nil){
        ViewController *login=[[ViewController alloc]initWithNibName:@"login" bundle:nil];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        //name不为空 免登录
        //先判断该员工是否离职
        [self sendRequest:useid];
        
    }
}


-(void)sendRequest:(NSString *)useid{
    RequestController *requestcon=[[RequestController alloc]init];
    NSString *param=[NSString stringWithFormat:@"u_id=%@",useid];
    NSMutableURLRequest *request=[requestcon sendRequest:@"user/LoginWithOut" andParam:param];
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
    
    NSString *message=[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"message"]];
    NSLog(@"%@",message);
    if([message isEqualToString:@"false"]){
        //不存在该用户
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户已注销，请重新登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        //存在用户则跳转
        TotalCountController *totalCountController=[[TotalCountController alloc]initWithNibName:@"totalCount" bundle:nil];
        totalCountController.title=@"统计中心";
        PersonalController *personalController=[[PersonalController alloc]initWithNibName:@"personal" bundle:nil];
        personalController.title=@"个人中心";
        NewMessageController *newMessageController=[[NewMessageController alloc]initWithNibName:@"newMessage" bundle:nil];
        newMessageController.title=@"最新动态";
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = [NSArray arrayWithObjects:totalCountController, newMessageController,personalController, nil];
        //    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"统计中心" image:[UIImage imageNamed:@"菜单栏选中状态.png"] selectedImage:[UIImage imageNamed:@"菜单栏选中状态.png"]];
        //
        //
        //    totalCountController.tabBarItem = item;
        //从UIViewController跳转到页面UITabBarController
        
        [self presentViewController:tabBarController animated:YES completion:nil];
    }

    
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is:%@",error.localizedDescription);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
