//
//  ETTUSERDefaultManager.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/10/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//


////////////////////////////////////////////////////////
/*
 new      : Modify
 time     : 2017.4.14 17:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 文件修改说明
            1.对 第一次登录 启动引导标示的缓存 没有数据库桥接存储
            2.有标签AIXUEPAIOS-1182对地方是修改的地方
            3.appId没有数据库存储
            4.没有用到的setStudentChooseClassroom 方法 数据表操作类以及编写，这里没有侨界
            5.类方法主要做了侨界功能
 */

/////////////////////////////////////////////////////
#import "ETTUSERDefaultManager.h"
#import "AXPUserInformation.h"
#import "ETTDBManagement.h"
///保存用户课堂临时信息文件的位置
NSString * const kUserReconnectionPath = @"Catch/reconnection";

@implementation ETTUSERDefaultManager

-(NSData *)getUserDefaultData
{
    return (NSData *)[[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
}

#pragma 设置用户登录名称、密码、是否记住 信息（对完）
+(BOOL)setUSERMessageForId:(NSString *)idStr passwordStr:(NSString *)passwordStr isSelected:(NSString *)selected
{
    if (idStr&&passwordStr&&![idStr isEqualToString:@""]&&![passwordStr isEqualToString:@""])
    {
        

         /*

         tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
         
         */
    
         return   [[ETTDBManagement sharedDBManagement] dbSetUserInfoTable:idStr passwordStr:passwordStr isSelected:selected];


    }else{
        return NO;
    }
}

+(void)setUSERMessageForIconImage:(UIImage *)image
{
     /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    if(image)
    {
      NSData *data = UIImagePNGRepresentation(image);
      [[ETTDBManagement sharedDBManagement] dbSetUserIcon:data];
    }

}
+(NSData *)getUSERMessageForIconImage
{
    return [[ETTDBManagement sharedDBManagement] dbGetUserIcon];
}
#pragma 获取用户信息
+(NSDictionary *)getUSERMessage
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */

   NSDictionary *userMessage =  [[ETTDBManagement sharedDBManagement] dbGetAllUserLogInfoData];

    return userMessage;
}

+(BOOL)initAllUserMessage:(NSDictionary *)dictionary
{
    if ([dictionary count]>0&&(int)[dictionary objectForKey:kResult]>0)
    {
        ETTAllUserMessageForLoginModel *allUserMessage = [[ETTAllUserMessageForLoginModel alloc]initWithDictionary:dictionary];
    
        
        
        NSArray *identityArray = [NSArray arrayWithArray:[allUserMessage.data valueForKey:@"identityList"]];
        
        NSDictionary *dict = identityArray.firstObject;
        
        
        NSString *userType;
        if (identityArray.count == 1)
        {
            if ([[identityArray[0]objectForKey:@"userType"]isEqualToNumber:@3])
            {
                userType = @"student";
            }else{
                userType = @"teacher";
            }
        }else{
            userType = @"all";
        }
   
        ////////////////////////////////////////////////////////
        /*
         
         tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
         
         */

        [self setCurrentIdentity:userType];
        [self setCurrentUserid:[dict valueForKey:@"jid"]];
        [[ETTDBManagement sharedDBManagement]dbSetAllUserMessage:dictionary];
        ////////////////////////////////////////////////////////

        return YES;
    }else
    {
        /*
         
         tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
         
         */
        [[ETTDBManagement sharedDBManagement]dbClearAllUserMessage];
       
        return NO;
    }
}

+(NSArray *)getIdentityArray
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    NSDictionary * dic = [[ETTDBManagement sharedDBManagement]dbGetAllUserMessage];
    ETTAllUserMessageForLoginModel *allUserModel =  [[ETTAllUserMessageForLoginModel alloc]initWithDictionary:dic];
    NSArray *identityArray = [NSArray arrayWithArray:[allUserModel.data valueForKey:@"identityList"]];

    return identityArray;
}

