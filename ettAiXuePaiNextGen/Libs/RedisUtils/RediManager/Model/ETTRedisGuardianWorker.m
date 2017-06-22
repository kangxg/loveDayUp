//
//  ETTRedisGuardianWorker.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisGuardianWorker.h"


#import "ETTReachability.h"
#import "EttRunLoopTimerOperation.h"

@interface ETTRedisGuardianWorker()<ETTOperationDelegate>
{
    ETTRunLoopTimerOperation * _mTimerOperation;
    NSOperationQueue         * _mOperationQueue;
    
}
@property (nonatomic,copy)NSString           *  MDChannelName;
@property (nonatomic,retain)NSTimer          *  MDTimer;
@property (nonatomic,assign)NSInteger           MDFailTimerCount;

@property (nonatomic,retain)NSOperationQueue *  MDOperationQueue;

@property (nonatomic,retain)dispatch_semaphore_t  MDRefSemaphore;

@end
@implementation ETTRedisGuardianWorker
@synthesize MDOperationQueue  = _mOperationQueue;
-(void)initData
{
    [super initData];
    _MDFailTimerCount = 0;
    self.EDWarehouse.EDHeartTime  = kREDIS_HEARTBEAT_TIME;
    _MDRefSemaphore = dispatch_semaphore_create(1);
}
-(void)suspensionWork
{
    if (_mOperationQueue)
    {
        [_mOperationQueue setSuspended:YES];
    }
}

-(void)restorework
{
    if (_mOperationQueue)
    {
        [_mOperationQueue setSuspended:false];
    }
}
-(void)endWorker
{
    [super endWorker];
    [self stopRedisStateBroadcast];
    _MDFailTimerCount = 0;
    
}
-(NSOperationQueue *)MDOperationQueue
{
    if (_mOperationQueue == nil)
    {
        _mOperationQueue      = [[NSOperationQueue alloc]init];
        _mOperationQueue.name = @"AuxiliaryQueue";
        _mOperationQueue.maxConcurrentOperationCount = 1;
    }
    
    return _mOperationQueue;
}
-(void)initLiveStateBroadcastOperationQueue
{
    [self stopRedisStateBroadcast];
    if (_mTimerOperation == nil)
    {
        _mTimerOperation = [[ETTRunLoopTimerOperation alloc]initWithInterval:kREDIS_HEARTBEAT_TIME withDelegate:self];
        _mTimerOperation.name = @"ownerStateRequestQueue";
        [self.MDOperationQueue addOperation:_mTimerOperation];
    }
    
}
-(void)stopRedisStateBroadcast
{
    if (_mTimerOperation)
    {
        [_mTimerOperation stop];
        [_mOperationQueue cancelAllOperations];
        _mOperationQueue = nil;
        _mTimerOperation = nil;
        
    }
    
}
-(void)PauseTimer
{
    [_MDTimer setFireDate:[NSDate distantFuture]];
}

-(void)startTime
{
    _MDFailTimerCount = 0;
    [_MDTimer setFireDate:[NSDate date]];
}

-(void)stopTimer
{
    [_MDTimer invalidate];
}

-(void)runTaskTimer
{
    dispatch_queue_t queue = dispatch_queue_create("etttimer", DISPATCH_QUEUE_SERIAL);
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kREDIS_HEARTBEAT_TIME * NSEC_PER_SEC)), queue, ^{
        _MDFailTimerCount  += kREDIS_HEARTBEAT_TIME;
        if (_MDFailTimerCount>kREDIS_CONVOY_TIME)
        {
            if (weakSelf.EDEmployer )
            {
                _MDFailTimerCount = 0;
                [weakSelf            stopRedisStateBroadcast];
                [weakSelf.EDEmployer manageGuardWorkerConnectionTimeout:weakSelf];
                
            }
            return ;
        }
        else
        {
            [weakSelf runTaskTimer];
        }
        
    });
    
}


-(void)startsWorker
{
    if (self.EDEmployer == nil)
    {
        return;
    }
    
    [self guardChannelSubscribeWorkSuccess];
    
}

-(void)guardChannelSubscribeWorkFail
{
    if (self.EDEmployer)
    {
        [self.EDEmployer manageGuardWorkerPublishMessageToChannelFail:self];
    }
    
}
-(void)guardChannelSubscribeWorkSuccess
{
    dispatch_semaphore_signal(_MDRefSemaphore);
    [self initLiveStateBroadcastOperationQueue];
}
/**
 *  Description 轮询回调
 */
-(void)pRunLoopEntry:(NSOperation *)operation
{
    
    [self pushHeartMessage:_MDChannelName];
    
}
-(void)pRunloopTimeout:(NSOperation *)operation
{
    
    [self  stopRedisStateBroadcast];
    if (self.EDEmployer)
    {
        [self.EDEmployer manageGuardWorkerConnectionTimeout:self];
        
    }
}
-(void)pushHeartMessage:(NSString *)escortName
{
    
    
    
    if (self.EDWarehouse.EDCocoaRedis == nil )
    {
        return;
    }
    
    dispatch_semaphore_wait(_MDRefSemaphore, DISPATCH_TIME_FOREVER);
    BOOL timeout = [self.EDWarehouse.EDCocoaRedis timesOut];
    if (timeout)
    {
        [self  stopRedisStateBroadcast];
        if (self.EDEmployer)
        {
            [self.EDEmployer manageGuardWorkerConnectionTimeout:self];
            
        }
        
    }
    else
    {
        WS(weakSelf);
        NSInteger heartTime = weakSelf.EDWarehouse.EDHeartTime;
        heartTime %= 10000;
        weakSelf.EDWarehouse.EDHeartTime = heartTime;
        [weakSelf.EDEmployer manageGuardWorkerConnectionWakeup:self];
        dispatch_semaphore_signal(_MDRefSemaphore);
    }
}

-(void)resetRunlooptime
{
    if (_mTimerOperation)
    {
        [_mTimerOperation taskeSuccess];
    }
}
-(BOOL)getAllowToOperation
{
    if (self.EDWarehouse.EDCocoaRedis == nil)
    {
        return false;
    }
    else
    {
        return YES;
    }
}
@end
