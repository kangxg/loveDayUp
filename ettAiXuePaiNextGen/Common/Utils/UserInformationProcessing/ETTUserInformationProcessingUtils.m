//
//  ETTUserInformationProcessingUtils.m
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

#import "ETTUserInformationProcessingUtils.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTCharacterAnimationManager.h"
#import "ETTNetworkManager.h"

@implementation ETTUserInformationProcessingUtils

+(ETTSideNavigationViewIdentity)determineStudentIdentity:(NSString *)jid inClassList:(NSArray *)classList
{
    ETTSideNavigationViewIdentity identity = ETTSideNavigationViewIdentityObserveStudents;
    for (id obj in classList) {
        if ([self determineWhether:jid isStudents:(NSDictionary *)obj]) {
            identity = ETTSideNavigationViewIdentityStudent;
            break;
        }
    }
    return identity;
}

///教师classroom中的每个classId的处理
+(BOOL)determineWhether:(NSString *)jid isStudents:(NSDictionary *)classDic
{
    BOOL returnBool = NO;
    NSArray *groupArray = classDic[@"groupList"];
    for (id obj in groupArray) {
        if ([self judgmentStudent:jid inUserList:(NSArray *)obj[@"userList"]]) {
            returnBool = YES;
            break;
        }
    }
    return returnBool;
}

///处理userList属性中的学生信息。
+(BOOL)judgmentStudent:(NSString *)jid inUserList:(NSArray *)userList
{
    BOOL returnBool = NO;
    for (id obj in userList) {
        NSString *userJid = [NSString stringWithFormat:@"%@",obj[@"jid"]];
        if ([jid isEqualToString:userJid]) {
            returnBool = YES;
            break;
        }
    }
    return returnBool;
}

+(ETTUserIDForLoginModel *)getUserIDForLoginModel
{
    NSString * rKey;
    ETTUserIDForLoginModel *userModel;
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"all"]) {
        rKey = @"teacher";
    }else{
        rKey = [ETTUSERDefaultManager getCurrentIdentity];
    }
    
    if ([rKey isEqualToString:@"teacher"]) {
        userModel = [ETTUSERDefaultManager getUserTypeModelWithType:ETTUSERDefaultTypeTeacher];
    }else if ([rKey isEqualToString:@"student"])
    {
        userModel = [ETTUSERDefaultManager getUserTypeModelWithType:ETTUSERDefaultTypeStudent];
    }else{
        NSLog(@"创建学校频道监听获取身份出错!");
    }
    return userModel;
}

+(void)studnetProcessChannelInformation:(NSString *)message
{
    NSDictionary *dict = [ETTRedisBasisManager getDictionaryWithJSON:message];
    
    if ([message isEqualToString:@"守护发送的信息"]) {
        
    }else{
        NSString *typeStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
        if ([[NSString stringWithFormat:@"%@",dict[@"mid"]]isEqualToString:[NSString stringWithFormat:@"%@",[ETTUSERDefaultManager getExecutedMid]]]&&[self getBoolForTypeOperation:dict]) {
            NSLog(@"当前命令已经执行过！");
        }else{
            NSDictionary *dic = [ETTUSERDefaultManager getUserTypeDictionaryPro];
            ETTUserIDForLoginModel *model = (ETTUserIDForLoginModel *)dic[@"student"];
            NSString *oToStr = [NSString stringWithFormat:@"%@",dict[@"to"]];
            
            NSArray *jidArr = [oToStr componentsSeparatedByString:@","];
            BOOL flag = false;
            for (id obj in jidArr) {
                NSString *toStr = [NSString stringWithFormat:@"%@",obj];
                if ([[NSString stringWithFormat:@"%@",model.jid]isEqualToString:[NSString stringWithFormat:@"%@",toStr]]||[toStr isEqualToString:@"ALL"]||[toStr isEqualToString:@"all"])
                {
                    if (dict[@"mid"]!=nil&&[self getBoolForTypeOperation:dict]) {
                        [ETTUSERDefaultManager setExecutedMid:[dict valueForKey:@"mid"]];
                    }
                    if ([[NSString stringWithFormat:@"%@",model.jid]isEqualToString:[NSString stringWithFormat:@"%@",toStr]])
                    {
                        flag = true;
                    }
                    [ETTProcessChannelInformationUtil studentProcessChannelInformationWithMessageDictionary:dict];
                    
                }
              
            }
            
            if (jidArr.count == 1 )
            {
              
                
                if ([typeStr isEqualToString:@"MA_02"] && !flag)
                {
                    NSArray *namesArr = dict[@"names"];
                    [[ETTCharacterAnimationManager shareAnimationManager]createAnimationView:ETTCHARANIMATIONREWAREOTHER info:namesArr];
                }
                
            }
            else
            {
                
                if ([typeStr isEqualToString:@"MA_02"])
                {
                    NSArray *namesArr = dict[@"names"];
                    [[ETTCharacterAnimationManager shareAnimationManager]createAnimationView:ETTCHARANIMATIONREWAREGROUP info:namesArr];
                }
              
            }
            
            
        }
    }
}

