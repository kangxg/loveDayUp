//
//  ETTRedisMaintenanceWorker.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRedisMaintenanceWorker.h"
#import "ETTRedisErrorHelper.h"
@interface ETTRedisMaintenanceWorker()
@property (readwrite, nonatomic, strong) dispatch_semaphore_t        MDSignal;
@property (nonatomic,assign)ETTRedisMaintenanceRecord   MDRecord;

@end

@implementation ETTRedisMaintenanceWorker
-(id)init:(id<ETTRedisDataHouseManageInterface>)dataHouseManager employers:(id<ETTRedisWorkerManageInterface>)employers
{
    if (self = [super init:dataHouseManager employers:employers])
    {
        _MDSignal = dispatch_semaphore_create(1);
        _MDRecord = ETTRedisMaintenanceRecordMake(false, 5,0,ETTERRORMAINTENANCENONE);
    }
    return self;
}
-(ETTErrorMaintenanceState)redisMaintenance:(NSError *)error withReids:(ObjCHiredis *)redis
{
    ETTErrorMaintenanceState  state = ETTERRORMAINTENANCENONE;
    if (error == nil)
    {
        return state;
    }
    
    if (error.code == ETTREDISERRORTYPENOAUTH )
    {
         NSInteger  nowTime = [[NSDate date]timeIntervalSince1970]/60;
         NSInteger   distance = nowTime - _MDRecord.lastMainten;
        if (distance <5 && _MDRecord.lastMainten)
        {
            if (_MDRecord.state == ETTERRORMAINTENANCESUCESS )
            {
                state = ETTERRORMAINTENANCESUCESS;
            }
            else
            {
                 state = ETTERRORMAINTENANCEBUSY;
            }
            return state;
        }

        dispatch_semaphore_wait(_MDSignal, _MDRecord.maxInterval);
        
        if ([self  redisAuth:redis])
        {
            state =  ETTERRORMAINTENANCESUCESS;
        }
        else
        {
            state =  ETTERRORMAINTENANCEFAILT;
           
        }
       
        _MDRecord = ETTRedisMaintenanceRecordMake(false, _MDRecord.maxInterval,nowTime,state);
        dispatch_semaphore_signal(_MDSignal);
    }
    
    return state;

}


-(BOOL)redisAuth:(ObjCHiredis *)redis
{
    if (self.EDWarehouse == nil || redis ==nil)
    {
        return false;
    }
    _MDRecord.maintenancing = YES;

    id reselt = [redis command:[NSString stringWithFormat:@"AUTH %@",[self.EDWarehouse getWorkPassword]]];
    NSError * err = [ETTRedisErrorHelper redisSetErrorHelp:reselt];
    if (err)
    {
        return false;
    }
    return YES;
}
@end
