//
//  ETTRemindForTeacherView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRemindForTeacherView.h"
@interface ETTRemindForTeacherView()
{
    
}
@end

@implementation ETTRemindForTeacherView
-(void)initData
{
    self.YVType = ETTREMINDVIEW;
}
-(void)createImageView
{
    [super createImageView];
    //    [self addSubview:self.MVimageBalloonView];
    
    self.YVRemindImageView.image = [UIImage imageNamed:@"remind_0"];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, -self.YVRemindImageView.image.size.height-20-45, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
}
-(void)createLableView
{
    
}

-(void)beginAnimated
{
    WS(weakSelf);
    [UIView transitionWithView:self.YVRemindImageView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2+160, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
       
        [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
       
            
        } completion:^(BOOL finished) {
            [weakSelf beginGifAnimation];
        }];
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    //    _mTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    
}
-(void)beginGifAnimation
{
    NSMutableArray *imgArray = [NSMutableArray array];
    
    for (int i = 0; i<11; i++)
    {
        UIImage  * image = [UIImage imageNamed:[NSString stringWithFormat:@"remind_%d",i]];
        [imgArray addObject:image];
    }
    
    self.YVRemindImageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    self.YVRemindImageView.animationDuration = 0.5;
    //动画重复次数 （0为重复播放）
    self.YVRemindImageView.animationRepeatCount = 3;
    //开始播放动画
    [self.YVRemindImageView startAnimating];
    
    [self performSelector:@selector(removeView) withObject:nil afterDelay:2.0f];
}
-(void)createButtonView
{
    [super createButtonView];
 
}

-(void)animatedAgain
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeView) object:nil];//可以取消成功。
    [self beginGifAnimation];
    
}

-(void)removeRemindview
{
  
    [super removeRemindview];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, (self.height -self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
