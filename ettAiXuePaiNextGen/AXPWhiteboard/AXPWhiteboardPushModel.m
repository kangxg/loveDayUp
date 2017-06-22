//
//  AXPWhiteboardPushModel.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/31.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPWhiteboardPushModel.h"

@implementation AXPWhiteboardPushModel

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    AXPWhiteboardPushModel *model = [[AXPWhiteboardPushModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
