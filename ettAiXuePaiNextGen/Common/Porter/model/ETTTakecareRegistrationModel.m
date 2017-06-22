//
//  ETTTakecareRegistrationModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/7.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTakecareRegistrationModel.h"

@implementation ETTTakecareRegistrationModel
@synthesize EDEmpo = _EDEmpo;
@synthesize EDDoorplate = _EDDoorplate;
-(id)init
{
    if (self = [super init])
    {
        [self resetTakecareRegistration];
    }
    return self;
}
-(void)resetTakecareRegistration
{
    _EDEmpo = -1;
    _EDDoorplate = -1;
}
@end
