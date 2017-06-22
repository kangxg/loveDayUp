//
//  ETTPaintbrushManager.h
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/20.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^pathCreated)(NSDictionary <UIBezierPath *,UIColor *>*bezierDict);

@interface ETTPaintbrushManager : NSObject

// 画笔颜色
@property(nonatomic ,strong) UIColor *paintbrushColor;

// 画笔宽度
@property(nonatomic ,assign) CGFloat paintbrushWidth;

// 画笔颜色透明度
@property(nonatomic ,assign) CGFloat paintbrushColorAlpha;


+(instancetype)sharedManager;

/**
 *  @author DeveloperLx, 16-07-20 15:07:09
 *
 *  @brief 创建路径
 *
 *  @param startPoint       路径的起始点
 *  @param completionHandle 路径创建完毕的回调
 *
 *  @since 0.0
 */
-(void)createBezierPathWithStartPoint:(CGPoint)startPoint completionHandle:(pathCreated)completionHandle;

/**
 *  @author DeveloperLx, 16-07-20 15:07:44
 *
 *  @brief 向路径中新增路径(一条路径中加入多个点)
 *
 *  @param addPoint         新增的路径点
 *  @param completionHandle 路径增加完毕之后的回调
 *
 *  @since 0.0
 */
-(void)addPointToBezierPath:(CGPoint)addPoint completionHandle:(pathCreated)completionHandle;


@end
