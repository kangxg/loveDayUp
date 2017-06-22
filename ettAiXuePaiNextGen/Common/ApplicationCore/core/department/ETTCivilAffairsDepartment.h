//
//  ETTCivilAffairsDepartment.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/4.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTSeniorLeadership.h"
#import "ETTDisasterListingModel.h"
#import "ETTTaskInterface.h"
@interface ETTCivilAffairsDepartment : ETTSeniorLeadership
@property (nonatomic,assign)ETTRestoreState  EDRestoreState;
-(nullable ETTDisasterListingModel *)startstatisticsDisasterOffice:(nonnull ETTCVCardModel *)card;

-(void)cacheClassAction:(nonnull id<ETTTaskInterface>)task withCard:(nonnull ETTCVCardModel *)card;

-(void)updateCacheClassAction:(nonnull id<ETTTaskInterface>)task withCard:(nonnull ETTCVCardModel *)card withFeild:(nonnull NSString *)feild;

-(void)deleteClassAction:(nonnull id<ETTTaskInterface>)task withCard:(nonnull ETTCVCardModel *)card;



@end
