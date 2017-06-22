//
//  ETTScenePorter.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/5.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTScenePorter.h"
#import "ETTNormalGuardModel.h"
#import "ETTGuradCaptainModel.h"
#import "ETTBackToPushView.h"
#import "ETTViewDelegate.h"
#import "ETTBackToPageManager.h"
#import "ETTTravelRecordsModel.h"
#import "ETTTakecareRegistrationModel.h"
#import "AXPWhiteboardToolbarManager.h"
#import "ETTCoursewareStackManager.h"
#import "Aspects.h"

@interface ETTScenePorter ()<ETTViewDelegate,ETTGuardModelInterface>
@property(nonatomic,retain)ETTBackToPushView              * MVPushView;
@property(nonatomic,retain)ETTTravelRecordsModel          * MVTravelRecords;
@property(nonatomic,retain)ETTTakecareRegistrationModel   * MVTakecareRegist;
@property(nonatomic,weak)  id<AspectToken>                  MVAspecttoken;

@property(nonatomic,weak)  id<AspectToken>                  MVAspectBindtoken;
@property(nonatomic,assign)ETTSideNavigationViewIdentity    MVViewIdentity;
@end
static  ETTScenePorter * porter = nil;
static dispatch_once_t onceToken;

@implementation ETTScenePorter
@synthesize EVGuradManager   = _EVGuradManager;
@synthesize EVPorterDelegate = _EVPorterDelegate;
@synthesize EDViewRecordManager  = _EDViewRecordManager;
+(instancetype)shareScenePorter
{
    dispatch_once(&onceToken, ^{
       porter = [[ETTScenePorter  alloc]init];
    });
    return porter;

}
+(void)attempDealloc
{
    if (porter.MVViewIdentity  == ETTSideNavigationViewIdentityTeacher)
    {
        [porter resetScenePorterSystem];
    }
    onceToken = 0;

    porter = nil;
    
}
 -(id)init
{
    if (self = [super init])
    {
        _MVViewIdentity    = ETTSideNavigationViewIdentityNone;
        _MVTravelRecords   = [[ETTTravelRecordsModel alloc]init];
        _MVTakecareRegist  = [[ETTTakecareRegistrationModel alloc]init];
        
        _EDViewRecordManager  =[[ETTViewsLoadedRecordManager alloc]init];
        [self initData];
        
}
    return self;
}

-(void)initData
{
    [self registPushingObserver];
    [self.EVGuradManager resetManagerSystem];
    [self registAspectoken];

}
-(void)resetScenePorterSystem
{
    [[AXPWhiteboardToolbarManager sharedManager] resetWhiteboardManager];;
    [self removePushingObserver];
    [[ETTBackToPageManager sharedManager] endPushing];
    [self hidenIspushView];
    [_EVGuradManager resetManagerSystem];
    [_MVAspecttoken remove];
    [_MVTravelRecords resetTravelRecords];
    [_MVTakecareRegist resetTakecareRegistration];
    [_EDViewRecordManager resetManagerSystem];
}
-(void)registPushingObserver
{
    [[ETTBackToPageManager sharedManager] addObserver:self forKeyPath:@"isPushing" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)registAspectoken
{
    if (_MVAspecttoken)
    {
        [_MVAspecttoken remove];
    }
WS(weakSelf);
   _MVAspecttoken= [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)  {
        [weakSelf showPushingView];
    }error:nil];
    
    if (_MVAspectBindtoken)
    {
        [_MVAspectBindtoken remove];
    }
    
    _MVAspectBindtoken = [ETTViewController aspect_hookSelector:@selector(bindingViewReturnCallback) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)  {
         [weakSelf showPushingView];
    } error:nil];
    
}
-(void)removePushingObserver
{
     [[ETTBackToPageManager sharedManager]  removeObserver:self forKeyPath:@"isPushing"];
}
-(void)dealloc
{
   

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isPushing"] )
    {
        if ([[change valueForKey:@"new"]boolValue] )
        {
            if ([self checkCanShowPushView])
            {
                 [self showIspushView];
            }
           
        }
        else
        {
            [self hidenIspushView];
        }
    }
}
-(BOOL)checkCanShowPushView
{
    ETTGuradCaptainModel * model = [_EVGuradManager getguradCapationModel:_MVTravelRecords.EDCurrentPath];
    
    ETTNormalGuardModel  * guardModel = [model getCurrentGuardModel];

    
    if (porter.MVViewIdentity  != ETTSideNavigationViewIdentityTeacher)
    {
        return false;
    }

   
    if ([ETTBackToPageManager sharedManager].isPushing && ![self queryWhetherCanPushOperation:guardModel] &&  ![guardModel.EDEDWorkUnitVC donotDisturb])

    {
        return YES;
    }
    return false;
}
-(BOOL)queryWhetherCanPushOperation:(ETTNormalGuardModel *)guardModel
{
    if (!guardModel)
    {
        return false;
    }
    
    if (_MVTakecareRegist.EDDoorplate == guardModel.EDGuradArchive.doorplate && _MVTakecareRegist.EDEmpo == guardModel.EDGuradArchive.empno && !guardModel.EDRoomView && !guardModel.EDRoomView.hidden )

    {
        return YES;
    }
    return false;
}

-(BOOL)getGuradNeedNotice
{
    ETTGuradCaptainModel * model = [_EVGuradManager getguradCapationModel:_MVTravelRecords.EDCurrentPath];
    return [model getNeedNoticeLastGurad];
}

