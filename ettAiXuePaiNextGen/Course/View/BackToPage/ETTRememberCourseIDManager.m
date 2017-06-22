//
//  ETTRememberCourseIDManager.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/31.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRememberCourseIDManager.h"

@implementation ETTRememberCourseIDManager

+ (ETTRememberCourseIDManager *)sharedManager {
    
    static ETTRememberCourseIDManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTRememberCourseIDManager alloc]init];
        
    });
    return manager;
}

@end
