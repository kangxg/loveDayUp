//
//  ETTGuradCaptainModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTGuradCaptainModel.h"
#import "ETTNormalGuardModel.h"
#import "ETTTakecareRegistrationModel.h"
@interface ETTGuradCaptainModel()
@property (nonatomic,retain)NSMutableArray <ETTNormalGuardModel *> * MDGuardModelArr;
@end

@implementation ETTGuradCaptainModel
@synthesize  MDGuardModelArr = _MDGuardModelArr;
@synthesize  EDTokenPath     = _EDTokenPath;
@synthesize  EDCurrentGuradEmpno = _EDCurrentGuradEmpno;
-(void)initGuardData
{
    _EDTokenPath = 0;
    if (_MDGuardModelArr == nil)
    {
        _MDGuardModelArr = [[NSMutableArray alloc]init];
    }
    if (_MDGuardModelArr.count)
    {
        [_MDGuardModelArr removeAllObjects];
    }
    ETTNormalGuardModel * normalGurad = [[ETTNormalGuardModel alloc]initGuard:self.EDEDWorkUnitVC unitName:self.EDWorkUnitName];
    normalGurad.EDLeader = self;
    self.EDEDWorkUnitVC.EVGuardModel = normalGurad;
    
    normalGurad.EDGuradArchive =  ETTGuradArchiveMake(-1, 0, ETTVCHANDLENONE);
    _EDCurrentGuradEmpno = normalGurad.EDGuradArchive.empno;
    [_MDGuardModelArr addObject:normalGurad];
    
}


-(void)setEDGuradArchive:(ETTGuradArchive)EDGuradArchive
{
    [super setEDGuradArchive:EDGuradArchive];
    ETTNormalGuardModel * normalGurad = _MDGuardModelArr.firstObject;
    if (normalGurad)
    {
        [normalGurad setDoorplate:self.EDGuradArchive.doorplate];
        [self sumToken:normalGurad];
    }
   
}

-(void )registerGurad:(ETTViewController *)vc withParentModel:(ETTNormalGuardModel *)guradModel withHandle:(ETTGuradHandle)handle
{
    if (vc)
    {
        ETTNormalGuardModel * lastGurad = _MDGuardModelArr.lastObject;
        if (lastGurad.EDEDWorkUnitVC == vc)
        {
            _EDCurrentGuradEmpno = lastGurad.EDGuradArchive.empno;
            return;
        }
        ETTNormalGuardModel * normalGurad = [[ETTNormalGuardModel alloc]initGuard:vc unitName:NSStringFromClass([vc class])];
        
        normalGurad.EDLeader = self;
        normalGurad.EDGuradArchive = ETTGuradArchiveMake(self.EDGuradArchive.doorplate, _MDGuardModelArr.count, handle);
        vc.EVGuardModel  = normalGurad;
        
      _EDCurrentGuradEmpno = normalGurad.EDGuradArchive.empno;
        normalGurad.EDTokenPath = guradModel.EDGuradArchive.empno;
      [_MDGuardModelArr addObject:normalGurad];
    }
}

-(BOOL)canOpenDoor:(ETTViewController *)vc withNum:(NSInteger)doorplat
{
    if (vc == self.EDEDWorkUnitVC)
    {
        return YES;
    }
    return false;
}

-(void)removeGurad:(ETTNormalGuardModel *)guardModel
{
    if ([_MDGuardModelArr containsObject:guardModel] )
    {
        [self subToken:guardModel];
       
        [_MDGuardModelArr removeObject:guardModel];

    }

    
}

-(void)deleteGurad:(ETTNormalGuardModel *)guardModel
{
    [self removeGurad:guardModel];
    [guardModel resetGuard];
    guardModel = nil;
}
-(void)removeGurad:(ETTNormalGuardModel *)guardModel takeRegist:(ETTTakecareRegistrationModel *)takecareModel
{
    if (self.EDGuradArchive.doorplate == takecareModel.EDDoorplate)
    {
        if (guardModel.EDGuradArchive.empno<= takecareModel.EDEmpo)
        {
         
            _EDCurrentGuradEmpno = guardModel.EDGuradArchive.empno -1;
            
            [self reportPathTosuperior:self.EDGuradArchive.doorplate empo:_EDCurrentGuradEmpno];
        }
        else
        {
            ETTNormalGuardModel * model = _MDGuardModelArr[takecareModel.EDEmpo];
            if ((guardModel.EDGuradArchive.empno-1) == model.EDGuradArchive.empno)
            {
                if (guardModel.EDGuradArchive.guradHandle ==ETTVCHANDLEPUSH)
                {
                    _EDCurrentGuradEmpno = guardModel.EDTokenPath;
                }
                else
                {
                    _EDCurrentGuradEmpno = model.EDGuradArchive.empno -1;
                }
            }
            else
            {
                _EDCurrentGuradEmpno = guardModel.EDGuradArchive.empno -1;
            }
            [self reportPathTosuperior:self.EDGuradArchive.doorplate empo:_EDCurrentGuradEmpno];
            [self removeGurad:guardModel];
        }
    }
    else
    {
        [self deleteGurad:guardModel];
       
    }

    
}
-(void)showIsPushingview:(ETTTakecareRegistrationModel *)takeModel
{
    if (takeModel== nil || takeModel.EDEmpo<0)
    {
        return;
    }
    if (takeModel.EDEmpo>(_MDGuardModelArr.count-1))
    {
        return;
    }
    if (takeModel.EDEmpo == _MDGuardModelArr.firstObject.EDGuradArchive.empno)
    {
        return;
    }
    if (_MDGuardModelArr.lastObject.EDGuradArchive.empno>takeModel.EDEmpo)
    {
        [self popView:_MDGuardModelArr.lastObject index:_MDGuardModelArr.lastObject.EDGuradArchive.empno-1 takecare:takeModel];
        [self showView:_MDGuardModelArr[_EDCurrentGuradEmpno].EDEDWorkUnitVC index:_MDGuardModelArr[_EDCurrentGuradEmpno].EDGuradArchive.empno+1 takecare:takeModel];
        
    }
    else
    {
        if (_MDGuardModelArr[_EDCurrentGuradEmpno].EDGuradArchive.empno == takeModel.EDEmpo)
        {
            ETTNormalGuardModel * rommmodel =_MDGuardModelArr[_EDCurrentGuradEmpno];
             ETTViewController * vctr = rommmodel.EDEDWorkUnitVC;
            if (rommmodel.EDRoomView)
            {
                [vctr returnBindingRoomView:rommmodel.EDRoomView];
            }
            
        }
        else
        {
             [self showView:_MDGuardModelArr[_EDCurrentGuradEmpno].EDEDWorkUnitVC index:_MDGuardModelArr[_EDCurrentGuradEmpno].EDGuradArchive.empno+1 takecare:takeModel];
        }
    }
}

