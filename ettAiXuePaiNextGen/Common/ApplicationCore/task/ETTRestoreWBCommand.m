//
//  ETTRestoreWBCommand.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRestoreWBCommand.h"

@implementation ETTRestoreWBCommand
-(void)init:(id<ETTCommandInterface>)manager
 withEntity:(id<ETTPerformEntityInterface>)entity
   withlist:(ETTDisasterListingModel *)model
{
    self.EDCommandType     = ETTCOMMANDTYPEWHITEBOARD;
    [super init:manager withEntity:entity withlist:model];
    
    
}
@end

#pragma mark 白板推送恢复
@implementation ETTRestoreWBFirstCommand

-(void)initData
{
    self.EDCommandIdentity = @"WB_state1";
    
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

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
     [super commandPeriodicallyFailure:entity withState:state];
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    
    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==4 )
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
            [self.EDCommandManager commandComplete:self];
        }
    }
    else
    {
        ETTRestoreWBSecondCommand  * command = [[ETTRestoreWBSecondCommand alloc]init];
       [ command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
    }
    
    
}

@end

#pragma mark 白板作答恢复
@implementation ETTRestoreWBSecondCommand
-(void)initData
{
    self.EDCommandIdentity = @"WB_state2";
    
}

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
     [super commandPeriodicallyFailure:entity withState:state];
    
}

-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    
    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==2 )
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
            [self.EDCommandManager commandComplete:self];
        }
    }
    else
    {
        ETTRestoreWBThirdCommand  * command = [[ETTRestoreWBThirdCommand alloc]init];
        [command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
    }
    
    
}

@end

#pragma mark 白板结束作答恢复

@implementation ETTRestoreWBThirdCommand

-(void)initData
{
    self.EDCommandIdentity = @"WB_state3";
    
}

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    [super commandPeriodicallyFailure:entity withState:state];
    
}


-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{

    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==3 )
    {
       [self commandComplete];
    }
    else if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] == 21 )
    {
        ETTRestoreWBNoMarkCommand * command = [[ETTRestoreWBNoMarkCommand alloc]init];
        [command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];

    }
    else if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] == 23 )
    {
        if ([[self.EDListModel.EDDisasterDic valueForKey:@"lastState"] integerValue] ==3) {
             [self.EDListModel.EDDisasterDic setValue:@(3) forKey:@"state"];
             [self commandComplete];
        }
        else
        {
            [self restoreWBFourthCommand:entity];
        }

       
    }
    else
    {
        [self restoreWBFourthCommand:entity];
       
    }
    
    
    
}

-(void)restoreWBFourthCommand:(id<ETTPerformEntityInterface>)entity
{
    ETTRestoreWBFourthCommand  * command = [[ETTRestoreWBFourthCommand alloc]init];
    [command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
}
-(void)commandComplete
{
    if (self.EDCommandManager)
    {
        self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;

        [self.EDCommandManager commandComplete:self];
    }
}
@end

#pragma mark 白板互批开始恢复 
@implementation ETTRestoreWBFourthCommand

-(void)initData
{
    self.EDCommandIdentity = @"WB_state4";
    
}

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    [super commandPeriodicallyFailure:entity withState:state];

    
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    
    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==5 )
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;

            [self.EDCommandManager commandComplete:self];
        }
    }
    else
    {
        ETTRestoreWBFifthCommand  * command = [[ETTRestoreWBFifthCommand alloc]init];
        [command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
    }
    
    
}


@end

#pragma mark 白板互批结束恢复
@implementation ETTRestoreWBFifthCommand

-(void)initData
{
    self.EDCommandIdentity = @"WB_state5";
    
}

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    [super commandPeriodicallyFailure:entity withState:state];
  
    
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    
    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==20 )
    {
          [self commandComplete];
    }
    else if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] == 22 )
    {
        ETTRestoreWBMarkCommand * command = [[ETTRestoreWBMarkCommand alloc]init];
        [command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
        
    }
    else if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] == 23 )
    {
        [self.EDListModel.EDDisasterDic setValue:@"20" forKey:@"state"];
     
        [self commandComplete];
    }
    else
    {
        [self commandComplete];
    }
    
}

-(void)commandComplete
{
    if (self.EDCommandManager)
    {
        self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
        [self.EDCommandManager commandComplete:self];
    }
}
@end

#pragma mark 白板推送学生作答图片 恢复

@implementation ETTRestoreWBNoMarkCommand

-(void)initData
{
    self.EDCommandIdentity = @"WB_state21";
    
}

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    [super commandPeriodicallyFailure:entity withState:state];
    
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{

    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==21 )
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
            [self.EDCommandManager commandComplete:self];
        }
    }
   
    
    
}


@end


#pragma mark 推送学生批阅图片 恢复

@implementation ETTRestoreWBMarkCommand


-(void)initData
{
    self.EDCommandIdentity = @"WB_state22";
    
}

-(void)commandPeriodicallyFailure:(id<ETTPerformEntityInterface>)entity withState:(ETTTaskOperationState)state
{
    [super commandPeriodicallyFailure:entity withState:state];
    
}
-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    
    if ([[self.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] ==22 )
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
            [self.EDCommandManager commandComplete:self];
        }
    }
}

@end
