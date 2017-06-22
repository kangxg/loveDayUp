//
//  ETTGuradBattalionChiefModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTGuradBattalionChiefModel.h"
#import "ETTGuradCaptainModel.h"
#import "ETTSideNavigationViewControllerDelegate.h"
#import "ETTPorterEnum.h"
#import "ETTNormalGuardModel.h"
@interface   ETTGuradBattalionChiefModel()
@property (nonatomic,retain)NSMutableArray <ETTGuradCaptainModel *> * MDGuradCaptainArr;
@end

@implementation ETTGuradBattalionChiefModel
@synthesize MDGuradCaptainArr = _MDGuradCaptainArr;
-(id)init
{
    if (self = [super init])
    {
        [self initGuardData];
    }
    return self;
}
-(void)initGuardData
{
    if (_MDGuradCaptainArr == nil)
    {
        _MDGuradCaptainArr = [[NSMutableArray alloc]init];
    }
}
-(void)resetManagerSystem
{
    if (_MDGuradCaptainArr.count)
    {
        [_MDGuradCaptainArr removeAllObjects];
    }
}

-(void )registerGuradCaptainManager:(ETTViewController *)vc
{
    if (vc && ![self haveGuradCaptain:vc])
    {
        ETTGuradCaptainModel *captainGurad = [[ETTGuradCaptainModel alloc]initGuard:vc unitName:NSStringFromClass([vc class])];
        captainGurad.EDLeader = self;
        captainGurad.EDGuradArchive =  ETTGuradArchiveMake(_MDGuradCaptainArr.count, _MDGuradCaptainArr.count, ETTVCHANDLENONE);
        [_MDGuradCaptainArr addObject:captainGurad];
    }
}

-(ETTGuradCaptainModel *)haveGuradCaptain:(ETTViewController *)vc 
{
    ETTGuradCaptainModel * model =nil;
    for (ETTGuradCaptainModel * captainModel in _MDGuradCaptainArr)
    {
        if (captainModel.EDEDWorkUnitVC == vc)
        {
            model = captainModel;
            break;
        }
    }
    
    return model;
}

-(BOOL)canOpenDoor:(ETTViewController *)vc withNum:(NSInteger)doorplat
{
    if (doorplat<0)
    {
        return false;
    }
    ETTGuradCaptainModel * captainModel = _MDGuradCaptainArr[doorplat];
    return  [captainModel canOpenDoor:vc withNum:doorplat];
    
}
-(ETTGuradCaptainModel *)getguradCapationModel:(NSInteger) doorplate
{
    if (doorplate<0 || doorplate>(_MDGuradCaptainArr.count -1))
    {
        return  nil;
    }
    
    return _MDGuradCaptainArr[doorplate];
}

-(void)removeGurad:(ETTNormalGuardModel *)guardModel
{
    if (guardModel == nil)
    {
        return;
    }
    NSInteger doorplate = guardModel.EDGuradArchive.doorplate;
    if (doorplate<1 || doorplate>(_MDGuradCaptainArr.count -1))
    {
        return;
    }
    ETTGuradCaptainModel * captainModel = _MDGuradCaptainArr[doorplate];
    [captainModel removeGurad:guardModel];
   
}
-(void)removeGurad:(ETTNormalGuardModel *)guardModel takeRegist:(ETTTakecareRegistrationModel *)takecareModel
{
    if (guardModel == nil)
    {
        return;
    }
    NSInteger doorplate = guardModel.EDGuradArchive.doorplate;
    if (doorplate<1 || doorplate>(_MDGuradCaptainArr.count -1))
    {
        return;
    }
    ETTGuradCaptainModel * captainModel = _MDGuradCaptainArr[doorplate];
    [captainModel removeGurad:guardModel takeRegist:takecareModel];
}
-(void)reportPathTosuperior:(NSInteger )doorplate empo:(NSInteger )empo
{
    if (self.EDLeader)
    {
        [self.EDLeader reportPathTosuperior:doorplate empo:empo];
    }
}
@end
