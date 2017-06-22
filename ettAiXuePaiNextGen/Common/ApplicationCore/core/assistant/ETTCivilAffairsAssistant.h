//
//  ETTCivilAffairsAssistant.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/5.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseAssistant.h"
#import "ETTDisasterListingModel.h"
#import "ETTTaskInterface.h"
#import "ETTGovernmentTask.h"
@interface ETTCivilAffairsAssistant : ETTBaseAssistant

@end

@interface ETTCivilBaseAssistant : ETTCivilAffairsAssistant

@end
/**
 Description 灾难通知
 */
@interface ETTDisasterStatisticsAssistant :  ETTCivilAffairsAssistant

-(ETTDisasterListingModel *) statisticsDisaster:(ETTCVCardModel *)card;

-(void)cacheClassAction:(id<ETTTaskInterface>)task withCard:(ETTCVCardModel *)card;
-(void)cacheClassAction:(id<ETTTaskInterface>)task withField:(NSString *)field withCard:(ETTCVCardModel *)card;
-(void)deleteClassAction:(id<ETTTaskInterface>)task withCard:(ETTCVCardModel *)card;
@end
