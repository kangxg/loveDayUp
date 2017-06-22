//
//  ETTRedisChannelOperation.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRedisChannelOperation.h"
@interface  ETTRedisChannelOperation()
{
    NSTimer         *   _mTimer;
    NSTimeInterval      _mInterval;
    
}
@end


@implementation ETTRedisChannelOperation
@synthesize EDTimer         = _mTimer;
@synthesize EDTimerInterval = _mInterval;
-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate
{
    if (self = [super init])
    {
        self.EDDelegate = delegate;
         _mInterval = interval>0?interval:5;
        
        [self createTimer];
    }
    return self;
}

-(void)createTimer
{
    NSRunLoop * myRunloop = [NSRunLoop currentRunLoop];
    
    
    [myRunloop addTimer:self.EDTimer forMode:NSDefaultRunLoopMode];
    
}

-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate withDataManager:(id<ETTRedisDataHouseManageInterface>)dataHouseManager
{
    return [self initWithInterval:interval withDelegate:delegate];
}
-(void)myDoFireTime:(id)sender
{
    
}


-(void)stop
{
    if (_mTimer)
    {
        [_mTimer invalidate];
        CFRunLoopStop(CFRunLoopGetCurrent());
        _mTimer = 0;

    }

}
@end


@interface  ETTReidsChannelRunLoop()

@end

@implementation ETTReidsChannelRunLoop
-(void)main
{
    @autoreleasepool
    {
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
         
                                 beforeDate: [NSDate distantFuture]];
    }
}
-(void)myDoFireTime:(id)sender
{
    if (self.EDDelegate  && [self.EDDelegate respondsToSelector:@selector(pRunLoopEntry:)])
    {
        
        [self.EDDelegate pRunLoopEntry:self];
        
        
    }
}

@end


@interface  ETTReidsReplayRunLoop()
/**
 Description 数据仓库管理员
 */
@property (nonatomic,weak,readonly)id<ETTRedisDataHouseManageInterface>   EDWarehouse;

@end

@implementation ETTReidsReplayRunLoop
@synthesize EDWarehouse = _EDWarehouse;
-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate withDataManager:(id<ETTRedisDataHouseManageInterface>)dataHouseManager
{
    if (self = [self initWithInterval:interval withDelegate:delegate])
    {
        _EDWarehouse = dataHouseManager;
    }
    return self;
}

-(void)main
{
    @autoreleasepool
    {
        
        NSRunLoop * myRunloop = [NSRunLoop currentRunLoop];
        NSDate * futureDate   = [NSDate dateWithTimeIntervalSinceNow:0.0];
        
        self.EDTimer     = [[NSTimer alloc]initWithFireDate:futureDate interval:0.1 target:self selector:@selector(myDoFireTime:) userInfo:nil repeats:YES];
        [myRunloop addTimer:self.EDTimer forMode:NSDefaultRunLoopMode];
        
        if ([NSThread currentThread].isMainThread) {
            NSLog(@"%s %d",__FILE__,__LINE__);
            [self doesNotRecognizeSelector:_cmd];
        }else{
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]];
        }
    }
}
-(void)myDoFireTime:(id)sender
{
    
    if (_EDWarehouse.EDChannelRedis)
    {
        id result = [_EDWarehouse.EDChannelRedis getReply];
        //if (self.EDDelegate  && [self.EDDelegate respondsToSelector:@selector(pRunLoopEntry:info:)])
        //{
            
            //[self.EDDelegate pRunLoopEntry:self info:result];
            
        //}
        if (result)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ETTReciveRedisChannelMsg object:result];

        }
       
        
    }
  
}

-(void)createTimer
{
}


@end
