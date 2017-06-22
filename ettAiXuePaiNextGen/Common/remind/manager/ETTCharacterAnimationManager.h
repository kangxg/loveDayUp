//
//  ETTCharacterAnimationManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTCharAnimationInterface.h"
@interface ETTCharacterAnimationManager : NSObject
+(instancetype)shareAnimationManager;
-(id<ETTCharAnimationInterface>)createAnimationView:(ETTCharAnimationViewType)ViewType info:(id)info;

-(id<ETTCharAnimationInterface>)createAnimationView:(ETTCharAnimationViewType)ViewType withSuperView:(UIView *)superView info:(id)info;;
//传入动画类型 superView：父视图 参数  count

@end
