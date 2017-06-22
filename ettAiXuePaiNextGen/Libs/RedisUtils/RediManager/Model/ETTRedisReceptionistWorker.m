//
//  ETTRedisReceptionistWorker.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisReceptionistWorker.h"
#import "ETTRedisHeader.h"
#import "ETTRedisErrorHelper.h"
@implementation ETTRedisReceptionistWorker
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler
{
 
//    if ([[NSThread currentThread] isMainThread])
//    {
//        [self redisAsyHMSET:key dictionary:dict respondHandler:respondHandler];
//    }
//    else
//    {
//        [self redisSyHMSET:key dictionary:dict respondHandler:respondHandler];
//    }
//    
      [self redisSyHMSET:key dictionary:dict respondHandler:respondHandler];

}


-(void)redisSyHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler
{
    if (self.EDWarehouse.EDCocoaRedis == nil )
    {
        return;
    }
    NSMutableArray* args = [NSMutableArray arrayWithObjects: @"HMSET", key, nil];
    
    for( id skey in dict ) {
        [args addObject: skey];
        [args addObject: dict[skey]];
    }
    id value= [self.EDWarehouse.EDCocoaRedis commandArgv:args];
    NSError * err = [ETTRedisErrorHelper redisHMSetErrorHelp:value];
    if (err)
    {
        WS(weakSelf);
        [self.EDWarehouse reportProblem:self withFault:self.EDWarehouse.EDCocoaRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
            if (state == ETTERRORMAINTENANCESUCESS)
            {
                [weakSelf redisSet:key value:value respondHandler:respondHandler];
            }
            
        }];
        
        if (respondHandler)
        {
            respondHandler(nil,err);
        }
        
    }
    else
    {
        
        if (respondHandler)
        {
            respondHandler(value,nil);
        }
        
        
    }
}

-(void)redisAsyHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler
{
    dispatch_queue_t queue = dispatch_queue_create("ettRecHMSET", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self redisSyHMSET:key dictionary:dict respondHandler:respondHandler];
    });
}
-(void)redisGet:(id)key respondHandler:(RespondHandler)respondHandler
{
 
    
//    if ([[NSThread currentThread] isMainThread])
//    {
//        [self redisAsyGet:key respondHandler:respondHandler];
//    }
//    else
//    {
//        [self redisSyGet:key respondHandler:respondHandler];
//    }
 [self redisSyGet:key respondHandler:respondHandler];

    

}
-(void)redisSyGet:(id)key respondHandler:(RespondHandler)respondHandler
{
    if (self.EDWarehouse.EDCocoaRedis == nil )
    {
        NSError * err = [[NSError alloc]initWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPEREDISNULL userInfo:nil];
        respondHandler(nil,err);
        return;
    }
    
    
    WS(weakSelf);
    BOOL isThere = [self redisCheckKeywhetherThere:key];
    if (isThere == false)
    {

        
        if (respondHandler)
        {
            NSError * err = [NSError errorWithDomain:ETTRedisCommondGetError code:ETTREDISERRORTYPEGETWITHNOKEY userInfo:nil];
            respondHandler(nil,err);
            
        }
    }
    else
    {
        id value = [self.EDWarehouse.EDCocoaRedis commandArgv:@[@"GET", key]];
        NSError * err = [ETTRedisErrorHelper redisHMSetErrorHelp:value];
        if (err)
        {
            [weakSelf.EDWarehouse reportProblem:self withFault:weakSelf.EDWarehouse.EDCocoaRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
                if (state == ETTERRORMAINTENANCESUCESS)
                {
                    [weakSelf redisGet:key respondHandler:respondHandler];
                }
            }];
            
            if (respondHandler)
            {
                respondHandler(nil,err);
            }
            
        }
        else
        {
            
            if (respondHandler)
            {
                respondHandler(value,nil);
            }
            
        }
        
        
    }

}

-(void)redisAsyGet:(id)key respondHandler:(RespondHandler)respondHandler
{
    dispatch_queue_t queue = dispatch_queue_create("ettRecGet", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self redisSyGet:key respondHandler:respondHandler];
    });
}

////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.3.23  14:00
 modifier : 康晓光
 version  ：AIXUEPAIOS-924
 branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
 describe : 师端奖励后学生端没有出现奖励数值的变化
 operation: 对要获取的key是否存在进行判断
 */
-(BOOL)redisCheckKeywhetherThere:(NSString *)key
{
    if(key)
    {
        id value = [self.EDWarehouse.EDCocoaRedis commandArgv:@[@"EXISTS", key]];
        if ([value boolValue])
        {
            return YES;
        }
    }
    return false;
}

////////////////////////////////////////////////////////
-(void)redisSet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{

//    if ([[NSThread currentThread] isMainThread])
//    {
//        [self redisAsySet:key value:value respondHandler:respondHandler];
//        
//    }
//    else
//    {
//        [self redisSySet:key value:value respondHandler:respondHandler];
//
//    }
    
    [self redisSySet:key value:value respondHandler:respondHandler];



}

