

//
//  ETTContinuousOperationWorker.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTContinuousOperationWorker.h"
#import "ETTUserInformationProcessingUtils.h"
@implementation ETTContinuousOperationWorker
@dynamic EDField;
@dynamic EDWorkInfoDic;
@synthesize EDWorkType;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_EDOperationKey forKey:@"OperationKey"];
    [aCoder encodeFloat:(CGFloat)_EDWorkTimeInterval forKey:@"WorkTimeInterval"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super init])
    {
        self.EDOperationKey     =  [aDecoder decodeObjectForKey:@"OperationKey"];
        self.EDWorkTimeInterval =  [aDecoder decodeFloatForKey:@"WorkTimeInterval"];
    }
    return self;
}
-(void)initData
{
    [super initData];
}
-(void)workComplete
{
    _EDOperationKey = nil;
    [super workComplete];
}
-(void)hangWorkerTask
{
    
}
-(void)wakeupWorkerTask
{
    [self startRedisWork];
}
-(void)startRedisWork
{
    
}
-(void)createOperQueue
{
    
}
@end


#pragma mark
#pragma mark  -------------------- 连续数据设置 -----------------------
/**
 Description 连续数据设置
 */
@implementation ETTContinuousSettingWorker
@synthesize EDWorkInfoDic = _EDWorkInfoDic;
@synthesize EDWorkType    = _EDWorkType;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_EDWorkInfoDic forKey:@"WorkInfoDic"];
    [aCoder  encodeObject:_EDWorkType forKey:@"WorkType"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder])
    {
        _EDWorkInfoDic   = [aDecoder decodeObjectForKey:@"WorkInfoDic"];
        _EDWorkType      = [aDecoder decodeObjectForKey:@"WorkType"];
    }
    return self;
}

-(void)setEDWorkInfoDic:(NSDictionary *)EDWorkInfoDic
{
    if (EDWorkInfoDic)
    {
        _EDWorkInfoDic = [[NSDictionary alloc]initWithDictionary:EDWorkInfoDic];
    }
}
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    self.EDOperationKey = key;
    self.EDHandlerblock = respondHandler;
    self.EDWorkTimeInterval = time;
    self.EDWorkType     = type;
    
    self.EDWorkInfoDic = dict;
    [self startRedisWork];
    
}
-(void)createOperQueue
{
    if (self.EDOperQueue == nil)
    {
        self.EDOperQueue = dispatch_queue_create([self.EDOperationKey UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
}

-(void)redisHMSETesurrection:(RespondHandler)respondHandler
{
    self.EDHandlerblock = respondHandler;
}
-(void)startRedisWork
{
    if (self.EDWarehouse.EDCocoaRedis == nil ||self.EDEmployer == nil || !self.EDOperationKey.length)
    {
        return;
    }
    
    WS(weakSelf);
    //测试中需要注释
    _EDWorkInfoDic = [ETTUserInformationProcessingUtils processMessageForHMSet:_EDWorkInfoDic forType:_EDWorkType];
    NSMutableArray* args = [NSMutableArray arrayWithObjects: @"HMSET",self.EDOperationKey, nil];
    
    for( id skey in _EDWorkInfoDic ) {
        [args addObject: skey];
        [args addObject: _EDWorkInfoDic[skey]];
    }
    id value= [self.EDWarehouse.EDCocoaRedis commandArgv:args];
    
    if ([value isKindOfClass:[NSString class]]&&[value isEqualToString:@"OK"])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.EDHandlerblock)
//            {
//                weakSelf.EDHandlerblock(value,nil);
//            }
//    });
        
        if (weakSelf.EDHandlerblock)
        {
            weakSelf.EDHandlerblock(value,nil);
        }
    }
    else
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.EDHandlerblock)
//            {
//                
//                NSError * err = [[NSError alloc]initWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPECONHMSET userInfo:@{@"value":value}];
//                weakSelf.EDHandlerblock(nil,err);
//            }
//
//        });
        
        if (weakSelf.EDHandlerblock)
        {
            
            NSError * err = [[NSError alloc]initWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPECONHMSET userInfo:@{@"value":value}];
            weakSelf.EDHandlerblock(nil,err);
        }
    }
}

