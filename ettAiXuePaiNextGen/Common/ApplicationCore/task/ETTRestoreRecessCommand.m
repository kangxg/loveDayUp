//
//  ETTRestoreRecessCommand.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRestoreRecessCommand.h"

@implementation ETTRestoreRecessCommand
-(void)init:(id<ETTCommandInterface>)manager
 withEntity:(id<ETTPerformEntityInterface>)entity
   withlist:(ETTDisasterListingModel *)model
{
    self.EDCommandType     = ETTCOMMANDTYPECOURSEWARE;
    [super init:manager withEntity:entity withlist:model];
    
    
}
@end


@implementation ETTRestoreRecessFirstStepCommand
-(void)initData
{
    self.EDCommandIdentity = @"CO_02_state1";
}
-(void)pretreatmentRestoreCommand
{
    if (self.EDListModel == nil || self.EDListModel.EDDisasterDic ==nil)
    {
        [self feedbackError:ETTTASKOPERATIONSTATETASKERROR];
        return;
    }
    
    NSString * type = [[self.EDListModel.EDDisasterDic valueForKey:@"userInfo"] valueForKey:@"CO_02_state"];
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
