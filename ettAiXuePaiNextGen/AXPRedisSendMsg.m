//
//  AXPRedisSendMsg.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPRedisSendMsg.h"
#import "ETTRedisBasisManager.h"
#import "ETTGovernmentTask.h"
#import "ETTAnouncement.h"
@implementation AXPRedisSendMsg

+(void)sendMessageWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    // 对于课堂状态的推送.记录在 redis 服务器中
    if (!isEmptyString(type)&&[type isEqualToString:@"WB_01"]&&[userInfo isKindOfClass:[NSDictionary class]]) {
    
        NSDictionary *dict = @{@"type":type ,
                               
                               @"userInfo":userInfo};
        
        NSString *jsonStr = [ETTRedisBasisManager getJSONWithDictionary:dict];
        
        NSString *redisClassStatusKey = [NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
        
        [redisManager redisSet:redisClassStatusKey value:jsonStr respondHandler:^(id value, id error) {
        }];
    }
  
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":type,
                            @"userInfo":userInfo
                            };
    ///////////////////////////////////////////////////
//    /*
//     Epic-KXG-AIXUEPAIOS-1141
//     */
//
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];

    [task setOperationState:ETTBACKOPERATIONSTATEWILLBEGAIN];
    [task putInDataFordic:dict];
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
    ///////////////////////////////////////////////////
    
    NSString *channelKey = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    

    
    [redisManager publishMessageToChannel:channelKey message:messageJSON  respondHandler:^(id value, id error) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if (!error) {
                /*
                 Epic-KXG-AIXUEPAIOS-1141
                 */
                [task setOperationState:ETTBACKOPERATIONSTATESTART];
                [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
                if (successHandle) {
                    successHandle();
                }
            }else{
                /*
                 Epic-KXG-AIXUEPAIOS-1141
                 */
                [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
                if (failHandle) {
                    failHandle();
                }
            }
        });
    }];
}
+(void)sendMessageCacheUserInfo:(NSDictionary *)userInfo type:(NSString *)type successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    if (!isEmptyString(type))
    {
        
        ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
            NSString *time = [ETTRedisBasisManager getTime];
            
        NSDictionary *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                   @"to":@"ALL",
                                   @"from":[AXPUserInformation sharedInformation].jid,
                                   @"type":type,
                                   @"userInfo":userInfo
                                   };
        NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
        NSString * key = [NSString stringWithFormat:@"%@_%@",type,[userInfo valueForKey:@"whiteboardId"]];
        [redisManager redisHMSET:key dictionary:@{[AXPUserInformation sharedInformation].jid:messageJSON} respondHandler:^(id value, id error) {
            if (!error) {
                
                if (successHandle) {
                    successHandle();
                }
                
            }else{
     
                if (failHandle) {
                    failHandle();
                }
            }

        }];
    }

}
+(void)sendMessageWithUserInfo:(NSDictionary *)userInfo redisValueDict:(NSDictionary *)valueDict type:(NSString *)type redisKey:(NSString *)redisKey successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    if (!isEmptyString(type)&&[type isEqualToString:@"WB_01"]&&[userInfo isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dict = @{@"type":type ,
                               
                               @"userInfo":userInfo};
        
        NSString *jsonStr = [ETTRedisBasisManager getJSONWithDictionary:dict];
        
        NSString *redisClassStatusKey = [NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
        
        [redisManager redisSet:redisClassStatusKey value:jsonStr respondHandler:^(id value, id error) {
        }];
    }
    
    
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":type,
                            @"userInfo":userInfo
                            };
    
    NSString *channelkey = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    
   
    ///////////////////////////////////////////////////
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    
    [task setOperationState:ETTBACKOPERATIONSTATEWILLBEGAIN];
    [task putInDataFordic:dict];
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
    ///////////////////////////////////////////////////

    
    [redisManager redisHMSET:redisKey dictionary:valueDict respondHandler:^(id value, id error) {
        
        if (error) {

        }else{
        
            NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
            
            [redisManager publishMessageToChannel:channelkey message:messageJSON  respondHandler:^(id value, id error) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    
                    if (!error) {
                        /*
                         Epic-KXG-AIXUEPAIOS-1141
                         */
                        [task setOperationState:ETTBACKOPERATIONSTATESTART];
                        [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];

                        if (successHandle) {
                            successHandle();
                        }
                    }else{
                        
                        [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                        [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
                        if (failHandle) {
                            failHandle();
                        }
                    }
                });
            }];
        }
    }];
}


+(void)sendStudentSubjecMessageWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    // 对于课堂状态的推送.记录在 redis 服务器中
    if (!isEmptyString(type)&&[type isEqualToString:@"WB_01"]&&[userInfo isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dict = @{@"type":type ,
                               
                               @"userInfo":userInfo};
        
        NSString *jsonStr = [ETTRedisBasisManager getJSONWithDictionary:dict];
        
        NSString *redisClassStatusKey = [NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
        
        [redisManager redisSet:redisClassStatusKey value:jsonStr respondHandler:^(id value, id error) {
        }];
    }
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                           @"to":@"ALL",
                           @"from":[AXPUserInformation sharedInformation].jid,
                           @"type":type,
                           @"userInfo":userInfo
                           };
    ///////////////////////////////////////////////////
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTETTSITUATIONCLASSUPDATE withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    
   
    [task putInDataFordic:dict];
    
  
    ///////////////////////////////////////////////////
    
    NSString *channelKey = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    
    
    [redisManager publishMessageToChannel:channelKey message:messageJSON  respondHandler:^(id value, id error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                /*
                 Epic-KXG-AIXUEPAIOS-1141
                 */
                [task setOperationState:ETTBACKOPERATIONSTATESTART];
                [task setExtensionData:@"subTopicUserInfo" value:dict];
                [ETTAnouncement reportGovernmentTask:task withType:ETTETTSITUATIONCLASSUPDATE withEntity:nil];
                if (successHandle) {
                    successHandle();
                }
            }else{
                /*
                 Epic-KXG-AIXUEPAIOS-1141
                 */
                [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                [ETTAnouncement reportGovernmentTask:task withType:ETTETTSITUATIONCLASSUPDATE withEntity:nil];
                if (failHandle) {
                    failHandle();
                }
            }
        });
    }];

}
@end
