//
//  PersonalController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "PersonalController.h"
#import "OpinionController.h"
#import "ViewController.h"
#import "TotalCountController.h"
#import "NewMessageController.h"
#import "RequestController.h"

@interface PersonalController ()<NSURLConnectionDataDelegate>{
    NSMutableData *_data;
}

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[_opinionbutton setBackgroundImage:[UIImage imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
   // [_opinionbutton setBackgroundImage:[UIImage imageNamed:@"设置按钮－点击.png"] forState:UIControlStateHighlighted];
    //设置圆形头像
    
    _myImageView.layer.cornerRadius=_myImageView.frame.size.width/2;
    _myImageView.clipsToBounds=YES;
    //设置头像白色边框
    _myImageView.layer.borderWidth=2.0f;
    _myImageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *name= [defaults objectForKey:@"use_id"];//根据键值取出name
    [self sendRequest:name];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addOpinion:(id)sender{
    OpinionController *opinionController=[[OpinionController alloc]initWithNibName:@"opinion" bundle:nil];
    
    [self presentViewController:opinionController animated:YES completion:nil];
    
}

-(void)exdit:(id)sender{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"use_id"];//根据键值移除name
    //清楚图片缓存
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       //NSDocumentDirectory  NSCachesDirectory  
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%d",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
    
    
    ViewController *viewController=[[ViewController alloc]initWithNibName:@"login" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
}


-(void)sendRequest:(NSString *)useid{
    RequestController *requestcon=[[RequestController alloc]init];
    NSString *param=[NSString stringWithFormat:@"u_id=%@",useid];
    NSMutableURLRequest *request=[requestcon sendRequest:@"user/Info" andParam:param];
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
    NSString *status=[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"status"]];
    NSLog(@"%@",message);
    if([message isEqualToString:@"true"]){
        if([status isEqualToString:@"0"]){
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户已注销，请重新登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            //存在则显示信息到页面
            NSDictionary *weatherInfo=[weatherDic objectForKey:@"obj"];
            // [weatherInfo objectForKey:@"u_url"];
            _namelable.text=[weatherInfo objectForKey:@"u_name"];
            _useidlable.text=[weatherInfo objectForKey:@"u_id"];
            _tellphonelable.text=[weatherInfo objectForKey:@"u_tel"];
            
            NSString *pic=[NSString stringWithFormat:@"%@",[weatherInfo objectForKey:@"u_url"]];
           
            NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
            NSLog(@"file:%@",file);
            if(file.count==0){
                [self getPicture:pic];
            }else{
                //缓存加载
                UIImage * imageFromWeb = [self loadImage:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
                [_myImageView setImage:imageFromWeb];
            }

            
            
        }
    }
    
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is:%@",error.localizedDescription);
}


-(void)getPicture:(NSString *)path{
    NSLog(@"图片路径：%@",path);
    NSURL *url=[NSURL URLWithString:path];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
         //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         
         UIImage *result = [UIImage imageWithData:data];
         [_myImageView setImage:result];
         NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSLog(@"保存路径:%@",documentsDirectoryPath);
         //Save Image to Directory
         [self saveImage:result withFileName:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
       
     
    }];
}


//存储图片
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}


//加载图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}



@end
