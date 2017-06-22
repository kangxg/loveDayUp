//
//  ETTAnouncement.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/28.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTAnouncement.h"
#import "ETTCoreLeadership.h"
@implementation ETTAnouncement
+(ETTGeneralManager *)lookingForGovernment
{
    ETTCoreLeadership * core = [ETTCoreLeadership fastCoreLeadership];
    return core.EDGeneralManager;
}

+(BOOL)reportGovernmentTask:(id<ETTTaskInterface>)task withType:(ETTSituation)type 
{
    return false;
}

+(BOOL)reportGovernmentTask:(nonnull id<ETTTaskInterface>)task withType:( ETTSituation)type withEntity:(nullable id<ETTPerformEntityInterface>)entity
{
    ETTCoreLeadership * core = [ETTCoreLeadership fastCoreLeadership];
    
    ETTGeneralManager * genneral = core.EDGeneralManager;
    if (genneral)
    {
        return   [genneral receiveChildGeneralWorkReport:task withEntity:entity];
    }
    return  false;
}



+(void)reportGovernmentRestoreTask:(nonnull id<ETTPerformEntityInterface>) entity withState:(ETTTaskOperationState) state
{
    ETTCoreLeadership * core = [ETTCoreLeadership fastCoreLeadership];
    
    ETTGeneralManager * genneral = core.EDGeneralManager;
    if (genneral)
    {
          [genneral receiveGovernmentRestoreReport:entity withState:state];
    }
   
}

+(BOOL)validationGovernmentRestoreTask:(nonnull id<ETTPerformEntityInterface>) entity
{
    ETTCoreLeadership * core = [ETTCoreLeadership fastCoreLeadership];
    
    ETTGeneralManager * genneral = core.EDGeneralManager;
    if (genneral)
    {
       return  [genneral receiveGovernmentRestore:entity];
    }
    return false;
}
@end