-(void)showIspushView
{
    if (!self.MVPushView.superview)
    {
        [self.MVPushView  showView:nil];
    }
    [self.MVPushView.superview bringSubviewToFront:self.MVPushView];
    [UIView animateWithDuration:0.5 animations:^{
        self.MVPushView.frame =CGRectMake(0, kSCREEN_HEIGHT-30, _MVPushView.width, 30);
    }];
}

-(void)hidenIspushView
{
    if (!self.MVPushView.superview)
    {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.MVPushView.frame =CGRectMake(0, kSCREEN_HEIGHT+30, _MVPushView.width, 30);
    }];
}

-(ETTBackToPushView *)MVPushView
{
    if (_MVPushView == nil)
    {
        _MVPushView = [[ETTBackToPushView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT+30, kSCREEN_WIDTH, 30)];
        _MVPushView.EVDelegate = self;
    }
    return _MVPushView ;
}

-(void)pViewSelected:(id)object
{
    [[ETTCoursewareStackManager new]stopCurrentAV:nil];
    
    if (_MVTakecareRegist.EDDoorplate == _MVTravelRecords.EDCurrentPath)
    {
         [self showIsPushingview];
    }
    else
    {
        if (self.EVPorterDelegate && [self.EVPorterDelegate respondsToSelector:@selector(pChangeViewFromDoorplate:)])
        {
            [self.EVPorterDelegate pChangeViewFromDoorplate:_MVTakecareRegist.EDDoorplate];
            [self showIsPushingview];
            
        }
    }
}

-(void)showIsPushingview
{
    ETTGuradCaptainModel  *captainModel = [_EVGuradManager getguradCapationModel:_MVTakecareRegist.EDDoorplate];
    [captainModel showIsPushingview:_MVTakecareRegist];
}
-(ETTGuradBattalionChiefModel *)EVGuradManager
{
    if (_EVGuradManager == nil)
    {
        _EVGuradManager = [[ETTGuradBattalionChiefModel alloc]init];
        _EVGuradManager.EDGuradArchive = ETTGuradArchiveMake(-1, 0, ETTVCHANDLENONE);
        _EVGuradManager.EDLeader = self;
    }
    return _EVGuradManager;
}

-(void )registerGuradCaptainManager:(ETTViewController *)vc type:(ETTSideNavigationViewIdentity)identity
{
    if (identity == ETTSideNavigationViewIdentityTeacher)
    {
        _MVViewIdentity = identity;
        [_EVGuradManager registerGuradCaptainManager:vc];
    }
}
-(void )registerGurad:(ETTViewController *)vc withGuard:(ETTNormalGuardModel *) guardModel withHandle:(ETTGuradHandle)handle
{
    if (guardModel == nil || vc == nil)
    {
        return;
    }
  
        ETTGuradCaptainModel * model = (ETTGuradCaptainModel *)guardModel.EDLeader;

        if (!model)
        {
           
            return;
        }
    
   
    
     [model registerGurad:vc withParentModel:guardModel withHandle:handle];
     model.EDTokenPath = guardModel.EDGuradArchive.empno;
    
}

-(void)removeGurad:(ETTNormalGuardModel *)guardModel
{
    if (guardModel== nil)
    {
        return;
    }
    
    ETTGuradCaptainModel * model = (ETTGuradCaptainModel *)guardModel.EDLeader;
    [model removeGurad:guardModel takeRegist:_MVTakecareRegist];
    
}
-(void)donotDisturbBackIntoTheRoom:(ETTNormalGuardModel * )guardModel withView:(UIView *)view;
{
    if (guardModel)
    {
        if (guardModel.EDRoomView == view)
        {
            [self hidenIspushView];
        }
    }
}

-(void)bindingViewToGuardModel:(ETTNormalGuardModel *)guardModel withView:(UIView *)view
{
    if (guardModel)
    {
        guardModel.EDRoomView = view;
    }
}

-(void)removeTheBindingViewToGuardModel:(ETTNormalGuardModel *)guardModel withView:(UIView *)view
{
    if (guardModel )
    {
        guardModel.EDRoomView = nil;
    }
}
-(void)showPushingView
{
    if ([self checkCanShowPushView])
    {
        [self showIspushView];
    }
    else
    {
        [self hidenIspushView];
    }
}
-(BOOL)canOpenDoor:(ETTViewController *)vc withNum:(NSInteger)doorplat
{
    return ( doorplat!= _MVTravelRecords.EDCurrentPath);
}


/**
 Description 注销快速返回备案
 */
-(void)cancellationRegistration:(ETTNormalGuardModel *)model
{
    
    if (_MVTakecareRegist && _MVTakecareRegist.EDDoorplate == model.EDGuradArchive.doorplate &&_MVTakecareRegist.EDEmpo == model.EDGuradArchive.empno  )
    {
        [_MVTakecareRegist resetTakecareRegistration];
    }
}
/**
 Description 确定备案
 
 @param token 口令
 */
-(void)enterRegistration:(ETTNormalGuardModel *)model
{
    if (_MVTakecareRegist.EDDoorplate >=0 && _MVTakecareRegist.EDEmpo>= 0)
    {
        return;
    }
    _MVTakecareRegist.EDDoorplate = model.EDGuradArchive.doorplate;
    _MVTakecareRegist.EDEmpo      = model.EDGuradArchive.empno;
}

/**
 Description  记录行踪
 
 @param from    来自哪里
 @param current 去往哪里
 */
-(void)recordWhereabouts:(NSInteger)from to:(NSInteger)current
{
    if (_MVTravelRecords)
    {
        _MVTravelRecords.EDFromPath = from;
        _MVTravelRecords.EDCurrentPath = current;
        
    }
}
-(void)reportPathTosuperior:(NSInteger)doorplate empo:(NSInteger)empo
{
    _MVTravelRecords.EDEmpo = empo;
}
@end
