//
//  ETTUserInformationProcessingUtils.h
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
//  Created by zhaiyingwei on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTSideNavigationViewControllerDelegate.h"
#import "ETTRedisManagerConst.h"
#import "ETTRedisBasisManager.h"
#import "ETTUserIDForLoginModel.h"
#import "ETTUSERDefaultManager.h"
#import "ETTProcessChannelInformationUtil.h"
#import "ETTUserIDForLoginModel.h"
#import "ETTRedisManagerConst.h"
#import "ETTUserIDForLoginModel.h"

typedef  void (^CallBackHandler) (id value,NSError *error);
typedef  void (^CompleteHandler) ();

@interface ETTUserInformationProcessingUtils : NSObject

/*
 *  判断学生身份，通过当前学生的jid和教师创建课堂返回的ClistList。
 */
+(ETTSideNavigationViewIdentity)determineStudentIdentity:(NSString *)jid inClassList:(NSArray *)classList;

+(ETTUserIDForLoginModel *)getUserIDForLoginModel;

///学生处理教师课堂发送的channel命令
+(void)studnetProcessChannelInformation:(NSString *)message;

/**
 Description  拉取 学生处理教师课堂发送的channel命令

 @param message
 */
+(void)studnetRestoreProcessChannelInformation:(NSString *)message;

///教师处理学生课堂channel的回馈信息
+(void)teacherProcessChannelInformation:(NSString *)message;

///学生更新自己的在线状态
-(void)updateStudentOnlineInformation:(NSMutableDictionary *)information;
///教师获得当前在线的学生信息
-(void)teacherGetStudentOnlineInformationWith:(NSString *)key callBackHandler:(CallBackHandler)callBackHandler;

+(NSDictionary *)processMessageForHMSet:(NSDictionary *)dict forType:(NSString *)type;

///发送课堂信息
+(void)publishMessageType:(NSString *)type toJid:(NSString *)jid;


+(void)publishMessageType:(NSString *)type toJid:(NSString *)jid names:(NSArray *)names;

///改变图片的大小
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;

///保存本次课的状态，以便重连使用
+(void)setClassroomState:(NSString *)state classroomId:(NSString *)classroomId identity:(NSString *)identity withMessage:(NSDictionary *)messDic;
///获取上次课的状态
+(NSMutableDictionary *)getLastClassroomState;

+(void)showErrorMessage:(NSInteger)errorNumber;

///处理账号互踢信息
+(void)playEachOther:(NSString *)classroomId withJid:(NSString *)jid;

///结束课堂
+(void)closeClassroomWithJid:(NSString *)jid withClassroomId:(NSString *)classroomId callBackHandler:(CallBackHandler)callBackHandler;

+(void)notifyTeacherExit;

@end












