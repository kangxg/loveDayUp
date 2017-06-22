//
//  ETTRewardsView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRewardsView.h"
#import "ETTSharklabel.h"
@interface ETTRewardsView()
@property (nonatomic,retain)ETTSharklabel  *  MVShareLabel;
@property (nonatomic,assign)NSInteger  MDRemindCount;
@end

@implementation ETTRewardsView
-(void)initData
{
    self.YVType = ETTREWARDSVIEW;
    _MDRemindCount = 1;
}

-(void)createLableView
{
    [self addSubview:self.MVShareLabel];
    self.MVShareLabel.alpha = 0;
}

-(ETTSharklabel *)MVShareLabel
{
    if (_MVShareLabel == nil)
    {
        _MVShareLabel =  [[ETTSharklabel alloc] init];
        _MVShareLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:40.0];
        _MVShareLabel.borderColor = [UIColor whiteColor];
        _MVShareLabel.textColor = [UIColor colorWithHexString:@"F2B922"];
        _MVShareLabel.textAlignment = NSTextAlignmentCenter;
        //        _MVShareLabel.backgroundColor = [UIColor blueColor];
    }
    return _MVShareLabel;
}

-(void)createImageView
{
    [super createImageView];
    self.YVRemindImageView.image = [UIImage imageNamed:@"rewards"];
 
    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, -self.YVRemindImageView.image.size.height, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
    
}
-(void)beginAnimated
{
    WS(weakSelf);
    [UIView transitionWithView:self.YVRemindImageView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2+120, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
         [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
             weakSelf.MVShareLabel.alpha = 1;
              weakSelf.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2,  (self.height-self.YVRemindImageView.image.size.height)/2, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
             
         } completion:^(BOOL finished) {
               [weakSelf shakeNumberLabel];
         }];
       
        
    } completion:^(BOOL finished) {
        
    }];

}

-(void)animatedAgain
{
    _MDRemindCount ++;
    [self shakeNumberLabel];
}
- (void)shakeNumberLabel
{
   
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:1];
//    NSInteger count = 1;
//    if (self.YVDelegate && [self.YVDelegate respondsToSelector:@selector(pGetRemindCount)])
//    {
//        count = [self.YVDelegate pGetRemindCount];
//    }
    _MVShareLabel.text = [NSString stringWithFormat:@"X %ld",(long)_MDRemindCount];
    [_MVShareLabel startAnimWithDuration:0.3];

}

- (void)hidePresendView
{
    //-self.frame.size.width
//    [weakSelf performSelector:@selector(removeView) withObject:nil afterDelay:1.7f];
    [self removeView];
//    [UIView animateWithDuration:0.30 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//
//    } completion:^(BOOL finished) {
//   
//        
//        //        NSLog(@"%ld",_animCount);
//       
//    }];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   
     _MVShareLabel.frame = CGRectMake((self.width-145)/2,self.height-164, 145, 45);
//    self.YVRemindImageView.frame = CGRectMake((self.width - self.YVRemindImageView.image.size.width)/2, 10, self.YVRemindImageView.image.size.width, self.YVRemindImageView.image.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
