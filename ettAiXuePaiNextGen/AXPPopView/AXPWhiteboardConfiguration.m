//
//  AXPWhiteboardConfiguration.m
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardConfiguration.h"
#import "UIColor+RGBColor.h"
#import "ETTUserInformationProcessingUtils.h"

static NSString *axpWhiteboardConfigKey = @"axpWhiteboardConfig";

static NSString *isFirstUseBrushKey = @"isFirstUseBrushKey";
static NSString *isFirstUseEraserKey = @"isFirstUseEraserKey";
static NSString *isFirstUseTextKey = @"isFirstUseTextKey";
static NSString *brushColorStrKey = @"brushColorSyrKey";
static NSString *brushSelectedKey = @"brushSelectedKey";
static NSString *toolbarKey = @"toolbarKey";
static NSString *apexStyleKey = @"apexStyleKey";
static NSString *showGridLineKey = @"showGridLineKey";
static NSString *showSymbolKey = @"showSymbolKey";
static NSString *brushColorKey = @"brushColorKey";
static NSString *brushAlphaKey = @"brushAlphaKey";
static NSString *brushSizeKey = @"brushSizeKey";
static NSString *eraserSizeKey = @"eraserSizeKey";
static NSString *isFirstUseBucketKey = @"isFirstUseBucketKey";
static NSString *buckerColorKey = @"buckerColorKey";
static NSString *bucketColorStrKey = @"bucketColorStrKey";
static NSString *textColorKey = @"textColorKey";
static NSString *textFontSizeKey = @"textFontSizeKey";
static NSString *selectedLineKey = @"selectedLineKey";
static NSString *isFirstDrawLineKey = @"isFirstDrawLineKey";
static NSString *isFirstDrawRayLineKey = @"isFirstDrawRayLineKey";
static NSString *selectedTriangleKey = @"selectedTriangleKey";
static NSString *isFirstDrawTriangleKey = @"isFirstDrawTriangleKey";
static NSString *isFirstDrawRightTriangleKey = @"isFirstDrawRightTriangleKey";
static NSString *isFirstDrawIsocelesTriangle = @"isFirstDrawIsocelesTriangle";
static NSString *isFirstDrawRegularTriangleKey = @"isFirstDrawRegularTriangleKey";
static NSString *selectedQuadrangleKey = @"selectedQuadrangleKey";
static NSString *isFirstDrawSquareKey = @"isFirstDrawSquareKey";
static NSString *isFirstDrawRectangleKey = @"isFirstDrawRectangleKey";
static NSString *isFirstDrawQuadrangleKey = @"isFirstDrawQuadrangleKey";
static NSString *isFirstDrawParallelogramKey = @"isFirstDrawParallelogramKey";
static NSString *isFirstDrawQuadrilateralKey = @"isFirstDrawQuadrilateralKey";
static NSString *selectedCircleKey = @"selectedCircleKey";
static NSString *isFirstDrawCircleKey = @"isFirstDrawCircleKey";

@implementation AXPWhiteboardConfiguration


static id _instance;
+(instancetype)sharedConfiguration
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AXPWhiteboardConfiguration *config = [[AXPWhiteboardConfiguration alloc] init];
        _instance = config;
//        [self loadConfiguration];
    });
    return _instance;
}

+(void)loadConfiguration
{
    
//    NSString *filePath = [self getFilePath];
//    
//    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
//    
//    if (data) {
//        
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        
//        _instance = [unarchiver decodeObjectForKey:axpWhiteboardConfigKey];
//        
//        [unarchiver finishDecoding];
//        
//    }else
//    {
//        [self setUpDefaultConfiguration];
//    }
}

