//
//  ETTDBManagement.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDBManagement.h"
#import "ETTDataHelperModel.h"
#import "ETTUserInfoHelperModel.h"
#import "ETTDataBaseConfigModel.h"
#import "ETTClassstateHelperModel.h"
#import "ETTAllUserMessageHelperModel.h"
#import "ETTTeacherRoomMsgHelperModel.h"
#import "ETTStuChooseRoomHelperModel.h"
#import "ETTCommandHelperModel.h"
#import "ETTDisasterHelpModel.h"
@interface ETTDBManagement()

@property (nonatomic, strong,readonly) FMDatabase              *   MDatabase;
@property (nonatomic, strong,readonly) ETTDataBaseConfigModel  *   MDbConfigModel;
@property (nonatomic, strong,readonly) NSMutableDictionary<NSString *,ETTDataHelperModel *> * MDatahelpers;
@end

@implementation ETTDBManagement
+ (instancetype)sharedDBManagement
{
    static ETTDBManagement * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTDBManagement alloc]init];
    });

    return manager;
}
-(id)init
{
    if (self = [super init])
    {
        _MDbConfigModel = [[ETTDataBaseConfigModel alloc]init];
        _MDatahelpers = [[NSMutableDictionary alloc]init];
        [self initDataBase];
    }
    return self;
}

- (void)initDataBase
{
   NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:_MDbConfigModel.dbName];
   _MDatabase = [FMDatabase databaseWithPath:filePath];
    
}
-(void)dbClose
{
    if (_MDatabase)
    {
        [_MDatabase close];
    }
}
-(FMDatabase *)pGetDatabase
{
    if ( _MDatabase == nil)
    {
        [self initDataBase];
    }
    return  _MDatabase;
}
#pragma mark 更新用户部分信息
-(bool)dbSetUserInfoTable:(NSString *)name passwordStr:(NSString *)password isSelected:(NSString *)selected
{
    
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    
    [model insertUserInfoTable:name passwordStr:password isSelected:selected];
    return YES;
}


#pragma mark 获取用户登录信息
-(NSDictionary *)dbGetAllUserLogInfoData
{
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    return  [model selectAllData];

}
#pragma mark 设置身份标识
-(void)dbSetCurrentIdentity:(NSString *)identity
{
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    [model updateUserIdentity:identity];
    
}

#pragma mark 设置id
-(void)dbSetUserId:(NSString *)uid
{
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    [model updateUserid:uid];
}
#pragma mark 设置头像
-(void)dbSetUserIcon:(NSData *)data
{
     ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
     [model updateUserIcon:data];
}

-(NSData *)dbGetUserIcon
{
     ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
     return  [model selectUserIcon];
}
#pragma mark 获取身份标识
-(NSString *)dbGetCurrentIdentity
{
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    return  [model selectUserIdentity];
}
#pragma mark 设置名称
-(NSString *)dbGetUserName
{
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    return [model selectUserName];
}
#pragma mark 设置身份ID
-(NSString *)dbGetUserid
{
    ETTUserInfoHelperModel * model = [self getUserInfoHelperModel];
    return [model selectUserid];

}
#pragma mark 创建用户登录信息表操作model
-(ETTUserInfoHelperModel *) createUserInfoTable
{
    ETTUserInfoHelperModel * model = [[ETTUserInfoHelperModel alloc]init:[_MDbConfigModel.tableNames valueForKey:@"userInfoTable"] withDelegate:self];
   
    return model;
    
}

#pragma mark 用户登录信息表操作model
-(ETTUserInfoHelperModel * )getUserInfoHelperModel
{
    ETTUserInfoHelperModel * model =(ETTUserInfoHelperModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"userInfoTable"]];
    if (model == nil)
    {
        model = [self createUserInfoTable];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"userInfoTable"]];
        
    }
    return model;

}

-(ETTDataHelperModel *)getDatahelperModel:(NSString *)name
{
                                          
    if (name)
    {
        ETTDataHelperModel * model =   [_MDatahelpers valueForKey:name];
        return model;
    }
    return nil;
}

