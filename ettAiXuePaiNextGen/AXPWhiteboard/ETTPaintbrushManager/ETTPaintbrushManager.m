//
//  ETTPaintbrushManager.m
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/20.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#define kPaintbrushColorDefault [UIColor redColor]
#define kPaintbrushWidthDefault 20

#import "ETTPaintbrushManager.h"

@interface ETTPaintbrushManager ()

@property(nonatomic ,strong) NSMutableArray *paths;

@end

@implementation ETTPaintbrushManager

static id _instance;

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init
{
    self = [super init];
    
    _paintbrushColor = kPaintbrushColorDefault;
    _paintbrushWidth = kPaintbrushWidthDefault;
    
    return self;
}


-(void)createBezierPathWithStartPoint:(CGPoint)startPoint completionHandle:(pathCreated)completionHandle
{
    // 1.0 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 1.1 设置路径的相关属性
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineWidth:self.paintbrushWidth];
    
    // 1.2 设置当前路径的起点
    [path moveToPoint:startPoint];
    
    UIColor *color;
        
    color = [self.paintbrushColor colorWithAlphaComponent:self.paintbrushColorAlpha/100.0];
    

    NSDictionary *dict = @{path:color};
    
    [self.paths addObject:dict];
    
    if (completionHandle) {
        completionHandle(dict);
    }
}

-(void)addPointToBezierPath:(CGPoint)addPoint completionHandle:(pathCreated)completionHandle
{
    NSDictionary *dict = self.paths.lastObject;
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        UIBezierPath *path = key;
        
        [path addLineToPoint:addPoint];
        
    }];
    
    if (completionHandle) {
        completionHandle(dict);
    }
}

-(NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}
@end