///登录或重连调用
+(void)studnetRestoreProcessChannelInformation:(NSString *)message
{
    NSDictionary *dict = [ETTRedisBasisManager getDictionaryWithJSON:message];
    
    if ([message isEqualToString:@"守护发送的信息"]) {
        
    }else{
        NSString *typeStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
        if ([[NSString stringWithFormat:@"%@",dict[@"mid"]]isEqualToString:[NSString stringWithFormat:@"%@",[ETTUSERDefaultManager getExecutedMid]]]&&[self getBoolForTypeOperation:dict]) {
            NSLog(@"%@  命令已经执行过！",typeStr);
        }else{
            NSDictionary *dic = [ETTUSERDefaultManager getUserTypeDictionaryPro];
            ETTUserIDForLoginModel *model = (ETTUserIDForLoginModel *)dic[@"student"];
            NSString *oToStr = [NSString stringWithFormat:@"%@",dict[@"to"]];
            
            NSArray *jidArr = [oToStr componentsSeparatedByString:@","];
           BOOL flag = false;
            for (id obj in jidArr) {
                NSString *toStr = [NSString stringWithFormat:@"%@",obj];
                if ([[NSString stringWithFormat:@"%@",model.jid]isEqualToString:[NSString stringWithFormat:@"%@",toStr]]||[toStr isEqualToString:@"ALL"]||[toStr isEqualToString:@"all"])
                {
                    if (dict[@"mid"]!=nil&&[self getBoolForTypeOperation:dict]) {
                        
                        [ETTUSERDefaultManager setExecutedMid:[dict valueForKey:@"mid"]];
                    }
                    
                    if ([typeStr isEqualToString:@"MA_02"]) {
                        if([typeStr isEqualToString:@"MA_02"] && [[NSString stringWithFormat:@"%@",model.jid]isEqualToString:[NSString stringWithFormat:@"%@",toStr]])
                        {
                            flag = true;
                        }
                        else
                        {
                            [ETTProcessChannelInformationUtil studentProcessChannelInformationWithMessageDictionary:dict];
                        }
                    }else if ([typeStr isEqualToString:@"MA_07_BEGIN"])
                    {
                        NSString *midStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"mid"]];
                        NSString *oldMidStr = [NSString stringWithFormat:@"%@",[ETTUSERDefaultManager getExecutedMid]];
                        if ([typeStr isEqualToString:@"MA_07_BEGIN"]&&![midStr isEqualToString:oldMidStr])
                        {
                            [ETTProcessChannelInformationUtil studentProcessChannelInformationWithMessageDictionary:dict];
                        }
                    }else if([typeStr isEqualToString:@"MA_05"]){
                        [ETTProcessChannelInformationUtil studentProcessChannelInformationWithMessageDictionary:dict];
                    }
                }
            
                if ([typeStr isEqualToString:@"MA_02"] &&  flag)
                {
                    
                    NSArray *namesArr = dict[@"names"];
                    [[ETTCharacterAnimationManager shareAnimationManager]createAnimationView:ETTCHARANIMATIONREWAREMINE info:namesArr];
                }
            }
            
            
        }
    }

}

///判断有效
+(BOOL)getBoolForTypeOperation:(NSDictionary *)dict
{
    NSString *typeStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
    return [typeStr isEqualToString:@"MA_02"]||[typeStr isEqualToString:@"MA_03"];
}

+(void)teacherProcessChannelInformation:(NSString *)message
{
    if (message) {
        NSDictionary *dict = [ETTRedisBasisManager getDictionaryWithJSON:message];
        [ETTProcessChannelInformationUtil teacherProcessChannelInformationWithMessageDictionary:dict];
    }
}

