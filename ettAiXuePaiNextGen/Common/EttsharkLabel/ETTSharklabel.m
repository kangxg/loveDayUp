//
//  ETTSharklabel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSharklabel.h"

@implementation ETTSharklabel
- (void)startAnimWithDuration:(NSTimeInterval)duration
{
    
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            
            self.transform = CGAffineTransformMakeScale(2.5, 2.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
}

@end
