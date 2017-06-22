//
//  NSMutableArray+merge.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "NSMutableArray+merge.h"

@implementation NSMutableArray (merge)
-(void)merge:(NSArray *)arr
{
    for (id obj in  arr)
    {
        if (![self containsObject:obj])
        {
            [self addObject:obj];
        }
    }
    
}
@end
