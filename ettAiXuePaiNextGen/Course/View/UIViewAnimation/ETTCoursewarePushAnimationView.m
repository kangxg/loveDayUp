//
//  ETTCoursewarePushAnimationView.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCoursewarePushAnimationView.h"

@interface ETTCoursewarePushAnimationView ()
{
    CGFloat angle;
    
}

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ETTCoursewarePushAnimationView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andAnimationTime:(NSInteger)animationTime {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViewWithTitle:title andAnimationTime:animationTime];
    }
    return self;
}

- (void)setupSubViewWithTitle:(NSString *)title andAnimationTime:(NSInteger)animationTime {
    
    UIImageView *imageView    = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.frame           = CGRectMake(200, 200, 120, 113);
    imageView.image           = [UIImage imageNamed:@"icon_loading"];
    imageView.centerX         = self.centerX;
    imageView.centerY         = self.centerY - 20;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue         = [NSNumber numberWithFloat:0.0];
    basicAnimation.toValue           = [NSNumber numberWithFloat:2.0 * M_PI];
    basicAnimation.repeatCount       = MAXFLOAT;
    basicAnimation.beginTime         = CACurrentMediaTime();
    basicAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basicAnimation.duration          = 3.0;
    [imageView.layer addAnimation:basicAnimation forKey:@"imageViewRotation"];

    //[self transformRotationAnimation];
    UILabel *titleLabel              = [[UILabel alloc]init];
    titleLabel.frame                 = CGRectMake(0, CGRectGetMidY(imageView.frame) - 70 - 64, 200, 20);
    titleLabel.text                  = title;
    titleLabel.textColor             = [UIColor blackColor];
    titleLabel.font                  = [UIFont systemFontOfSize:13.0];
    titleLabel.textAlignment         = NSTextAlignmentCenter;
    titleLabel.centerX               = self.centerX;
    [self addSubview:titleLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeCoursewarePushAnimationView)]) {
            [self.delegate removeCoursewarePushAnimationView];
        }
        
    });
    
}

- (void)transformRotationAnimation {
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0));
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageView.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 5;
        [self transformRotationAnimation];
    }];
}

@end
