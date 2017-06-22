//
//  ETTAnouncement.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/28.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTGeneralManager.h"
#import "ETTTaskInterface.h"
#import "ETTPerformEntityInterface.h"
@interface ETTAnouncement : NSObject

+(nonnull ETTGeneralManager *)lookingForGovernment;

+(BOOL)reportGovernmentTask:(nonnull id<ETTTaskInterface>)task withType:( ETTSituation)type;
 

+(BOOL)reportGovernmentTask:(nonnull id<ETTTaskInterface>)task withType:( ETTSituation)type withEntity:(nullable id<ETTPerformEntityInterface>)entity;

+(void)reportGovernmentRestoreTask:(nonnull id<ETTPerformEntityInterface>) entity withState:(ETTTaskOperationState) state;

+(BOOL)validationGovernmentRestoreTask:(nonnull id<ETTPerformEntityInterface>) entity;
@end
