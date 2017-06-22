//
//  ETTCommandHelperModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/14.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCommandHelperModel.h"

@implementation ETTCommandHelperModel
-(void)createTalbel
{
    if (self.EDDelegate == nil)
    {
        return;
    }
    if (self.EDTableName)
    {
        FMDatabase * db = [self.EDDelegate pGetDatabase];
        if ([db open])
        {
            NSString * sql = [NSString stringWithFormat:@"create table if not exists %@('uid' VARCHAR primary key, 'currendMA07Mid' VARCHAR, 'executedMid' VARCHAR, 'StartPageState' VARCHAR)",self.EDTableName];
            BOOL isCreateSuccses = [db executeUpdate:sql];
            if (!isCreateSuccses)
            {
                ETTLog(@"%@",db.lastErrorMessage);
            }
            
        }
        
    }
}
-(void)updateTableItem:(NSString *)uid withValue:(NSString *)value withKey:(NSString *)key
{
    if (key == nil || uid == nil)
    {
        return;
    }
    
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return;
    }
    
    if ([db open])
    {
        
        NSString * sql = [NSString stringWithFormat:@"SELECT COUNT(uid) AS 'count' FROM %@ WHERE uid  = ?",self.EDTableName];
        FMResultSet *rs =[db  executeQuery:sql,uid];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];
            if (count >0)
            {
                STRINGGOBJECT(value);
                NSString * sql  =   [NSString stringWithFormat:@"UPDATE %@ SET  %@ = '%@' WHERE uid = '%@'",self.EDTableName,key, value,uid];
                BOOL  res = [db executeUpdate:sql];
                if (res)
                {
                    NSLog(@"update success");
                }
                else
                {
                    NSLog(@"update Failure");
                }
                [db close];
                break;
                //存在
            }
            else
            {
                //不存在
                [self insertTableItem:uid withValue:value withKey:key];
                break;
            }
        }
        
        
        
    }
    
}

-(void)insertTableItem:(NSString *)uid withValue:(NSString *)value withKey:(NSString *)key
{
    if (key == nil || uid == nil)
    {
        return;
    }
    
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return;
    }
    
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"insert into %@(uid,%@) values(?,?)",self.EDTableName,key];
        STRINGGOBJECT(value);
        BOOL isInsertSuccess = [db executeUpdate:sql,uid,value];
        if (!isInsertSuccess) {
            ETTLog(@"%@",db.lastErrorMessage);
        }
        [db close];
        
        
    }
    
}
-(NSString *)selectCommand:(NSString *)uid withkey:(NSString *)key
{
    if (uid == nil || key == nil)
    {
        return nil;
    }
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return nil;
    }
    
    if ([db open])
    {
        
        NSString * sql  =   [NSString stringWithFormat:@"select %@ from  %@  where uid = '%@'",key, self.EDTableName,uid];
        FMResultSet * resultSet = [db executeQuery:sql];
        NSString * result = nil;
        while (resultSet.next)
        {
            result = [resultSet stringForColumn:key];
            
        }
//        [db close];
        return result;
    }
    return nil;

}

@end
