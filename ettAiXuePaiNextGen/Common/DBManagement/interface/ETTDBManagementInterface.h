//
//  ETTDBManagementInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.13 10:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 数据库管理接口
 */
/////////////////////////////////////////////////////
#ifndef ETTDBManagementInterface_h
#define ETTDBManagementInterface_h
#import "ETTTaskInterface.h"
@protocol ETTDBManagementInterface <NSObject>

@optional

/**
 Description 设置用户登录信息

 @param name 用户名
 @param password 密码
 @param selected 是否记忆
 @return 设置状态结果
 */
-(bool)dbSetUserInfoTable:(NSString *)name passwordStr:(NSString *)password isSelected:(NSString *)selected;


/**
 Description  获取用户登录所有信息

 @return      登录信息字典
 */
-(NSDictionary *)dbGetAllUserLogInfoData;


/**
 Description  设置登录用户的身份

 @param identity 身份标识
 */
-(void)dbSetCurrentIdentity:(NSString *)identity;


/**
 Description  设置登录用户ID

 @param uid    用户ID
 */
-(void)dbSetUserId:(NSString *)uid;


/**
 Description  设置登录用户头像
 
 @param data    用户头像图片二进制数据
 */
-(void)dbSetUserIcon:(NSData *)data;

-(NSData *)dbGetUserIcon;

/**
 Description  获取当前登录用户身份

 @return      用户身份字符串
 */
-(NSString *)dbGetCurrentIdentity;


/**
 Description  获取当前用户登录用户名

 @return     用户名
 */
-(NSString *)dbGetUserName;


/**
 Description  设置用户ID

 @return      用户ID字符串
 */
-(NSString *)dbGetUserid;

/**
 Description  设置当前班级状态

 @param value  数据
 */
-(void)dbSetCurrentClassroomClassStateInformation:(NSString *)value;

/**
 Description 获取当前班级状态数据

 @return     班级状态json格式字符串
 */
-(NSString *)dbGetCurrentClassroomClassStateInformation;


/**
 Description 清除班级状态数据
 */
-(void)dbClearClassStateCache;


/**
 Description 设置所有人员信息

 @param dic
 */
-(void)dbSetAllUserMessage:(NSDictionary *)dic;

/**
 Description 清理所有人员数据
 */
-(void)dbClearAllUserMessage;


/**
 Description 获取所有人员数据

 @return
 */
-(NSDictionary *)dbGetAllUserMessage;


/**
 Description  设置老师班级数据

 @param dic   班级数据
 */
-(void)dbSetTeacherclassroommessage:(NSDictionary *)dic;


/**
 Description 获取老师班级数据

 @return     班级数据
 */
-(NSDictionary *)dbGetTeacherclassroommessage;


/**
 Description  设置学生选择班级数据

 @param dic
 */
-(void)dbSetStudentChooseClassroom:(NSDictionary *)dic;


/**
 Description  获取学生选择班级数据

 @return      班级数据
 */
-(NSDictionary *)dbGetStudentChooseClassroom;


/**
 Description 设置缓存命令

 @param value 缓存数据
 @param key   对应的字段
 */
-(void)dbSetCommandCache:(NSString *)value withKey:(NSString *)key;


/**
 Description  获取缓存命令

 @param key   缓存命令字段
 @return      命令值
 */
-(NSString *)dbGetCommandCache:(NSString *)key;


/**
 Description  清理所有命令缓存
 */
-(void)dbClearAllCommandCache;




/**
 Description 获取灾难所有数据
 */
-(NSDictionary *)dbGetDisasterAllCache;
/**
 Description  设置灾难备份数据

 @param value 灾难数据
 @param key    类型key
 */
-(void)dbSetDisasterCache:(NSString *)value withKey:(NSString *)key;

-(void)dbSetClassActionCache:( id<ETTTaskInterface>)task;


-(void)dbSetClassActionCache:( id<ETTTaskInterface>)task withField:(NSString *)field;
-(void)dbDeleteClassActionCache:( id<ETTTaskInterface>)task;


/**
 Description 获取灾难数据

 @param key 字段名
 */
-(NSString *)dbGetDisasterCache:(NSString *)key;



-(void)dbClose;

@end
#endif /* ETTDBManagementInterface_h */
