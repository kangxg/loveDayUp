//
//  ETTCharacterAnimationManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCharacterAnimationManager.h"
#import "ETTBaseCharAnimationView.h"
#import "ETTRemindDelegate.h"
#import <objc/runtime.h>
@interface ETTCharacterAnimationManager()<ETTRemindDelegate>

@end

@implementation ETTCharacterAnimationManager
+(instancetype)shareAnimationManager
{
    static ETTCharacterAnimationManager * manager = nil;
    if (manager == nil)
    {
        manager = [[ETTCharacterAnimationManager alloc]init];
    }
    
    return manager;
}
-(id<ETTCharAnimationInterface>)createAnimationView:(ETTCharAnimationViewType)ViewType info:(id)info
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    return [self createAnimationView:ViewType withSuperView:window info:info];
}

-(id<ETTCharAnimationInterface>)createAnimationView:(ETTCharAnimationViewType)ViewType withSuperView:(UIView *)superView info:(id)info
{
    id <ETTCharAnimationInterface> animationView = (ETTBaseCharAnimationView *)[self getRemindView:ViewType];
    if (animationView == nil )
    {
        animationView = [ETTBaseCharAnimationView createAnimationView:ViewType withSuperView:superView info:info];
        animationView.EVDelegate = self;
        [self setAssociatedObject:animationView];
    }
    else
    {
        if (animationView.EVType == ViewType)
        {
            [animationView animatedAgain:info];
        }
        else
        {
         
            [self deleteAssociatedObject];
            animationView = [ETTBaseCharAnimationView createAnimationView:ViewType withSuperView:superView info:info];
            animationView.EVDelegate = self;
            [self setAssociatedObject:animationView];
        
            
        }
    }

   return animationView;
}
-(void)removeAnimationView
{
     ETTBaseCharAnimationView * view = ( ETTBaseCharAnimationView *)objc_getAssociatedObject(self, CharAnimationKey);
    if (view)
    {
        objc_setAssociatedObject(self, CharAnimationKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [view removeAnimationView];
    }
}
-(void)pRemoveRemindView
{
    [self removeAnimationView];
}

-(id<ETTCharAnimationInterface>)getRemindView:(ETTCharAnimationViewType)ViewType
{
  
        ETTBaseCharAnimationView * view = (ETTBaseCharAnimationView *)objc_getAssociatedObject(self, CharAnimationKey);
        return view;
    
}
                                
-(void)setAssociatedObject:(id<ETTCharAnimationInterface>)view
{
    if (view)
    {
        [self deleteAssociatedObject];
        
        objc_setAssociatedObject(self, CharAnimationKey, view, OBJC_ASSOCIATION_ASSIGN);
        
    }
}
-(void)deleteAssociatedObject
{
    ETTBaseCharAnimationView * view = (ETTBaseCharAnimationView *)objc_getAssociatedObject(self, RemindAssociatedKey);
  
    objc_setAssociatedObject(self, CharAnimationKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [view removeAnimationView];
}
                                

@end