+(NSMutableDictionary *)getUserTypeDictionary
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    NSArray * identityArray = [ETTUSERDefaultManager getIdentityArray];
    
    if ([identityArray count]>1) {
        [userDic setValue:@6 forKey:@"userType"];
    }
    
    NSLog(@"%d",[[userDic valueForKey:@"userType"]intValue]==6);
    for (id obj in identityArray) {
        NSLog(@"%@",obj);
        if ([[userDic valueForKey:@"userType"]intValue] != 6) {
            [userDic setValue:[obj objectForKey:@"userType"] forKey:@"userType"];
        }
        if ([[obj valueForKey:@"userType"]intValue] == 1) {
            [userDic setValue:obj forKey:@"teacher"];
        }
        if ([[obj valueForKey:@"userType"]intValue] == 3) {
            [userDic setValue:obj forKey:@"student"];
        }
    }
    
    return userDic;
}

+(NSMutableDictionary *)getUserTypeDictionaryPro
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    NSArray * identityArray = [ETTUSERDefaultManager getIdentityArray];
    if ([identityArray count]>1) {
        [userDic setValue:@6 forKey:@"userType"];
    }
    
    NSLog(@"%d",[[userDic valueForKey:@"userType"]intValue]==6);
    for (id obj in identityArray) {
        NSLog(@"%@",obj);
        if ([[userDic valueForKey:@"userType"]intValue] != 6) {
            [userDic setValue:[obj objectForKey:@"userType"] forKey:@"userType"];
        }
        if ([[obj valueForKey:@"userType"]intValue] == 1) {
            ETTUserIDForLoginModel *userIdModel = [[ETTUserIDForLoginModel alloc]initWithDictionary:obj];
            [userDic setValue:userIdModel forKey:@"teacher"];
        }
        if ([[obj valueForKey:@"userType"]intValue] == 3) {
            ETTUserIDForLoginModel *userIdModel = [[ETTUserIDForLoginModel alloc]initWithDictionary:obj];
            [userDic setValue:userIdModel forKey:@"student"];
        }
    }
    
    return userDic;
}

+(ETTUserIDForLoginModel *)getUserTypeModelWithType:(ETTUSERDefaultType)type
{
    ETTUserIDForLoginModel *model;
    switch (type) {
        case ETTUSERDefaultTypeStudent:
            model = [[ETTUSERDefaultManager getUserTypeDictionaryPro]valueForKey:@"student"];
            break;
        case ETTUSERDefaultTypeTeacher:
            model = [[ETTUSERDefaultManager getUserTypeDictionaryPro]valueForKey:@"teacher"];
            break;
            
        default:
            break;
    }
    return model;
}

+(NSArray *)getUserClassTagList
{
    ETTUserIDForLoginModel *userIdMoel = [[ETTUSERDefaultManager getUserTypeDictionaryPro]valueForKey:@"teacher"];
    NSArray *userArray = userIdMoel.classTagList;
    return userArray;
}

+(NSArray *)getUserClassTagListForUserType:(ETTUSERDefaultType)type
{
    NSString *mKey;
    switch (type) {
        case ETTUSERDefaultTypeStudent:
            mKey = @"student";
            break;
        case ETTUSERDefaultTypeTeacher:
            mKey = @"teacher";
            break;
        default:
            break;
    }
    ETTUserIDForLoginModel *userIdModel = [[ETTUSERDefaultManager getUserTypeDictionaryPro]valueForKey:mKey];
    NSArray *userArray = userIdModel.classTagList;
    return userArray;
}

+(void)setCurrentUserid:(NSString *)uid
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement] dbSetUserId:uid];
}

+(void)setCurrentIdentity:(NSString *)identityName
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement] dbSetCurrentIdentity:identityName];
}

+(NSString *)getCurrentIdentity
{
   /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
   */
  NSString * result =  [[ETTDBManagement sharedDBManagement] dbGetCurrentIdentity];
  return  result;

}

+(void)setStudentChooseClassroom:(ETTStudentSelectTeacherModel *)model
{
    [[NSUserDefaults standardUserDefaults]setObject:model forKey:@"studentChooseClassroom"];
}

+(ETTStudentSelectTeacherModel *)getStudentChooseClassroom
{
    //return [[ETTDBManagement sharedDBManagement]dbGetStudentChooseClassroom];
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"studentChooseClassroom"];
}

+(void)setTeacherClassroomMessage:(NSDictionary *)dict
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement]dbSetTeacherclassroommessage:dict];

}

