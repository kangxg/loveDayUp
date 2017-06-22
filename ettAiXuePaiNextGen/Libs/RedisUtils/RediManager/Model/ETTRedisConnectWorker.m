//
//  ETTRedisConnectWorker.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisConnectWorker.h"
#import "ObjCHiredis.h"


#import "ETTRedisChannelConnectWorker.h"
@implementation ETTRedisConnectWorker
-(void)startsWorker
{
    [self connectServer];
}
-(void)workAgain
{
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self getSquare:kREDIS_CONVOY_TIME withTime:self.EDNumberOfLinks] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf connectServer];
        NSLog(@"第%f次链接!间隔%f秒!",weakSelf.EDNumberOfLinks ,[self getSquare:kREDIS_CONVOY_TIME withTime:self.EDNumberOfLinks] );
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
    [self.EDEmployer manageWorkWillBegain:self];
    
    
    self.EDNumberOfLinks = 1;
    
    NSString * host  =  [self.EDWarehouse getWorkHost];
    int       port  =  [self.EDWarehouse getWorkServerPort];
    WS(weakSelf);
    ObjCHiredis * cocoProis =[ObjCHiredis redis:host on:[NSNumber numberWithInt:port] db:[NSNumber numberWithInt:0]];
    
    if (cocoProis)
    {
        [weakSelf.EDEmployer manageWorkConnectSuccess:weakSelf];
        
        [weakSelf.EDEmployer manageWorkRegAuthPwdWillBegain:weakSelf];
        id reselt =  [cocoProis command:[NSString stringWithFormat:@"AUTH %@",[weakSelf.EDWarehouse getWorkPassword]]];
        if (reselt == nil)
        {
            NSError * err = [NSError errorWithDomain:@"fail" code:201 userInfo:nil];
            [weakSelf.EDEmployer manageWorkRegAuthPwdFail:weakSelf error:err];
            [cocoProis close];
            
        }
        else
        {
            [weakSelf.EDWarehouse setEDCocoaRedis:cocoProis];
            [weakSelf updateTimeWithCocoaRedis];
            [weakSelf.EDEmployer manageWorkConnectSuccess:weakSelf];
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
        ETTRedisChannelConnectWorker * channelConnectWorker = [[ETTRedisChannelConnectWorker alloc]init:self.EDWarehouse employers:self.EDEmployer];
                [self.EDEmployer manageWorkerHandove:self succession:channelConnectWorker];
        
    }
}

@end
