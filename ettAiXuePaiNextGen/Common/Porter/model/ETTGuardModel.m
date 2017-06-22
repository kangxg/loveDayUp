//
//  ETTGuardModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTGuardModel.h"

@implementation ETTGuardModel
@synthesize EDEDWorkUnitVC = _EDEDWorkUnitVC;
@synthesize EDWorkUnitName = _EDWorkUnitName;
@synthesize EDLeader       = _EDLeader;
@synthesize EDGuradArchive = _EDGuradArchive;
@dynamic    EDTokenPath   ;
-(instancetype)initGuard:(ETTViewController  *)workUnit unitName:(NSString *)name
{
    if (self = [super init])
    {
        _EDWorkUnitName = name;
        _EDEDWorkUnitVC = workUnit;
        [self initGuardData];
        
    }
    return self;
}
-(void)resetGuard
{
    
}
-(void)initGuardData
{
    _EDGuradArchive.doorplate  = -1;
    _EDGuradArchive.empno      = -1;
    _EDGuradArchive.needNotice = YES;
    _EDGuradArchive.guradHandle = ETTVCHANDLENONE;
}

-(void)setDoorplate:(NSInteger )doorplate
{
    ETTGuradArchive guradArchive = self.EDGuradArchive;
    guradArchive.doorplate = doorplate;
    self.EDGuradArchive = guradArchive;
}
-(void)setEmpno:(NSInteger )empno
{
    ETTGuradArchive guradArchive = self.EDGuradArchive;
    guradArchive.doorplate = empno;
    self.EDGuradArchive = guradArchive;

}
-(void)setHandle:(ETTGuradHandle)handle
{
    ETTGuradArchive guradArchive = self.EDGuradArchive;
    guradArchive.doorplate = handle;
    self.EDGuradArchive = guradArchive;
}

-(void)setNeedNotice:(BOOL)needNotice
{
    ETTGuradArchive guradArchive = self.EDGuradArchive;
    guradArchive.needNotice = needNotice;
    self.EDGuradArchive = guradArchive;
}

-(void)reportPathTosuperior:(NSInteger )doorplate empo:(NSInteger )empo
{
    
}

-(void)showIsPushingview:(ETTTakecareRegistrationModel *)takeModel
{
    
}
@end
