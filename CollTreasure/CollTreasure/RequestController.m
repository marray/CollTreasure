//
//  RequestController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/12/9.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "RequestController.h"

@interface RequestController ()

@end

@implementation RequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSMutableURLRequest *)sendRequest:(NSString *)path andParam:(NSString *)param{
    NSString *strurl=[NSString stringWithFormat:@"http://192.168.1.112:8080/cash/%@",path];
    NSURL *url=[NSURL URLWithString:strurl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    return request;
}

-(void)sendRequestAndJson:(NSString *)path andParam:(NSString *)param{
     //NSDictionary *weatherDic=nil;
    // 请求地址
    NSString *urlString = [NSString stringWithFormat:@"http://119.254.111.21:8080/cash_server/%@",path];
    // 初始化一个NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 初始化一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
//         NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         
     NSDictionary *weatherDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         
         NSLog(@"%@", weatherDic);
         
     }];
    //return weatherDic;
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
