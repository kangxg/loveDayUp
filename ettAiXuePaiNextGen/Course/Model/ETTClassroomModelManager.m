//
//  ETTClassroomModelManager.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/28.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassroomModelManager.h"


@implementation ETTClassroomModelManager

+ (ETTClassroomModelManager *)sharedManager {
    
    static ETTClassroomModelManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTClassroomModelManager alloc]init];
    });
    return manager;
}

@end
