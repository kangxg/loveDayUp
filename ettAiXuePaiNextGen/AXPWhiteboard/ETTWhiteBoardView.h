//
//  ETTWhiteBoardView.h
//  whiteboardDemo
//
//  Created by DeveloperLx on 16/7/11.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPWhiteboardConfiguration.h"
#import "AXPBrushView.h"
#import "AXPTextContantView.h"
#import "AXPPolygonContantView.h"

typedef enum : NSUInteger {
    AXPPhotoImage = 0,
    AXPCoursewareImage = 1,
    AXPPushImage = 2,
} AXPImageSource;

typedef enum : NSUInteger {
    AXPPolygonAddLine = 0,
    AXPolygonAddRayLine = 1,
} AXPPolygonLine;

typedef enum : NSUInteger {
    AXPPolygonAddTriangle = 0,
    AXPPolygonAddRightTriangle = 1,
    AXPPolygonAddIsocelesTriangle = 2,
    AXPPolygonAddRegularTriangle = 3,
} AXPPolygonTriangle;

typedef enum : NSUInteger {
    AXPPolygonAddSquare = 0,
    AXPPolygonAddRectangle = 1,
    AXPPolygonAddRegularParallelogram = 2,
    AXPPolygonAddRegularQuadrilateral = 3,
} AXPPolygonQuadrangle;

typedef enum : NSUInteger {
    AXPPolygonAddCircle = 0,
} AXPPolygonCircle;

@interface ETTWhiteBoardView : UIView

@property(nonatomic ,strong) AXPBrushView *brushView;
@property(nonatomic ,strong) AXPTextContantView *textContantView;
@property(nonatomic ,strong) AXPPolygonContantView *polygonContantView;

@property(nonatomic ,strong) AXPWhiteboardConfiguration *whiteboardConfig;

// 路径数组 -- 按添加顺序记录白板中需要绘制的 手绘(字典)/文字(字典)/图片
@property(nonatomic ,strong) NSMutableArray *paths;

@property(nonatomic ,strong) NSMutableArray *photoImages;

@property(nonatomic ) NSInteger currentSymbolIndex;

@property(nonatomic ,strong) UITextView *currentTextView;

@property(nonatomic ,assign) BOOL isAddText;

// 选中的图片 -- 移动的图片
@property(nonatomic ,strong) UIView *selectedView;

// 添加拖拽和旋转手势
-(void)addPinchAndRotationGestureRecognizer;

// 添加点击手势
-(void)addTapGesture;

// 添加图片
- (void)addImage:(UIImage *)image from:(AXPImageSource)source;

// 删除未完成的特殊图形
-(void)removeNotCompletedPolygon;

// 文本输入框完成
-(void)textViewDidDone;

// 清空白板
-(void)clearWhiteboard;

// 上一步
-(BOOL)forward;

// 下一步
-(BOOL)next;

// 选中某个特殊图形   
-(void)selectedMovedImageWithPoint:(CGPoint)startPoint;

// 改变UITextView的layer
-(void)changeTextViewLayer;

@end
