//
//  Sqllib.h
//  CollTreasure
//
//  Created by Stefan on 14/12/25.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "cashInfo.h"

@interface Sqllib : NSObject

+(Sqllib *)shareInstance;
//注释------打开数据库
-(void)openDB;
//注释------插入数据
-(void)insertDataWithNumber:(cashInfo *)cashinfo;
                             //注释------修改数据
-(void)updateMoney:(NSString *)bar type:(NSString *)type money:(double)money;
//注释------删除数据
-(void)deleteNumber:(int)uid;
//注释------查询所有数据
-(NSMutableArray *)selectedAllData;
//注释------根据number查询指定的数据
-(NSMutableArray *)selectedOneDataWithName:(NSString *)name;

-(int)selectByUnique:(NSString *)barnumber andtype:(NSString *)type;

@end
