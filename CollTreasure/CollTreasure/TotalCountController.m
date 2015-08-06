//
//  TotalCountController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "TotalCountController.h"
#import "DetailController.h"
#import "RequestController.h"
#import "ImageScrollViewController.h"
#import "cashInfo.h"
#import "Sqllib.h"
#import "AddColumViewController.h"
#import "ZBarSDK.h"



@interface TotalCountController ()<sendToDetail,ZBarReaderDelegate>{
    NSMutableData *_data;
    NSMutableDictionary *todayArray;
    NSMutableDictionary *yesterArray;
    NSMutableDictionary *weekArray;
    NSMutableDictionary *monthArray;
    
}

@end

@implementation TotalCountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_morebutton.layer setCornerRadius:23.0];
    _morebutton.layer.borderWidth=1.5f;
    _morebutton.layer.borderColor=[[UIColor whiteColor]CGColor];
    [_addbutton.layer setCornerRadius:23.0];
    _addbutton.layer.borderWidth=1.5f;
    _addbutton.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    
    todayArray=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",nil];
    yesterArray=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",nil];
    weekArray=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",nil];
    monthArray=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",nil];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"use_id"];//根据键值取出name

    NSDate *today=[NSDate date];
    NSDate *yesterday=[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *todayTime = [formate stringFromDate:today];
    NSString *yesterTime=[formate stringFromDate:yesterday];
    NSString *param1=[NSString stringWithFormat:@"h_type=%@&h_status=%@&h_uid=%@&h_startTime=%@&h_endTime=%@",@"全部",@"2",name,todayTime,todayTime];
    NSString *param2=[NSString stringWithFormat:@"h_type=%@&h_status=%@&h_uid=%@&h_startTime=%@&h_endTime=%@",@"全部",@"2",name,yesterTime,yesterTime];
    NSString *param3=[NSString stringWithFormat:@"h_type=%@&h_status=%@&h_uid=%@&h_startTime=%@&h_endTime=%@",@"全部",@"0",name,todayTime,todayTime];
    NSString *param4=[NSString stringWithFormat:@"h_type=%@&h_status=%@&h_uid=%@&h_startTime=%@&h_endTime=%@",@"全部",@"1",name,todayTime,todayTime];
  

    [self TodaypostRequest:param1];
    [self yesterdaypostRequest:param2];
    [self WeekpostRequest:param3];
    [self MonthpostRequest:param4];
    

    
}
- (void)viewDidAppear:(BOOL)animated{
    //NSLog(@"更新界面：%@",[todayArray objectForKey:@"title_0"]);
    // UIImageView默认不允许用户交互
    CGRect scrolRect=CGRectMake((self.view.frame.size.width-247)/2, 65,247, 198);
    NSArray *arr=[NSArray arrayWithObjects:todayArray,yesterArray,weekArray,monthArray,nil];
    ImageScrollViewController *imageScroll=[[ImageScrollViewController alloc] initWithListData:arr withFrame:scrolRect];
    [self.view insertSubview:imageScroll atIndex:0];
    
    [self.view sendSubviewToBack:_bgimage];


}


-(void)viewWillDisappear:(BOOL)animated{
    [self.view removeFromSuperview];
}

-(void)GoToDetail{
    DetailController *detailController=[[DetailController alloc]initWithNibName:@"tableView" bundle:nil];
    [self presentViewController:detailController animated:YES completion:nil];
}

//查询更多
-(void)getMore:(id)sender{
    
}


//添加记录 扫描 
-(void)addCash:(id)sender{
    
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    reader.showsZBarControls = YES;
    [self presentViewController:reader animated:YES completion:nil];

}


- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info

{
    
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    //_myimage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    AddColumViewController *addController=[[AddColumViewController alloc]initWithNibName:@"addcolum" bundle:nil];
    
    [self presentViewController:addController animated:YES completion:nil];
    
    //存储条码
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:symbol.data forKey:@"barnumber"];
    
    NSLog(@"结果是： %@",symbol.data);
}





-(void)dealData:(NSString *)param{
    NSError *error;
     NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *str=[defaults objectForKey:param];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"status"];
    NSString *status=[NSString stringWithFormat:@"%@",weatherInfo];