-(void)updateStudentOnlineInformation:(NSMutableDictionary *)information
{
    NSString *key = [NSString stringWithFormat:@"%@%@",information[@"classroomId"],kPCI_STUDENT_MANAGEMENT];
    
    
    NSString *fieldKey = information[@"jid"];
    NSDictionary *messageDic = @{fieldKey:[ETTRedisBasisManager getJSONWithDictionary:information]};
    
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    [redisManager redisHMSET:key dictionary:messageDic type:kREDIS_COMMAND_TYPE_MA_01 intervals:kREDIS_GET_DEFAULT_INTERVAL respondHandler:^(id value, id error) {
        if (!error) {
            ETTLog(@"更新数据成功！");
        }else{
            ETTLog(@"更新数据失败！");
        }
    }];
}

NSDictionary *oldStudentOnlineMessageDict;
-(void)teacherGetStudentOnlineInformationWith:(NSString *)key callBackHandler:(CallBackHandler)callBackHandler
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    [redisManager redisHGETALL:key intervals:0 respondHandler:^(id value, id error) {
        if (!error) {
            NSArray *allStudentMessageArr = [value allValues];
            NSString *nowTime = [ETTRedisBasisManager getTime];
            NSMutableArray *studentArr = [NSMutableArray array];
            NSMutableArray *observeStudents = [NSMutableArray array];
            for (id obj in allStudentMessageArr) {
                NSDictionary *messageDic = (NSDictionary *)[ETTRedisBasisManager getDictionaryWithJSON:obj];
                int time = [NSString stringWithFormat:@"%@",messageDic[@"time"]].intValue;
                if (nowTime.intValue-time<kREDIS_GET_DEFAULT_INTERVAL*kREDIS_CONNECT_SCALE) {
                    if ([messageDic[@"identity"]isEqualToString:@"student"]) {
                        [studentArr addObject:messageDic];
                    }else if ([messageDic[@"identity"]isEqualToString:@"ObserveStudents"]){
                        [observeStudents addObject:messageDic];
                    }
                }
            }
            
            NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
            if ([studentArr count]>0||[observeStudents count]>0) {
                if ([studentArr count]>0) {
                    [messageDic setObject:studentArr forKey:@"student"];
                }
                
                if ([observeStudents count]>0) {
                    [messageDic setObject:observeStudents forKey:@"ObserveStudents"];
                }
            }
            if ([studentArr count]<=0) {
                NSArray *stuArr = [NSArray array];
                [messageDic setObject:stuArr forKey:@"student"];
            }
            if ([observeStudents count]<=0) {
                NSArray *stuArr = [NSArray array];
                [messageDic setObject:stuArr forKey:@"ObserveStudents"];
            }
            
            if ([oldStudentOnlineMessageDict count]==0) {
                oldStudentOnlineMessageDict = [NSDictionary dictionaryWithDictionary:messageDic];
                callBackHandler(messageDic,error);
            }else{
                if (![oldStudentOnlineMessageDict isEqualToDictionary:messageDic]) {
                    oldStudentOnlineMessageDict = messageDic;
                    callBackHandler(messageDic,error);
                }
            }
        }else{
            callBackHandler(nil,error);
        }
    }];
}

+(NSDictionary *)processMessageForHMSet:(NSDictionary *)dict forType:(NSString *)type
{
    if ([type isEqualToString:kREDIS_COMMAND_TYPE_MA_01]) {
        NSArray *messageArr = [dict allValues];
        NSMutableDictionary *messDict;
        if ([messageArr firstObject]) {
            messDict = [ETTRedisBasisManager getDictionaryWithJSON:[messageArr firstObject]];
        }
        NSString *key = messDict[@"jid"];
        [messDict setObject:[ETTRedisBasisManager getTime] forKey:@"time"];
        NSDictionary *messageDict = @{key:[ETTRedisBasisManager getJSONWithDictionary:messDict]};
        
        return messageDict;
    }
    
    return nil;
}

