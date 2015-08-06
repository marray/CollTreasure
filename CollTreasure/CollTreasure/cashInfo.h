//
//  cashInfo.h
//  CollTreasure
//
//  Created by smallfeng on 14/12/12.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cashInfo : NSObject

@property (nonatomic) int *hid;

@property(nonatomic,strong) NSString *hbar;

@property(nonatomic,strong) NSString *htype;

@property(nonatomic,strong) NSString *huid;

@property(nonatomic) NSString *hmoney;

@property(nonatomic,strong) NSDate *hdate;



@end