-(void)setUpDefaultConfiguration
{

    self.brushSelected               = 9;
    
    NSString *toolbarStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"toolbar"];
    self.toolbar                     = isEmptyString(toolbarStr)?@"左侧":toolbarStr;
    self.apexStyle                   = @"circleApexBlack";
    self.showGridLine                = NO;
    self.showSymbol                  = YES;

    self.isFirstUseBrush             = YES;
    self.brushColorStr               = @"black";
    self.brushColor                  = kAXPCOLORblack;
    self.brushAlpha                  = 100;
    self.brushSize                   = 3;

    self.isFirstUseEraser            = YES;
    self.eraserSize                  = 30;

    self.isFirstUseBucket            = YES;
    self.bucketColorStr              = @"black";
    self.bucketColor                 = kAXPCOLORblack;

    self.isFirstUseText              = YES;
    self.textColor                   = kAXPCOLORblack;
    self.textFontSize                = 18;

    self.selectedLine                = 0;
    self.isFirstDrawLine             = YES;
    self.isFirstDrawRayLine          = YES;

    self.selectedTriangle            = 0;
    self.isFirstDrawTriangle         = YES;
    self.isFirstDrawRightTriangle    = YES;
    self.isFirstDrawIsocelesTriangle = YES;
    self.isFirstDrawRegularTriangle  = YES;

    self.selectedQuadrangle          = 0;
    self.isFirstDrawSquare           = YES;
    self.isFirstDrawRectangle        = YES;
    self.isFirstDrawQuadrangle       = YES;
    self.isFirstDrawParallelogram    = YES;
    self.isFirstDrawQuadrilateral    = YES;

    self.selectedCircle              = 0;
    self.isFirstDrawCircle           = YES;

//    _instance = config;
    
    [self saveConfiguration];
}

-(void)saveConfiguration
{
    NSMutableData *data = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self forKey:axpWhiteboardConfigKey];
    [archiver finishEncoding];
    
    [data writeToFile:[AXPWhiteboardConfiguration getFilePath] atomically:YES];
}

+(NSString *)getFilePath
{
    NSString *filePath = [NSString stringWithFormat:@"%@/whiteboardConfig",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject];
    
    return filePath;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_brushSelected forKey:brushSelectedKey];
    
    [aCoder encodeObject:_toolbar forKey:toolbarKey];
    [aCoder encodeObject:_apexStyle forKey:apexStyleKey];
    [aCoder encodeBool:_showGridLine forKey:showGridLineKey];
    [aCoder encodeBool:_showSymbol forKey:showSymbolKey];
    
    [aCoder encodeBool:_isFirstUseBrush forKey:isFirstUseBrushKey];
    [aCoder encodeObject:_brushColorStr forKey:brushColorStrKey];
    [aCoder encodeObject:_brushColor forKey:brushColorKey];
    [aCoder encodeDouble:_brushAlpha forKey:brushAlphaKey];
    [aCoder encodeDouble:_brushSize forKey:brushSizeKey];
    
    [aCoder encodeBool:_isFirstUseEraser forKey:isFirstUseEraserKey];
    [aCoder encodeDouble:_eraserSize forKey:eraserSizeKey];
    
    [aCoder encodeBool:_isFirstUseBucket forKey:isFirstUseBucketKey];
