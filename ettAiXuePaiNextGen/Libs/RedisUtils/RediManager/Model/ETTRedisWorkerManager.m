//
//  ETTRedisWorkerManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerManager.h"

@implementation ETTRedisWorkerManager
-(void)manageWorkWillBegain:(ETTRedisWorkerModel *)worker
{
    
}

-(void)manageWorkConnectSuccess:(ETTRedisWorkerModel *)worker
{
    
}
-(void)manageWorkRegAuthPwdWillBegain:(ETTRedisWorkerModel *)worker
{
    
}
-(void)manageWorkRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker
{
    
}

/**
 Description 连接任务redis密码验证成功
 
 @param object 工作者
 */
-(void)manageWorkConnectRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker
{
    
}


/**
 Description 频道连接 redis密码验证成功
 
 @param object 工作者
 */
-(void)manageWorkChannelConnectRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker
{
    
}
-(void)manageWorkConnectFinished:(ETTRedisWorkerModel *)worker error:( NSError *)err
{
    
}
-(void)manageWorkChannelConnectFinished:(ETTRedisWorkerModel *)worker error:(NSError *)err
{
}
-(void)manageWorkConnectFail:(ETTRedisWorkerModel *)worker error:( NSError *)err
{
    
}

-(void)manageWorkerHandove:(ETTRedisWorkerModel *)OnDuty succession:(ETTRedisWorkerModel *)succession
{

}

-(void)manageGuardWorkerReceivingSubcribtion:(ETTRedisWorkerModel *)worker withChannel:(NSString *)channelName
{
    
}
-(void)manageGuardWorkerPublishMessageToChannelFail:(ETTRedisWorkerModel *)worker
{
    
}

-(void)manageGuardWorkerConnectionTimeout:(ETTRedisWorkerModel *)worker
{
    
}

-(void)manageGuardWorkerConnectionWakeup:(ETTRedisWorkerModel *)worker
{
    
}

-(BOOL)manageWorkerCanAllowedtowork:(ETTRedisWorkerModel *)worker
{
    return YES;
}
-(void)startsWorker
{
    
}
-(void)workAgain
{
    
}
@end
