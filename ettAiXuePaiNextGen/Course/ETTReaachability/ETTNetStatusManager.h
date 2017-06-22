//
//  AXPNetStatusManager.h
//  AXPBasic
//
//  Created by Liu Chuanan on 16/9/20.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETTReachability.h"

@interface ETTNetStatusManager : NSObject

/**
 *  初始化
 *
 *  @return 网络状态
 */
+ (ETTNetStatusManager *)sharedNetStatusManager;

/**
 *  设置
 */
- (void)setupReachability;


@property (strong, nonatomic) ETTReachability *reachability;

@property (copy, nonatomic) NSString *netStatusInfo;//网络状态信息

@end
