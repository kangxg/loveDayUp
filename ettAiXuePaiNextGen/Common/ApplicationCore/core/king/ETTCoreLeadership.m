//
//  ETTCoreLeadership.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCoreLeadership.h"
#import "ETTPersonnelDepartment.h"
#import "ETTGeneralManager.h"
#import "ETTSeniorOfficialsConfigModel.h"
#import "ETTCoreAssistant.h"
#import "ETTTempGeneralManager.h"
#import "ETTFormalGeneralManager.h"
#import "ETTUSERDefaultManager.h"
#import "ETTSecurityDepartment.h"
#import "ETTCivilAffairsDepartment.h"

@interface ETTCoreLeadership()
@property (nonatomic,retain ) ETTCoreArchivesAssistant        * MDArchivesAssistant;

@property (nonatomic,retain ) ETTPersonnelDepartment          * MDPersonnelLeader;

@property (nonatomic,retain ) ETTSecurityDepartment           * MDSecurityManager;

@property (nonatomic,retain ) ETTCivilAffairsDepartment       * MDCivilAffairsManager;

@property (nonatomic,retain ) ETTSeniorOfficialsConfigModel   * MDSeniorConfig;
@end

@implementation ETTCoreLeadership
+(instancetype)birthCoreLeadership
{
    static ETTCoreLeadership * appking = nil;
    static dispatch_once_t preKing;
    dispatch_once(&preKing, ^{
        appking = [[ETTCoreLeadership alloc]init];
        
    });
    return appking;
}

+(instancetype)fastCoreLeadership
{
    return [ETTCoreLeadership birthCoreLeadership];
}

-(id)init
{
    if (self = [super init])
    {
        _MDSeniorConfig = [[ETTSeniorOfficialsConfigModel alloc]init];
        [self createArchivesAssistant];
        
        [self.MDArchivesAssistant createHighestCard:self config:_MDSeniorConfig ];
        
        [self createPersonnelDepartment];
        [self createSecurityDepartment];
        [self createCivilAffairsDepartment];
    }
    return self;
}

-(void)establishmentNational:(UIApplication   *)territory
{
    NSLock * lock = [NSLock new];
    [lock lock];
    if (territory)
    {
        [self  formationInterimGovernment];
    }
    [lock unlock];
}

/**
 Description 组建政府
 */
-(void)formationInterimGovernment
{
    
    if (_MDPersonnelLeader)
    {
        //创建 总理 工牌
        ETTCVCardModel * card =[_MDArchivesAssistant createSeniorLeadershipCard:ETTOFFICIALSGENERALMANAGER boss:self config:_MDSeniorConfig];
        //人事 开始 整理总理信息
        [_MDPersonnelLeader startOffice:ETTPERDEPOFFICEGENMANAGER withCard:card];
        //获取总理的 个人信息model
        ETTGenNationalPossessionsModel * model = (ETTGenNationalPossessionsModel *)[_MDPersonnelLeader getNationalPossessionsModel:card.EDName];
         //创建 代理总理
        _EDGeneralManager = [[ETTTempGeneralManager alloc]initPatryOfficials:self];
        [_EDGeneralManager appointedPersonnelDepartment:self.MDPersonnelLeader patryBoss:_MDArchivesAssistant.EDHighestCard];
        [_EDGeneralManager appointedSecurityDepartment:self.MDSecurityManager patryBoss:_MDArchivesAssistant.EDHighestCard];
        
        [_EDGeneralManager appointedCivilAffairsDepartment:self.MDCivilAffairsManager patryBoss:_MDArchivesAssistant.EDHighestCard];
        
        //任命
        [_EDGeneralManager appointmentOfficials:model.EDCVCard patryBoss:_MDArchivesAssistant.EDHighestCard];
        
    }
 
} 
-(void)createArchivesAssistant
{
    if (_MDArchivesAssistant == nil)
    {
        _MDArchivesAssistant = [[ETTCoreArchivesAssistant alloc]initCoreAssistant:self];
    }
}
-(void)createPersonnelDepartment
{
    //任命的卡片
    ETTCVCardModel * newCard = [_MDArchivesAssistant createSeniorLeadershipCard:ETTOFFICIALSPERDEP boss:self config:_MDSeniorConfig];
    //领导的卡片
    ETTCVCardModel * leaderCard =_MDArchivesAssistant.EDHighestCard;
    
    [self.MDPersonnelLeader appointmentOfficials:newCard    patryBoss:leaderCard];
}


