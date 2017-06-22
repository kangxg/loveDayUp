//
//  ETTPushCoverView.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/12/2.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTPushCoverView.h"
#import "DGActivityIndicatorView.h"
#import <Masonry.h>

@implementation ETTPushCoverView

- (instancetype)initWithLabelTitle:(NSString *)labelTitle {
    
    if (self = [super init]) {
        
        [self layoutSubviewWithSynchronizeViewTitle:labelTitle];
        
    }
    return self;
}

//学生的动画:学生接收到老师推送的课件/试卷/试题动画
- (void)layoutSubviewWithSynchronizeViewTitle:(NSString *)title {
    
    UILabel *titleLabel                            = [[UILabel alloc]init];
    titleLabel.text                                = title;
    titleLabel.textColor                           = [UIColor whiteColor];
    titleLabel.font                                = [UIFont systemFontOfSize:25.0];
    [self addSubview:titleLabel];

    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor whiteColor]];
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@120);
        make.height.equalTo(@30);
        make.top.equalTo(self).offset(250);
        make.centerX.equalTo(self).offset(-40);
        
    }];
    
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    UIImageView *pandaRotation = [[UIImageView alloc]init];
    pandaRotation.image        = [UIImage imageNamed:@"panda_rotation"];
    [self addSubview:pandaRotation];

    UIImageView *panda         = [[UIImageView alloc]init];
    panda.image                = [UIImage imageNamed:@"panda"];
    [self addSubview:panda];
    
    [pandaRotation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
    }];
    [panda mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(pandaRotation);
        make.width.equalTo(@160);
        make.height.equalTo(@160);
    }];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.beginTime         = CACurrentMediaTime();
    basicAnimation.fromValue         = [NSNumber numberWithFloat:0.0];
    basicAnimation.toValue           = [NSNumber numberWithFloat:M_PI * 2.0];
    basicAnimation.repeatCount       = MAXFLOAT;
    basicAnimation.duration          = 5.0;
    basicAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    [pandaRotation.layer addAnimation:basicAnimation forKey:@"pandaRotation"];
}


@end
