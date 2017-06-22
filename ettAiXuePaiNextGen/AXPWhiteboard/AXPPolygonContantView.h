//
//  AXPPolygonContantView.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXPPolygonContantView : UIView

@property(nonatomic ,strong) UIBezierPath *completionDashPath;
@property(nonatomic ,strong) UIBezierPath *linePath;
@property(nonatomic ,strong) NSMutableDictionary *symbolDict;


-(void)drawPolygonlinePath:(UIBezierPath *)linePath symbolDict:(NSMutableDictionary *)symbolDict points:(NSMutableArray *)points;

-(void)drawPolygonWithPolygonElements:(NSMutableArray *)polygonElements;

@end
