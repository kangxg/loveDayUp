//
//  ETTDisasterHelpModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/5.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDisasterHelpModel.h"
#import "ETTGovernmentTask.h"
#import "ETTJSonStringDictionaryTransformation.h"
@implementation ETTDisasterHelpModel
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
            NSString * sql = [NSString stringWithFormat:@"create table if not exists %@('uid' VARCHAR primary key, 'type' VARCHAR, 'theUserInfo' VARCHAR, 'disaster' VARCHAR, 'roomid' VARCHAR,'time' VARCHAR,'other' VARCHAR,'subTopicUserInfo' VARCHAR)",self.EDTableName];
            BOOL isCreateSuccses = [db executeUpdate:sql];
            NSAssert(isCreateSuccses, @"灾难备份数据库创建失败");
            
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
                
                NSString * sql  =   [NSString stringWithFormat:@"UPDATE %@ SET  %@ = '%@',time = '%@'  WHERE uid = '%@'",self.EDTableName,key, value,[self getNowDate],uid];
                BOOL  res = [db executeUpdate:sql];
                NSAssert(res, @"灾难数据表更新失败");
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

-(NSString *)getNowDate
{
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    return nowtimeStr;
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
        NSString * sql = [NSString stringWithFormat:@"insert into %@(uid,%@,time) values(?,?,?)",self.EDTableName,key];
        STRINGGOBJECT(value);
        BOOL isInsertSuccess = [db executeUpdate:sql,uid,value,[self getNowDate]];
        NSAssert(isInsertSuccess, @"灾难数据表插入用户数据失败");
        [db close];
        
        
    }
    
}

-(NSString *)selectDisasterMessage:(NSString *)uid withkey:(NSString *)key
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
        [db close];
        return result;
    }
    return nil;

}
-(NSDictionary  * )selectMessage:(NSString *)uid;
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
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        NSString * sql  = [NSString stringWithFormat:@"select * from  %@ where uid = '%@'",self.EDTableName,uid];
        FMResultSet *resultSet  =  [db executeQuery:sql];
        
        while (resultSet.next)
        {
            [dic setValue:[resultSet stringForColumn:@"uid"] forKey:@"jid"];
            [dic setValue:[resultSet stringForColumn:@"type"] forKey:@"type"];
             [dic setValue:[resultSet stringForColumn:@"time"] forKey:@"time"];
            [dic setValue:[resultSet stringForColumn:@"roomid"] forKey:@"roomid"];
            
            NSString * result  = [resultSet stringForColumn:@"theUserInfo"];
            NSString * other   = [resultSet stringForColumn:@"other"];
            
            NSString * lastUserinfo = [resultSet stringForColumn:@"subTopicUserInfo"];
            if (result)
            {
                NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * jsondic = [NSJSONSerialization JSONObjectWithData:jsonData
                                     
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
                [dic setValue:jsondic forKey:@"theUserInfo"];
                
            }
            
            if (other)
            {
           
                NSError * error = nil;
                NSData  * otherdata =[other dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * otherjsondic = [NSJSONSerialization JSONObjectWithData:otherdata
                                               
                                                                              options:NSJSONReadingMutableLeaves
                                                                                error:&error];
                if (error == nil)
                {
                     [dic setValue:otherjsondic forKey:@"other"];
                }
               
            }
            
            if (lastUserinfo)
            {
                NSError * error = nil;
                NSData  * lastUserinfodata =[lastUserinfo dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * lastUserinfojsondic = [NSJSONSerialization JSONObjectWithData:lastUserinfodata
                                               
                                                                              options:NSJSONReadingMutableLeaves
                                                                                error:&error];
                if (error == nil)
                {
                    [dic setValue:lastUserinfojsondic forKey:@"subTopicUserInfo"];
                }

            }
            [dic setValue:[resultSet stringForColumn:@"disaster"] forKey:@"disaster"];
        }
        [db close];
        return dic;

        

    }
    return nil;

}

-(void)updateClassActionCache:(NSString *)uid withTask:(id<ETTTaskInterface>)task
{
    if (task == nil || uid == nil)
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
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (count >0)
            {
                ETTGovernmentClassReportTask * genTask = ( ETTGovernmentClassReportTask * )task;
                NSString * type = genTask.EDDisasterType;
                NSString *theUserInfoJson = nil;
                if (genTask.EDDisasterDic)
                {
                   theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:genTask.EDDisasterDic];
                }
                NSString * otherJson = nil;
                if (genTask.EDDisasterOtherDic)
                {
                     otherJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:genTask.EDDisasterOtherDic];
                }

        
    
                STRINGGOBJECT(type);
                STRINGGOBJECT(theUserInfoJson);
                STRINGGOBJECT(otherJson);

                NSString * sql  =   [NSString stringWithFormat:@"UPDATE %@ SET  type = '%@',theUserInfo = '%@',roomid = '%@', time = '%@' ,other = '%@'  WHERE uid = '%@'",self.EDTableName,type,theUserInfoJson,genTask.EDDisasterClassRoomid,[self getNowDate],otherJson,uid];
                BOOL  res = [db executeUpdate:sql];
                NSAssert(res, @"灾难数据表更新失败");
                [db close];
                break;
                //存在
            }
            else
            {
                //不存在
                [self insertTableItem:uid withTask:task];
                break;
            }
        }
        
        
        
    }

}

