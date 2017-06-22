//
//  ETTUSERDefaultManager.h
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

#import <Foundation/Foundation.h>
#import "ETTLoginViewConst.h"
#import "ETTAllUserMessageForLoginModel.h"
#import "ETTUserIDForLoginModel.h"
#import "ETTStudentSelectTeacherModel.h"


typedef void(^resphoneHandler)(NSDictionary *identityArray);

typedef NS_ENUM(NSInteger,ETTUSERDefaultType) {
    ETTUSERDefaultTypeAll,
    ETTUSERDefaultTypeStudent,
    ETTUSERDefaultTypeTeacher
};

@interface ETTUSERDefaultManager : NSObject

+(BOOL)setUSERMessageForId:(NSString *)idStr passwordStr:(NSString *)passwordStr isSelected:(NSString *)selected;

+(void)setUSERMessageForIconImage:(UIImage *)image;


+(NSData *)getUSERMessageForIconImage;
/*
 *  获取USERDEFAULT中的信息。
 *
 *  key值分别为@"id",@"password",@"selected";
 */
+(NSDictionary *)getUSERMessage;

/*
 *  @"AllUserMessage"登录以后的信息
 */
+(BOOL)initAllUserMessage:(NSDictionary *)dictionary;

/*
 *  获得用户身份列表
 */
+(NSArray *)getIdentityArray;

/*
 *  1=教师；2=管理员；3=学员 4=演示帐号  6=双重身份既是学生又是老师
 *
 *  return 中@“userType”中身份编码，@“student”学生数据，@“teacher”教师数据
 */
+(NSMutableDictionary *)getUserTypeDictionary;

/*
 *  1=教师；2=管理员；3=学员 4=演示帐号  6=双重身份既是学生又是老师
 *
 *  return 中@“userType”中身份编码，@“student”学生数据，@“teacher”教师数据
 *  与上面方法的区别在于 返回的value由类封装后返回
 */
+(NSMutableDictionary *)getUserTypeDictionaryPro;

+(ETTUserIDForLoginModel *)getUserTypeModelWithType:(ETTUSERDefaultType)type;

+(NSArray *)getUserClassTagList;

+(NSArray *)getUserClassTagListForUserType:(ETTUSERDefaultType)type;

/*
 *  设置当前的登录身份，主要用于解决多身份用户登录
 */
+(void)setCurrentIdentity:(NSString *)identityName;

/*
 *  获取当前的身份 @"teacher"  @"student" @"ObserveStudents"
 */
+(NSString *)getCurrentIdentity;

+(void)setStudentChooseClassroom:(ETTStudentSelectTeacherModel *)model;
+(ETTStudentSelectTeacherModel *)getStudentChooseClassroom;

///存储教师创建课堂的redis channel的信息。
+(void)setTeacherClassroomMessage:(NSDictionary *)dict;
///获得教师创建课堂的redis channel的信息。
+(NSDictionary *)getTeacherClassroomMessage;



+(void)setExecutedMid:(NSString *)mid;
+(NSString *)getExecutedMid;

+(void)setCurrendMA07Mid:(NSString *)mid;
+(NSString *)getCurrentMA07Mid;

#pragma mark ----- 处理当前的用户课堂信息 ------

/**
 存储当前的课堂信息，下次用户登录的时候用于获取上次课堂的基本信息。
 @param dict 用户信息。
 */
+(void)setCurrentClassroomInformation:(NSString *)messageJSON;
+(NSString *)getLastClassroomInformation;

+(void)setStartPageState:(NSString *)state;
+(NSString *)getStartPageState;


+(NSString *)getAppId;
+(void)setAppId;
////////////////////////////////////////////////////////
/*
 new      : Modify
 time     : 2017.3.14  10:59
 modifier : 康晓光
 version  ：Epic-0313-AIXUEPAIOS-1061
 branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1004rollback_Epic0313_1061
 describe : 对AIXUEPAIOS-1004_Epic0313_1061 分支代码的恢复
 +(void)setReconnectionClass:(BOOL)type;
 +(BOOL)getReconnectionClass;
 */

/////////////////////////////////////////////////////


+(NSString *)getVersionId;
+(void)setVersionId:(NSString *)versionId;

+(BOOL)getAppInstallState;
+(void)setAppInstallState:(BOOL)state;



+(void)clearClassStateCache;


+(NSString *)getRedisIp;


+(void)close;

@end
