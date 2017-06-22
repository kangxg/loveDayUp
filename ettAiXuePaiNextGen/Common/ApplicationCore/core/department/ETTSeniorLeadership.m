//
//  ETTSeniorLeadership.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTSeniorLeadership.h"

@implementation ETTSeniorLeadership

@synthesize EDAssistant    = _EDAssistant;

-(id)init
{
    if (self = [super init])
    {
        [self initAssistant];
    }
    return self;
}
-(void)initAssistant
{
    
}
-(void)startedOffice
{
    
}

-(void)startedOffice:(NSInteger)officeType
{
    
}
-(void)appointedOfficialsManager:(nonnull id<ETTOfficialsManagerInterface>)manger
                        bossCard:(nonnull  ETTCVCardModel *  )leaderCard
{
    if (manger == nil  )
    {
        return;
    }
    if (leaderCard.EDLevel> ETTOFFICIALSNATIONAL)
    {
        self.EDGeneralBoss = manger;
    }
}

@end
