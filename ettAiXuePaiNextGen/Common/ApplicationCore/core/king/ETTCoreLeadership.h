//
//  ETTCoreLeadership.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTOfficialsInterface.h"
#import "ETTBaseOfficials.h"
#import "ETTOfficialsManagerInterface.h"
#import "ETTPartyMemberInteface.h"
#import "ETTPartyManagerInterface.h"

#import "ETTHighestLeaderInterface.h"
#import "ETTGeneralManager.h"


/**
 Description 最高领导人
 */
@interface ETTCoreLeadership : NSObject<ETTOfficialsManagerInterface,
    ETTPartyManagerInterface,
    ETTPartyMemberInteface,
    ETTHighestLeaderInterface
>

@property (nonatomic,retain ,readonly) ETTGeneralManager               * EDGeneralManager;

+(instancetype)birthCoreLeadership;

+(instancetype)fastCoreLeadership;



/**
 Description  构建国家

 @param territory 国家资源
 */
-(void)establishmentNational:(UIApplication   *)territory;


@end