+(void)publishMessageType:(NSString *)type toJid:(NSString *)jid
{
    if (!jid||jid.integerValue == 0) {
        jid = @"ALL";
    }
    
    NSDictionary *dic = [[ETTUSERDefaultManager getTeacherClassroomMessage]objectForKey:@"message"];
    NSString *channelName = [NSString stringWithFormat:@"%@%@",dic[@"classroomId"],kPCI_CLASSROOM_CHANNEL];
    NSDictionary *messDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                              @"time":[ETTRedisBasisManager getTime],
                              @"from":@"XMAN",
                              @"to":jid,
                              @"type":type};
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:messDic];
    
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    NSDictionary *theUserInfo = @{
                                  @"type":type,
                                  @"theUserInfo":messDic
    };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            [redisManager publishMessageToChannel:channelName message:messageJSON respondHandler:^(id value, id error) {
                if (!error) {
                    NSLog(@"%@ 推送成功!",type);
                }else{
                    NSLog(@"推送失败!");
                }
            }];
        } else {
            ETTLog(@"查看/奖励等redis缓存失败原因:%@",error);
        }
    }];
    
    
}
+(void)publishMessageType:(NSString *)type toJid:(NSString *)jid names:(NSArray *)names
{
    if (!jid||jid.integerValue == 0) {
        jid = @"ALL";
    }
    
    NSDictionary *dic = [[ETTUSERDefaultManager getTeacherClassroomMessage]objectForKey:@"message"];
    NSString *channelName = [NSString stringWithFormat:@"%@%@",dic[@"classroomId"],kPCI_CLASSROOM_CHANNEL];
    NSDictionary *messDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                              @"time":[ETTRedisBasisManager getTime],
                              @"from":@"XMAN",
                              @"to":jid,
                              @"type":type,
                              @"names":names};
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:messDic];
    
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    NSDictionary *theUserInfo = @{
                                  @"type":type,
                                  @"theUserInfo":messDic
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            [redisManager publishMessageToChannel:channelName message:messageJSON respondHandler:^(id value, id error) {
                if (!error) {
                    NSLog(@"%@ 推送成功!",type);
                }else{
                    NSLog(@"推送失败!");
                }
            }];
        } else {
            ETTLog(@"查看/奖励等redis缓存失败原因:%@",error);
        }
    }];

}
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(void)setClassroomState:(NSString *)state classroomId:(NSString *)classroomId identity:(NSString *)identity withMessage:(NSDictionary *)messDic
{
    NSDictionary *dict;
    if (messDic!=nil) {
        dict = @{@"type":state,
                 @"classroomId":classroomId,
                 @"userInfo":messDic,
                 @"identity":identity};
    }else{
        dict = @{@"type":state,
                 @"classroomId":classroomId,
                 @"identity":identity};
    }
    NSString *messJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    [ETTUSERDefaultManager setCurrentClassroomInformation:messJSON];
}

+(NSMutableDictionary *)getLastClassroomState
{
    NSString *messJSON = [ETTUSERDefaultManager getLastClassroomInformation];
    NSMutableDictionary *messDic = [ETTRedisBasisManager getDictionaryWithJSON:messJSON];
    return messDic;
}

+(void)showErrorMessage:(NSInteger)errorNumber
{
    NSLog(@"error number is %ld",errorNumber);
    NSString *errStr = nil;
    switch (errorNumber) {
        case -1:
            errStr = @"操作失败，请重试";
            break;
        case -2:
            errStr = @"系统参数错误，访问失败";
            break;
        case -3:
            errStr = @"获取用户失败，请重试或重新登录";
            break;
        case -4:
            errStr = @"加密信息验证不通过";
            break;
        case -5:
            errStr = @"存在敏感词";
            break;
        case -6:
            errStr = @"操作失败，请重试";//@"数据库罢工了，重试运行";
            break;
        case -7:
            errStr = @"课堂已经关闭";
            break;
            //        case -10001:
            //            errStr = @"用户名不存在";
            //            break;
            //        case -10002:
            //            errStr = @"密码错误";
            //            break;
            //        case -10003:
            //            errStr = @"用户不存在";
            //            break;
            //        case -10004:
            //            errStr = @"没有权限";
            //            break;
            //        case -10005:
            //            errStr = @"没有班级";
            //            break;
        case -20001:
            errStr = @"学校不存在";
            break;
        case -20002:
            errStr = @"课堂限定人数设置错误，请联系客服";
            break;
        case -20003:
            errStr = @"上课班级不存在";
            break;
        case -20004:
            errStr = @"该用户存在正在进行的课堂，系统关闭课堂失败";
            break;
        case -20005:
            errStr = @"教师的课列表为空请先建课";
            break;
        case -20006:
            errStr = @"未能进入课堂，请重试";
            break;
        case -20007:
            errStr = @"课堂不存在";
            break;
        case -20008:
            errStr = @"非本人创建课堂不能重连";
            break;
        case -20009:
            errStr = @"学校不存在";
            break;
            //        case -30001:
            //            errStr = @"动作已经保存";
            //            break;
            //        case -30002:
            //            errStr = @"抢答时间不能为空";
            //            break;
            //        case -30003:
            //            errStr = @"旁听生的相关奖励、提醒、抢答、点名信息不记录";
            //            break;
            
        default:
            break;
    }
    
    if (errStr!=nil) {
        [self mShowErrorMessage:errStr];
    }}

+(void)mShowErrorMessage:(NSString *)errorMessage
{
    [[iToast makeText:errorMessage]show];
}

