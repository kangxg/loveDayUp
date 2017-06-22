//
//  ETTSharklabel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTSharklabel : UILabel
// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic,strong) UIColor       *borderColor;

- (void)startAnimWithDuration:(NSTimeInterval)duration;

@end
