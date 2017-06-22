//
//  ETTRemindManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRemindManager.h"
#import "ETTBaseRemindView.h"
#import "ETTRemindDelegate.h"
#import <objc/runtime.h>
@interface ETTRemindManager()<ETTRemindDelegate>

@end

@implementation ETTRemindManager
+(instancetype)shareRemindManager
{
    static ETTRemindManager * manager = nil;
    if (manager == nil)
    {
        manager = [[ETTRemindManager alloc]init];
    }
    
    return manager;
}
-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType
{

    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    return [self createRemindView:ViewType withSuperView:window];

}

-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withCount:(NSInteger)count
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    return [self createRemindView:ViewType withSuperView:window withCount:count];
}
-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withSuperView:(UIView *)superView
{
    
    return [self createRemindView:ViewType withSuperView:superView withCount:1];
}

-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withSuperView:(UIView *)superView withCount:(NSInteger)count
{
   
    id<ETTRemindViewInterface> remindview  = (ETTBaseRemindView *)[self getRemindView:ViewType];
    if (remindview == nil )
    {
        remindview = [ETTBaseRemindView createRemindView:ViewType withSuperView:superView];
        remindview.YVDelegate = self;
        [self setAssociatedObject:remindview];
    }
    else
    {
        if (remindview.YVType == ViewType)
        {
            [remindview animatedAgain];
        }
        else
        {
            if (remindview.YVType !=ETTLOCKSCREEViEW)
            {
                [self deleteAssociatedObject];
                remindview = [ETTBaseRemindView createRemindView:ViewType withSuperView:superView];
                remindview.YVDelegate = self;
                [self setAssociatedObject:remindview];
            }
           
        }
    }
    
    return remindview;
}
-(id<ETTRemindViewInterface>)getRemindView:(ETTRemindViewType)ViewType
{
    if (ViewType == ETTLOCKSCREEViEW) {
        ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindLockScreenAssociatedKey);
        return view;
    }
    else
    {
        ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindAssociatedKey);
        return view;
    }
    return nil;

}

-(id<ETTRemindViewInterface>)getRemindView
{
    ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self,RemindLockScreenAssociatedKey);
    if (view == nil)
    {
        view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindAssociatedKey);
    }
    return view;
}
-(void)deblockingRemindView
{
    ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self,RemindLockScreenAssociatedKey);
    if (view)
    {
        objc_setAssociatedObject(self, RemindLockScreenAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [view deblockingRemindView];
    }

}
-(void)setAssociatedObject:(id<ETTRemindViewInterface>)view
{
    if (view)
    {
        if (view.YVType == ETTLOCKSCREEViEW)
        {
            objc_setAssociatedObject(self, RemindLockScreenAssociatedKey, view, OBJC_ASSOCIATION_ASSIGN);
        }
        else
        {
            [self deleteAssociatedObject];
            
            objc_setAssociatedObject(self, RemindAssociatedKey, view, OBJC_ASSOCIATION_ASSIGN);
        }
        

    }
}

-(void)deleteAssociatedObject
{
    ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindAssociatedKey);
    if (view && view.YVType != ETTLOCKSCREEViEW)
    {
        objc_setAssociatedObject(self, RemindAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [view removeRemindview];
    }

}
-(void)removeRemindView
{
    ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindAssociatedKey);
    if (view)
    {
        objc_setAssociatedObject(self, RemindAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [view removeRemindview];
    }
}

-(NSInteger )pGetRemindCount
{
    return 1;
}

-(void)pRemoveRemindView
{
    [self removeRemindView];
}


-(void)removeResponderRemindView
{
    ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindAssociatedKey);
    if (view && view.YVType == ETTRESPONDERVIEW)
    {
        objc_setAssociatedObject(self, RemindAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [view removeRemindview];
    }
    
  
}

-(void)removeRollCallRemindView
{
    ETTBaseRemindView * view = (ETTBaseRemindView *)objc_getAssociatedObject(self, RemindAssociatedKey);
    if (view && view.YVType == ETTROLLCALLVIEW)
    {
        objc_setAssociatedObject(self, RemindAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [view removeRemindview];
    }

}

@end
