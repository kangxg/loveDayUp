//
//  AXPUserInformation.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/4.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPUserInformation.h"

@implementation AXPUserInformation

static id _instance;
+(instancetype)sharedInformation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark -- 伪造学生数据
-(void)setUpStudentPoseData
{
}

+(instancetype)infomationWithDict:(NSDictionary *)dict
{
    AXPUserInformation *information = [[AXPUserInformation alloc] init];
    
    [information setValuesForKeysWithDictionary:dict];
    
    return information;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
