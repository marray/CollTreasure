//
//  TotalCountController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol sendToDetail <NSObject>

-(void)GoToDetail;

@end

@interface TotalCountController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *bgimage;


@property (nonatomic, strong) IBOutlet UIButton *morebutton;

@property (nonatomic, strong) IBOutlet UIButton *addbutton;


-(IBAction)getMore:(id)sender;

-(IBAction)addCash:(id)sender;

@end
