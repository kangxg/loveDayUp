//
//  ETTPersonnelDepartment.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTSeniorLeadership.h"
#import "ETTNationalPossessionsModel.h"

/**
 Description  人事部 部长
 */
@interface ETTPersonnelDepartment : ETTSeniorLeadership


-(void)startOffice:(NSInteger)officeType withCard:(nonnull ETTCVCardModel *)card;

-(nullable ETTNationalPossessionsModel *)getNationalPossessionsModel:(nonnull NSString *)name;
@end
