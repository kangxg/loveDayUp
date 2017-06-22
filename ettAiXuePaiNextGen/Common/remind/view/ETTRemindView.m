//
//  ETTRemindView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRemindView.h"
#import <ImageIO/ImageIO.h>
@interface ETTRemindView()
{
    NSTimer * _mTimer;
}
@property (nonatomic,retain)UIImageView * MVimageBalloonView;
@property (assign, nonatomic) NSInteger ProcessingIndex;
@end
@implementation ETTRemindView
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
    [super createLableView];
    self.YVRemindlable.textAlignment = NSTextAlignmentCenter;
     self.YVRemindlable.textColor = [UIColor colorWithHexString:@"F8E71C"];
    self.YVRemindlable.text = @"认真听课";
    self.YVRemindlable.frame = CGRectMake((self.width-145)/2,-45, 145, 45);
}
-(void)beginAnimated
{
    WS(weakSelf);
    [UIView transitionWithView:self.YVRemindImageView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2+160, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
         weakSelf.YVRemindlable.frame = CGRectMake((self.width-145)/2,weakSelf.YVRemindImageView.v_bottom +20, 145, 45);
        [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
              weakSelf.YVRemindlable.frame = CGRectMake((self.width-145)/2,weakSelf.height-164, 145, 45);
            
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
   
    [self bringSubviewToFront:self.delBtn];
}
-(void)animatedAgain
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeView) object:nil];//可以取消成功。
    [self beginGifAnimation];

}
-(void)removeRemindview
{
    [_mTimer invalidate];
    [super removeRemindview];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, (self.height -self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
    self.YVRemindlable.frame = CGRectMake(0, self.height-164, self.width, self.YVRemindlable.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
