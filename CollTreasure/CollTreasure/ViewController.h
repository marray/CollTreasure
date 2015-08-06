//
//  ViewController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/11/27.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginrootcontroller <NSObject>

-(void) loginchangerootcontroller;

@end

@interface ViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField *useid;

@property (nonatomic,strong) IBOutlet UITextField *checkcode;

@property (nonatomic,strong) IBOutlet UIButton *confirmbutton;

@property (nonatomic,strong) IBOutlet UIButton *getcheckcodebutton;

@property (nonatomic, strong) IBOutlet UIButton *registerbutton;

@property (nonatomic, strong) IBOutlet UIButton *loginbutton;

@property (nonatomic, strong) IBOutlet UIImageView *myimageview;

@property (nonatomic,strong) id<loginrootcontroller> logindelegate;

-(IBAction)gotoRegister:(id)sender;

-(IBAction)getthecheckcode:(id)sender;

-(IBAction)uselogin:(id)sender;

@end

