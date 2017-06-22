//
//  AXPNetStatusManager.m
//  AXPBasic
//
//  Created by Liu Chuanan on 16/9/20.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "ETTNetStatusManager.h"
#import <UIKit/UIKit.h>

@implementation ETTNetStatusManager

+ (ETTNetStatusManager *)sharedNetStatusManager {
    
    static ETTNetStatusManager *sharedManager;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        sharedManager = [[ETTNetStatusManager alloc]init];
        
    });
    return sharedManager;
}

- (void)setupReachability {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityStatusChanged:) name:kReachabilityChangedNotification object:nil];
    ETTReachability *reachability = [ETTReachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
    
    self.reachability = reachability;
    //return reachability;
}

- (void)reachabilityStatusChanged:(NSNotification *)notification {
    
    ETTReachability *currentReachability  = [notification object];
    NSParameterAssert([currentReachability isKindOfClass:[ETTReachability class]]);
    switch ([currentReachability currentReachabilityStatus]) {
        case NotReachable:{
            self.netStatusInfo = @"当前没有网络";
            NSLog(@"当前没有网络");
            break;
        }
        case ReachableViaWiFi:
            NSLog(@"Wifi");
            break;
        case ReachableViaWWAN:
            NSLog(@"蜂窝数据");
                default:
            break;
    }
    
}


@end
