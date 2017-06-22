//
//  ETTDataHelperModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDataHelperModel.h"

@implementation ETTDataHelperModel
@synthesize EDTableName = _EDTableName;
@synthesize EDDelegate  = _EDDelegate;
-(instancetype)init:(NSString *)tableName withDelegate:(id<ETTDataHelperDelegate>)delegate
{
    if (self = [super init])
    {
        _EDTableName = tableName;
        _EDDelegate  = delegate;
        [self createTalbel];
    }
    return self;
}
-(void)createTalbel
{
    
}
-(NSDictionary *)selectAllData
{
    return nil;
}

-(void)setTableitems:(NSString *)key withValue:(NSString *)value
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return ;
    }
    
    if ([db open])
    {
        STRINGGOBJECT(value);
//        STRINGGOBJECT(conditionsKey);
//        STRINGGOBJECT(conditionsValue);
        NSString * sql  =   [NSString stringWithFormat:@" UPDATE %@ SET  '%@'= '%@'",self.EDTableName, key,value];
        BOOL  res = [db executeUpdate:sql];
        if (res)
        {
            NSLog(@"update success");
        }
        else
        {
           NSLog(@"update Failure");
        }
//        [db close];
        
    }

}

-(id)getTableItems:(NSString *)key
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return nil;
    }
    
    if ([db open])
    {
        STRINGGOBJECT(key);
        
        NSString * sql  =   [NSString stringWithFormat:@"select %@ from  %@ ",key,self.EDTableName];
        FMResultSet * resultSet = [db executeQuery:sql];
        NSString * result = nil;
        while (resultSet.next)
        {
            result = [[resultSet stringForColumn:key] copy];
            
        }
//        [db close];
        return result;

        
//        if (res)
//        {
//            NSLog(@"update success");
//        }
//        else
//        {
//            NSLog(@"update Failure");
//        }
       
        
    }
    return  nil;
}
-(BOOL)deleteAllDataOfTable
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return false;
    }
    if ( [db open])
    {
        BOOL success =  [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",self.EDTableName]];
       // [db close];
        return success;
        
    }
    return false;
}
-(void)deleteAllDataOfTable:(NSString *)uid
{
    
}
-(NSString *)dictionaryTransToJsonString:(NSDictionary *)dic
{
    if (dic == nil)
    {
        return @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}


-(NSDictionary  * )selectMessage:(NSString *)uid
{
    return nil;
}

-(void)updateTableItem:(NSString *)value withKey:(NSString *)key
{
    
}
-(void)updateTableItem:(NSString *)uid withValue:(NSString *)value withKey:(NSString *)key
{
    
}
@end
