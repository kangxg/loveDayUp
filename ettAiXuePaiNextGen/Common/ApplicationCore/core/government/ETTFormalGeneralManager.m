//
//  ETTFormalGeneralManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTFormalGeneralManager.h"
#import "ETTTempGeneralManager.h"
#import "ETTRemindManager.h"
#import "ETTRestoreCommand.h"
@interface ETTFormalGeneralManager()

/**
 Description  灾难恢复
 */
-(void)disasterRecovery;
@end

@implementation ETTFormalGeneralManager
@synthesize EDSecurityManager     = _EDSecurityManager;
@synthesize EDPersonnelManager    = _EDPersonnelManager;
@synthesize EDCivilAffairsManager = _EDCivilAffairsManager;

@synthesize EDEntity              = _EDEntity;
-(BOOL)workhandover:(id)handoverPerson
{
    if (handoverPerson == nil)
    {
        return false;
    }
    ETTTempGeneralManager * tmpgen = handoverPerson;
    if (tmpgen.EDCVCard.EDLevel>ETTOFFICIALSNATIONAL)
    {
        _EDPersonnelManager     = tmpgen.EDPersonnelManager;
        [_EDSecurityManager appointedOfficialsManager:self bossCard:self.EDCVCard];
        
        _EDSecurityManager      = tmpgen.EDSecurityManager;
        [_EDPersonnelManager appointedOfficialsManager:self bossCard:self.EDCVCard];
        
        
        _EDCivilAffairsManager  = tmpgen.EDCivilAffairsManager;
        [_EDCivilAffairsManager appointedOfficialsManager:self bossCard:self.EDCVCard];
        
        self.EDEntity = tmpgen.EDEntity;
    }
    
    return YES;
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
-(void)startOffice
{
    [self disasterRecovery];
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

-(void)disasterRecovery
{
    
}
@end

#pragma mark
#pragma mark  ----------- teacher --------------
@interface ETTFormalTeacherGeneralManager()

@end

@implementation ETTFormalTeacherGeneralManager
@synthesize EDMembershipCommand = _EDMembershipCommand;
-(void)startOffice
{
    if (self.EDCVCard == nil || self.EDCVCard.EDLevel< ETTOFFICIALSNATIONAL)
    {
        return;
    }
    [self disasterRecovery];
}

-(void)disasterRecovery
{
    if (self.EDCivilAffairsManager == nil ||self.EDCivilAffairsManager.EDRestoreState == ETTRESTOREEND || self.EDCivilAffairsManager.EDRestoreState == ETTDELRESTOREACACHIVE )
    {
        return;
    }


    ETTDisasterListingModel * model = [self.EDCivilAffairsManager startstatisticsDisasterOffice:self.EDCVCard];
    if (model == nil || model.EDJid == nil || model.EDDisasterType == nil || model.EDDisasterDic == nil  )
    {
        return;
    }
    
    if (!isEmptyString(model.EDRoomId)  && [[AXPUserInformation sharedInformation].classroomId isEqualToString:model.EDRoomId])
    {
        [ETTRestoreCommand createCommand:self withEntity:self.EDEntity withlist:model];
    }
    
//    [[ETTRemindManager shareRemindManager]createRemindView:ETTLOCKSCREEViEW];
    

    
    
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
        case ETTSITUATIONCLASSREPORT:
        {
            if (self.EDCivilAffairsManager)
            {
            
//                self.EDEntity = entity;
                self.EDEntity = nil;
                [self.EDCivilAffairsManager cacheClassAction:task withCard:self.EDCVCard];
                isComplete = YES;
            }
            
        }
            break;
        case  ETTDELRESTOREACACHIVE:
        {
            if (self.EDCivilAffairsManager)
            {
                self.EDEntity = nil;
                [self.EDCivilAffairsManager deleteClassAction:task withCard:self.EDCVCard];
                isComplete = YES;
            }

        }
            break;
        case ETTSITUATIONCLASSENDPUSHREPORT:
        {
            self.EDEntity = nil;
            [self.EDCivilAffairsManager deleteClassAction:task withCard:self.EDCVCard];
            isComplete = YES;
        }
            break;
        case ETTETTSITUATIONCLASSUPDATE:
        {
             [self.EDCivilAffairsManager updateCacheClassAction:task withCard:self.EDCVCard withFeild:@"subTopicUserInfo"];
        }
          break;
        default:
            break;
    }
    return isComplete;
}
-(void)receiveGovernmentRestoreReport:(nonnull id<ETTPerformEntityInterface>) entity withState:(ETTTaskOperationState) state
{
    if (self.EDMembershipCommand == nil || entity == nil )
    {
        return;
    }
    if (state == ETTTASKOPERATIONSTATELOADCOMPLETE)
    {
        [self.EDMembershipCommand excuteCommand];
    }
    
}

-(BOOL)receiveGovernmentRestore:(nonnull id<ETTPerformEntityInterface>) entity
{
    if (entity == nil)
    {
        return false;
    }
    
    if (self.EDMembershipCommand.EDEntity == entity)
    {
        return YES;
    }
    return false;
}
-(void)commandFeedbackSteps:(id<ETTCommandInterface>)task
{
    if (task ==nil)
    {
        [self commandComplete:task];
        return;
    }
    

    switch (task.EDCommandState)
    {
        case ETTTASKOPERATIONSTATEWILLBEGAIN:
        {
            
            [_EDMembershipCommand excuteCommand];
        }
            break;
        case ETTTASKOPERATIONSTATELOADCOMPLETE:
        {
           
            
        }
            break;
        case ETTTASKOPERATIONSTATETASKERROR:
        {
            //任务错误，命令不能直行 这里需要处理 结束动画等
            [self commandComplete:task];
        }
            break;
        default:
            break;
    }
   
}

-(void)commandComplete:(id<ETTCommandInterface>)command
{
    if (command == nil)
    {
        return;
    }
    

    //需要处理，命令完成
    NSLock * lock = [[NSLock alloc]init];
    [lock lock];
    
    if (self.EDCivilAffairsManager )
    {
//        ETTRestoreCommand  * restoreCommand = (ETTRestoreCommand *)command;
        self.EDMembershipCommand = nil;
        ETTGovRestoreWorkTask * task = [[ETTGovRestoreWorkTask alloc] initTask:ETTRESTOREEND];
        task.EDCommmand = command;
        [self.EDCivilAffairsManager deleteClassAction:task withCard:self.EDCVCard];
       
    }

    [lock unlock];
}
@end



@implementation ETTFormalStudentGeneralManager
-(void)startOffice
{

}
@end