-(void)updateClassActionCache:(NSString *)uid withTask:( id<ETTTaskInterface>)task withField:(NSString *)field
{
    if (field == nil || task == nil || uid == nil)
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
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (count >0)
            {
             

                
               
                ETTGovernmentClassReportTask * genTask = ( ETTGovernmentClassReportTask * )task;
                NSDictionary * lastDic = [genTask.EDDisasterOtherDic valueForKey:field];
                
                NSString * rstr = [ETTRedisBasisManager getJSONWithDictionary:lastDic];
                STRINGGOBJECT(rstr);
                [self updateTableItem:uid withValue:rstr withKey:@"subTopicUserInfo"];
                
            }

        }
        
    }
}

-(NSDictionary *)selectMessage:(NSString *)uid withField:(NSString *)field
{
    if (uid == nil || field == nil)
    {
        return nil;
    }
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return nil;
    }

    NSString * sql  =   [NSString stringWithFormat:@"select %@ from  %@  where uid = '%@'",field,self.EDTableName,uid];
    FMResultSet * resultSet = [db executeQuery:sql];
    NSString * result = nil;
    while (resultSet.next)
    {
        result = [resultSet stringForColumn:@"other"];
        
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
    return nil;
}


-(void)insertTableItem:(NSString *)uid withTask:(id<ETTTaskInterface>)task{
    if (task == nil || uid == nil)
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
        ETTGovernmentClassReportTask * genTask = ( ETTGovernmentClassReportTask * )task;
        NSString * type = genTask.EDDisasterType;
        NSString * theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:genTask.EDDisasterDic];
        
        NSString * otherJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:genTask.EDDisasterOtherDic];
        NSDictionary * lastdic =[genTask.EDDisasterOtherDic valueForKey:@"subTopicUserInfo"];
        NSString * lastUserInfoJson = nil;
        if (lastdic)
        {
            lastUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:lastdic];
        }
        
        STRINGGOBJECT(type);
        STRINGGOBJECT(theUserInfoJson);
        STRINGGOBJECT(otherJson);
        STRINGGOBJECT(lastUserInfoJson);
        NSString * sql = [NSString stringWithFormat:@"insert into %@(uid,type,theUserInfo,roomid,time,other,subTopicUserInfo) values(?,?,?,?,?,?,?)",self.EDTableName];
      
        BOOL isInsertSuccess = [db executeUpdate:sql,uid,type,theUserInfoJson,genTask.EDDisasterClassRoomid ,[self getNowDate],otherJson,lastUserInfoJson];
        NSAssert(isInsertSuccess, @"灾难数据表插入用户数据失败");
        [db close];
        
        
    }
    
}

-(void)deleteClassActionCache:(NSString *)uid withTask:( id<ETTTaskInterface>)task
{
    if (task == nil || uid == nil)
    {
        return;
    }
    
    [self  deleteAllDataOfTable];
}
@end
