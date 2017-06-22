//
//  ETTRedisServerDelegate.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTRedisBasisDelegate <NSObject>
@optional
-(void)redisHGETReturnValue:(RespondHandler)respondHandler;

-(void)processChannelMessage:(NSString *)message;

@end
