//
//  ETTCommandInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//



#import <Foundation/Foundation.h>

#import "ETTPerformEntityInterface.h"


@protocol ETTCommandInterface <NSObject>
@optional
//@property (nonatomic,retain,readonly)
@property (nonatomic,assign)ETTCommandType         EDCommandType;
@property (nonatomic,assign)ETTTaskOperationState  EDCommandState;
@property (nonatomic,weak)id<ETTCommandInterface>  EDCommandManager;

@property (nonatomic,retain)id<ETTCommandInterface>  EDMembershipCommand;
@property (nonatomic,weak)id<ETTPerformEntityInterface> EDEntity;


-(void)runningStateCommand:(id<ETTCommandInterface>)command;


-(void)excuteCommand;

-(void)commandComplete:(id<ETTCommandInterface>)command;

-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity;

-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state;

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state;;

-(void)commandComplete;
/**
 Description  向命令管理返回

 @param task  命令体
 */
-(void)commandFeedbackSteps:(id<ETTCommandInterface>)task;
@end


