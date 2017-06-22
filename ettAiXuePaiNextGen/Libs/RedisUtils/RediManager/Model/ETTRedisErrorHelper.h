//
//  ETTRedisErrorHelper.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/31.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.21  11:15
 modifier : 康晓光
 version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
 problem  : 大课件redis验证权限处理
 describe : reids 数据返回结果错误检查辅助类，如果没有错误，返回nil
 */
////////////////////////////////////////////////////////
#import "ETTBaseModel.h"

@interface ETTRedisErrorHelper : ETTBaseModel
+(NSError *)redisSetErrorHelp:(id)value;

+(NSError *)redisHMSetErrorHelp:(id)value;

+(NSError *)redisPushChannelErrorHelp:(id)value;
+(NSError *)redisHGetErrorHelp:(id)value;

+(NSError *)redisGetReplyErrorhelp:(id)value;
@end
