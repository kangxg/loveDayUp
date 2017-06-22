//
//  AXPRedisManager.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AXPRedisManager : NSObject

+(void)setRedisvalueWithHost:(NSString *)host key:(NSString *)redisKey value:(id)redisValue completionHandle:(void(^)(id message))completion;

+(void)getRedisvalueWithHost:(NSString *)host key:(NSString *)redisKey completionHandle:(void(^)(id message))completion;

+(void)setRedisMapvalueWithHost:(NSString *)host redisKey:(NSString *)redisKey field:(id)field value:(id)redisValue completionHandle:(void(^)(id message))completion;

// 获取所有的 Map 数据(dict)
+(void)getRedisMapvalueWithHost:(NSString *)host redisKey:(NSString *)redisKey completionHandle:(void(^)(id message))completion;

// 获取 Map 中的某一个数据 (jsonStr)
+(void)getRedisMapvalueWithHost:(NSString *)host redisKey:(NSString *)redisKey field:(id)field completionHandle:(void(^)(id message))completion;



@end
