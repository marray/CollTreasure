//
//  RegisterController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/11/28.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registerdeledaterootcontroller <NSObject>

-(void) registerrootcontrollerchanged:(UIViewController *)view;

@end

@interface RegisterController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField *useid;

@property (nonatomic,strong) IBOutlet UITextField *usename;

@property (nonatomic, strong) IBOutlet UITextField *tellphone;

@property (nonatomic,strong) IBOutlet UIButton *registerbutton;

@property (nonatomic, strong) IBOutlet UIImageView *myimageview;

@property (nonatomic, strong) IBOutlet UIButton *registerButton;

@property (nonatomic,strong) id<registerdeledaterootcontroller> registerdeledate;

-(IBAction)useregister:(id)sender;

-(IBAction)gotoLogin:(id)sender;


@end
