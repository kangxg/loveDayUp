//
//  ETTRedisErrorHelper.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/31.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRedisErrorHelper.h"
#import "ETTRedisHeader.h"
@implementation ETTRedisErrorHelper
+(NSError *)redisSetErrorHelp:(id)value
{
    NSError * err = nil;

    if (value== nil)
    {
        err = [[NSError alloc]initWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPESINGSET userInfo:nil];;
        return err;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"ERR syntax error"])
        {
            err = [NSError errorWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPESINGSET userInfo:nil];
        }
        else if ([value isEqualToString:@"NOAUTH Authentication required."])
        {
            err = [NSError errorWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPENOAUTH userInfo:nil];
        }

    }
    else
    {
        err = nil;
    }
    return err;
}

+(NSError *)redisHMSetErrorHelp:(id)value
{
    NSError * err = nil;

    if (value== nil)
    {
        err = [[NSError alloc]initWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPESINGLEHMSET userInfo:nil];;
        return err;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"ERR syntax error"])
        {
            err = [NSError errorWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPESINGLEHMSET userInfo:nil];
        }
        else if ([value isEqualToString:@"NOAUTH Authentication required."])
        {
            err = [NSError errorWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPENOAUTH userInfo:nil];
        }
    }
    else
    {
        err = nil;
    }
    return err;

}
+(NSError *)redisPushChannelErrorHelp:(id)value
{
    NSError * err = nil;

    if (value== nil)
    {
        err = [[NSError alloc]initWithDomain:ETTRedisCommondPushChannelError code:ETTREDISERRORTYCONPUBLISH userInfo:nil];;
        return err;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"ERR syntax error"])
        {
            err = [NSError errorWithDomain:ETTRedisCommondPushChannelError  code:ETTREDISERRORTYPUBLISH userInfo:nil];
        }
        else if ([value isEqualToString:@"NOAUTH Authentication required."])
        {
            err = [NSError errorWithDomain:ETTRedisCommondPushChannelError  code:ETTREDISERRORTYPENOAUTH userInfo:nil];
        }

    }
    else
    {
        err = nil;
    }
    return err;

}
+(NSError *)redisHGetErrorHelp:(id)value
{
    NSError * err = nil;
    
    if (value== nil)
    {
        err = [[NSError alloc]initWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPEHGET userInfo:nil];;
        return err;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"ERR syntax error"])
        {
            err = [[NSError alloc]initWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPEHGET userInfo:nil];;
        }
        else if ([value isEqualToString:@"NOAUTH Authentication required."])
        {
            err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPENOAUTH userInfo:nil];
        }

    }

    return err;
}

+(NSError *)redisGetReplyErrorhelp:(id)value
{
    NSError * err = nil;
 
    if (value== nil)
    {
        err = [[NSError alloc]initWithDomain:ETTRedisCommondGetReplyError code:ETTREDISERRORTYPEREPLYNULL userInfo:nil];;
        return err;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"ERR syntax error"])
        {
            err = [[NSError alloc]initWithDomain:ETTRedisCommondGetReplyError code:ETTREDISERRORTYPEERROR userInfo:nil];;
        }
        else if ([value isEqualToString:@"NOAUTH Authentication required."])
        {
            err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPENOAUTH userInfo:nil];
        }
        
    }
    
    return err;

}
@end
