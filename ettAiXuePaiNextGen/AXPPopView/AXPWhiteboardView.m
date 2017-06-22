//
//  AXPWhiteboardView.m
//  test
//
//  Created by Li Kaining on 16/9/23.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardView.h"
#import "AXPWhiteboardPromptView.h"
#import "AXPPolygonManager.h"
#import "ETTWhiteBoardView.h"

@implementation AXPWhiteboardView

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
{
    [super insertSubview:view aboveSubview:siblingSubview];
    
    // 给新的 whiteboardView 设置标记起始位置.
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ETTWhiteBoardView class]]) {
        
           ETTWhiteBoardView *whiteboardView = obj;
           
           [AXPPolygonManager sharedManager].currentIndex = whiteboardView.currentSymbolIndex;
           
           *stop = YES;
        }
    }];
}


-(void)showPromptWithStr:(NSString *)promptStr
{
    if ([self.subviews.lastObject isKindOfClass:[AXPWhiteboardPromptView class]]) {
        
        AXPWhiteboardPromptView *promptView = self.subviews.lastObject;
        [promptView removeFromSuperview];
    }
    
    AXPWhiteboardPromptView *promptView = [[AXPWhiteboardPromptView alloc] initWithPromptStr:promptStr];

    promptView.frame                    = CGRectMake(0, 0, kAXPWhiteboardPromptW, kAXPWhiteboardPromptH);

    promptView.center                   = CGPointMake(kWIDTH/2,0);
    
    [self addSubview:promptView];
    [self bringSubviewToFront:promptView];
    
    [UIView animateWithDuration:0.5 animations:^{
        //
        promptView.center = CGPointMake(kWIDTH/2, 8+47/2);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
            [UIView animateWithDuration:0.5 animations:^{
                //
                promptView.center = CGPointMake(kWIDTH/2, 0);
                
            } completion:^(BOOL finished) {
                //
                [promptView removeFromSuperview];
            }];
        });
    }];
}

@end
