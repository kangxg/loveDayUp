//
//  ETTRedisMaintenanceWorker.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerModel.h"
#import "ETTRedisMaintenanceReportInterface.h"
////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.21  11:15
 modifier : 康晓光
 version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
 problem  : 大课件redis验证权限处理
 describe : redis 维护工
 */
////////////////////////////////////////////////////////
@interface ETTRedisMaintenanceWorker : ETTRedisWorkerModel


-(ETTErrorMaintenanceState)redisMaintenance:(NSError *)error  withReids:(ObjCHiredis *)redis;

@end
