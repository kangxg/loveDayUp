//
//  ETTRedisGuardianWorker.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerModel.h"

@interface ETTRedisGuardianWorker : ETTRedisWorkerModel
-(void)guardChannelSubscribeWorkFail;
-(void)guardChannelSubscribeWorkSuccess;

-(BOOL)getAllowToOperation;

-(void)suspensionWork;

-(void)restorework;
@end
