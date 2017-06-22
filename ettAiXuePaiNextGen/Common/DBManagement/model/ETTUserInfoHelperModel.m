//
//  ETTUserInfoHelperModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTUserInfoHelperModel.h"
@interface ETTUserInfoHelperModel()
@property (atomic,copy,readonly)NSString * MId;
@property (atomic,copy,readonly)NSString * MIdentity;
@end

@implementation ETTUserInfoHelperModel
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
            NSString * sql = [NSString stringWithFormat:@"create table if not exists %@('uid' VARCHAR ,'username' VARCHAR primary key, 'password' VARCHAR, 'selected' VARCHAR, 'identity' VARCHAR,'icon' blob)",self.EDTableName];
            
            BOOL isCreateSuccses = [db executeUpdate:sql];
            
            if (!isCreateSuccses)
            {
                ETTLog(@"%@",db.lastErrorMessage);
            }
         
        }
      
    }
}

-(void)insertUserInfoTable:(NSString *)name passwordStr:(NSString *)password isSelected:(NSString *)selected
{
    NSString * uname = [self selectUserName];
    if (name && uname && [name isEqualToString:uname])
    {
         [self updateAllUserInfoTable:name passwordStr:password isSelected:selected];
    }
    else
    {
       [self updateUserInfoTable:name passwordStr:password isSelected:selected];
    }
    
  
}

-(void)updateUserInfoTable:(NSString *)name passwordStr:(NSString *)password isSelected:(NSString *)selected
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return;
    }
    
    
    [self deleteAllDataOfTable];
    if ([db open])
    {
       
        STRINGGOBJECT(name);
        STRINGGOBJECT(password);
        STRINGGOBJECT(selected);
        
        NSString *  sql = [NSString stringWithFormat:@"insert into %@('username','password','selected') values(?,?,?)",self.EDTableName];
        BOOL isInsertSuccess = [db executeUpdate:sql,name,password,selected];
        if (!isInsertSuccess)
        {
            ETTLog(@"%@",db.lastErrorMessage);
        }
        [db close];
    }

}
-(void)updateAllUserInfoTable:(NSString *)name passwordStr:(NSString *)password isSelected:(NSString *)selected
{
    
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return;
    }
    
    NSData * icon       =  [self selectUserIcon];
    NSString * uid      =  [self  selectUserid];
    NSString * identity =  [self selectUserIdentity];
    
    [self deleteAllDataOfTable];
    
    if ([db open])
    {
        STRINGGOBJECT(uid);
        STRINGGOBJECT(identity);
        STRINGGOBJECT(name);
        STRINGGOBJECT(password);
        STRINGGOBJECT(selected);
        
        NSString *  sql = [NSString stringWithFormat:@"insert into %@('username','password','selected','uid','identity','icon') values('%@','%@','%@','%@','%@',?)",self.EDTableName,name,password,selected,uid,identity];
        
        BOOL isInsertSuccess = [db executeUpdate:sql,icon];
        if (!isInsertSuccess)
        {
            ETTLog(@"%@",db.lastErrorMessage);
        }
//        [db close];
    }

}

-(void)updateUserIdentity:(NSString *)value
{
    if (_MIdentity == nil || ![_MIdentity isEqualToString:value])
    {
         _MIdentity = value;
         [self setTableitems:@"identity" withValue:value];
    }
   
}

-(NSData *)selectUserIcon
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return nil;
    }
    
    if ([db open])
    {
      
        
        NSString * sql  =   [NSString stringWithFormat:@"select icon from  %@ ",self.EDTableName];
        FMResultSet * resultSet = [db executeQuery:sql];
        NSData * result = nil;
        while (resultSet.next)
        {
            result = [resultSet dataForColumn:@"icon"];
                      
        }
//        [db close];
        return result;
    }
    return nil;
}

-(NSString *)selectUserIdentity
{

  if (_MIdentity)
  {
     return _MIdentity;
  }
  _MIdentity = [self getTableItems:@"identity"];
  return _MId;
}

-(NSString * )selectUserName
{
    return [self getTableItems:@"username"];
}

-(NSString * )selectUserid
{
    if (_MId)
    {
        return _MId;
    }
    _MId =  [NSString stringWithFormat:@"%@",[self getTableItems:@"uid"]];
    return _MId;
}
-(void)updateUserid:(NSString *)uid
{
    if (uid == nil)
    {
        return;
    }

    _MId = uid;
    [self setTableitems:@"uid" withValue:uid];

    
}

-(void)updateUserIcon:(NSData *)data
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return ;
    }
    
    if ([db open])
    {
        NSString * sql  =   [NSString stringWithFormat:@"UPDATE %@ SET  '%@'= ?",self.EDTableName, @"icon" ];
        BOOL  res = [db executeUpdate:sql,data];
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
-(void)setTableitems:(NSString *)key withValue:(NSString *)value
{
    [super setTableitems:key withValue:value];
}
-(NSDictionary *)selectAllData
{
    FMDatabase * db = [self.EDDelegate pGetDatabase];
    if (db == nil)
    {
        return nil;
    }
    
    if ([db open])
    {

        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        NSString * sql  = [NSString stringWithFormat:@"select * from  %@",self.EDTableName];
        FMResultSet *resultSet  =  [db executeQuery:sql];

        while (resultSet.next)
        {
            [dic setValue:[resultSet stringForColumn:@"username"] forKey:@"id"];
            [dic setValue:[resultSet stringForColumn:@"password"] forKey:@"password"];
            [dic setValue:[resultSet stringForColumn:@"selected"] forKey:@"selected"];
            
            [dic setValue:[resultSet stringForColumn:@"identity"] forKey:@"identity"];
            [dic setValue:[resultSet stringForColumn:@"uid"] forKey:@"uid"];
            [dic setValue:[resultSet dataForColumn:@"icon"] forKey:@"icon"];

        }
//        [db close];
        return dic;
    }
    return nil;
}
@end
