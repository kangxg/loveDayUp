//
//  ETTRedisPostOfficeQueue.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTRedisPostOfficeQueue : NSOperationQueue

@end


@interface ETTRedisPostOfficeChannelQueue : ETTRedisPostOfficeQueue

@end


@interface ETTRedisChannelReplyQueue : ETTRedisPostOfficeQueue

@end