@end


#pragma mark
#pragma mark  -------------------- 连续获取所用 -----------------------
/**
 Description 连续获取所用
 */
@implementation ETTContinuousGetALLWorker
-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    self.EDOperationKey = key;
    self.EDHandlerblock = respondHandler;
    self.EDWorkTimeInterval = time;
    [self startRedisWork];
}

-(void)redisHGETALLTesurrection:(RespondHandler)respondHandler
{
    self.EDHandlerblock = respondHandler;
}

-(void)startRedisWork
{
    if (self.EDWarehouse.EDCocoaRedis == nil ||self.EDEmployer == nil || !self.EDOperationKey.length)
    {
        return;
    }
    
    WS(weakSelf);
    
    id value = [self.EDWarehouse.EDCocoaRedis commandArgv:@[@"HGETALL", self.EDOperationKey]];
    if (value)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.EDHandlerblock)
//            {
//                weakSelf.EDHandlerblock([self promiseNSDict:value],nil);
//            }
//        });
        if (weakSelf.EDHandlerblock)
        {
            weakSelf.EDHandlerblock([self promiseNSDict:value],nil);
        }
    }
    else
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.EDHandlerblock)
//            {
//                NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPCONHGETALL userInfo:nil];
//                weakSelf.EDHandlerblock(nil,err);
//            }
//        });
        
        if (weakSelf.EDHandlerblock)
        {
            NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPCONHGETALL userInfo:nil];
            weakSelf.EDHandlerblock(nil,err);
        }
    }
}

-(void)dealloc
{
    
}
@end

#pragma mark
#pragma mark  -------------------- 连续获取单个 -----------------------
/**
 Description 连续获取单个 key外层大 key field 内层小key
 */
@implementation ETTContinuousGetSingleWorker
@synthesize EDField = _EDField;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_EDField forKey:@"Field"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder])
    {
        self.EDField   = [aDecoder decodeObjectForKey:@"Field"];
    }
    return self;
}
-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    self.EDOperationKey = key;
    self.EDField        = field;
    self.EDWorkTimeInterval = time;
    self.EDHandlerblock = respondHandler;
    
    [self startRedisWork];
}

-(void)startRedisWork
{
    if (self.EDWarehouse.EDCocoaRedis == nil ||self.EDEmployer == nil || !self.EDOperationKey.length)
    {
        return;
    }
    WS(weakSelf);
    
    id value = [self.EDWarehouse.EDCocoaRedis commandArgv:@[@"HGET",self.EDOperationKey,self.EDField]];
    
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.7  18:00
     modifier : 康晓光
     version  ：Dev-0224
     branch   ：1043
     describe : 增加返回字符串 错误判断
     */
    if (value)
    {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (weakSelf.EDHandlerblock)
//            {
//                if ([value isKindOfClass:[NSString class]])
//                {
//                    if ([value isEqualToString:@"ERR syntax error"])
//                    {
//                        NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPCONHGET userInfo:nil];
//                        weakSelf.EDHandlerblock(nil,err);
//                        
//                    }
//                    else
//                    {
//                        weakSelf.EDHandlerblock(value,nil);
//                    }
//                }
//                else
//                {
//                    weakSelf.EDHandlerblock(value,nil);
//                }
//                
//            }
//        });
        if (weakSelf.EDHandlerblock)
        {
            if ([value isKindOfClass:[NSString class]])
            {
                if ([value isEqualToString:@"ERR syntax error"])
                {
                    NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPCONHGET userInfo:nil];
                    weakSelf.EDHandlerblock(nil,err);
                    
                }
                else
                {
                    weakSelf.EDHandlerblock(value,nil);
                }
            }
            else
            {
                weakSelf.EDHandlerblock(value,nil);
            }
            
        }
    }
    else
    {
        if (weakSelf.EDHandlerblock)
        {
            NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPCONHGET userInfo:nil];

             weakSelf.EDHandlerblock(nil,err);
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPCONHGET userInfo:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//               
//            });
//            
//            
//        });
    }

    /////////////////////////////////////////////////////
    
}

