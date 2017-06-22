//
//  ETTCoreAssistant.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseAssistant.h"
#import "ETTCVCardModel.h"
#import "ETTHighestLeaderInterface.h"
#import "ETTCoreLeadership.h"
#import "ETTSeniorOfficialsConfigModel.h"


/**
 Description  核心领导人助手
 */
@interface ETTCoreAssistant : ETTBaseAssistant

/**
 Description 直属上级领导
 */
@property(nonatomic,assign,nonnull)id<ETTHighestLeaderInterface>  EDHighestLeadr;


/**
 Description  构造函数

 @param boss  直属上级领导
 
 @return      助手实例
 */
-(nullable instancetype)initCoreAssistant:(nonnull id<ETTHighestLeaderInterface>)boss;
@end



@interface ETTCoreArchivesAssistant : ETTCoreAssistant
@property  (nonatomic,retain,readonly,nonnull) ETTCVCardModel  *  EDHighestCard;


/**
 Description  为最高领导人创建工牌

 @param leader 最高领导人
 @param config 配置
 */
-(void)createHighestCard:(nonnull ETTCoreLeadership *)leader config:(nonnull ETTSeniorOfficialsConfigModel *)config;


/**
 Description   创建高级领导的工牌

 @param level  官员级别
 @param leader 上司
 @param config 配置
 @return 工牌
 */
-(nullable ETTCVCardModel *)createSeniorLeadershipCard:(ETTOfficialsLevel )level boss:(nonnull ETTCoreLeadership *)leader config:(nonnull ETTSeniorOfficialsConfigModel *)config;
@end
