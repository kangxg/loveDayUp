//
//  ETTRedisWorkerInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTRedisWorkerInterface <NSObject>
@optional
-(void)startsWorker;
-(void)workAgain;


-(void)endWorker;
@end
