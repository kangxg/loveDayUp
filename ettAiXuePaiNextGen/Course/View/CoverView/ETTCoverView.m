//
//  ETTCoverView.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCoverView.h"
#import "DGActivityIndicatorView.h"
#import <Masonry.h>
#import "ETTPushMProgressBarView.h"

@interface ETTCoverView ()
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ETTPushMProgressBarView *pushProgressView;

@end

@implementation ETTCoverView



- (instancetype)initWithFrame:(CGRect)frame labelTitle:(NSString *)title {
    
    if (self = [super initWithFrame:frame]) {
        [self layoutSubviewWithTitle:title];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame progressViewTitle:(NSString *)title {
    
    if (self = [super initWithFrame:frame]) {
        [self layoutSubviewWithProgressViewTitle:title];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame synchronizeViewTitle:(NSString *)title {
    
    if (self = [super initWithFrame:frame]) {
        [self layoutSubviewWithSynchronizeViewTitle:title];
    }
    return self;
}

//老师&学生打开pdf课件之前动画
- (void)layoutSubviewWithTitle:(NSString *)title {
    
    UILabel *titleLabel                            = [[UILabel alloc]init];
    titleLabel.text                                = title;
    titleLabel.textColor                           = [UIColor whiteColor];
    titleLabel.font                                = [UIFont systemFontOfSize:15.0];
    titleLabel.textAlignment                       = NSTextAlignmentCenter;
    [self addSubview:titleLabel];

    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor whiteColor]];
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@120);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-30);
        
    }];
    
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
}

//老师的动画:老师推课件/试卷/试题动画
- (void)layoutSubviewWithProgressViewTitle:(NSString *)title {
    
    UILabel *titleLabel                            = [[UILabel alloc]init];
    titleLabel.text                                = title;
    titleLabel.textColor                           = [UIColor colorWithRed:(83/255.0) green:83/255.0 blue:83/255.0 alpha:1.0];
    titleLabel.font                                = [UIFont systemFontOfSize:25.0];
    [self addSubview:titleLabel];

    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor colorWithRed:(83/255.0) green:83/255.0 blue:83/255.0 alpha:1.0]];
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@120);
        make.height.equalTo(@30);
        make.top.equalTo(self).offset(250);
        make.centerX.equalTo(self);
        
    }];
    
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    _pushProgressView                = [[ETTPushMProgressBarView alloc] init];
    _pushProgressView.progress       = 0.0;
    _pushProgressView.barBorderColor = [UIColor lightGrayColor];
    _pushProgressView.barFillColor   = kC1_COLOR;
    [self addSubview:_pushProgressView];
    
    [self.pushProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-100);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(pushProgressViewKeepProgress) userInfo:nil repeats:YES];
}

- (void)pushProgressViewKeepProgress {
    _pushProgressView.progress = _pushProgressView.progress + 0.04;
    if (_pushProgressView.progress == 1.0f) {
        _pushProgressView.progress = 0.0;
        _pushProgressView          = nil;
        [_pushProgressView removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        if ([self.delegate respondsToSelector:@selector(removeCoverViewFromSuperView)]) {
            [self.delegate removeCoverViewFromSuperView];
        }
    }
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
