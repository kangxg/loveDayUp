//
//  ETTOfficialsInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTPartyMemberInteface.h"
#import "ETTAssistantInterface.h"
#import "ETTOfficialsManagerInterface.h"
#import "ETTPartyManagerInterface.h"
#import "ETTCVCardModel.h"
#import "ETTCoreHeader.h"
/**
 Description 官员接口文件
 */

@protocol ETTOfficialsInterface <NSObject,ETTPartyMemberInteface>


@property (nonatomic,weak,nullable)id<ETTOfficialsManagerInterface>    EDGeneralBoss;

@property (nonatomic,weak,nullable)id<ETTPartyManagerInterface>    EDPartyBoss;


-(nullable instancetype)initOfficials:(nullable id<ETTOfficialsManagerInterface>)generalBoss patryboss:(nullable id<ETTPartyManagerInterface> )patryboss;

-(nullable instancetype)initGeneralOfficials:(nonnull id<ETTOfficialsManagerInterface>)generalBoss;

-(nullable instancetype)initPatryOfficials:(nonnull id<ETTPartyManagerInterface> )patryboss;




/**
 Description 官员任命

 @param card 认命的工牌
 @param leaderCard 上级领导的工牌
 */

-(void)appointmentOfficials:(nonnull ETTCVCardModel *)card
                  patryBoss:( nonnull  ETTCVCardModel *  )leaderCard;


/**
 Description 委任职位管理

 @param manger 管理者
 @param leaderCard 管理者名片
 */
-(void)appointedOfficialsManager:(nonnull id<ETTOfficialsManagerInterface>)manger
                        bossCard:(nonnull  ETTCVCardModel *  )leaderCard;


-(BOOL)workhandover:(nonnull id)handoverPerson;
@end
