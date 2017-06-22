//
//  ETTRedisWorkerManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
/**
 Description 工人管理者
 */
#import <Foundation/Foundation.h>
#import "ETTRedisWorkerInterface.h"
#import "ETTRedisWorkerManageInterface.h"


@interface ETTRedisWorkerManager : NSObject<ETTRedisWorkerManageInterface,ETTRedisWorkerInterface>

@end
