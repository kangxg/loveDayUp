//
//  ETTCivilAffairsDepartment.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/4.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCivilAffairsDepartment.h"
#import "ETTCivilAffairsAssistant.h"
#import "ETTScenePorter.h"
@interface ETTCivilAffairsDepartment ()
@property (nonatomic,retain)ETTDisasterStatisticsAssistant *  MDDisasterStatisticsAssistant;
@end


@implementation ETTCivilAffairsDepartment
-(void)initOffice
{
    if (_MDDisasterStatisticsAssistant == nil)
    {
        _MDDisasterStatisticsAssistant = [[ETTDisasterStatisticsAssistant alloc]initAssistant:self];
    }
  
}

-(void)initAssistant
{
    
}

-(void)startedOffice
{
    
}

-(ETTDisasterListingModel *)startstatisticsDisasterOffice:(nonnull ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel<ETTOFFICIALSNATIONAL)
    {
        return nil;
    }
    if (_MDDisasterStatisticsAssistant)
    {
        
       return  [_MDDisasterStatisticsAssistant statisticsDisaster:self.EDCVCard];
    }
    return nil;
}
-(void)cacheClassAction:(id<ETTTaskInterface>)task withCard:(ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel<ETTOFFICIALSNATIONAL)
    {
        return ;
    }
    
    if (_MDDisasterStatisticsAssistant)
    {
        [_MDDisasterStatisticsAssistant cacheClassAction:task withCard:self.EDCVCard];
    }
}
-(void)updateCacheClassAction:(nonnull id<ETTTaskInterface>)task withCard:(nonnull ETTCVCardModel *)card withFeild:(nonnull NSString *)feild
{
    if (feild == nil || task == nil ||card.EDLevel<ETTOFFICIALSNATIONAL )
    {
        return;
    }
    if (_MDDisasterStatisticsAssistant)
    {
        [_MDDisasterStatisticsAssistant cacheClassAction:task withField:feild withCard:self.EDCVCard];
    }
}
-(void)deleteClassAction:(nonnull id<ETTTaskInterface>)task withCard:(nonnull ETTCVCardModel *)card
{
    if (card == nil || card.EDLevel<ETTOFFICIALSNATIONAL || task == nil)
    {
        return ;
    }
    
    if (_MDDisasterStatisticsAssistant == nil)
    {
        return;
    }
    
    if ([task isKindOfClass:[ETTGovRestoreWorkTask class]])
    {
        [self toDealWithGovRestoreWorkTask:task];
    }
    
    
}

-(void)toDealWithGovRestoreWorkTask:(nonnull id<ETTTaskInterface>)task
{

    switch (task.EDTaskType)
    {
        case ETTRESTOREEND:
        {
            self.EDRestoreState = ETTRESTOREEND;
            task.EDCommmand = nil;
            task = nil;
        }
            break;
        case ETTDELRESTOREACACHIVE:
        {
            self.EDRestoreState = ETTDELRESTOREACACHIVE;
            if (_MDDisasterStatisticsAssistant)
            {
                [_MDDisasterStatisticsAssistant deleteClassAction:task withCard:self.EDCVCard];
            }
           
        }
            
        default:
            break;
    }

}
@end
