//
//  ETTCoursewarePresentViewControllerManager.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCoursewarePresentViewControllerManager.h"

@implementation ETTCoursewarePresentViewControllerManager

+ (ETTCoursewarePresentViewControllerManager *)sharedManager {
    
    static ETTCoursewarePresentViewControllerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTCoursewarePresentViewControllerManager alloc]init];
    });
    return manager;
}

@end
