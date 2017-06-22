//
//  AXPPolygonCalculateManager.h
//  特殊图形
//
//  Created by Li Kaining on 16/8/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#define kSymbolMargin 15

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AXPPolygonCalculateManager : NSObject


#pragma mark -- line 直线

/**
 *  @author DeveloperLx, 16-09-01 17:09:39
 *
 *  @brief 获取直线标注点坐标
 *
 *  @param startPoint 直线的"起始点"
 *  @param endPoint   直线的"终点"
 *
 *  @return 直线标注点坐标数组
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getLineSymbolPointWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 *  @author DeveloperLx, 16-08-26 15:08:07
 *
 *  @brief 任意点到已知直线垂线和直线的交点(垂足)坐标
 *
 *  @param pointA 直线第一个点
 *  @param pointB 直线第二个点
 *  @param pointC 任意点
 *
 *  @return 垂足坐标
 *
 *  @since 0.0
 */
+(CGPoint)getVerticalIntersectPointWithlinePointA:(CGPoint)pointA linePointB:(CGPoint)pointB andArbitraryPoint:(CGPoint)pointC;

#pragma mark -- triangle 三角形
/**
 *  @author DeveloperLx, 16-08-30 10:08:29
 *
 *  @brief 获取等边三角形
 *
 *  @param points 等边三角形前两个点数组
 *
 *  @return 等边三角形三个顶点数组
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getEquilateralTriangleWithPoints:(NSArray <NSString *>*)points;

/**
 *  @author DeveloperLx, 16-08-30 10:08:32
 *
 *  @brief 获取直角三角形
 *
 *  @param points 原三角形三个顶点数组
 *
 *  @return 直角三角形三个顶点数组
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getRightAngleTriangleWithPoints:(NSArray <NSString *>*)points;

/**
 *  @author DeveloperLx, 16-08-30 10:08:34
 *
 *  @brief 获取等腰三角形
 *
 *  @param points 原三角形三个顶点数组
 *
 *  @return 等腰三角形三个顶点数组
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getIsoscelesTriangleWithPoints:(NSArray <NSString *>*)triangleApex;

/**
 *  @author DeveloperLx, 16-08-19 11:08:45
 *
 *  @brief 获取三角形三个顶点的标注点坐标
 *
 *  @param triangleApex 三角形顶点数组
 *
 *  @return 三角形标注点数组(注意与传入的三角形顶点位置相对应)
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getTriangleSymbolPointWithTriangleApex:(NSArray <NSString *>*)triangleApex;


#pragma mark -- 四边形
/**
 *  @author DeveloperLx, 16-08-25 16:08:34
 *
 *  @brief 获取长方形的四个点
 *
 *  @param points 长方形前三个点
 *
 *  @return 长方形的四个点
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getRectangleWithThreePoints:(NSArray <NSString *>*)points;

/**
 *  @author DeveloperLx, 16-08-25 16:08:34
 *
 *  @brief 获取平行四边形的四个点
 *
 *  @param points 平行四边形的前三个点
 *
 *  @return 平行四边形的的四个点
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getParallelogramWithPoints:(NSArray <NSString *>*)points;

/**
 *  @author DeveloperLx, 16-08-26 16:08:44
 *
 *  @brief 获取正方形四个顶点
 *
 *  @param points 正方形的一条边坐标数组(两个顶点)
 *
 *  @return 正方形的四个顶点坐标
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getSquareWithPoints:(NSArray <NSString *>*)points;


#pragma mark -- triangle 多边形
/**
 *  @author DeveloperLx, 16-08-23 10:08:24
 *
 *  @brief 获取多边形各个标注点的位置
 *
 *  @param polygon 多边形顶点坐标数组
 *
 *  @return 多边形标注点数组
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getPolygonSymbolWithPolygon:(NSArray <NSString *>*)polygon;


#pragma mark -- expand 扩展功能
/**
 *  @author DeveloperLx, 16-08-19 11:08:01
 *
 *  @brief 获取三角形角平分线与对边的交点坐标
 *
 *  @param triangleApex 三角形顶点数组
 *
 *  @return 焦点数组(注意与传入的三角形顶点位置相对应)
 *
 *  @since 0.0
 */
