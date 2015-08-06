//
//  DetailController.m
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "DetailController.h"
#import "TotalCountController.h"
#import "PersonalController.h"
#import "NewMessageController.h"
#import "cashInfo.h"
#import "RequestController.h"

NSString *const TableSampleIdentifier = @"TableSampleIdentifier";

@interface DetailController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>{
    NSDictionary *dicc;
    NSUserDefaults *defaults;
    NSString *bar;
    NSString *type;

}

@property (nonatomic,strong) NSDictionary *list;

@end

@implementation DetailController
@synthesize list=_list;

- (void)viewDidLoad {
    [super viewDidLoad];
    _mybar.barTintColor=[UIColor colorWithRed:0.73 green:0.58 blue:0.15 alpha:1];
    [_mybar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _mybar.translucent = NO;
    
    //(id)[UIImage imageWithColor:[UIColor colorWithRed:0.73 green:0.58 blue:0.15 alpha:1]].CGImage;
    
    defaults=[NSUserDefaults standardUserDefaults];
    if([defaults integerForKey:@"total_list_size"]==0){
        // 1.弹框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有可以显示的数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    NSDictionary *results=[defaults objectForKey:@"detail_List"];
    //detail_List
    dicc=[defaults objectForKey:@"detail_List"];
    
    //设置没数据时隐藏下划线
    [self.myTableview setScrollEnabled:NO];
    [self setEXtraCellLineHidden:self.myTableview];
    
    //下滑线从左边显示
    if ([self.myTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.list=results;
}



#pragma mark- tableview的处理
//多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [defaults integerForKey:@"total_list_size"];
}

//设置没数据时下划线隐藏
-(void)setEXtraCellLineHidden:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

//下划线下从左边开始显示
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//每组每行的数据，设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
    }
    
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSUInteger row = [indexPath row];
    NSString *s=[NSString stringWithFormat:@"total_list_%lu",(unsigned long)row];
    
    //时间戳转时间
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateStyle:NSDateFormatterMediumStyle];
    [formate setTimeStyle:NSDateFormatterShortStyle];
    [formate setDateFormat:@"yyyy.MM.dd"];
    NSString *ti=[NSString stringWithFormat:@"%@",[[dicc objectForKey:s]objectForKey:@"h_date"]];
    NSString *d=[ti substringWithRange:NSMakeRange(0, 10)];
    NSDate *da=[NSDate dateWithTimeIntervalSince1970:[d floatValue]];
    NSString *dateTime=[formate stringFromDate:da];

    //显示日期
    UILabel *mylable=[[UILabel alloc] initWithFrame:CGRectMake(40,23,220,15)];
    mylable.font=[UIFont systemFontOfSize:14.0f];
    mylable.textColor=[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1];
    mylable.text=[NSString stringWithFormat:@"%@",dateTime];
    
    //显示基本信息
    UILabel *mylable2=[[UILabel alloc] initWithFrame:CGRectMake(10,35,cell.frame.size.width-170,70)];
    mylable2.numberOfLines=0;
    mylable2.font=[UIFont systemFontOfSize:15.0f];
    mylable2.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    mylable2.lineBreakMode=UILineBreakModeCharacterWrap;
    mylable2.text=[NSString stringWithFormat:@"运单号  %@类型     %@",[[dicc objectForKey:s]objectForKey:@"h_bar"],[[dicc objectForKey:s]objectForKey:@"h_type"]];
    

    UILabel *yuan=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-30, 50, 30, 40)];
    yuan.font=[UIFont systemFontOfSize:15.0f];
    yuan.textColor=[UIColor colorWithRed:0.78 green:0.67 blue:0.32 alpha:1];
    yuan.text=@"元";
    
    //显示金额
    UILabel *mylable3=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 50, 100, 40)];
    mylable3.font=[UIFont boldSystemFontOfSize:35.0f];
    mylable3.textColor=[UIColor colorWithRed:0.73 green:0.58 blue:0.15 alpha:1];
    mylable3.text=[NSString stringWithFormat:@"%@",[[dicc objectForKey:s]objectForKey:@"h_money"]];
    
    [cell.contentView addSubview:mylable];
    [cell.contentView addSubview:mylable2];
    [cell.contentView addSubview:mylable3];
    [cell.contentView addSubview:yuan];
    
    //设置显示列表的字体
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    
    UIImageView *uiv=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
    [uiv setImage:[UIImage imageNamed:@"时钟.png"]];
    [cell.contentView addSubview:uiv];
    
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-110, 60, 20, 20)];
    [iv setImage:[UIImage imageNamed:@"add.png"]];
    [cell.contentView addSubview:iv];
//    cell.accessoryView=iv;
    
    
    //4.返回cell
    return cell;
}
//设置单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

//选中单元格所产生事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    //    从数组中取出当前行内容
    NSString *s=[NSString stringWithFormat:@"total_list_%li",(long)row];
    bar = [NSString stringWithFormat:@"%@",[[dicc objectForKey:s]objectForKey:@"h_bar"]];
    type = [NSString stringWithFormat:@"%@",[[dicc objectForKey:s]objectForKey:@"h_type"]];
    //    弹出警告信息
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改金额"
                                                   message:@" "
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles: @"修改",nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];

    
}

#pragma mark 获得对话框中输入框里的值／／对话框按钮触发事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *bt=[alertView buttonTitleAtIndex:buttonIndex];
    if([bt isEqualToString:@"修改"]){
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSString *content=tf.text;
        NSLog(@"输入框的内容：%@",content);
        
        NSString *param=[NSString stringWithFormat:@"h_bar=%@&h_type=%@&h_money=%@",bar,type,content];
        [self sendRequest:param];
        NSLog(@"alertView.tag:%li",(long)buttonIndex);
//        NSString *s=[NSString stringWithFormat:@"total_list_%i",0];
//        [[dicc objectForKey:s]setObject:content forKey:@"h_money"];
//        NSLog(@"修改后的金额：%@",[NSString stringWithFormat:@"%@",[[dicc objectForKey:s]objectForKey:@"h_money"]]);
        [self viewWillAppear:YES];
    }
}


-(void)sendRequest:(NSString *)param{
    RequestController *requestcon=[[RequestController alloc]init];
    NSMutableURLRequest *request=[requestcon sendRequest:@"his/updateMoney" andParam:param];
    
    // 初始化一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         // 解析成字符串数据
//         NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *status=[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"status"]];
         NSLog(@"status前:%@",status);
         
         if([status isEqualToString:@"1"]){
             NSLog(@"status:%@",status);
             

         }
         
     }];
    
}


//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"调用了 didDeselectRowAtIndexPath 方法。");
//}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!tableView.editing){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myTableview reloadData];
    _mybar.frame=CGRectMake(0, 0, 320, 75);
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)detailBack:(id)sender{
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

@end
