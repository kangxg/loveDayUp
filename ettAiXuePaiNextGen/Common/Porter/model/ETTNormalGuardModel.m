//
//  ETTNormalGuardModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTNormalGuardModel.h"

@implementation ETTNormalGuardModel
@synthesize EDTokenPath = _EDTokenPath;
-(void)resetGuard
{
    if (self.EDEDWorkUnitVC)
    {
        self.EDEDWorkUnitVC = nil;
    }
}
@end
