//
//  AXPPolygonManager.h
//  特殊图形
//
//  Created by Li Kaining on 16/8/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^completionBlock)(NSMutableDictionary *polygonDict);
typedef void(^drawPathBlock)(UIBezierPath *linePath ,NSMutableDictionary *polygonSymbols);
typedef void(^completionDashBlock)(UIBezierPath *dashPath);

@interface AXPPolygonManager : NSObject

// 标记起始点
@property(nonatomic) NSInteger currentIndex;

@property(nonatomic ,strong) NSMutableArray *points;

@property(nonatomic ,strong) NSMutableArray *symbols;

// 存放贝塞尔曲线的路径
@property(nonatomic ,strong) NSMutableArray *linePaths;

@property(nonatomic ,strong) UIButton *finishedButton;

// 多边形标注点位置
@property(nonatomic ,strong) NSMutableDictionary *polygonSymbols;

/*
 *  @author DeveloperLx, 16-09-01 17:09:44
 *
 *  @brief 存放特殊图形相关的数据数组.数组中存放的是字典,每一个字典代表一个特殊图形.
 *
 *  字典的 key 值就是特殊图形的标记名称,如: ABC ,ABCD, AB 等等.
 *  字典的 object 是一个数组,这个数组包含三个部分:
 *  1> 特殊图形的顶点数组: 每一个数组中都存放着一个特殊图形的所有顶点.
 *  2> 特殊图形的路径: 特殊图形的路径是一个 UIBezierPath.
 *  3> 特殊图形的标注点字典: 将特殊图形的所有标注点数据信息都存放在这个字典中.
 *  这个字典中的每一条数据都是一个标注点的数据信息.包含以下内容:
 *  key: 标注点名称,如:A,B,C...Z9 ; obj: 标注点的位置,是一个转换成字符串的 CGPoint.
 *
 *  @since 1.0
 */
@property(nonatomic ,strong) NSMutableArray *polygonElements;

+(instancetype)sharedManager;

#pragma mark -- 直线 :直线,射线

/**
 *  @author DeveloperLx, 16-08-23 09:08:44
 *
 *  @brief 添加直线/线段并且添加标记
 *
 *  @param points 点坐标数组
 *
 *  @since 0.0
 */
-(void)addLineAndSymbolmarkWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

/**
 *  @author DeveloperLx, 16-08-23 09:08:13
 *
 *  @brief 添加射线
 *
 *  @param points 点坐标数组
 *
 *  @since 0.0
 */
-(void)addRayLineAndSymbolmarkWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

#pragma mark -- 三角形 :任意三角形,等边三角形,直角三角形,等腰三角形

/**
 *  @author DeveloperLx, 16-08-23 09:08:29
 *
 *  @brief 添加三角形并且添加三角形顶点标注
 *
 *  @param points 点坐标数组(三角形顶点)
 *
 *  @since 0.0
 */
-(void)addTriangleAndSymbolmarkWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

/**
 *  @author DeveloperLx, 16-08-30 10:08:20
 *
 *  @brief 添加等边三角形
 *
 *  @param points 等边三角形的前两个点
 *
 *  @since 0.0
 */
-(void)addEquilateralTriangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

/**
 *  @author DeveloperLx, 16-08-30 10:08:06
 *
 *  @brief 添加直角三角形
 *
 *  @param points 原始三角形三个点坐标
 *
 *  @since 0.0
 */
-(void)addRightAngleTriangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

/**
 *  @author DeveloperLx, 16-08-30 11:08:52
 *
 *  @brief 添加等腰三角形
 *
 *  @param points 原始三角形三个点坐标
 *
 *  @since 0.0
 */
-(void)addIsoscelesTriangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

#pragma mark -- 四边形 :正方形,长方形,平行四边形
/**
 *  @author DeveloperLx, 16-08-26 17:08:21
 *
 *  @brief 添加正方形(两个点)
 *
 *  @param points 两个点数组
 *
 *  @since 0.0
 */
-(void)addSquareWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;
/**
 *  @author DeveloperLx, 16-08-26 17:08:15
 *
 *  @brief 添加长方形(三个点)
 *
 *  @param points 三个点(长方形的前三个点)
 *
 *  @since 0.0
 */
-(void)addRectangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

/**
 *  @author DeveloperLx, 16-08-26 17:08:55
 *
 *  @brief 添加平行四方形(三个点)
 *
 *  @param points 三个点(平行四边形的前三个点)
 *
 *  @since 0.0
 */
-(void)addParallelogramWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;

#pragma mark -- 多边形 :任意多边形

/**
 *  @author DeveloperLx, 16-08-30 10:08:35
 *
 *  @brief 添加多边形
 *
 *  @param points       多边形的前两个点坐标
 *  @param drawRectView 完成按钮添加在哪个View.
 *
 *  @since 0.0
 */
-(void)addPolygonPoints:(NSArray *)points drawRectView:(UIView *)drawRectView drawPath:(drawPathBlock)drawPath completionDashPath:(completionDashBlock)dashPath completion:(completionBlock)completion;

#pragma mark -- 圆 :任意圆

/**
 *  @author DeveloperLx, 16-08-31 16:08:43
 *
 *  @brief 通过两点(直径)添加圆
 *
 *  @param points 直径的两个点
 *
 *  @since 0.0
 */
-(void)addArcWithDiameterPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion;


// 添加多边形标注字典
-(void)addPolygonSymbolWithPolygonApex:(NSArray *)polygonApex andSymbol:(NSArray *)symbols toDicts:(NSMutableDictionary *)dict;

#pragma mark -- 添加直角和等腰标识
/**
 *  @author DeveloperLx, 16-11-17 11:11:32
 *
 *  @brief 添加直角和等腰标识
 *
 *  @param points      三角形的三个顶点坐标数组
 *  @param polygonPath 三角形的 bezierPath
 *
 *  @since 0.0
 */
+(void)addRigthAngleMarkAndIsoscelesMarkWithTriangleApexs:(NSArray *)points andPath:(UIBezierPath *)polygonPath;

@end