+(void)playEachOther:(NSString *)classroomId withJid:(NSString *)jid
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *playeachotherKey = [NSString stringWithFormat:@"%@%@",classroomId,kPCI_PLAY_EACH_OTHER];
    NSString *fieldKey = [NSString stringWithFormat:@"%@",jid];
    [redisManager redisHGET:playeachotherKey field:fieldKey respondHandler:^(id value, id error) {
        if (!error) {
            NSDictionary *lgDic = [ETTRedisBasisManager getDictionaryWithJSON:value];
            if (lgDic) {
                ///判断信息对方是否需要下线
                [self judgeEachOther:classroomId withJid:jid loginMessage:lgDic];
            }else{
                ///没有登录信息
                [self updatePalyEachOtherMessage:classroomId withJid:jid];
            }
        }
    }];
}

///判断自己获取的登录信息的有效性
+(void)judgeEachOther:(NSString *)classroomId withJid:(NSString *)jid loginMessage:(NSDictionary *)lgDic
{
    NSString *jidStr = [lgDic objectForKey:@"jid"];
    if ([jid isEqualToString:jidStr]) {
        ///是该账号的登录信息
        NSString *currendAppId = [ETTUSERDefaultManager getAppId];
        NSString *lgAppId = [lgDic objectForKey:@"appId"];
        if ([currendAppId isEqualToString:lgAppId]) {
            ///是自己的登录信息,不需要做任何操作。
        }else{
            ///不是自己的登录信息，通知对方下线。
            ///应该判断一下对方的身份，如果是教师应该自己下线。
            [self eachOther:classroomId withJid:jid];
        }
    }else{
        ///不是该账号的登录信息
        [self updatePalyEachOtherMessage:classroomId withJid:jid];
    }
}

///通知对方下线
+(void)eachOther:(NSString *)classroomId withJid:(NSString *)jid
{
    NSString *classroomKey = [NSString stringWithFormat:@"%@%@",classroomId,kPCI_CLASSROOM_CHANNEL];
    NSDictionary *messDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                              @"time":[NSString stringWithFormat:@"%@",[ETTRedisBasisManager getTime]],
                              @"from":jid,
                              @"to":jid,
                              @"type":@"PLAY_EACH_OTHER",
                              @"appID":[NSString stringWithFormat:@"%@",[ETTUSERDefaultManager getAppId]]
                              };
    NSString *messJson = [ETTRedisBasisManager getJSONWithDictionary:messDic];
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:classroomKey message:messJson respondHandler:^(id value, id error) {
        if (!error) {
            [self updatePalyEachOtherMessage:classroomId withJid:jid];
        }else{
            ///通知对方下线失败应该做一些操作，但是暂时还没想好做什么，先这样以后再加
            [self updatePalyEachOtherMessage:classroomId withJid:jid];
        }
    }];
}

+(void)updatePalyEachOtherMessage:(NSString *)classroomId withJid:(NSString *)jid
{
    NSString *classroomKey = [NSString stringWithFormat:@"%@%@",classroomId,kPCI_PLAY_EACH_OTHER];
    NSString *field = [NSString stringWithFormat:@"%@",jid];
    NSDictionary *lgDic = @{@"jid":[AXPUserInformation sharedInformation].jid,
                            @"identity":[ETTUSERDefaultManager getCurrentIdentity],
                            @"appID":[ETTUSERDefaultManager getAppId]};
    NSString *lgJSON = [ETTRedisBasisManager getJSONWithDictionary:lgDic];
    NSDictionary *messDic = @{field:lgJSON};
    [[ETTRedisBasisManager sharedRedisManager]redisHMSET:classroomKey dictionary:messDic respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"更新登录信息失败!");
        }else{
            NSLog(@"更新登录信息成功!");
        }
    }];
}

+(void)closeClassroomWithJid:(NSString *)jid withClassroomId:(NSString *)classroomId callBackHandler:(CallBackHandler)callBackHandler
{
    NSString *jidStr            = [NSString stringWithFormat:@"%@",jid];
    NSString *classroomIdStr    = [NSString stringWithFormat:@"%@",classroomId];
    NSDictionary *paramDic = @{@"jid":jidStr,
                               @"classroomId":classroomIdStr};
    NSString *urlBody = @"axpad/classroom/closeClassroom.do";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_HOST,urlBody];
    [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:paramDic responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        if (error) {
            callBackHandler(responseDictionary,error);
        }else{
            callBackHandler(responseDictionary,error);
        }
    }];
}

+(void)notifyTeacherExit
{
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kEXIT object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kCLASS_CLOSED object:nil];
    }
}

@end
