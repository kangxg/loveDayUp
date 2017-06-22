//
//  ETTGeneralManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTGeneralManager.h"

@implementation ETTGeneralManager
@dynamic EDPersonnelManager;
@dynamic EDSecurityManager;
@dynamic EDCivilAffairsManager;
-(void)buildComplete
{
    
}

-(BOOL)receiveChildGeneralWorkReport:(id<ETTTaskInterface>)task withEntity:(nullable id<ETTPerformEntityInterface>)entity
{
    return false;
}
-(void)receiveGovernmentRestoreReport:(nonnull id<ETTPerformEntityInterface>) entity withState:(ETTTaskOperationState) state
{
    
}
-(BOOL)receiveGovernmentRestore:(nonnull id<ETTPerformEntityInterface>) entity
{
    return false;
}
-(void)appointedSecurityDepartment:(ETTSecurityDepartment *)manager patryBoss:(ETTCVCardModel *)leaderCard
{
  
}

-(void)appointedPersonnelDepartment:(ETTPersonnelDepartment *)manager patryBoss:(ETTCVCardModel *)leaderCard
{

}

-(void)appointedCivilAffairsDepartment:(ETTCivilAffairsDepartment *)manager patryBoss:(ETTCVCardModel *)leaderCard
{

}

-(void)commandFeedbackSteps:(id<ETTCommandInterface>)task
{
    
}

-(void)commandComplete:(id<ETTCommandInterface>)task
{
    
}
@end
