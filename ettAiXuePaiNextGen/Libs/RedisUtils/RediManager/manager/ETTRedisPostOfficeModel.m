
//
//  ETTRedisPostOfficeModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRedisPostOfficeModel.h"
#import "ETTRedisPostOfficeQueue.h"
#import "ETTRedisChannelOperation.h"
#import "ETTOperationDelegate.h"

#import "ETTRedisErrorHelper.h"
@interface ETTRedisPostOfficeModel()<ETTOperationDelegate>
{
    ETTRedisChannelReplyQueue         *  _mReplyQueue;
    ETTReidsReplayRunLoop             *  _mReplyOperation;
}
@property(nonatomic,retain)ETTRedisChannelReplyQueue         * MDRedisChannelReplyQueue;
@property (nonatomic,retain)ETTReidsReplayRunLoop            * MDReplyOperation;

@property (nonatomic,retain)dispatch_semaphore_t  MDRefSemaphore;
@end

@implementation ETTRedisPostOfficeModel
@synthesize MDRedisChannelReplyQueue = _mReplyQueue;
@synthesize MDReplyOperation         = _mReplyOperation;
-(id)init:(id<ETTRedisDataHouseManageInterface>)dataHouseManager employers:(id<ETTRedisWorkerManageInterface>)employers
{
    if (self = [super init:dataHouseManager employers:employers])
    {
        
    }
    return self;
}

-(void)initData
{
    [super initData];
    _EDChannelNames = [[NSMutableArray alloc]init];
}

-(ETTRedisChannelReplyQueue *)MDRedisChannelReplyQueue
{
    if (_mReplyQueue == nil)
    {
        _mReplyQueue          = [[ETTRedisChannelReplyQueue alloc]init];
        _mReplyQueue.name     =  @"RedisChannelReplyQueue";
        _mReplyQueue.maxConcurrentOperationCount     = 3;
    }
    return _mReplyQueue;
}

-(void)endWorker
{
   [_EDChannelNames removeAllObjects];
   [self stopRedisStateBroadcast];
    [self removeNotify];
}
-(void)initLiveStateBroadcastOperationQueue

{
    
    if (self.EDWarehouse.EDChannelRedis == nil)
    {
        return;
    }
  
    
    dispatch_queue_t queue = dispatch_queue_create("ett", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
                  [self stopRedisStateBroadcast];
        
        _mReplyOperation = [[ETTReidsReplayRunLoop alloc]initWithInterval:0.1 withDelegate:self withDataManager:self.EDWarehouse];

        [self.MDRedisChannelReplyQueue addOperation:_mReplyOperation];
        
    });
   
}
-(void)reginNotify
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveRedisChannelNotifyMsg:) name:ETTReciveRedisChannelMsg object:nil];
}

-(void)removeNotify
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

-(void)stopRedisStateBroadcast
{
    
    if (_mReplyOperation)
    {
        [_mReplyOperation stop];
        [_mReplyOperation cancel];
        _mReplyOperation = nil;
    }
    if (_mReplyQueue)
    {
        
        for (ETTReidsReplayRunLoop * op in _mReplyQueue.operations)
        {
            [op stop];
            [op cancel];
        }
        [_mReplyQueue cancelAllOperations];
        _mReplyQueue = nil;
       
        
    }
    
    
    
}
-(void)registeredChannelPublishMessages:(NSArray  *)channelNames  respondHandler:(RespondHandler)respondHandler
{
    if (channelNames)
    {
        [_EDChannelNames removeAllObjects];
        [_EDChannelNames addObjectsFromArray:channelNames];
       
    }
}


-(void)registeredCPublishMessage:(NSString  *)channelName  respondHandler:(RespondHandler)respondHandler
{
    if (channelName)
    {
        if (![_EDChannelNames containsObject:channelName])
        {
            [_EDChannelNames addObject:channelName];
        }
    }
}


-(void)startsWorker
{
    if (self.EDEmployer == nil)
    {
        return;
    }
    [self reginNotify];
    [self initLiveStateBroadcastOperationQueue];
}


/**
 *  Description 轮询回调
 */
-(void)pRunLoopEntry:(NSOperation *)operation
{
    if (self.EDWarehouse.EDChannelRedis == nil)
    {
        return;
    }
   
   
    ETTReidsReplayRunLoop * replyWork = [[ETTReidsReplayRunLoop alloc]initWithInterval:5 withDelegate:self withDataManager:self.EDWarehouse];
    [self.MDRedisChannelReplyQueue addOperation:replyWork];
    
}

-(void)pRunLoopEntry:(NSOperation *)operation info:(id)info
{
    if (self.EDWarehouse.EDChannelRedis )
    {
        [self.EDWarehouse dataWarehousing:info];
    }
    
}

-(void)reciveRedisChannelNotifyMsg:(NSNotification *)notify
{
    if (self.EDWarehouse.EDChannelRedis )
    {
        ////////////////////////////////////////////////////////
        /*
         new      : Modify
         time     : 2017.4.21  11:34
         modifier : 康晓光
         version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
         branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
         problem  : 大课件redis验证权限处理
         describe : 对结果进行一次错误检查，如果没有错误则交由数据仓库处理
         */
        //[self.EDWarehouse dataWarehousing:notify.object];
        ////////////////////////////////////////////////////////
        NSError * err = [ETTRedisErrorHelper redisGetReplyErrorhelp:notify.object];
        if (err)
        {
            if (err.code ==ETTREDISERRORTYPENOAUTH)
            {
                [self.EDWarehouse reportProblem:self withFault:self.EDWarehouse.EDChannelRedis withError:err withHandle:^(ETTErrorMaintenanceState state) {
                    
                }];
            }
        }
        else
        {
            [self.EDWarehouse dataWarehousing:notify.object];
        }
    }


}


@end
