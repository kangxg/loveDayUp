//
//  ETTRedisDataHouseManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
/**
 Description 仓库管理员
 */
#import <Foundation/Foundation.h>
#import "ETTRedisDataHouseManageInterface.h"
#import "ETTRedisMaintenanceReportInterface.h"
@interface ETTRedisDataHouseManager : NSObject<ETTRedisDataHouseManageInterface,ETTRedisReportInterface>

@end
