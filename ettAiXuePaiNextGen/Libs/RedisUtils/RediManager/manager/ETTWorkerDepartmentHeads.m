//
//  ETTWorkerDepartmentHeads.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTWorkerDepartmentHeads.h"

@implementation ETTWorkerDepartmentHeads
@synthesize EDWorkerArr = _EDWorkerArr;
-(id)init:(id<ETTRedisDataHouseManageInterface>)dataHouseManager employers:(id<ETTRedisWorkerManageInterface>)employers
{
    if (self = [super init:dataHouseManager employers:employers])
    {
        _EDWorkerArr = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_EDWorkerArr forKey:@"Workers"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
     if (self =[super init]) {
         self.EDWorkerArr=[aDecoder decodeObjectForKey:@"Workers"];
     }
    return self;
}
-(void)removeWorker:(id)key
{
    ETTContinuousOperationWorker  * tempworker  = [self haveWorkerWithTask:key];

    if (tempworker)
    {
        [tempworker workComplete];
        [self.EDWorkerArr removeObject:tempworker];
        return;
        
    }

    
}

-(BOOL)setWorkerTask:(id)key withInfo:(NSDictionary *)dict
{
    ETTContinuousOperationWorker  * tempworker  = [self haveWorkerWithTask:key];
    if (tempworker)
    {
        
         tempworker.EDWorkInfoDic = dict;
         return YES;
    }
   
    
    return false;
}

-(ETTContinuousOperationWorker *)haveWorkerWithTask:(id)key
{
       for (ETTContinuousOperationWorker  * worker in self.EDWorkerArr)
    {
        
        if ([worker.EDOperationKey isEqualToString:key])
        {
         
            return worker;
        }
    }
    return nil;
}
-(ETTContinuousOperationWorker *)haveWorkerWithTask:(id)key withField:(NSString *)Feild
{
    return nil;
}

-(void)hangWorkersTask
{

}

-(void)wakeupWorkersTask
{
    for (ETTContinuousOperationWorker  * worker in self.EDWorkerArr)
    {
        [worker wakeupWorkerTask];
        
    }
}
-(void)resurrectionWorkers:(RespondHandler)respondHandler
{
    
}

-(void)removeRedisWorker:(id)key
{
    [self removeWorker:key];
}
-(void)removeRedisWorker:(id)key withFeile:(id)field
{
    
}


-(void)endWorker
{
    [super endWorker];
    [self.EDWorkerArr removeAllObjects];
}
@end

#pragma mark
#pragma mark ---------------------- 连续设置部门领导    ------------------------
@implementation ETTContinuousSettingHeads
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{

    [self removeWorker:key];
    ETTContinuousSettingWorker  * worker = [[ETTContinuousSettingWorker  alloc]init:self.EDWarehouse employers:self.EDEmployer];
    [self.EDWorkerArr addObject:worker];
    [worker redisHMSET:key dictionary:dict type:type intervals:time respondHandler:respondHandler];
    
}

-(void)resurrectionWorkers:(RespondHandler)respondHandler
{
    for (ETTContinuousSettingWorker   * worker in self.EDWorkerArr)
    {
        [worker resetEmployer:self.EDEmployer];
        [worker resetHouseManager:self.EDWarehouse];
        [worker redisHMSETesurrection:respondHandler];
    }
}


@end

#pragma mark
#pragma mark ---------------------- 连续获取所有 部门领导 -----------------------
@implementation ETTContinuousGetALLHeads
-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    [self removeWorker:key];
    
    ETTContinuousGetALLWorker  * worker = [[ETTContinuousGetALLWorker  alloc]init:self.EDWarehouse employers:self.EDEmployer];
    [self.EDWorkerArr addObject:worker];
    
    [worker redisHGETALL:key intervals:time respondHandler:respondHandler];

}
-(void)resurrectionWorkers:(RespondHandler)respondHandler
{
    for (ETTContinuousGetALLWorker    * worker in self.EDWorkerArr)
    {
        [worker resetEmployer:self.EDEmployer];
        [worker resetHouseManager:self.EDWarehouse];
        [worker redisHGETALLTesurrection:respondHandler];
    }
}
@end

#pragma mark
#pragma mark ---------------------- 连续获取 单个 部门领导 ------------------------
@implementation ETTContinuousGetSingleHeads
-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    [self removeWorker:key andField:field];
    ETTContinuousGetSingleWorker  * worker = [[ETTContinuousGetSingleWorker  alloc]init:self.EDWarehouse employers:self.EDEmployer];
    [self.EDWorkerArr addObject:worker];
    [worker redisHGET:key field:field intervals:time respondHandler:respondHandler];

}
-(void)resurrectionWorkers:(RespondHandler)respondHandler
{
    for (ETTContinuousGetSingleWorker    * worker in self.EDWorkerArr)
    {
        [worker resetEmployer:self.EDEmployer];
        [worker resetHouseManager:self.EDWarehouse];
        [worker redisHGETTesurrection:respondHandler];
    }
}

-(void)removeWorker:(id)key andField:(id)field
{
    ETTContinuousOperationWorker  * tempworker  = nil;
    for (ETTContinuousSettingWorker  * worker in self.EDWorkerArr)
    {
        if ([worker.EDOperationKey isEqualToString:key] && [worker.EDField isEqualToString:field])
        {
            [worker workComplete];
            [self.EDWorkerArr removeObject:worker];
            
        }
    }
    
    if (tempworker)
    {
        [tempworker workComplete];
        [self.EDWorkerArr removeObject:tempworker];
 
        
    }
}
-(void)removeRedisWorker:(id)key withFeile:(id)field
{
    [self removeWorker:key andField:field];
//    [self removeRedisWorker:key withFeile:field];
}

@end



#pragma mark
#pragma mark ---------------------- 连续向频道推送消息 ------------------------
@implementation  ETTContinuousSendChannelMsgHeads
-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    [self removeWorker:channelName];
    ETTContinuousPushChannelWorker  * worker = [[ ETTContinuousPushChannelWorker  alloc]init:self.EDWarehouse employers:self.EDEmployer];
    [self.EDWorkerArr addObject:worker];
    [worker channelPublishMessage:channelName message:message intervalTime:time respondHandler:respondHandler];
}

-(void)resurrectionWorkers:(RespondHandler)respondHandler
{
    for (ETTContinuousPushChannelWorker   * worker in self.EDWorkerArr)
    {
        [worker resetEmployer:self.EDEmployer];
        [worker resetHouseManager:self.EDWarehouse];
        [worker redisPushChannelTesurrection:respondHandler];
    }
}



@end

