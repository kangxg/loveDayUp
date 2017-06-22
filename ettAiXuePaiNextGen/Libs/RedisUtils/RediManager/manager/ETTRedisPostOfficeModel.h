//
//  ETTRedisPostOfficeModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerModel.h"

@interface ETTRedisPostOfficeModel : ETTRedisWorkerModel

/**
 Description 邮局需要邮递的频道
 */
@property(nonatomic,retain,readonly)NSMutableArray <NSString *>  *  EDChannelNames;

-(void)registeredChannelPublishMessages:(NSArray  *)channelNames  respondHandler:(RespondHandler)respondHandler;


-(void)registeredCPublishMessage:(NSString  *)channelName  respondHandler:(RespondHandler)respondHandler;



@end
