//
//  AXPRedisSendMsg.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPRedisSendMsg : NSObject

+(void)sendMessageWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle;

+(void)sendMessageWithUserInfo:(NSDictionary *)userInfo redisValueDict:(NSDictionary *)valueDict type:(NSString *)type redisKey:(NSString *)redisKey successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle;


+(void)sendMessageCacheUserInfo:(NSDictionary *)userInfo type:(NSString *)type successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle;


+(void)sendStudentSubjecMessageWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type successHandle:(void(^)())successHandle failHandle:(void(^)())failHandle;
@end