+(NSDictionary *)getTeacherClassroomMessage
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    return  [[ETTDBManagement sharedDBManagement] dbGetTeacherclassroommessage];

}

+(void)setExecutedMid:(NSString *)mid
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement] dbSetCommandCache:mid withKey:@"executedMid"];

}

+(NSString *)getExecutedMid
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    return [[ETTDBManagement sharedDBManagement]dbGetCommandCache:@"executedMid"];

}

+(void)setCurrendMA07Mid:(NSString *)mid
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement] dbSetCommandCache:mid withKey:@"currendMA07Mid"];

}

+(NSString *)getCurrentMA07Mid
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    return [[ETTDBManagement sharedDBManagement]dbGetCommandCache:@"currendMA07Mid"];

}

+(void)setCurrentClassroomInformation:(NSString *)messageJSON
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement]dbSetCurrentClassroomClassStateInformation:messageJSON];

}

+(NSString *)getLastClassroomInformation
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    NSString * result = [[ETTDBManagement sharedDBManagement]dbGetCurrentClassroomClassStateInformation];
    return result;

}
+(void)close
{
    [[ETTDBManagement sharedDBManagement] dbClose];
}
+(void)setStartPageState:(NSString *)state
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
    [[ETTDBManagement sharedDBManagement] dbSetCommandCache:state withKey:@"StartPageState"];
    
}

+(NSString *)getStartPageState
{
    /*
     
     tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
     
     */
     return [[ETTDBManagement sharedDBManagement]dbGetCommandCache:@"StartPageState"];
}

+(NSString *)getAppId
{
    NSString *appIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppId"];
    return appIdStr;
}

+(void)setAppId
{
    int a = round(arc4random());
    NSString *appIdStr = [NSString stringWithFormat:@"%d_AppId",a];
    [[NSUserDefaults standardUserDefaults]setObject:appIdStr forKey:@"AppId"];
}

+(NSString *)getVersionId
{
    NSString *appIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"VersionId"];
    return appIdStr;
}

+(void)setVersionId:(NSString *)versionId
{
    [[NSUserDefaults standardUserDefaults]setObject:versionId forKey:@"VersionId"];
}

+(BOOL)getAppInstallState
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"AppInstallState"];
}

+(void)setAppInstallState:(BOOL)state
{
    [[NSUserDefaults standardUserDefaults]setBool:state forKey:@"AppInstallState"];
}
/*
 
 tag  ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 
 */
+(void)clearClassStateCache
{
    ETTDBManagement *dbmanagement = [ETTDBManagement sharedDBManagement];
    [dbmanagement dbClearClassStateCache];
    [dbmanagement dbClearAllCommandCache];
}
////////////////////////////////////////////////////////
/*
 new      : Modify
 time     : 2017.3.14  10:57
 modifier : 康晓光
 version  ：Epic-0313-AIXUEPAIOS-1061
 branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1004rollback_Epic0313_1061
 describe : 对AIXUEPAIOS-1004_Epic0313_1061 分支代码的恢复
 +(void)setReconnectionClass:(BOOL)type
 {
 [[NSUserDefaults standardUserDefaults]setBool:type forKey:@"ReconnectionClass"];
 }
 */


/////////////////////////////////////////////////////

////////////////////////////////////////////////////////
/*
 new      : Modify
 time     : 2017.3.14  10:58
 modifier : 康晓光
 version  ：Epic-0313-AIXUEPAIOS-1061
 branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1004rollback_Epic0313_1061
 describe : 对AIXUEPAIOS-1004_Epic0313_1061 分支代码的恢复
 +(BOOL)getReconnectionClass
 {
 return [[NSUserDefaults standardUserDefaults]boolForKey:@"ReconnectionClass"];
 }
 */

/////////////////////////////////////////////////////

+(NSString *)getRedisIp
{
    NSDictionary *dicData = [self getUserTypeDictionary];
    if ([[dicData objectForKey:[ETTUSERDefaultManager getCurrentIdentity]]isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)[dicData objectForKey:[ETTUSERDefaultManager getCurrentIdentity]];
        NSLog(@"data is %@",data);
        if (data[@"redisIp"]) {
            return data[@"redisIp"];
        }
    }
    return nil;
}


@end
