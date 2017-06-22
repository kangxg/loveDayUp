//
//  AXPWhiteboardConfiguration.h
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AXPWhiteboardConfiguration : NSObject<NSCoding>

+(instancetype)sharedConfiguration;

-(void)saveConfiguration;

-(void)setUpDefaultConfiguration;

// 推送状态
@property(nonatomic ) BOOL isWhiteboardPushing;

// 互批状态
@property(nonatomic ) BOOL isMutualCorrect;

// 每次进入,默认选择画笔
@property(nonatomic ) NSInteger brushSelected;

// 设置
@property(nonatomic ,copy) NSString *toolbar;
@property(nonatomic ,copy) NSString *apexStyle;
@property(nonatomic ) BOOL showGridLine;
@property(nonatomic ) BOOL showSymbol;

// 画笔
@property(nonatomic ) BOOL isFirstUseBrush;
@property(nonatomic ,copy) NSString *brushColorStr;
@property(nonatomic ,strong) UIColor *brushColor;
@property(nonatomic ) CGFloat brushAlpha;
@property(nonatomic ) CGFloat brushSize;

// 橡皮擦
@property(nonatomic ) BOOL isFirstUseEraser;
@property(nonatomic ) CGFloat eraserSize;

// 画桶颜色
@property(nonatomic ) BOOL isFirstUseBucket;
@property(nonatomic ,copy) NSString *bucketColorStr;
@property(nonatomic ,strong) UIColor *bucketColor;

// 文字
@property(nonatomic ) BOOL isFirstUseText;
@property(nonatomic ,strong) UIColor *textColor;
@property(nonatomic ) CGFloat textFontSize;


// 直线
@property(nonatomic ) NSInteger selectedLine;
@property(nonatomic ) BOOL isFirstDrawLine;
@property(nonatomic ) BOOL isFirstDrawRayLine;

// 三角形
@property(nonatomic ) NSInteger selectedTriangle;
@property(nonatomic ) BOOL isFirstDrawTriangle;
@property(nonatomic ) BOOL isFirstDrawRightTriangle;
@property(nonatomic ) BOOL isFirstDrawIsocelesTriangle;
@property(nonatomic ) BOOL isFirstDrawRegularTriangle;

// 四边形
@property(nonatomic ) NSInteger selectedQuadrangle;
@property(nonatomic ) BOOL isFirstDrawSquare;
@property(nonatomic ) BOOL isFirstDrawRectangle;
@property(nonatomic ) BOOL isFirstDrawQuadrangle;
@property(nonatomic ) BOOL isFirstDrawParallelogram;
@property(nonatomic ) BOOL isFirstDrawQuadrilateral;

// 圆
@property(nonatomic ) NSInteger selectedCircle;
@property(nonatomic ) BOOL isFirstDrawCircle;


@end
