//
//  ETTTravelRecordsModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/7.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"

/**
 Description  行程记录
 */
@interface ETTTravelRecordsModel : ETTBaseModel

/**
 Description  从那里来
 */
@property (nonatomic,assign)NSInteger   EDFromPath;

/**
 Description 当前 门牌号
 */
@property (nonatomic,assign)NSInteger   EDCurrentPath;


/**
 Description 员工号
 */
@property (nonatomic,assign)NSInteger   EDEmpo;


/**
 Description  复位 行程记录
 */
-(void)resetTravelRecords;
@end
