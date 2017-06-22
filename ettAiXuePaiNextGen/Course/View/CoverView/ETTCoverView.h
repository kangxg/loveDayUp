//
//  ETTCoverView.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"


@protocol ETTCoverViewDelegate <NSObject>

@optional
- (void)removeCoverViewFromSuperView;
- (void)removeSynchronizeCoverViewFromSuperView;

@end

@interface ETTCoverView : ETTView


/**
 打开课件之前的动画

 @param frame <#frame description#>
 @param title <#title description#>

 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame labelTitle:(NSString *)title;


/**
 教师推送课件pdf/试卷的动画

 @param frame <#frame description#>
 @param title <#title description#>

 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame progressViewTitle:(NSString *)title;


/**
 老师推课件 学生显示正在同步

 @param frame <#frame description#>
 @param title <#title description#>

 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame synchronizeViewTitle:(NSString *)title;


@property (weak, nonatomic) id <ETTCoverViewDelegate> delegate;

@end
