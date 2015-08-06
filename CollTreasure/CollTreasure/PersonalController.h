//
//  PersonalController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *namelable;

@property (nonatomic,strong) IBOutlet UILabel *useidlable;

@property (nonatomic,strong) IBOutlet UILabel *tellphonelable;

@property (nonatomic,strong) IBOutlet UIButton *opinionbutton;

@property (nonatomic, strong) IBOutlet UIImageView *myImageView;

-(IBAction)addOpinion:(id)sender;

-(IBAction)exdit:(id)sender;

@end
