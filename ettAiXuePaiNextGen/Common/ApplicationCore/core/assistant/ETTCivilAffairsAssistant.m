//
//  ETTCivilAffairsAssistant.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/5.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCivilAffairsAssistant.h"
#import "ETTDBManagement.h"
#import "ETTJSonStringDictionaryTransformation.h"
@implementation ETTCivilAffairsAssistant

@end

@implementation ETTCivilBaseAssistant

@end

#pragma mark
#pragma mark -----------------灾难统计--------------------
@implementation ETTDisasterStatisticsAssistant

-(ETTDisasterListingModel *) statisticsDisaster:(ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel !=ETTOFFICIALSCIVILAFFAIRS)
    {
        return nil;
    }
    NSDictionary * dic  = [[ETTDBManagement sharedDBManagement]dbGetDisasterAllCache];
    ETTDisasterListingModel * model = [[ETTDisasterListingModel alloc]init];
    
    if ([model putInDataFordic:dic])
    {
        return model;
    }
    return nil;
}
-(void)cacheClassAction:(id<ETTTaskInterface>)task withCard:(ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel !=ETTOFFICIALSCIVILAFFAIRS)
    {
        return ;
    }
    

    [[ETTDBManagement sharedDBManagement] dbSetClassActionCache:task];

}

-(void)cacheClassAction:(id<ETTTaskInterface>)task withField:(NSString *)field withCard:(ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel !=ETTOFFICIALSCIVILAFFAIRS)
    {
        return ;
    }
    [[ETTDBManagement sharedDBManagement] dbSetClassActionCache:task withField:field];
}

-(void)deleteClassAction:(id<ETTTaskInterface>)task withCard:(ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel !=ETTOFFICIALSCIVILAFFAIRS)
    {
        return ;
    }
    [[ETTDBManagement sharedDBManagement] dbDeleteClassActionCache:task];
    

}


@end
