//
//  AXPPolygonImageModel.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPPolygonImageModel : NSObject

// 特殊图形名称
@property(nonatomic ,copy) NSString *polygonName;

// 图形形状
@property(nonatomic ,strong) UIBezierPath *bezierPath;

// 选中时候的颜色
@property(nonatomic ,strong) UIColor *color;

// 标记字典
@property(nonatomic ,strong) NSMutableDictionary *polygonSymbolDict;

// 顶点数组
@property(nonatomic ,strong) NSMutableArray *apexPointsArray;

@end
