//
//  ETTRedisChannelConnectWorker.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisChannelConnectWorker.h"
#import "ObjCHiredis.h"
@implementation ETTRedisChannelConnectWorker
-(void)startsWorker
{
    [self connectServer];
}
-(void)stopWorker
{
    [super workComplete];
}
-(void)workAgain
{
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self getSquare:kREDIS_CONVOY_TIME withTime:self.EDNumberOfLinks] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf connectServer];
        NSLog(@"第%d次链接!间隔%f秒!",0,[self getSquare:kREDIS_CONVOY_TIME withTime:0] );
        weakSelf.EDNumberOfLinks += 1;
        
    });
    
}
-(void)dealloc
{
    
}
-(void)connectServer
{
    if (self.EDEmployer == nil)
    {
        return;
    }
    if (self.EDWarehouse == nil)
    {
        return;
    }
    [self.EDEmployer manageWorkWillBegain:self];
    self.EDNumberOfLinks = 1;
    
    WS(weakSelf);
    
    NSString * host  = [self.EDWarehouse getWorkHost];
    int  port  = [self.EDWarehouse getWorkServerPort];
    ObjCHiredis * cocoProis =[ObjCHiredis redis:host on:[NSNumber numberWithInt:port] db:[NSNumber numberWithInt:0]];
    
    
    if (cocoProis)
    {
        [weakSelf.EDEmployer manageWorkConnectSuccess:weakSelf];
        
        [weakSelf.EDEmployer manageWorkRegAuthPwdWillBegain:weakSelf];
        id reselt = [cocoProis commandArgv:@[@"AUTH",[weakSelf.EDWarehouse getWorkPassword]]];
        
        if (reselt == nil)
        {
            NSError * err = [NSError errorWithDomain:@"fail" code:201 userInfo:nil];
            [weakSelf.EDEmployer manageWorkRegAuthPwdFail:weakSelf error:err];
            [weakSelf.EDEmployer manageWorkChannelConnectRegAuthPwdSuccess:weakSelf];
            [cocoProis close];
            
        }
        else
        {
            
            [weakSelf.EDWarehouse setEDChannelRedis:cocoProis];
            [weakSelf updateTimeWithCocoaRedis];
            [weakSelf.EDEmployer manageWorkChannelConnectRegAuthPwdSuccess:weakSelf];
            [weakSelf workTaskComplete];
            
        }
        
    }
    else
    {
        NSError * err = [NSError errorWithDomain:@"fail" code:101 userInfo:nil];
        [weakSelf.EDEmployer manageWorkConnectFail:weakSelf error:err];
        
    }
}

-(void)workTaskComplete
{
    if (self.EDEmployer)
    {
        [self.EDEmployer manageWorkConnectFinished:self error:nil];
    }
}
@end
