//
//  EttRunLoopTimerOperation.m
//  ETTRedisDemo
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 16/8/2.
//  Copyright © 2016年 zhaiyingwei. All rights reserved.
//

#import "EttRunLoopTimerOperation.h"

@interface EttRunLoopTimerOperation ()
{
    NSTimer         *_mTimer;       //计时器
    NSTimeInterval   _mInterval;    //timer的间隔时间
    BOOL             _mUseTimer;    //是否使用timer
    
    id               _mTarget;      //委托对象
    NSString        *_mFunc_name;   //委托方法
    
    BOOL             _mFinished;
    BOOL             _mExecuting;
}

@end

@implementation EttRunLoopTimerOperation

-(instancetype)initWithInterval:(NSTimeInterval)interval useTimer:(BOOL)useTime withDelegate:(id<EttOperationDelegate>)delegate
{
    if (self = [super init]) {
        _mUseTimer      =   useTime;
        self.MDelegate  =   delegate;
        _mInterval      =   interval;
        
        _mFinished      =   NO;
        _mExecuting     =   NO;
    }
    return self;
}

-(instancetype)initWithInterval:(NSTimeInterval)interval useTimer:(BOOL)useTime addTarget:(id)target hookSelector:(NSString *)funcName
{
    if (self = [super init]) {
        _mInterval      =   interval;
        _mUseTimer      =   useTime;
        _mTarget        =   target;
        _mFunc_name     =   funcName;
        
        _mFinished      =   NO;
        _mExecuting     =   NO;
    }
    return  self;
}

-(void)main
{
    @autoreleasepool {
        if (![self isCancelled]) {
            _mExecuting = YES;
            NSRunLoop *_mRunLoop = [NSRunLoop currentRunLoop];
            NSDate *futureDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
            _mInterval = _mInterval>0?_mInterval:10.0;
            _mTimer=[[NSTimer alloc]initWithFireDate:futureDate interval:_mInterval target:self selector:@selector(selectorForTimer:) userInfo:nil repeats:YES];
            [_mRunLoop addTimer:_mTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
            [[NSRunLoop currentRunLoop]run];
        }
    }
}

-(void)selectorForTimer:(id)sender
{
    if (_mFunc_name) {
        SEL func_selector = NSSelectorFromString(_mFunc_name);
        if (_mTarget && [_mTarget respondsToSelector:func_selector]) {
            IMP imp = [_mTarget methodForSelector:func_selector];
            imp();
        }else{
            NSLog(@"target为nil或target没能实现selector!");
        }
    }else{
        if (self.MDelegate && [self.MDelegate respondsToSelector:@selector(pSelectorForTimer)]) {
            [self.MDelegate pSelectorForTimer];
        }else{
            NSLog(@"需要实现EttOperationDelegate协议的pSelectorForTimer方法!");
        }
    }
}

-(BOOL)begin
{
    if (_mTimer) {
        [_mTimer setFireDate:[NSDate distantPast]];
        [[NSRunLoop currentRunLoop]run];
        _mExecuting = YES;
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)stop
{
    if (_mTimer) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        [_mTimer setFireDate:[NSDate distantFuture]];
        _mExecuting = NO;
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)delegateTimer
{
    if (_mTimer) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        [_mTimer invalidate];
        _mTimer = nil;
        _mExecuting = NO;
        _mFinished = YES;
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isFinished
{
    return _mFinished;
}

-(BOOL)isExecuting
{
    return _mExecuting;
}

@end





































