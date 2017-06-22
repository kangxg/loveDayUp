//
//  ETTBaseOfficials.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseOfficials.h"

@implementation ETTBaseOfficials

@synthesize EDCVCard       = _EDCVCard;
@synthesize EDPartyBoss    = _EDPartyBoss;
@synthesize EDGeneralBoss  = _EDGeneralBoss;
-(void)startOffice
{
    
}

-(void)startOffice:(NSInteger)officeType
{
    
}
-(instancetype)initOfficials:(id<ETTOfficialsManagerInterface>)generalBoss patryboss:(id<ETTPartyManagerInterface> )patryboss
{
    if (self = [super init])
    {
        _EDPartyBoss = patryboss;
        _EDGeneralBoss = generalBoss;
        [self initOffice];
    }
    return self;
}

-(instancetype)initGeneralOfficials:(id<ETTOfficialsManagerInterface>)generalBoss
{
  
    return [self initOfficials:generalBoss patryboss:nil];
}

-(instancetype)initPatryOfficials:(id<ETTPartyManagerInterface> )patryboss
{
 
    return [self initOfficials:nil patryboss:patryboss];
}

-(void)initOffice
{
    
}


-(void)appointmentOfficials:(ETTCVCardModel *)card patryBoss:(ETTCVCardModel *  )leaderCard
{
    if (leaderCard == nil || card == nil)
    {
        return;
    }
    
    if (card.EDLevel >ETTOFFICIALSLEVEL )
    {
        _EDCVCard = [card copy];
    }
    [self startOffice];
    
}
-(void)appointedOfficialsManager:(nonnull id<ETTOfficialsManagerInterface>)manger
                        bossCard:(nonnull  ETTCVCardModel *  )leaderCard
{
    
}


-(BOOL)workhandover:(nonnull id)handoverPerson
{
    return false;
}
@end
