//
//  ETTSingleCharAnimationView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTSingleCharAnimationView.h"

@implementation ETTSingleCharAnimationView
-(instancetype)initAnimationView:(UIView *)superView info:(id)info
{
    if (!superView)
    {
        return nil;
    }
    CGRect frame = CGRectMake((kWIDTH-500)/2, -44, 500, 44);
    self = [self initAnimationView:superView withFrame:frame info:info];
    return self;
    
}
-(void)createLableView
{
    [super createLableView];
//    if (self.EVInfoArr.count)
//    {
//          self.EVAnimationLabel.text = [NSString stringWithFormat:@"%@ 获得了奖励",self.EVInfoArr.firstObject];
//    }
  
  
    
}

-(void)beginAnimated
{
    
    if (!self.EVInfoArr.count)
    {
        [self removeView];
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.center = CGPointMake(kWIDTH / 2, 22);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                self.center = CGPointMake(kWIDTH / 2, -44);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self removeView];
                }];
                
            }];
            
        });
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation ETTRewardSelfCharAnimationView
-(void)initData:(id)data
{
    [super initData:data];
    self.EVType =ETTCHARANIMATIONREWAREMINE;
}
-(void)createLableView
{
    [super createLableView];
    [self displayNameMsg:1];
    if (self.EVInfoArr.count)
    {
        self.EVAnimationLabel.text = @"您获得了奖励";
    }
    
    
    
}
-(void)animatedAgain:(NSArray *)name
{
    if ([name.firstObject isEqualToString:self.EVInfoArr.firstObject])
    {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeView) object:nil];//可以取消成功。
        [self displayNameMsg:(self.EVAnimationCount+1)];
        [self beginAnimated];
        
    }
    
}
-(void)displayNameMsg:(NSInteger)count
{
    if (self.EVInfoArr.count)
    {
        self.EVAnimationCount = count;
        if (self.EVAnimationCount>1)
        {
            self.EVAnimationLabel.text = [NSString stringWithFormat:@"%@ 获得了奖励 X%ld",self.EVInfoArr.firstObject,(long)self.EVAnimationCount];
        }
        else
        {
             self.EVAnimationLabel.text = [NSString stringWithFormat:@"%@ 获得了奖励",self.EVInfoArr.firstObject];
        }
       
    }

}


@end
//
@implementation ETTRewardSingleCharAnimationView
-(void)initData:(id)data
{
    [super initData:data];
    self.EVType =ETTCHARANIMATIONREWAREOTHER;
}

-(void)animatedAgain:(NSArray *)name
{
    if ([name.firstObject isEqualToString:self.EVInfoArr.firstObject])
    {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeView) object:nil];//可以取消成功。
        [self displayNameMsg:(self.EVAnimationCount+1)];
        [self beginAnimated];
        
    }
    
}
-(void)createLableView
{
    [super createLableView];
    [self displayNameMsg:1];

    
    
}

-(void)displayNameMsg:(NSInteger)count
{
    if (self.EVInfoArr.count)
    {
        self.EVAnimationCount = count;
        if (self.EVAnimationCount>1)
        {
            self.EVAnimationLabel.text = [NSString stringWithFormat:@"%@ 获得了奖励 X%ld",self.EVInfoArr.firstObject,(long)self.EVAnimationCount];
        }
        else
        {
             self.EVAnimationLabel.text = [NSString stringWithFormat:@"%@ 获得了奖励",self.EVInfoArr.firstObject];
        }
      
    }

}
@end
