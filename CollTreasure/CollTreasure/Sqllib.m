//
//  Sqllib.m
//  CollTreasure
//
//  Created by Stefan on 14/12/25.
//  Copyright (c) 2014年 肖彬. All rights reserved.
//

#import "Sqllib.h"
static sqlite3 *db;

@implementation Sqllib

static Sqllib *manager;
+(Sqllib *)shareInstance
{
    if (manager == nil) {
        manager = [[Sqllib alloc]init];
    }
    return manager;
}
-(void)openDB
{
    if (db != nil) {
        return;
    }
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"ios24database.sqlite"];
    //注释------根据数据库路径打开数据库，参数为C语言字符串
    int result = sqlite3_open([filePath UTF8String], &db);
    if (result == SQLITE_OK) {
        NSString *sql = @"CREATE TABLE Cash(c_id INTEGER PRIMARY KEY AUTOINCREMENT,c_bar TEXT,c_type TEXT,c_money TEXT,c_date TEXT,c_uid TEXT)";
        //注释------执行sql语句,exec包含两步，1 准备 2 执行
        sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
        NSLog(@"%@",filePath);
    }
}

//插入一条记录
-(void)insertDataWithNumber:(cashInfo *)cashinfo
{
    //注释------1 打开数据库
    [self openDB];
    //注释------2 创建跟随指针，记录数据库的每一步操作
    sqlite3_stmt *stmt;
    //注释------3 写Sql语句
    NSString *sql = @"insert into Cash(c_id,c_bar,c_type,c_money,c_date,c_uid) values(NULL,?,?,?,?,?)";
    //注释------4 准备  验证sql语句
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    //注释------5 判断结果，执行行对应的插入操作
    if (result == SQLITE_OK) {
        //注释------绑定sql语句中的值（替换 ？）?表示要替换的值，顺序从1开始
       // sqlite3_bind_int(stmt, 1, *(cashinfo.hid));
        sqlite3_bind_text(stmt, 1, [cashinfo.hbar UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [cashinfo.htype UTF8String],-1,NULL);
        sqlite3_bind_text(stmt, 3,[cashinfo.hmoney UTF8String],-1,NULL);
        sqlite3_bind_text(stmt, 4,[[NSString stringWithFormat:@"%@",cashinfo.hdate] UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [cashinfo.huid UTF8String], -1, NULL);
        NSLog(@"准备好了。。。");
        //注释------执行准备好的sql语句
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    
   // char *errmsg=NULL;
   // sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);

}

//更新金额
-(void)updateMoney:(NSString *)bar type:(NSString *)type money:(double)money{
    
    
}

//删除数据
-(void)deleteNumber:(int)uid{
    [self openDB];
    NSLog(@"删除数据，。。");
    sqlite3_stmt *stmt = NULL;
    NSString *sql = @"delete from Cash where c_id = ?";
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, uid);
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
}

//查询所有
-(NSMutableArray *)selectedAllData{
    
    return nil;
}

//查询某一条数据
-(NSMutableArray *)selectedOneDataWithName:(NSString *)name{
    
    return nil;
}

-(int)selectByUnique:(NSString *)barnumber andtype:(NSString *)type{
    int cid;
    [self openDB];
    sqlite3_stmt *stmt = NULL;
    //注释------查询 *表示查询所有字段
    NSString *sql=[NSString stringWithFormat:@"select * from Cash where c_bar='%@' and c_type='%@' ",barnumber,type];
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            cid= sqlite3_column_int(stmt, 0);
        }
    }
    sqlite3_finalize(stmt);
    
    return cid;
}



@end
