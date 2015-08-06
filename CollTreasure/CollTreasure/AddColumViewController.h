//
//  AddColumViewController.h
//  CollTreasure
//
//  Created by Stefan on 14/12/29.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddColumViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *barnumber;

@property (nonatomic, strong) IBOutlet UITextField *money;

@property (nonatomic, strong) IBOutlet UITextField *time;

@property (nonatomic, strong) IBOutlet UITextField *type;

@property (nonatomic, strong) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) IBOutlet UIButton *backButton;

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) IBOutlet UIToolbar *dateBar;

@property (nonatomic, strong) IBOutlet UIPickerView *selecttype;

@property (nonatomic, strong) IBOutlet UIDatePicker *datepicker;

-(IBAction)addconfirm:(id)sender;

-(IBAction)back:(id)sender;



@end
