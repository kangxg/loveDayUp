//
//  ETTClassstateHelperModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTClassstateHelperModel.h"

@implementation ETTClassstateHelperModel
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
            NSString * sql = [NSString stringWithFormat:@"create table if not exists %@('uid' VARCHAR primary key, 'classstate' VARCHAR)",self.EDTableName];
            BOOL isCreateSuccses = [db executeUpdate:sql];
            if (!isCreateSuccses)
            {
                ETTLog(@"%@",db.lastErrorMessage);
            }
            
        }
        
    }
}

-(void)updateTableItem:(NSString *)value withKey:(NSString *)key
{
    if (key == nil)
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
        FMResultSet *rs =[db  executeQuery:sql,key];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (count >0)
            {
                STRINGGOBJECT(value);
                NSString * sql  =   [NSString stringWithFormat:@"UPDATE %@ SET  classstate= '%@' WHERE uid = '%@'",self.EDTableName, value,key];
                BOOL  res = [db executeUpdate:sql];
                if (res)
                {
                    NSLog(@"update success");
                }
                else
                {
                    NSLog(@"update Failure");
                }
//                [db close];
                break;
                //存在
            }
            else
            {
                //不存在
                [self insertTableItem:value withKey:key];
                break;
            }
        }

       
        
    }
    
}

-(void)insertTableItem:(NSString *)value withKey:(NSString *)key
{
    if (key == nil)
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
        NSString * sql = [NSString stringWithFormat:@"insert into %@('uid','classstate') values(?,?)",self.EDTableName];
        STRINGGOBJECT(value);
        BOOL isInsertSuccess = [db executeUpdate:sql,key,value];
        if (!isInsertSuccess) {
            ETTLog(@"%@",db.lastErrorMessage);
        }
//        [db close];

        
    }

}
-(NSString * )selectClassState:(NSString *)uid
{
    if (uid == nil)
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
        
        NSString * sql  =   [NSString stringWithFormat:@"select classstate from  %@  where uid = '%@'",self.EDTableName,uid];
        FMResultSet * resultSet = [db executeQuery:sql];
        NSString * result = nil;
        while (resultSet.next)
        {
            result = [resultSet stringForColumn:@"classstate"];
            
        }
//        [db close];
        return result;
    }
        return nil;
}

-(void)deleteClassState:(NSString *)uid
{
    if (uid == nil)
    {
        return;
    }
    
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return ;
    }
    
    if ([db open])
    {
       
        NSString * sql  =   [NSString stringWithFormat:@"delete from  %@  where uid = '%@'",self.EDTableName,uid];
        BOOL isSuccessDelete  = [db executeUpdate:sql];
        if (!isSuccessDelete) {
            ETTLog(@"删除数据失败原因 :%@",db.lastErrorMessage);
        }
//        [db close];
        
    }


}


@end
