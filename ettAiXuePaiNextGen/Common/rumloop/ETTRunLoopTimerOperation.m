//
//  ETTRunLoopTimerOperation.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRunLoopTimerOperation.h"
@interface ETTRunLoopTimerOperation()
{
    NSTimer         *   _mTimer;
    NSTimeInterval      _mInterval;
    NSInteger           _mTimeout;
    NSInteger           _mTimeCount;
}
@property (nonatomic,retain)NSTimer           *  EDTimer;
@end
@implementation ETTRunLoopTimerOperation
@synthesize EDTimer         = _mTimer;
-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate
{
    if (self = [super init])
    {
        self.EDDelegate = delegate;
        _mInterval = interval;
        _mTimeCount =  0;
        _mTimeout = 40;
         [self createTimer];
    }
    return self;
}

-(void)createTimer
{
    NSRunLoop * myRunloop = [NSRunLoop currentRunLoop];
    
    
    [myRunloop addTimer:self.EDTimer forMode:NSDefaultRunLoopMode];
    
}

-(NSTimer *)EDTimer
{
    if (_mTimer == nil)
    {
        NSDate * futureDate   = [NSDate dateWithTimeIntervalSinceNow:0.0];
        
        _mTimer     = [[NSTimer alloc]initWithFireDate:futureDate interval:_mInterval target:self selector:@selector(myDoFireTime:) userInfo:nil repeats:YES];
        
        
    }
    return _mTimer;
}
-(void)main
{
    @autoreleasepool
    {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
         
                                 beforeDate: [NSDate distantFuture]];
        
    }
}

-(void)stop
{
    if (_mTimer)
    {
        [_mTimer invalidate];
        CFRunLoopStop(CFRunLoopGetCurrent());
        _mTimeout = 0;
        
    }
    
}
-(void)taskeSuccess
{
    _mTimeCount = 0;
}
-(void)myDoFireTime:(id)sender
{
    if (self.EDDelegate  && [self.EDDelegate respondsToSelector:@selector(pRunLoopEntry:)])
    {
       
     [self.EDDelegate pRunLoopEntry:self];
        
       
    }
    
}
@end
@interface ETTStuPerformanceRunLoop()
{
    NSTimer         *   _mTimer;
    NSTimeInterval      _mInterval;
 
}
@end
@implementation  ETTStuPerformanceRunLoop

-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate
{
    if (self = [super init])
    {
        self.EDDelegate = delegate;
        _mInterval = interval;
     
    }
    return self;
}

-(void)main
{
    @autoreleasepool
    {
        NSRunLoop * myRunloop = [NSRunLoop currentRunLoop];
        NSDate * futureDate   = [NSDate dateWithTimeIntervalSinceNow:0.0];
        _mInterval = _mInterval>0?_mInterval:5;
        _mTimer     = [[NSTimer alloc]initWithFireDate:futureDate interval:_mInterval target:self selector:@selector(myDoFireTime:) userInfo:nil repeats:YES];
        [myRunloop addTimer:_mTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
         
                                 beforeDate: [NSDate distantFuture]];
        
    }
}

-(void)stop
{
    if (_mTimer)
    {
        [_mTimer invalidate];
        CFRunLoopStop(CFRunLoopGetCurrent());
        
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

