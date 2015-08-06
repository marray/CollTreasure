//
//  RequestController.h
//  CollTreasure
//
//  Created by 肖彬 on 14/12/9.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestController : UIViewController

-(NSMutableURLRequest *)sendRequest:(NSString *)path andParam:(NSString *)param;

-(void)sendRequestAndJson:(NSString *)path andParam:(NSString *)param;

@end
