//
//  AppDelegate.m
//  CollTreasure
//
//  Created by 肖彬 on 14/11/27.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RegisterController.h"
#import "TotalCountController.h"
#import "PersonalController.h"
#import "NewMessageController.h"
#import "FirstController.h"
#import "APService.h"
#import "Sqllib.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    ViewController *login=[[ViewController alloc]initWithNibName:@"login" bundle:nil];
//    login.title=@"登陆";
//    self.window.rootViewController=login;
//    RegisterController *regist=[[RegisterController alloc]initWithNibName:@"registerone" bundle:nil];
//    regist.title=@"注册";
    FirstController *firstcon=[[FirstController alloc]initWithNibName:@"firstView" bundle:nil];
    firstcon.title=@"第一个";
    self.window.rootViewController=firstcon;
    
    //状态栏颜色设置
    //1.在info.plist添加一行view Controller-based，，设置值为NO
    //2.添加代码
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
//这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //kJPFNetworkDidReceiveMessageNotification
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //[self createLocalNotification];
    //[defaultCenter postNotificationName:@"message" object:@"数据"];
    
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//         NSLog(@"进来了啊if？");
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }  else {
//        NSLog(@"进来了啊else？");
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//        
//    }
    
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        NSLog(@"当前版本号：%f",[[UIDevice currentDevice].systemVersion floatValue]);
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }

    // Required
    [APService setupWithOption:launchOptions];
    
    if(launchOptions &&[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]){
        NSLog(@"通过push启动应用，数据：%@",[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]);
    }
    
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //成功注册registerUserNotificationSettings:后，回调的方法
    NSLog(@"%@",notificationSettings);
    
    [application registerForRemoteNotifications];
}
#endif




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"原始deviceToken:%@",deviceToken);
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSLog(@"何时进来？");
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    [APService handleRemoteNotification:userInfo];
    NSLog(@"userInfo内容:%@",userInfo);
    
    if([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive){
        NSLog(@"程序运行在前台。。。");
    }else{
        UILocalNotification *localnotification=[[UILocalNotification alloc]init];
        localnotification.alertAction=@"ok";
        localnotification.alertBody=content;
        localnotification.applicationIconBadgeNumber=1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];
    }
    
    
    
    //[self createLocalNotification];
}


-(void)createLocalNotification{
    // 创建一个本地推送
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    if(notification != nil){
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = @"推送内容";
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}



// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    notification.alertBody=@"测试推送的快捷回复";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    NSLog(@"notification  %@----%@",identifier,notification);
    completionHandler();//处理完消息，最后一定要调用这个代码块
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    NSLog(@"userInfo  %@----%@",identifier,userInfo);
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
    
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"点击提示框。。。");
    // 点击提示框打开
    //application.applicationIconBadgeNumber=0;
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"接受到的push的数据：%@",userInfo);
    
    //清除图标上的通知纪录条数
//    application.applicationIconBadgeNumber=0;
    
//    NSString *topId=[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    
    // Required
    [APService handleRemoteNotification:userInfo];
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"接受到的push的数据 IOS7：%@",userInfo);
    
  //  NSString *str=[APService registrationID];
   // NSLog(@"str:%@",str);
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
//    [rootViewController addNotificationCount];
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册推送权限失败，error:%@",error);
}






@end
