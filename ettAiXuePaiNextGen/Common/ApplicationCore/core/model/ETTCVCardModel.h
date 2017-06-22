//
//  ETTCVCardModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTCoreHeader.h"
/**
 Description 工牌
 */
@interface ETTCVCardModel : ETTBaseModel<NSCopying>

/**
 Description  姓名
 */
@property (nonatomic,retain,readonly)NSString *   EDName;

/**
 Description  人员编号
 */
@property (nonatomic,retain,readonly)NSString *   EDEmpNumber;


/**
 Description  级别
 */
@property (nonatomic,assign,readonly)ETTOfficialsLevel    EDLevel;

/**
 Description  类型
 */
@property (nonatomic,assign,readonly)ETTPersonType         EDPerType;


-(instancetype)initWithCard:(ETTCVCardModel *)card;

@end