#pragma mark  
#pragma mark -------用户状态-------
-(ETTClassstateHelperModel * )getClassstateHelperModel
{
    ETTClassstateHelperModel * model =(ETTClassstateHelperModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"classstateTable"]];
    if (model == nil)
    {
        model = [self createClassstateHelperModel];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"classstateTable"]];
        
    }
    return model;
    
}
-(void)dbClearClassStateCache
{
    ETTClassstateHelperModel * model = [self getClassstateHelperModel];
    if ([[self dbGetCurrentIdentity] isEqualToString:_MDbConfigModel.clearIdentity] && [_MDbConfigModel.clearClassState isEqualToString:@"clear"])
    {
            [model  deleteClassState:[self dbGetUserid]];
    }

}
-(ETTClassstateHelperModel *) createClassstateHelperModel
{
    ETTClassstateHelperModel * model = [[ETTClassstateHelperModel  alloc]init:[_MDbConfigModel.tableNames valueForKey:@"classstateTable"] withDelegate:self];
    
    return model;
    
}

-(void)dbSetCurrentClassroomClassStateInformation:(NSString *)value
{
    ETTClassstateHelperModel * model = [self getClassstateHelperModel];
    [model updateTableItem:value withKey:[self dbGetUserid]];
}


-(NSString *)dbGetCurrentClassroomClassStateInformation
{
    ETTClassstateHelperModel * model = [self getClassstateHelperModel];
    return  [model selectClassState:[self dbGetUserid]];
}


#pragma mark
#pragma mark -------allUserMessage model------
-(void)dbSetAllUserMessage:(NSDictionary *)dic
{
    if (dic == nil)
    {
        return;
    }
    ETTAllUserMessageHelperModel * model = [self getAllUserMessageHelperModel];
    [model updateTableItem:dic withKey:[self dbGetUserid]];
    
}
-(ETTAllUserMessageHelperModel * )getAllUserMessageHelperModel
{
    ETTAllUserMessageHelperModel * model =(ETTAllUserMessageHelperModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"allUserMessage"]];
    if (model == nil)
    {
        model = [self createAallUserMessageHelperModel];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"allUserMessage"]];
        
    }
    return model;
    
}
-(ETTAllUserMessageHelperModel *) createAallUserMessageHelperModel
{
    ETTAllUserMessageHelperModel * model = [[ETTAllUserMessageHelperModel  alloc]init:[_MDbConfigModel.tableNames valueForKey:@"allUserMessage"] withDelegate:self];
    
    return model;
    
}

-(NSDictionary *)dbGetAllUserMessage
{
     ETTAllUserMessageHelperModel * model = [self getAllUserMessageHelperModel];
     return [model selectAllUserMessage:[self dbGetUserid]];
}
-(void)dbClearAllUserMessage
{
    ETTAllUserMessageHelperModel * model = [self getAllUserMessageHelperModel];
    [model deleteAllDataOfTable];
}

#pragma mark
#pragma mark -------teacherclassroommessage model------
-(void)dbSetTeacherclassroommessage:(NSDictionary *)dic
{
    ETTTeacherRoomMsgHelperModel * model = [self getTeacherclassroommessageHelperModel];
    [model updateTableItem:dic withKey:[self dbGetUserid]];
}

-(NSDictionary *)dbGetTeacherclassroommessage
{
    ETTTeacherRoomMsgHelperModel * model = [self getTeacherclassroommessageHelperModel];
    return [model selectMessage:[self dbGetUserid]];

}

-(ETTTeacherRoomMsgHelperModel * )getTeacherclassroommessageHelperModel
{
    ETTTeacherRoomMsgHelperModel * model =(ETTTeacherRoomMsgHelperModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"teacherclassroommessage"]];
    if (model == nil)
    {
        model = [self createTeacherclassroommessageHelperModel];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"teacherclassroommessage"]];
        
    }
    return model;
    
}
-(ETTTeacherRoomMsgHelperModel *) createTeacherclassroommessageHelperModel
{
    ETTTeacherRoomMsgHelperModel * model = [[ETTTeacherRoomMsgHelperModel   alloc]init:[_MDbConfigModel.tableNames valueForKey:@"teacherclassroommessage"] withDelegate:self];
    
    return model;
    
}

#pragma mark
#pragma mark ------- StudentChooseClassroom model------

-(void)dbSetStudentChooseClassroom:(NSDictionary *)dic
{
    ETTStuChooseRoomHelperModel * model= [self getStudentChooseClassroomHelperModel];
    [model updateTableItem:dic withKey:[self dbGetUserid]];
}

-(NSDictionary *)dbGetStudentChooseClassroom
{
      ETTStuChooseRoomHelperModel * model= [self getStudentChooseClassroomHelperModel];
      return  [model selectMessage:[self dbGetUserid]];
}

