//
//  ETTRestoreCommand.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRestoreCommand.h"
#import "ETTRestorePaperCommand.h"
#import "ETTRestoreRecessCommand.h"
#import "ETTRestoreWBCommand.h"
@implementation ETTRestoreCommand

@synthesize EDEntity            = _EDEntity;
@synthesize EDCommandManager    = _EDCommandManager;
@synthesize EDMembershipCommand = _EDMembershipCommand;
@synthesize EDListModel         = _EDListModel;
@synthesize EDCommandType       = _EDCommandType;
@synthesize EDCommandState      = _EDCommandState;
+(instancetype )createCommand:(id<ETTCommandInterface>)manager
          withEntity:(id<ETTPerformEntityInterface>)entity
            withlist:(ETTDisasterListingModel *)model
{
    if(model == nil)
    {
       return nil;
    }
    ETTRestoreCommand  *  command = nil;
    if ([model.EDDisasterType isEqualToString:@"CO_02"])
    {
        
       command =  [[ETTRestoreRecessFirstStepCommand alloc]init];
       [command init:manager withEntity:entity withlist:model];

    }
    else if ([model.EDDisasterType isEqualToString:@"CO_04"])
    {
        command =[[ETTRestorePaperFirstStepCommand alloc]init];
        [command init:manager withEntity:entity withlist:model];

    }
    else if ([model.EDDisasterType isEqualToString:@"WB_01"])
    {
        if ([[model.EDDisasterDic valueForKey:@"state"] integerValue] == 24)
        {
            command =[[ETTRestorePaperFirstStepCommand alloc]init];
            [command init:manager withEntity:entity withlist:model];
        }
        else
        {
            command = [[ETTRestoreWBFirstCommand alloc]init];
            [command init:manager withEntity:entity withlist:model];
        }
       
       
    }
    return command;
}


-(void)init:(id<ETTCommandInterface>)manager
          withEntity:(id<ETTPerformEntityInterface>)entity
            withlist:(ETTDisasterListingModel *)model
{
         
        
        _EDCommandManager = manager;
        _EDEntity = entity;
        _EDListModel = model;
        _EDCommandManager.EDMembershipCommand = self;
        [self initData];
        self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAIN;
        [_EDCommandManager commandFeedbackSteps:self];
    
}
-(void)excuteCommand
{
    self.EDCommandState = ETTTASKOPERATIONSTATESTART;
    [self pretreatmentRestoreCommand];
}
-(void)initData
{
    
}
-(void)pretreatmentRestoreCommand
{
    if (self.EDListModel == nil || self.EDListModel.EDDisasterDic ==nil)
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
        return;
    }
    
    NSString * type = [self.EDListModel.EDDisasterDic valueForKey:@"state"] ;
    if (type == nil || self.EDEntity == nil)
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
        return;
    }
    if (self.EDEntity)
    {
        [self.EDEntity performTask:self];
    }
    else
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
    }
    
    
    
}


-(void)commandFeedbackSteps:(id<ETTCommandInterface>)task
{
    
}

-(void)commandComplete
{
    
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    
}
-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    [self feedbackError:state];
}

-(void)feedbackError:(ETTTaskOperationState  )state
{
    self.EDCommandState = state;
    if (self.EDCommandManager)
    {
        
        [self.EDCommandManager commandFeedbackSteps:self];
    }
    
}
@end
