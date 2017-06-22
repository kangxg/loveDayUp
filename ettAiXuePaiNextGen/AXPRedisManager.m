//
//  AXPRedisManager.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

/*
    
*/

#import "AXPRedisManager.h"
#import "ETTRedisBasisManager.h"

@implementation AXPRedisManager

+(void)setRedisvalueWithHost:(NSString *)host key:(NSString *)redisKey value:(id)redisValue completionHandle:(void(^)(id message))completion
{
    if (redisKey)
    {
        [[ETTRedisBasisManager sharedRedisManager] redisSet:redisKey value:redisValue respondHandler:^(id value, id error) {
            if (value)
            {
                
               dispatch_async(dispatch_get_main_queue(), ^{
                if (completion)
                {
                    completion(value);
                }
                });
            }
            else
            {
                 NSLog(@"Error: %@", error);
            }
            
        }];

    }

}


+(void)getRedisvalueWithHost:(NSString *)host key:(NSString *)redisKey completionHandle:(void(^)(id message))completion
{
    
    if (redisKey )
    {
        [[ETTRedisBasisManager sharedRedisManager] redisGet:redisKey respondHandler:^(id value, id error) {
            if (value && ![value isKindOfClass:[NSNull class]])
            {
                
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion)
                {
                    completion(value);
                    
                }
            });
            }
            else
            {
                 NSLog(@"Error: %@", error);
            }
        }];
    }

}

+(void)setRedisMapvalueWithHost:(NSString *)host redisKey:(NSString *)redisKey field:(id)field value:(id)redisValue completionHandle:(void(^)(id message))completion
{
    if (redisKey)
    {
        [[ETTRedisBasisManager sharedRedisManager]  redisHMSET:redisKey dictionary:field respondHandler:^(id value, id error) {
            if (value)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion)
                    {
                        completion(value);
                    }
                });
            }
            else
            {
                NSLog(@"Error: %@", error);
            }
        }];
    }

}

+(void)getRedisMapvalueWithHost:(NSString *)host redisKey:(NSString *)redisKey completionHandle:(void(^)(id message))completion
{
    if (redisKey)
    {
        [[ETTRedisBasisManager sharedRedisManager] redisHGETALL:redisKey respondHandler:^(id value, id error) {
            if (value && ![value isKindOfClass:[NSNull class]])
            {
            
                dispatch_async(dispatch_get_main_queue(), ^{
            
                    if (completion)
                    {
                        completion(value);
                    }
                });
            }
            else
            {
                NSLog(@"Error: %@", error);
            }

        }];
    }
}

+(void)getRedisMapvalueWithHost:(NSString *)host redisKey:(NSString *)redisKey field:(id)field completionHandle:(void(^)(id message))completion
{
    
    
    
    if (redisKey)
    {
        
        [[ETTRedisBasisManager sharedRedisManager] redisHGET:redisKey field:field respondHandler:^(id value, id error) {
            if (value && ![value isKindOfClass:[NSNull class]])
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (completion)
                    {
                        completion(value);
                    }
                });
            }
            else
            {
                NSLog(@"Error: %@", error);
            }

        }];
         
    }
}


@end