-(ETTStuChooseRoomHelperModel * )getStudentChooseClassroomHelperModel
{
    ETTStuChooseRoomHelperModel * model =(ETTStuChooseRoomHelperModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"studentChooseClassroom"]];
    if (model == nil)
    {
        model = [self createStudentChooseClassroomHelperModel];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"studentChooseClassroom"]];
        
    }
    return model;
    
}
-(ETTStuChooseRoomHelperModel *) createStudentChooseClassroomHelperModel
{
    ETTStuChooseRoomHelperModel * model = [[ETTStuChooseRoomHelperModel   alloc]init:[_MDbConfigModel.tableNames valueForKey:@"studentChooseClassroom"] withDelegate:self];
    
    return model;
    
}

#pragma mark
#pragma mark ------- commanCache  model------
-(void)dbSetCommandCache:(NSString *)value withKey:(NSString *)key
{
    ETTCommandHelperModel * model = [self getCommandHelperModel];
    [model updateTableItem:[self dbGetUserid] withValue:value withKey:key];
}

-(NSString *)dbGetCommandCache:(NSString *)key
{
    ETTCommandHelperModel * model = [self getCommandHelperModel];

    return [model selectCommand:[self dbGetUserid] withkey:key];
}

-(ETTCommandHelperModel * )getCommandHelperModel
{
    ETTCommandHelperModel * model =(ETTCommandHelperModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"commandCache"]];
    if (model == nil)
    {
        model = [self createCommandHelperModel];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"commandCache"]];
        
    }
    return model;
    
}
-(ETTCommandHelperModel *) createCommandHelperModel
{
    ETTCommandHelperModel * model = [[ETTCommandHelperModel  alloc]init:[_MDbConfigModel.tableNames valueForKey:@"commandCache"] withDelegate:self];
    
    return model;
    
}
-(void)dbClearAllCommandCache
{
     ETTCommandHelperModel * model = [self getCommandHelperModel];
     [model deleteAllDataOfTable];
}

#pragma mark
#pragma mark ------- 灾难恢复  model------
-(NSString *)dbGetDisasterCache:(NSString *)key
{
    ETTDisasterHelpModel * model = [self getDisasterHelperModel];
    return [model selectDisasterMessage:[self dbGetUserid] withkey:key];
}
-(NSDictionary *)dbGetDisasterAllCache
{
    ETTDisasterHelpModel * model = [self getDisasterHelperModel];

    return [model selectMessage:[self dbGetUserid]];
}


-(void)dbSetDisasterCache:(NSString *)value withKey:(NSString *)key
{
    
    ETTDisasterHelpModel * model = [self getDisasterHelperModel];
    [model updateTableItem:[self dbGetUserid] withValue:value withKey:key];
}
-(void)dbSetClassActionCache:( id<ETTTaskInterface>)task
{
    ETTDisasterHelpModel * model = [self getDisasterHelperModel];
    [model  updateClassActionCache:[self dbGetUserid] withTask:task];
}

-(void)dbSetClassActionCache:( id<ETTTaskInterface>)task withField:(NSString *)field
{
     ETTDisasterHelpModel * model = [self getDisasterHelperModel];
    [model updateClassActionCache:[self dbGetUserid] withTask:task withField:field];
    
}
-(void)dbDeleteClassActionCache:( id<ETTTaskInterface>)task
{
    ETTDisasterHelpModel * model = [self getDisasterHelperModel];
    [model deleteClassActionCache:[self dbGetUserid] withTask:task];
}

-(ETTDisasterHelpModel * )getDisasterHelperModel
{
    ETTDisasterHelpModel * model =(ETTDisasterHelpModel *) [self getDatahelperModel:[_MDbConfigModel.tableNames valueForKey:@"disaster"]];
    if (model == nil)
    {
        model = [self createDisasterHelperModel];
        [_MDatahelpers setObject:model forKey:[_MDbConfigModel.tableNames valueForKey:@"disaster"]];
        
    }
    return model;
    
}
-(ETTDisasterHelpModel *) createDisasterHelperModel
{
    ETTDisasterHelpModel * model = [[ETTDisasterHelpModel  alloc]init:[_MDbConfigModel.tableNames valueForKey:@"disaster"] withDelegate:self];
    
    return model;
    
}
@end
