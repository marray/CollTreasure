//
//  OpinionController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionController : UIViewController

@property (nonatomic,strong) IBOutlet UITextView *adviceContent;

@property (nonatomic, strong) IBOutlet UINavigationBar *mybar;

@property (nonatomic, strong) IBOutlet UITextView *myop;

-(IBAction)sendOp:(id)sender;

-(IBAction)backOpinion:(id)sender;

@end