-(void)createSecurityDepartment
{
    //任命的卡片
    ETTCVCardModel * newCard = [_MDArchivesAssistant createSeniorLeadershipCard:ETTOFFICIALSSECURITY boss:self config:_MDSeniorConfig];
    //领导的卡片
    ETTCVCardModel * leaderCard =_MDArchivesAssistant.EDHighestCard;
    
    [self.MDSecurityManager appointmentOfficials:newCard    patryBoss:leaderCard];
}

-(void)createCivilAffairsDepartment
{
    //任命的卡片
    ETTCVCardModel * newCard = [_MDArchivesAssistant createSeniorLeadershipCard:ETTOFFICIALSCIVILAFFAIRS boss:self config:_MDSeniorConfig];
    //领导的卡片
    ETTCVCardModel * leaderCard =_MDArchivesAssistant.EDHighestCard;
    
    [self.MDCivilAffairsManager appointmentOfficials:newCard    patryBoss:leaderCard];
}
-(ETTCoreArchivesAssistant *)MDArchivesAssistant
{
    if (_MDArchivesAssistant == nil)
    {
        _MDArchivesAssistant = [[ETTCoreArchivesAssistant alloc]initPatryOfficials:self];
    }
    return _MDArchivesAssistant;
}

-(ETTPersonnelDepartment *)MDPersonnelLeader
{
    if (_MDPersonnelLeader == nil)
    {
        _MDPersonnelLeader = [[ETTPersonnelDepartment alloc]initPatryOfficials:self];
    }
    return _MDPersonnelLeader;
}

-(ETTSecurityDepartment *)MDSecurityManager
{
    if (_MDSecurityManager == nil)
    {
        _MDSecurityManager = [[ETTSecurityDepartment alloc]initPatryOfficials:self];
    }
    return _MDSecurityManager;
}

-(ETTCivilAffairsDepartment *)MDCivilAffairsManager
{
    if (_MDCivilAffairsManager == nil)
    {
        _MDCivilAffairsManager = [[ETTCivilAffairsDepartment alloc]initPatryOfficials:self];
    }
    return _MDCivilAffairsManager;
}
#pragma mark 临时政府
-(BOOL)interimGovernmentBuildComplete
{
    BOOL isBuildComplete = false;
    if ([_EDGeneralManager isKindOfClass:[ETTFormalGeneralManager class]])
    {
        return isBuildComplete;
    }
    NSString * identity = [ETTUSERDefaultManager getCurrentIdentity];
    ETTFormalGeneralManager * formanManager = nil;
    if ([identity isEqualToString:@"teacher"])
    {
        formanManager = [[ETTFormalTeacherGeneralManager alloc]initPatryOfficials:self];
    }
    else
    {
          formanManager = [[ETTFormalStudentGeneralManager alloc]initPatryOfficials:self];
    }
    if ( [formanManager workhandover:_EDGeneralManager])
    {
        
        ETTGenNationalPossessionsModel * model = (ETTGenNationalPossessionsModel *)[_MDPersonnelLeader getNationalPossessionsModel:_EDGeneralManager.EDCVCard.EDName];
        _EDGeneralManager = formanManager;
        [_EDGeneralManager appointmentOfficials:model.EDCVCard patryBoss:_MDArchivesAssistant.EDHighestCard];
        
        
        isBuildComplete = YES;
        
    }
    
    return isBuildComplete;
}
@end