//    NSLog(@"查询总额状态：%@",status);
    NSArray *array=weatherDic[@"obj"];
    NSMutableDictionary *dicc=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",nil];
    int totalmoney=0;
    NSInteger counts=0;
    if([status isEqualToString:@"1"]){
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic=[array objectAtIndex:i];
            
            NSString *str=[NSString stringWithFormat:@"total_list_%i",i];
            NSDictionary *myDictionary=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[dic objectForKey:@"h_id"]], [NSString stringWithFormat:@"%@",[dic objectForKey:@"h_bar"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"h_type"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"h_uid"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"h_money"]],[dic objectForKey:@"h_date"], nil]forKeys:[NSArray arrayWithObjects:@"h_id", @"h_bar",@"h_type",@"h_uid",@"h_money",@"h_date", nil]];
            
            [dicc setValue:myDictionary forKey:str];
            int s=[[dic objectForKey:@"h_money"]intValue];
            totalmoney=totalmoney+s;
            
        }
        counts=array.count;
        //NSLog(@"totalmoney:%i",totalmoney);
    }else if([status isEqualToString:@"0"]){
        totalmoney=0;
        dicc=nil;
        counts=0;
    }
        if([param isEqualToString:@"today_list"]){
            [todayArray setValue:@"今日总额" forKey:@"title_0"];
            [todayArray setValue:[NSString stringWithFormat:@"%i",totalmoney] forKey:@"totalmoney_0"];
            [todayArray setValue:dicc forKey:@"detail_0"];
            [todayArray setValue:[NSString stringWithFormat:@"%li",(long)counts] forKey:@"totalsize_0"];
//            NSLog(@"today_title:%@",[todayArray objectForKey:@"title_0"]);
//            NSLog(@"todayArray:%@",[[[todayArray objectForKey:@"detail_0"]objectForKey:@"total_list_0"]objectForKey:@"h_uid"]);
        }else if([param isEqualToString:@"yesterday_list"]){
            [yesterArray setValue:@"昨日总额" forKey:@"title_1"];
            [yesterArray setValue:[NSString stringWithFormat:@"%i",totalmoney] forKey:@"totalmoney_1"];
            [yesterArray setValue:dicc forKey:@"detail_1"];
            [yesterArray setValue:[NSString stringWithFormat:@"%li",(long)counts] forKey:@"totalsize_1"];
//            NSLog(@"yesterArray:%@",[[[yesterArray objectForKey:@"detail_1"]objectForKey:@"total_list_0"]objectForKey:@"h_uid"]);
        }else if([param isEqualToString:@"week_list"]){
            //本周
            [weekArray setValue:@"本周总额" forKey:@"title_2"];
            [weekArray setValue:[NSString stringWithFormat:@"%i",totalmoney] forKey:@"totalmoney_2"];
            [weekArray setValue:dicc forKey:@"detail_2"];
            [weekArray setValue:[NSString stringWithFormat:@"%li",(long)counts] forKey:@"totalsize_2"];
//            NSLog(@"weekArray:%@",[[[weekArray objectForKey:@"detail_2"]objectForKey:@"total_list_0"]objectForKey:@"h_uid"]);
        }else if([param isEqualToString:@"month_list"]){
            //本月
            [monthArray setValue:@"本月总额" forKey:@"title_3"];
            [monthArray setValue:[NSString stringWithFormat:@"%i",totalmoney] forKey:@"totalmoney_3"];
            [monthArray setValue:dicc forKey:@"detail_3"];
            [monthArray setValue:[NSString stringWithFormat:@"%li",(long)counts] forKey:@"totalsize_3"];
//            NSLog(@"monthArray:%@",[[[monthArray objectForKey:@"detail_3"]objectForKey:@"total_list_0"]objectForKey:@"h_uid"]);

        }
    
    
    
}



-(void)TodaypostRequest:(NSString *)param{
    RequestController *requestcon=[[RequestController alloc]init];
    NSMutableURLRequest *request=[requestcon sendRequest:@"his/select" andParam:param];
    
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
         NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
          NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
         [defaults setObject:str forKey:@"today_list"];
         
         [self dealData:@"today_list"];
         
     }];
}


-(void)yesterdaypostRequest:(NSString *)param{
    RequestController *requestcon=[[RequestController alloc]init];
    NSMutableURLRequest *request=[requestcon sendRequest:@"his/select" andParam:param];
    
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
         NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
         [defaults setObject:str forKey:@"yesterday_list"];
         
         [self dealData:@"yesterday_list"];
     }];
}


-(void)WeekpostRequest:(NSString *)param{
    RequestController *requestcon=[[RequestController alloc]init];
    NSMutableURLRequest *request=[requestcon sendRequest:@"his/select" andParam:param];
    
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
         NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
         [defaults setObject:str forKey:@"week_list"];
         
         [self dealData:@"week_list"];
     }];
}


-(void)MonthpostRequest:(NSString *)param{
    RequestController *requestcon=[[RequestController alloc]init];
    NSMutableURLRequest *request=[requestcon sendRequest:@"his/select" andParam:param];
    
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
         NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
         [defaults setObject:str forKey:@"month_list"];
         
         [self dealData:@"month_list"];
     }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
