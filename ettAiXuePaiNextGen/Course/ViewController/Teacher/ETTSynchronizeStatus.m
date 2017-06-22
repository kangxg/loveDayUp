//
//  ETTSynchronizeStatus.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/3.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSynchronizeStatus.h"

@implementation ETTSynchronizeStatus

+ (ETTSynchronizeStatus *)sharedManager {
    
    static ETTSynchronizeStatus *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTSynchronizeStatus alloc]init];
    });
    return manager;
    
}

@end
