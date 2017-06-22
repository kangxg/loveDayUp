//
//  ETTRedisDataHouseManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisDataHouseManager.h"
#import "ETTRedisDataWarehouse.h"
#import "ETTRedisMaintenanceWorker.h"
@implementation ETTRedisDataHouseManager
@synthesize EDManager         = _EDManager;
@synthesize EDDataHouse       = _EDDataHouse;
@synthesize EDCocoaRedis      = _EDCocoaRedis;
@synthesize EDChannelRedis    = _EDChannelRedis;

@synthesize EDServerHost      = _EDServerHost;
@synthesize EDServerPort      = _EDServerPort;
@synthesize EDHeartTime       = _EDHeartTime;
@synthesize EDHasRegChannel   = _EDHasRegChannel;
-(instancetype)init:(id<ETTRedisWorkerManageInterface>)manger withHouse:(ETTRedisDataWarehouse *)dataHouse
{
    if (self = [super init])
    {
        _EDManager    = manger;
        _EDDataHouse  = dataHouse;
    }
    return self;
}

-(NSString *)getWorkPassword
{
    if (_EDDataHouse.EDPassword.length)
    {
        return _EDDataHouse.EDPassword;
    }
    return kRedisPassWord;
}
-(void)setWorkPassword:(NSString *)pwd
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDPassword = pwd;
    }
}
-(void)setConnectResponHandler:(RespondHandler)responHandler
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDHandler = responHandler;
    }
}
-(BOOL)EDHasRegChannel
{
    if (_EDDataHouse)
    {
        return _EDDataHouse.EDHasRegChannel;
    }
    return false;
}

-(void)setEDHasRegChannel:(BOOL)EDHasRegChannel
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDHasRegChannel = EDHasRegChannel;
    }
}
-(NSString *)getWorkHost
{
    return _EDDataHouse.EDServerHost;
}

-(int)getWorkServerPort
{
    return (int)_EDDataHouse.EDServerPort;
}

-(NSTimeInterval )getRedisTime
{
    return _EDDataHouse.EDRedisTime;
}

-(NSTimeInterval )getLoginTime
{
    return _EDDataHouse.EDLoginTime;
}

-(void)updateTime:(NSDate *)redisDate
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDRedisTime = [redisDate timeIntervalSince1970];
        _EDDataHouse.EDLoginTime = [[NSDate new]timeIntervalSince1970];
    }
}

-(void)setEDCocoaRedis:(ObjCHiredis *)EDCocoaRedis
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDCocoaRedis = EDCocoaRedis;
    }
}
-(ObjCHiredis *)EDCocoaRedis
{
    if (_EDDataHouse)
    {
        return _EDDataHouse.EDCocoaRedis;
    }
    return nil;
    
}

-(void)setEDChannelRedis:(ObjCHiredis *)EDChannelRedis
{
    if (_EDDataHouse)
    {
        _EDDataHouse .EDChannelRedis = EDChannelRedis;
    }
}

-(ObjCHiredis *)EDChannelRedis
{
    if (_EDDataHouse)
    {
        return _EDDataHouse.EDChannelRedis;
    }
    
    return nil;
}



-(void)setEDServerHost:(NSString *)EDServerHost
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDServerHost = EDServerHost;
    }
}
-(void)setEDServerPort:(int)EDServerPort
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDServerPort = EDServerPort;
    }
}


-(NSString *)EDServerHost
{
    if (_EDDataHouse)
    {
        return _EDDataHouse.EDServerHost;
    }
    return nil;
}

-(int)EDServerPort
{
    if (_EDDataHouse)
    {
        return  (int)_EDDataHouse.EDServerPort;
    }
    return 0;
}

-(RespondHandler)getRespondBackHandle
{
    if (_EDDataHouse)
    {
        return _EDDataHouse.EDHandler;
    }
    return nil;
}

/**
 Description 放入订阅的频道数组
 
 */
-(void)putinChannelWithArr:(NSArray<NSString *> *)channelArr
{
    for (NSString * name in channelArr)
    {
        [self putinChannelWithChannelName:name];
    }
}
/**
 Description 放入频道
 
 */
-(void)putinChannelWithChannelName:(NSString *)channelName
{
    [_EDDataHouse.EDChannelNameSet addObject:channelName];
}

-(void)removeChannelWithArr:(NSArray<NSString *> *)channelArr
{
    if (channelArr.count)
    {
        for (NSString * channelname in channelArr)
        {
            [self removeChannelWithChannelName:channelname];
        }
    }
}

-(void)removeChannelWithChannelName:(NSString *)channelName
{
    if (channelName.length)
    {
        [_EDDataHouse.EDChannelNameSet removeObject:channelName];
    }
}
-(void)setEDHeartTime:(NSInteger)EDHeartTime
{
    if (_EDDataHouse)
    {
        _EDDataHouse.EDHeartTime =EDHeartTime;
    }
}

-(NSInteger )EDHeartTime
{
    if (_EDDataHouse)
    {
        return  _EDDataHouse.EDHeartTime;
    }
    return 0;
}

-(void)removeOberServer
{
    if (_EDDataHouse)
    {
        [_EDDataHouse removeOberServer];
    }
}
-(void)registerOberServer:(void (^)(NSString *message))subscribeMessage
{
    if (_EDDataHouse)
    {
       
        [_EDDataHouse registerOberServer:subscribeMessage];
    }
}

-(void)endWork
{
    if (_EDDataHouse)
    {
        [_EDDataHouse resetDataHouse];
    }
}
////////////////////////////////////////////////////////
/*
 new      : ADD
 time     : 2017.4.21  11:15
 modifier : 康晓光
 version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
 problem  : 大课件redis验证权限处理
 describe : 对redis 进行一次认证，并返回结果
 */
-(void)reportProblem:(id<ETTRedisWorkerInterface>)worker withFault:(ObjCHiredis *)redis withError:(NSError *)err withHandle:(ErrorMaintenanceBlock)block
{
    if (err == nil || redis == nil || worker == nil)
    {
        return;
    }
    
    if (_EDManager)
    {
        ETTErrorMaintenanceState  state  = [[_EDManager callRedisRedisMaintenanceHelp] redisMaintenance:err withReids:redis];
        switch (state)
        {
                
            case ETTERRORMAINTENANCESUCESS:
            {
                if (block)
                {
                    block(ETTERRORMAINTENANCESUCESS);
                    
                }
            }
                break;
            case ETTERRORMAINTENANCEBUSY:
            {
                if (block)
                {
                    block(state);
                    
                }
            }
                break;
            case ETTERRORMAINTENANCEFAILT:
            {
                if (block)
                {
                    block(state);
                    
                }
                [_EDManager manageWorkerReportAuthFail:self];
            }
                break;
            default:
                break;
        }
        
    }
}

-(void)dataWarehousing:(id)info
{
    @synchronized (self)
    {
        if (info == nil)
        {
            return;
        }
        if (![info isKindOfClass:[NSArray class]])
        {
            
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray * result = info;
            NSString* command = result[0];
            if( [command isEqualToString:@"message"] )
            {
                if (_EDDataHouse)
                {
                    [_EDDataHouse dataWarehousing: result[2]];
                }
                NSDictionary* info = @{@"channel": result[1], @"message": result[2]};
                [[NSNotificationCenter defaultCenter] postNotificationName:ETTCocoaRedisMessageNotification  object:nil userInfo:info];
                
                
                if (_EDManager )
                {
                    [_EDManager DeliveryChannelData:result[2]];
                }
            }
        });
    }
    
}
@end