-(void)showView:(ETTViewController *)vc index:(NSInteger )index takecare:(ETTTakecareRegistrationModel *)takeModel
{
    if (index>takeModel.EDEmpo)
    {
        return;
    }
    ETTNormalGuardModel * model =_MDGuardModelArr[index];
    ETTViewController * vctr = model.EDEDWorkUnitVC;
    if (model.EDGuradArchive.guradHandle == ETTVCHANDLEPUSH)
    {
        [vc.navigationController pushViewController:vctr animated:false];
        if (model.EDRoomView)
        {
            [vctr returnBindingRoomView:model.EDRoomView];
        }
    }
    else if (model.EDGuradArchive.guradHandle == ETTVCHANDLEPRESENT)
    {
        [vc presentViewController:vctr animated:false completion:nil];
        if (model.EDRoomView)
        {
            [vctr returnBindingRoomView:model.EDRoomView];
        }
    }
    
    _EDCurrentGuradEmpno ++;
    [self showView:vctr index:model.EDGuradArchive.empno+1 takecare:takeModel];
    
}

-(void)popView:(ETTNormalGuardModel *)guardModel index:(NSInteger )index takecare:(ETTTakecareRegistrationModel *)takeModel

{
    if (index<takeModel.EDEmpo)
    {
        return;
    }
    [self removeGurad:guardModel takeRegist:takeModel];
    
    ETTNormalGuardModel * model =_MDGuardModelArr[_EDCurrentGuradEmpno];
    if (guardModel.EDGuradArchive.guradHandle == ETTVCHANDLEPUSH)
    {
        [guardModel.EDEDWorkUnitVC.navigationController popViewControllerAnimated:false];
    }
    else if (guardModel.EDGuradArchive.guradHandle == ETTVCHANDLEPRESENT)
    {
        NSLog(@"dismiss");
        [guardModel.EDEDWorkUnitVC dismissViewControllerAnimated:false completion:nil];
    }
    
    [self popView:model index:(model.EDGuradArchive.empno-1) takecare:takeModel];

}
-(BOOL)getCurrentDoorplate:(NSInteger )tokenPath
{
//    NSInteger dooplate = tokenPath%10;
     NSInteger dooplate = self.EDGuradArchive.doorplate;
    return  dooplate ;
}
-(BOOL)getNeedNoticeLastGurad
{
    if (_EDCurrentGuradEmpno<0 || _EDCurrentGuradEmpno>(_MDGuardModelArr.count-1))
    {
        return false;
    }
    ETTNormalGuardModel * model = _MDGuardModelArr[_EDCurrentGuradEmpno];
    return model.EDGuradArchive.needNotice;
}
-(void)subToken:(ETTNormalGuardModel *)guardModel
{
    _EDTokenPath = (_EDTokenPath/10 -guardModel.EDGuradArchive.empno * pow(10,guardModel.EDGuradArchive.empno))*10+ self.EDGuradArchive.empno ;
     [self reportPathTosuperior:self.EDGuradArchive.doorplate empo:_EDCurrentGuradEmpno];
   
}
-(ETTNormalGuardModel *)getCurrentGuardModel:(NSInteger )empo
{
    if (empo<0 || empo>(_MDGuardModelArr.count-1))
    {
        return nil;
    }
    return _MDGuardModelArr[empo];
}
-(ETTNormalGuardModel *)getCurrentGuardModel
{
    if (_EDCurrentGuradEmpno<0||_EDCurrentGuradEmpno>(_MDGuardModelArr.count-1))
    {
        return nil;
    }
    
    return _MDGuardModelArr[_EDCurrentGuradEmpno];
}
-(void)reportPathTosuperior:(NSInteger)doorplate empo:(NSInteger)empo
{
    if (self.EDLeader)
    {
         [self.EDLeader reportPathTosuperior:doorplate empo:empo];
    }
   
}
-(void)sumToken:(ETTNormalGuardModel *)guradModel
{
    
    _EDTokenPath = (_EDTokenPath/10 + guradModel.EDGuradArchive.empno * pow(10,guradModel.EDGuradArchive.empno))*10 + self.EDGuradArchive.empno ;
    [self reportPathTosuperior:self.EDGuradArchive.doorplate empo:_EDCurrentGuradEmpno];


}
@end
