//
//  ETTTeacherRoomMsgHelperModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/13.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTTeacherRoomMsgHelperModel.h"

@implementation ETTTeacherRoomMsgHelperModel
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
            NSString * sql = [NSString stringWithFormat:@"create table if not exists %@('uid' VARCHAR primary key, 'message' VARCHAR)",self.EDTableName];
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
    if (uid == nil )
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
        if (dic == nil)
        {
            return;
        }
   
        NSString * jsonstr = [self dictionaryTransToJsonString:dic];
        [self insertTableItem:jsonstr  withKey:uid];
    }
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
        NSString * sql = [NSString stringWithFormat:@"insert into %@('uid','message') values(?,?)",self.EDTableName];
        STRINGGOBJECT(value);
        BOOL isInsertSuccess = [db executeUpdate:sql,uid,value];
        if (!isInsertSuccess) {
            ETTLog(@"%@",db.lastErrorMessage);
        }
//        [db close];
        
    }
    
}
-(NSDictionary  * )selectMessage:(NSString *)uid
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
        
        NSString * sql  =   [NSString stringWithFormat:@"select message from  %@  where uid = '%@'",self.EDTableName,uid];
        FMResultSet * resultSet = [db executeQuery:sql];
        NSString * result = nil;
        while (resultSet.next)
        {
            result = [resultSet stringForColumn:@"message"];
            
        }
//        [db close];
        if (result)
        {
            NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:nil];
            
            return  dic;
        }
        
    }
    return nil;
}


@end