+(NSArray <NSString *>*)getTriangleIntersectionPointWithTriangleApex:(NSArray <NSString *>*)triangleApex;

/**
 *  @author DeveloperLx, 16-08-19 11:08:55
 *
 *  @brief 利用顶点和焦点求标注点的位置
 *
 *  @param angleApex  三角形顶点
 *  @param focusPoint 过这个顶点的角平分线与对边的焦点
 *
 *  @return 标注点的位置
 *
 *  @since 0.0
 */
+(CGPoint)getSymbolPointWithAngleApex:(CGPoint)angleApex andIntersectionPoint:(CGPoint)focusPoint;

/**
 *  @author DeveloperLx, 16-08-31 11:08:01
 *
 *  @brief 直角三角形直角标识
 *
 *  @param triangleApex 三角形顶点坐标数组
 *
 *  @return 直角三角形标识
 *
 *  @since 0.0
 */
+(UIBezierPath *)addRightAngleMarkWithTrianglePoints:(NSArray <NSString *>*)triangleApex;

/**
 *  @author DeveloperLx, 16-09-01 15:09:09
 *
 *  @brief 添加等腰三角形的腰标识
 *
 *  @param triangleApex 三角形顶点坐标数组
 *
 *  @return 等腰三角形的腰标识数组(如果是等边三角形,返回三条边的标识)
 *
 *  @since 0.0
 */
+(NSArray <UIBezierPath *>*)addIsoscelesTriangleMarkWithPoints:(NSArray <NSString *>*)triangleApex;

/**
 *  @author DeveloperLx, 16-08-23 10:08:17
 *
 *  @brief 获取三角形顶点标注点坐标(只获取一个标注点,如传入三角形ABC,则获取B点标注点坐标)
 *
 *  @param triangleApex 三角形顶点数组
 *
 *  @return 三角形顶点标注点坐标
 *
 *  @since 0.0
 */
+(CGPoint)getTriangleApexSymbolPointWithTriangleApex:(NSArray <NSString *>*)triangleApex;


#pragma mark -- 判断触摸点是否在多边形内
/**
 *  @author DeveloperLx, 16-08-19 10:08:55
 *
 *  @brief 判断触摸点是否在多边形内
 *
 *  @param touchPoint 触摸点
 *  @param polygon    多边形顶点坐标数组
 *
 *  @return 如果在,返回YES,否则 NO.
 *
 *  @since 0.0
 */
+(BOOL)touchPoint:(CGPoint)touchPoint InPolygon:(NSArray <NSString *>*)polygon explan:(NSString *)explanStr;

/**
 *  @author DeveloperLx, 16-09-06 11:09:35
 *
 *  @brief 获取特殊图形最小的四边形frame
 *
 *  @param polygon 特殊图形标记点
 *
 *  @return 能够容纳特殊图形的最小四边形frame
 *
 *  @since 0.0
 */
+(CGRect)getPolygonMinRectWithPolygon:(NSArray *)polygon;

+(CGRect)getPolygonMinRectWithPolygon:(NSArray *)polygon explan:(NSString *)explanStr;

/**
 *  @author DeveloperLx, 16-09-07 11:09:38
 *
 *  @brief 计算缩放之后特殊特性的顶点坐标
 *
 *  @param polygon 缩放前特殊图形的顶点坐标
 *  @param frame   缩放之后特殊图形的frame
 *
 *  @return 缩放后特殊图形的顶点坐标
 *
 *  @since 0.0
 */
+(NSArray *)getPinchPolygonWithOriginalPolygon:(NSArray *)polygon andPinchedFrame:(CGRect)frame;

+(NSArray *)getCirclePinchPointWithCircle:(NSArray *)circle pinchedFrame:(CGRect)frame;


@end
