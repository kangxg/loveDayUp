//
//  ETTTestPaperReconnectPushAnimationManager.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETTTestPaperReconnectPushAnimationManager;

@protocol testPaperReconnectPushAnimationDelegate <NSObject>

@required

- (void)removePushAnimationWithManager:(ETTTestPaperReconnectPushAnimationManager *)manager;

@end

@interface ETTTestPaperReconnectPushAnimationManager : NSObject

@property (weak, nonatomic)id <testPaperReconnectPushAnimationDelegate>delegate;


/**
 课堂重连学生获得推试卷动画
 */
- (void)addTestPaperReconnectPushAnimation;


/**
 课堂重连推试卷动画移除
 */
- (void)removeTestPaperReconnectPushAnimation;

@end
