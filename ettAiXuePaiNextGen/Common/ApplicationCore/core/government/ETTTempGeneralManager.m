//
//  ETTTempGeneralManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTTempGeneralManager.h"
#import "ETTRemindManager.h"
#import "ETTRestoreCommand.h"
@implementation ETTTempGeneralManager
@synthesize EDSecurityManager     = _EDSecurityManager;
@synthesize EDPersonnelManager    = _EDPersonnelManager;
@synthesize EDCivilAffairsManager = _EDCivilAffairsManager;
@synthesize EDEntity              = _EDEntity;
-(void)buildComplete
{
   
}
-(void)appointmentOfficials:(ETTCVCardModel *)card patryBoss:(ETTCVCardModel *  )leaderCard
{
    if (leaderCard == nil || card == nil)
    {
        return;
    }
    
    if (leaderCard.EDLevel == ETTOFFICIALSHIGHEST && card.EDLevel >ETTOFFICIALSNATIONAL )
    {
        self.EDCVCard = [card copy];
    }
    [self startOffice];
    
}
-(BOOL)receiveChildGeneralWorkReport:(id<ETTTaskInterface>)task withEntity:(nullable id<ETTPerformEntityInterface>)entity
{
    BOOL isComplete = false;
    if (task == nil)
    {
        return isComplete;
    }
  
    switch (task.EDTaskType)
    {
        case ETTSITUATIONINCLASSROOM:
        {
            if (self.EDPartyBoss)
            {
                self.EDEntity = entity;
                isComplete = [self.EDPartyBoss interimGovernmentBuildComplete];
                            }
           
        }
            break;
            
        default:
            break;
    }
    return isComplete;
}


-(void)appointedSecurityDepartment:(ETTSecurityDepartment *)manager patryBoss:(ETTCVCardModel *)leaderCard
{
    if (leaderCard.EDLevel == ETTOFFICIALSHIGHEST)
    {
        _EDSecurityManager = manager;
        [_EDSecurityManager appointedOfficialsManager:self bossCard:self.EDCVCard];
    }
}

-(void)appointedPersonnelDepartment:(ETTPersonnelDepartment *)manager patryBoss:(ETTCVCardModel *)leaderCard
{
    if (leaderCard.EDLevel == ETTOFFICIALSHIGHEST)
    {
        _EDPersonnelManager = manager;
        [ _EDPersonnelManager appointedOfficialsManager:self bossCard:self.EDCVCard];
    }
}

-(void)appointedCivilAffairsDepartment:(ETTCivilAffairsDepartment *)manager patryBoss:(ETTCVCardModel *)leaderCard
{
    if (leaderCard.EDLevel == ETTOFFICIALSHIGHEST)
    {
        _EDCivilAffairsManager = manager;
        [_EDCivilAffairsManager appointedOfficialsManager:self bossCard:self.EDCVCard];
    }
}
@end


@implementation ETTTempTeacherGeneralManager

@end


@implementation ETTTempStudentGeneralManager

@end
