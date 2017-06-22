//
//  ETTAllUserMessageHelperModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/13.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTAllUserMessageHelperModel.h"

@implementation ETTAllUserMessageHelperModel
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
            NSString * sql = [NSString stringWithFormat:@"create table if not exists %@('uid' VARCHAR primary key, 'allUserMessage' VARCHAR)",self.EDTableName];
            BOOL isCreateSuccses = [db executeUpdate:sql];
            if (!isCreateSuccses)
            {
                ETTLog(@"%@",db.lastErrorMessage);
            }
            
        }
        
    }
}
-(void)updateTableItem:(NSDictionary *)dic withKey:(NSString *)uid
{
    if (uid == nil || dic == nil)
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
        [self deleteAllDataOfTable];
        NSString * jsonstr = [self dictionaryTransToJsonString:dic];
        [self insertTableItem:jsonstr  withKey:uid];
    }
//    if ([db open])
//    {
//        
//        NSString * sql = [NSString stringWithFormat:@"SELECT COUNT(uid) AS 'count' FROM %@ WHERE uid  = ?",self.EDTableName];
//        FMResultSet *rs =[db  executeQuery:sql,uid];
//        while ([rs next]) {
//            NSInteger count = [rs intForColumn:@"count"];
//            if (count >0)
//            {
//                NSString * jsonstr = [self dictionaryTransToJsonString:dic];
//                STRINGGOBJECT(jsonstr);
//                NSString * sql  =   [NSString stringWithFormat:@"UPDATE %@ SET  'classstate'= '%@' WHERE uid = '%@'",self.EDTableName, jsonstr,uid];
//                BOOL  res = [db executeUpdate:sql];
//                if (res)
//                {
//                    NSLog(@"update success");
//                }
//                else
//                {
//                    NSLog(@"update Failure");
//                }
//                [db close];
//                break;
//                //存在
//            }
//            else
//            {
//                //不存在
//                NSString * jsonstr = [self dictionaryTransToJsonString:dic];
//                [self insertTableItem:jsonstr  withKey:uid];
//                break;
//            }
//        }
//        
//    }

   

}

-(void)insertTableItem:(NSString *)value withKey:(NSString *)uid
{
    if (uid == nil)
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
        NSString * sql = [NSString stringWithFormat:@"insert into %@('uid','allUserMessage') values(?,?)",self.EDTableName];
        STRINGGOBJECT(value);
        BOOL isInsertSuccess = [db executeUpdate:sql,uid,value];
        if (!isInsertSuccess) {
            ETTLog(@"%@",db.lastErrorMessage);
        }
//        [db close];
        
    }
    
}
-(NSDictionary  * )selectAllUserMessage:(NSString *)uid
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
        
        NSString * sql  =   [NSString stringWithFormat:@"select allUserMessage from  %@  where uid = '%@'",self.EDTableName,uid];
        FMResultSet * resultSet = [db executeQuery:sql];
        NSString * result = nil;
        while (resultSet.next)
        {
            result = [resultSet stringForColumn:@"allUserMessage"];
            
        }

        if (result)
        {
            NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:nil];
            [db close];
            return  dic;
        }
       
        [db close];
    }
    return nil;
}

@end