//    [aCoder encodeObject:_bucketColorStr forKey:bucketColorStrKey];
    [aCoder encodeObject:_bucketColor forKey:buckerColorKey];
    
    [aCoder encodeBool:_isFirstUseText forKey:isFirstUseTextKey];
    [aCoder encodeObject:_textColor forKey:textColorKey];
    [aCoder encodeDouble:_textFontSize forKey:textFontSizeKey];
    
    [aCoder encodeInteger:_selectedLine forKey:selectedLineKey];
    [aCoder encodeBool:_isFirstDrawLine forKey:isFirstDrawLineKey];
    [aCoder encodeBool:_isFirstDrawRayLine forKey:isFirstDrawRayLineKey];
    
    [aCoder encodeInteger:_selectedTriangle forKey:selectedTriangleKey];
    [aCoder encodeBool:_isFirstDrawTriangle forKey:isFirstDrawTriangleKey];
    [aCoder encodeBool:_isFirstDrawRightTriangle forKey:isFirstDrawRightTriangleKey];
    [aCoder encodeBool:_isFirstDrawIsocelesTriangle forKey:isFirstDrawIsocelesTriangle];
    [aCoder encodeBool:_isFirstDrawRegularTriangle forKey:isFirstDrawRegularTriangleKey];
    
    [aCoder encodeInteger:_selectedQuadrangle forKey:selectedQuadrangleKey];
    [aCoder encodeBool:_isFirstDrawSquare forKey:isFirstDrawSquareKey];
    [aCoder encodeBool:_isFirstDrawRectangle forKey:isFirstDrawRectangleKey];
    [aCoder encodeBool:_isFirstDrawQuadrangle forKey:isFirstDrawQuadrangleKey];
    [aCoder encodeBool:_isFirstDrawParallelogram forKey:isFirstDrawParallelogramKey];
    [aCoder encodeBool:_isFirstDrawQuadrilateral forKey:isFirstDrawQuadrilateralKey];
    
    [aCoder encodeInteger:_selectedCircle forKey:selectedCircleKey];
    [aCoder encodeBool:_isFirstDrawCircle forKey:isFirstDrawCircleKey];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _brushSelected               = [aDecoder decodeIntegerForKey:brushSelectedKey];

        // 设置
        _toolbar                     = [aDecoder decodeObjectForKey:toolbarKey];
        _apexStyle                   = [aDecoder decodeObjectForKey:apexStyleKey];
        _showGridLine                = [aDecoder decodeBoolForKey:showGridLineKey];
        _showSymbol                  = [aDecoder decodeBoolForKey:showSymbolKey];

        // 画笔
        _isFirstUseBrush             = [aDecoder decodeBoolForKey:isFirstUseBrushKey];
        _brushColorStr               = [aDecoder decodeObjectForKey:brushColorStrKey];
        _brushColor                  = [aDecoder decodeObjectForKey:brushColorKey];
        _brushAlpha                  = [aDecoder decodeDoubleForKey:brushAlphaKey];
        _brushSize                   = [aDecoder decodeDoubleForKey:brushSizeKey];

        // 橡皮擦
        _isFirstUseEraser            = [aDecoder decodeBoolForKey:isFirstUseEraserKey];
        _eraserSize                  = [aDecoder decodeDoubleForKey:eraserSizeKey];

        // 画桶
        _isFirstUseBucket            = [aDecoder decodeBoolForKey:isFirstUseBucketKey];
//        _bucketColorStr              = [aDecoder decodeObjectForKey:bucketColorStrKey];
        _bucketColor                 = [aDecoder decodeObjectForKey:buckerColorKey];

        // 文字
        _isFirstUseText              = [aDecoder decodeBoolForKey:isFirstUseTextKey];
        _textColor                   = [aDecoder decodeObjectForKey:textColorKey];
        _textFontSize                = [aDecoder decodeDoubleForKey:textFontSizeKey];

        // 直线
        _selectedLine                = [aDecoder decodeIntegerForKey:selectedLineKey];
        _isFirstDrawLine             = [aDecoder decodeBoolForKey:isFirstDrawLineKey];
        _isFirstDrawRayLine          = [aDecoder decodeBoolForKey:isFirstDrawRayLineKey];

        // 三角形
        _selectedTriangle            = [aDecoder decodeIntegerForKey:selectedTriangleKey];
        _isFirstDrawTriangle         = [aDecoder decodeBoolForKey:isFirstDrawTriangleKey];
        _isFirstDrawRightTriangle    = [aDecoder decodeBoolForKey:isFirstDrawRightTriangleKey];
        _isFirstDrawIsocelesTriangle = [aDecoder decodeBoolForKey:isFirstDrawIsocelesTriangle];
        _isFirstDrawRegularTriangle  = [aDecoder decodeBoolForKey:isFirstDrawRegularTriangleKey];

        // 四边形
        _selectedQuadrangle          = [aDecoder decodeIntegerForKey:selectedQuadrangleKey];
        _isFirstDrawSquare           = [aDecoder decodeBoolForKey:isFirstDrawSquareKey];
        _isFirstDrawRectangle        = [aDecoder decodeBoolForKey:isFirstDrawRectangleKey];
        _isFirstDrawQuadrangle       = [aDecoder decodeBoolForKey:isFirstDrawQuadrangleKey];
        _isFirstDrawParallelogram    = [aDecoder decodeBoolForKey:isFirstDrawParallelogramKey];
        _isFirstDrawQuadrilateral    = [aDecoder decodeBoolForKey:isFirstDrawQuadrilateralKey];

        // 圆
        _selectedCircle              = [aDecoder decodeIntegerForKey:selectedCircleKey];
        _isFirstDrawCircle           = [aDecoder decodeBoolForKey:isFirstDrawCircleKey];
        
    }
    return self;
}


@end
