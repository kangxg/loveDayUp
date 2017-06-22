//
//  ETTBaseOfficials.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTOfficialsInterface.h"
#import "ETTPartyMemberInteface.h"
#import "ETTCVCardModel.h"

/**
 Description  官员基类
 */
@interface ETTBaseOfficials : NSObject<ETTOfficialsInterface>

@property (nonatomic,retain)ETTCVCardModel *  EDCVCard;


-(void)initOffice;

-(void)startOffice;


-(void)startOffice:(NSInteger)officeType;
@end
