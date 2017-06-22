//
//  ETTRadarIndictorView.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 2017/3/23.
//  Copyright © 2017年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTRadarIndictorView : UIView

@property (nonatomic, assign) CGFloat radius;   // 半径
@property(nullable, nonatomic,strong) UIColor *startColor;  // 渐变开始颜色
@property(nullable, nonatomic,strong) UIColor *endColor;    // 渐变结束颜色
@property (nonatomic, assign) CGFloat angle;    // 扫描角度
@property (nonatomic, assign) BOOL clockwise;   // 是否顺时针

- (void)startScan;

- (void)stopScan;

@end