-(void)redisSySet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{
    if (self.EDWarehouse.EDCocoaRedis == nil )
    {
        return;
    }
    WS(weakSelf);
    NSMutableArray * commArr = [NSMutableArray array];
    [commArr addObject:@"SET"];
    [commArr addObject:key];
    [commArr addObject:value];
    id result = [self.EDWarehouse.EDCocoaRedis commandArgv:commArr];
    
    NSError * err = [ETTRedisErrorHelper redisSetErrorHelp:result];
    //[NSError errorWithDomain:ETTRedisCommondSetError code:ETTREDISERRORTYPENOAUTH userInfo:nil];
    //
    if (err)
    {
        [self.EDWarehouse reportProblem:self withFault:self.EDWarehouse.EDCocoaRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
            if (state == ETTERRORMAINTENANCESUCESS)
            {
                [weakSelf redisSet:key value:value respondHandler:respondHandler];
            }
        }];
        
        
        if (respondHandler)
        {
            respondHandler(nil,err);
        }
        
        
    }
    else
    {
        
        if (respondHandler)
        {
            respondHandler(value,nil);
        }
        
    }
}

-(void)redisAsySet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{
    dispatch_queue_t queue = dispatch_queue_create("ettReceptionSET", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self redisSySet:key value:value respondHandler:respondHandler];
    });
    
}
-(void)redisHGETALL:(id)key respondHandler:(RespondHandler)respondHandler
{

//    if ([[NSThread currentThread] isMainThread])
//    {
//        [self redisAsyHGETALL:key respondHandler:respondHandler];
//    }
//    else
//    {
//        [self redisSyHGETALL:key respondHandler:respondHandler];
//    }
    
    [self redisSyHGETALL:key respondHandler:respondHandler];
    
}
-(void)redisSyHGETALL:(id)key respondHandler:(RespondHandler)respondHandler
{
    if (self.EDWarehouse.EDCocoaRedis == nil )
    {
        return;
    }
    
    id value = [self.EDWarehouse.EDCocoaRedis commandArgv:@[@"HGETALL", key]];
    NSError * err = [ETTRedisErrorHelper redisHMSetErrorHelp:value];
    
    if (err)
    {
        WS(weakSelf);
        [self.EDWarehouse reportProblem:self withFault:self.EDWarehouse.EDCocoaRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
            if (state == ETTERRORMAINTENANCESUCESS)
            {
                [weakSelf redisHGETALL:key respondHandler:respondHandler];
            }
        }];
        if (respondHandler)
        {
            respondHandler(nil,err);
        }
        
        
    }
    else
    {
    
        
        if (respondHandler)
        {
            respondHandler([self promiseNSDict:value],nil);
            
        }
        
        
        
    }

}

-(void)redisAsyHGETALL:(id)key respondHandler:(RespondHandler)respondHandler
{
    dispatch_queue_t queue = dispatch_queue_create("ettRecHGETALL", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self redisSyHGETALL:key respondHandler:respondHandler];
    });
}
-(void)redisHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler
{
 
      [self redisSyHGET:key field:field respondHandler:respondHandler];
//    if ([[NSThread currentThread] isMainThread])
//    {
//          [self redisAsyHGET:key field:field respondHandler:respondHandler];
//    }
//    else
//    {
//        [self redisSyHGET:key field:field respondHandler:respondHandler];
//      
//    }
    
}
-(void)redisSyHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler
{
    if (self.EDWarehouse.EDCocoaRedis == nil )
    {
        return;
    }
    id value = [self.EDWarehouse.EDCocoaRedis commandArgv:@[@"HGET", key, field]];
    NSError * err = [ETTRedisErrorHelper redisHGetErrorHelp:value];
    if (err)
    {
        WS(weakSelf);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //                    });
        [self.EDWarehouse reportProblem:self withFault:self.EDWarehouse.EDCocoaRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
            if (state == ETTERRORMAINTENANCESUCESS)
            {
                [weakSelf redisHGET:key field:field respondHandler:respondHandler];
                
            }
        }];
        if (respondHandler)
        {
            respondHandler(nil,err);
        }
        
        
        
    }
    else
    {

        if (respondHandler)
        {
            respondHandler(value,nil);
        }
        
    }

}

-(void)redisAsyHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler
{
        dispatch_queue_t queue = dispatch_queue_create("ettRecHGET", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            [self redisSyHGET:key field:field respondHandler:respondHandler];
        });
}
-(void)publishMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler
{
//    if ([[NSThread currentThread] isMainThread])
//    {
//
//        [self publishAsyMessageToChannel:channelName message:message respondHandler:respondHandler];
//
//        
//    }
//    else
//    {
//       [self publishSyMessageToChannel:channelName message:message respondHandler:respondHandler];
//    }
     [self publishSyMessageToChannel:channelName message:message respondHandler:respondHandler];
}
-(void)publishSyMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler
{
    if (self.EDWarehouse.EDCocoaRedis)
    {
        NSMutableArray *commArr = [NSMutableArray array];
        [commArr addObject:@"PUBLISH"];
        [commArr addObject:channelName];
        [commArr addObject:message];
        id returnData = [self.EDWarehouse.EDCocoaRedis  commandArgv:commArr];
        NSError * err = [ETTRedisErrorHelper redisPushChannelErrorHelp:returnData];
        if (err)
        {
            WS(weakSelf);

            if (respondHandler)
            {
                respondHandler(nil,err);
            }
            [self.EDWarehouse reportProblem:self withFault:self.EDWarehouse.EDCocoaRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
                if (state == ETTERRORMAINTENANCESUCESS)
                {
                    [weakSelf publishMessageToChannel:channelName message:message respondHandler:respondHandler];
                    
                }
            }];
            
        }
        else
        {

            if (respondHandler)
            {
                respondHandler(returnData,nil);
            }
            
        }
    }
}

-(void)publishAsyMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler
{
     dispatch_queue_t queue = dispatch_queue_create("ettRecPUBLISH", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self publishSyMessageToChannel:channelName message:message respondHandler:respondHandler];
    });
}

@end
