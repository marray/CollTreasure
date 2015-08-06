//
//  DetailController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/12/1.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *backbutton;

-(IBAction)detailBack:(id)sender;

@property (nonatomic, strong) IBOutlet UITableView *myTableview;

@property (nonatomic, strong) IBOutlet UINavigationBar *mybar;

@end
