//
//  ETTTestPaperReconnectPushAnimationManager.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTestPaperReconnectPushAnimationManager.h"
#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"

@interface ETTTestPaperReconnectPushAnimationManager ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *pushText;
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIImageView *rotationView;


@end

@implementation ETTTestPaperReconnectPushAnimationManager

//添加动画
- (void)addTestPaperReconnectPushAnimation {
    
    //获取主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.coverView];
    [self addSubview];
    
}

//移除动画
- (void)removeTestPaperReconnectPushAnimation {
    int random = [self getRandomNumberFrom:2 to:3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(random * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverView removeFromSuperview];
    });
}


#pragma private method
- (void)addSubview {
    
    [self.containView addSubview:self.pushText];
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor whiteColor]];
    activityIndicatorView.frame                    = CGRectMake(CGRectGetMaxX(self.pushText.frame), 0, 60, 30);
    activityIndicatorView.centerY                  = self.pushText.centerY;
        [activityIndicatorView startAnimating];
    [self.containView addSubview:activityIndicatorView];

    [self.containView addSubview:self.rotationView];

    CABasicAnimation *basicAnimation               = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue                       = [NSNumber numberWithFloat:0.0];
    basicAnimation.toValue                         = [NSNumber numberWithFloat:M_PI * 2.0];
    basicAnimation.repeatCount                     = MAXFLOAT;
    basicAnimation.duration                        = 2.5;
    basicAnimation.beginTime                       = CACurrentMediaTime();
    basicAnimation.timingFunction                  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    [self.rotationView.layer addAnimation:basicAnimation forKey:@"rotation"];
    [self.coverView addSubview:self.containView];
    
}

- (int)getRandomNumberFrom:(int)from to:(int)to {
    
    return (from + (arc4random() % (to - from + 1)));
}

- (UIView *)coverView {
    
    if (_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.frame = CGRectMake(0, 0, k_MAINSCREEN_WIDTH, k_MAINSCREEN_HEIGHT);
        _coverView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }
    return _coverView;
}

/**
 label

 @return <#return value description#>
 */
- (UILabel *)pushText {
    
    if (_pushText) {
        _pushText           = [[UILabel alloc]init];
        _pushText.text      = @"正在推送";
        _pushText.textColor = [UIColor whiteColor];
        _pushText.frame     = CGRectMake(10, 10, 100, 30);
        _pushText.textAlignment = NSTextAlignmentRight;
    }
    return _pushText;
}


/**
 容器

 @return <#return value description#>
 */
- (UIView *)containView {
    
    if (_containView) {
        _containView        = [[UIView alloc]init];
        _containView.frame  = CGRectMake(0, 0, 180, 210);
        _containView.center = _coverView.center;
        
    }
    return _containView;
}

- (UIImageView *)rotationView {
    if (_rotationView) {
        _rotationView       = [[UIImageView alloc]init];
        _rotationView.image = [UIImage imageNamed:@"icon_loading"];
        _rotationView.frame = CGRectMake(10, CGRectGetMaxY(self.pushText.frame) + 10, 150, 150);
    }
    return _rotationView;
}

@end
