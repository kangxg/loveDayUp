//
//  ETTGeneralManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//


#import "ETTSeniorLeadership.h"
#import "ETTOfficialsManagerInterface.h"
#import "ETTGovernmentTask.h"
#import "ETTPersonnelDepartment.h"
#import "ETTCivilAffairsDepartment.h"
#import "ETTSecurityDepartment.h"
#import "ETTPerformEntityInterface.h"
/**
 Description 政府总理父类
 */
@interface ETTGeneralManager : ETTSeniorLeadership<ETTOfficialsManagerInterface,ETTCommandInterface>
@property (nonatomic,weak,readonly,nullable) ETTPersonnelDepartment  * EDPersonnelManager;

@property (nonatomic,weak,readonly,nullable) ETTSecurityDepartment   * EDSecurityManager;

@property (nonatomic,weak,readonly,nullable) ETTCivilAffairsDepartment * EDCivilAffairsManager;


/**
 Description  委任人事部长到政府部门

 @param manager 人事部管理者
 @param leaderCard 任命凭证
 */
-(void)appointedPersonnelDepartment:(nonnull ETTPersonnelDepartment *)manager patryBoss:(nonnull ETTCVCardModel * )leaderCard;


/**
 Description  委任安全部长到政府部门

 @param manager 安全部门管理者
 @param leaderCard 任命凭证
 */
-(void)appointedSecurityDepartment :(nonnull ETTSecurityDepartment  *)manager patryBoss:(nonnull ETTCVCardModel * )leaderCard;

/**
 Description  委任民政部长到政府部门
 
 @param manager 民政部门管理者
 @param leaderCard 任命凭证
 */
-(void)appointedCivilAffairsDepartment:(nonnull ETTCivilAffairsDepartment *)manager patryBoss:(nonnull ETTCVCardModel * )leaderCard;


/**
 Description  收到子部门工作报告

 @param task 任务对象
 @return 处理结果
 */
-(BOOL)receiveChildGeneralWorkReport:(nonnull id<ETTTaskInterface>)task  withEntity:(nullable id<ETTPerformEntityInterface>)entity;

-(void)receiveGovernmentRestoreReport:(nonnull id<ETTPerformEntityInterface>) entity withState:(ETTTaskOperationState) state;

-(BOOL)receiveGovernmentRestore:(nonnull id<ETTPerformEntityInterface>) entity;
-(void)buildComplete;


@end
