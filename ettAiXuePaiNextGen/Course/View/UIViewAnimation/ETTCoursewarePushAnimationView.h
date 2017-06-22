//
//  ETTCoursewarePushAnimationView.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"

@protocol ETTCoursewarePushAnimationViewDelegate <NSObject>

@optional


/**
 删除动画
 */
- (void)removeCoursewarePushAnimationView;

@end

@interface ETTCoursewarePushAnimationView : ETTView

@property (weak, nonatomic) id<ETTCoursewarePushAnimationViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andAnimationTime:(NSInteger)animationTime;

@end
