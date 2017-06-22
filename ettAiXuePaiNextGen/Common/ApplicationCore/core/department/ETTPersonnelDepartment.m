//
//  ETTPersonnelDepartment.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTPersonnelDepartment.h"
#import "ETTPersonnellAssistant.h"
@interface ETTPersonnelDepartment()
@property (nonatomic,retain)ETTPerArchivesAssistant  * MDArchivesAssistant;
@end

@implementation ETTPersonnelDepartment
@synthesize MDArchivesAssistant  = _MDArchivesAssistant;

//-(id)init
//{
//    if (self = [super init])
//    {
//        
//    }
//    return self;
//}
-(void)initOffice
{
    if (_MDArchivesAssistant == nil)
    {
        _MDArchivesAssistant = [[ETTPerArchivesAssistant alloc]initAssistant:self];
    }
    
    
    
}

-(void)initAssistant
{
    
}

-(void)startedOffice
{
    
}

-(void)startOffice:(NSInteger)officeType withCard:(nonnull ETTCVCardModel *)card
{
    [_MDArchivesAssistant archivesOffice:officeType withCard:card];
}

-(nullable ETTNationalPossessionsModel *)getNationalPossessionsModel:(nonnull NSString *)name
{
    return [_MDArchivesAssistant getNationalPossessionsModel:name];
}
-(void)startOffice:(NSInteger)officeType
{
    switch (officeType)
    {
        case ETTPERDEPOFFICEGENMANAGER:
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)appointmentOfficials:(ETTCVCardModel *)card patryBoss:(ETTCVCardModel *  )leaderCard
{
    if (leaderCard == nil || card == nil)
    {
        return;
    }
    
    if (card.EDLevel >ETTOFFICIALSNATIONAL )
    {
        self.EDCVCard = card;
    }
    
}
@end
