//
//  ETTRestorePaperCommand.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRestorePaperCommand.h"

@implementation ETTRestorePaperCommand
-(void)init:(id<ETTCommandInterface>)manager
          withEntity:(id<ETTPerformEntityInterface>)entity
            withlist:(ETTDisasterListingModel *)model
{
    self.EDCommandType     = ETTCOMMANDTYPEPAPER;
    [super init:manager withEntity:entity withlist:model];
  
   
}
@end


@implementation ETTRestorePaperFirstStepCommand
-(void)initData
{
    self.EDCommandIdentity = @"CO_04_state1";
   
}

-(void)pretreatmentRestoreCommand
{
    if (self.EDListModel == nil || self.EDListModel.EDDisasterDic ==nil)
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
        return;
    }

    NSString * type = [[self.EDListModel.EDDisasterDic valueForKey:@"userInfo"] valueForKey:@"CO_04_state"];
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


-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    NSString * type = [[self.EDListModel.EDDisasterDic valueForKey:@"userInfo"] valueForKey:@"CO_04_state"];
    if ([self.EDCommandIdentity isEqualToString:type])
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
            [self.EDCommandManager commandComplete:self];
        }
    }
    else
    {
        ETTRestorePaperSecondStepCommand  * command = [[ETTRestorePaperSecondStepCommand alloc]init];
        [ command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
    }

    
}

@end


@implementation  ETTRestorePaperSecondStepCommand
-(void)initData
{
    self.EDCommandIdentity = @"CO_04_state2";
   
}
-(void)pretreatmentRestoreCommand
{
    if (self.EDListModel == nil || self.EDListModel.EDDisasterDic ==nil)
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
        return;
    }
    
    NSString * type = [[self.EDListModel.EDDisasterDic valueForKey:@"userInfo"] valueForKey:@"CO_04_state"];
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


-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{
    NSString * type = [[self.EDListModel.EDDisasterDic valueForKey:@"userInfo"] valueForKey:@"CO_04_state"];

//
    if ([type isEqualToString:self.EDCommandIdentity])
    {
        NSDictionary  * dic =self.EDListModel.EDLastDic;
        if (dic && dic.count)
        {
            ETTRestorePaperThirdStepCommand  * command = [[ ETTRestorePaperThirdStepCommand alloc]init];
            [ command init:self.EDCommandManager withEntity:entity withlist:self.EDListModel];
        }
        else
        {
            if (self.EDCommandManager)
            {
                self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
                [self.EDCommandManager commandComplete:self];
            }
        }

       
    }
    else
    {
        if (self.EDCommandManager)
        {
            self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
            [self.EDCommandManager commandComplete:self];
        }
    }

}
@end


@implementation ETTRestorePaperThirdStepCommand
-(void)initData
{
    self.EDCommandIdentity = @"CO_06_state1";
    
}

-(void)pretreatmentRestoreCommand
{
    if (self.EDListModel == nil || self.EDListModel.EDDisasterDic ==nil)
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
        return;
    }

    NSString * type = [[self.EDListModel.EDDisasterDic valueForKey:@"userInfo"] valueForKey:@"CO_04_state"];
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

-(void)commandPeriodicallyComplete:(id<ETTPerformEntityInterface>)entity
{

    if (self.EDCommandManager)
    {
        self.EDCommandState = ETTTASKOPERATIONSTATEWILLBEGAINEND;
        [self.EDCommandManager commandComplete:self];
    }
    
}
@end
