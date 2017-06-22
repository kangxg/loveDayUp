//
//  ETTRollCallView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRollCallView.h"
#import <ImageIO/ImageIO.h>
@interface ETTRollCallView()
{
      NSTimer * _mTimer;
}
@property (nonatomic,retain)UIImageView * MVimageBalloonView;
@property (assign, nonatomic) NSInteger ProcessingIndex;
@property (nonatomic,retain)UIButton    * MVCloseBtn;
@end
@implementation ETTRollCallView
-(void)initData
{
    self.YVType = ETTROLLCALLVIEW;
}
-(void)createImageView
{
    [super createImageView];
    self.YVRemindImageView.image = [UIImage imageNamed:@"reollcall"];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, -self.YVRemindImageView.image.size.height-20-45, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
    
}
-(void)createButtonView
{
    [super createButtonView];
    [self addSubview:self.MVCloseBtn];
   
}

-(UIButton *)MVCloseBtn
{
    if (_MVCloseBtn == nil)
    {
        _MVCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MVCloseBtn.frame = self.bounds;
        [_MVCloseBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVCloseBtn ;
}


-(void)beginAnimated
{
    WS(weakSelf);
    [UIView transitionWithView:self.YVRemindImageView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  self.height, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
        weakSelf.YVRemindlable.frame = CGRectMake(0,weakSelf.YVRemindImageView.v_bottom +20, self.width, 45);
        [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
            weakSelf.YVRemindlable.frame = CGRectMake(0,weakSelf.height-164, self.width, 45);
            
        } completion:^(BOOL finished) {
            [weakSelf beginScaleAnimation];
        }];
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    //    _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    
}
-(void)beginScaleAnimation
{
    CAKeyframeAnimation * bounceAnimation =  [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@(1.0),@(1.2), @(0.9), @(1.15), @(0.95), @(1.02), @(1.0)];
    bounceAnimation.duration = 1.0;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [self.YVRemindImageView.layer addAnimation:bounceAnimation forKey:@"ImageViewAnimation"];
//    [self performSelector:@selector(removeView) withObject:nil afterDelay:1.7f];

}
-(void)createLableView
{
    [super createLableView];
    self.YVRemindlable.textAlignment = NSTextAlignmentCenter;
    self.YVRemindlable.textColor = [UIColor colorWithHexString:@"F8E71C"];
    self.YVRemindlable.text = @"你被点到了！";
    self.YVRemindlable.frame = CGRectMake(0,-45, self.width, 45);
}



-(void)animatedAgain
{
  
     [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeView) object:nil];//可以取消成功。
     [self beginScaleAnimation];
}
-(void)removeRemindview
{
    [_mTimer invalidate];
    [super removeRemindview];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, (self.height -self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
//     self.YVRemindlable.frame = CGRectMake(0, self.height-164, self.width, self.YVRemindlable.height);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
