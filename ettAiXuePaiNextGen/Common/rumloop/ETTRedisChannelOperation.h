//
//  ETTRedisChannelOperation.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTBaseRunLoopOperation.h"
#import "ETTRedisDataHouseManageInterface.h"
@interface ETTRedisChannelOperation : ETTBaseRunLoopOperation
@property (nonatomic,retain)NSTimer           *  EDTimer;
@property (nonatomic,assign,readonly)NSTimeInterval      EDTimerInterval;
-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate ;

-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate withDataManager:(id<ETTRedisDataHouseManageInterface>)dataHouseManager ;

-(void)createTimer;

-(void)myDoFireTime:(id)sender;
@end


@interface ETTReidsChannelRunLoop: ETTRedisChannelOperation


@end


@interface ETTReidsReplayRunLoop: ETTRedisChannelOperation


@end