-(void)redisHGETTesurrection:(RespondHandler)respondHandler;
{
    self.EDHandlerblock = respondHandler;
}

-(void)dealloc
{
    
}
@end


#pragma mark
#pragma mark  -------------------- 连续向频道推送 -----------------------

/**
 Description 连续向频道推送
 */
@implementation ETTContinuousPushChannelWorker : ETTContinuousOperationWorker
@synthesize EDWorkInfoDic  = _EDWorkInfoDic;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_EDWorkInfoDic forKey:@"WorkInfoDic"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder])
    {
        _EDWorkInfoDic   = [aDecoder decodeObjectForKey:@"WorkInfoDic"];
    }
    return self;
}
-(void)setEDWorkInfoDic:(NSDictionary *)EDWorkInfoDic
{
    if (EDWorkInfoDic)
    {
        _EDWorkInfoDic = [[NSDictionary alloc]initWithDictionary:EDWorkInfoDic];
    }
}

-(void)createOperQueue
{
    if (self.EDOperQueue == nil)
    {
        self.EDOperQueue = dispatch_queue_create([self.EDOperationKey UTF8String], DISPATCH_QUEUE_SERIAL);
    }
}
-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    self.EDOperationKey = channelName;
    self.EDWorkInfoDic  = message;
    self.EDWorkTimeInterval = time;
    self.EDHandlerblock = respondHandler;
    [self startRedisWork];
}

-(void)startRedisWork
{
    if (self.EDWarehouse.EDCocoaRedis == nil ||self.EDEmployer == nil || !self.EDOperationKey.length)
    {
        return;
    }
    WS(weakSelf);
    NSString *messageJson = [self upDateMessageTimeForJSONWithDictionary:self.EDWorkInfoDic];
    NSMutableArray *commArr = [NSMutableArray array];
    [commArr addObject:@"PUBLISH"];
    [commArr addObject:self.EDOperationKey];
    [commArr addObject:messageJson];
    id returnData = [self.EDWarehouse.EDCocoaRedis  commandArgv:commArr];
    
    if (returnData)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.EDHandlerblock)
//            {
//                weakSelf.EDHandlerblock(returnData,nil);
//            }
//        });
        
        if (weakSelf.EDHandlerblock)
        {
            weakSelf.EDHandlerblock(returnData,nil);
        }
    }
    else
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.EDHandlerblock)
//            {
//                NSError * err = [NSError errorWithDomain:ETTRedisCommondPushChannelError code:ETTREDISERRORTYCONPUBLISH userInfo:nil];
//                weakSelf.EDHandlerblock(nil,err);
//            }
//
//        });
        if (weakSelf.EDHandlerblock)
        {
            NSError * err = [NSError errorWithDomain:ETTRedisCommondPushChannelError code:ETTREDISERRORTYCONPUBLISH userInfo:nil];
            weakSelf.EDHandlerblock(nil,err);
        }
    }
    
}

-(void)redisPushChannelTesurrection:(RespondHandler)respondHandler
{
    self.EDHandlerblock = respondHandler;
}
-(NSString *)upDateMessageTimeForJSONWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [messageDic setObject:[ETTRedisBasisManager getTime] forKey:@"time"];
    NSString *jsonStr = [ETTRedisBasisManager getJSONWithDictionary:messageDic];
    return jsonStr;
}
@end


@implementation ETTContinuousGetChannelMsgWorker : ETTContinuousOperationWorker
-(void)initData
{
    [super initData];
    _EDChannelNames = [[NSMutableArray alloc]init];
}
-(void)channelMessage:(NSString *)channelName  respondHandler:(RespondHandler)respondHandler
{
    self.EDOperationKey = channelName;
    
    self.EDHandlerblock = respondHandler;
    [self startRedisWork];
}

-(void)redisChannelTesurrection:(RespondHandler)respondHandler
{
    
}
-(void)startRedisWork
{
    if (self.EDWarehouse.EDCocoaRedis == nil ||self.EDEmployer == nil || !self.EDOperationKey.length)
    {
        return;
    }
    
}
@end


