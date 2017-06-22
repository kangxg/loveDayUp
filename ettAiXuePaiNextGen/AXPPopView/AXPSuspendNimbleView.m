//
//  AXPSuspendNimbleView.m
//  test
//
//  Created by Li Kaining on 16/9/29.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPSuspendNimbleView.h"
#import "UIColor+RGBColor.h"
#import "AXPWhiteboardConfiguration.h"
#import "AXPWhiteboardToolbarManager.h"

#define kAnimationDuration 0.25
#define kMarginWH 16
#define kMarginBL 28
#define kNimbleButtonWH 40
#define kNimbleManagerButtonWH 56

@interface AXPSuspendNimbleView ()

@property(nonatomic ,strong) UIView *nimbleSuper;
@property(nonatomic ,strong) NSMutableArray *nimbleArray;


@end

@implementation AXPSuspendNimbleView


static id _instance;

-(instancetype)initSuspendNimbleViewWithNimbleButtonRect:(CGRect)rect superView:(UIView *)superView
{
    self = [super init];
    
    self.nimbleSuper = superView;
    
    //快捷弹出按钮
    [self setUpSuspendNimbleButtonWithRect:rect];
    
    //设置按钮的图片
    [self loadNimbelImages];
    
    //设置
    [self creatNimbleFunctionButton];
    //设置
    [self creatExplainLable];
    
    return self;
}

-(void)setUpSuspendNimbleButtonWithRect:(CGRect)rect;
{
    AXPNimbleButton *suspendNimbleButton = [self creatButtonWithNormalImageName:@"fab_default" highlightedImageName:@"fab_pressed"];
    suspendNimbleButton.frame            = rect;

    [suspendNimbleButton addTarget:self action:@selector(selectedSuspendNimbleButton:) forControlEvents:UIControlEventTouchUpInside];
    self.suspendNimbleButton             = suspendNimbleButton;
    
    [self.nimbleSuper addSubview:suspendNimbleButton];
    [self.nimbleSuper bringSubviewToFront:suspendNimbleButton];
}

-(AXPNimbleButton *)creatButtonWithNormalImageName:(NSString *)normalImage highlightedImageName:(NSString *)highlightedImage
{
    AXPNimbleButton *button = [AXPNimbleButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 40, 40);
    
    return button;
}

-(void)selectedSuspendNimbleButton:(AXPNimbleButton *)button
{
    if (self.isShowAnimation) {
        return;
    }
    
    [self.nimbleSuper bringSubviewToFront:self];
    [self.nimbleSuper bringSubviewToFront:self.suspendNimbleButton];
    
    if (!button.selected) {
        
        //之前是显示4个按钮  现在是显示2个
        [self showNimbleToolbar];
        
    }else
    {   
        //之前是4个按钮  现在是2个
        [self hiddenNimbleToolbarCompletion:nil];
    }
}

//显示4个按钮
-(void)showNimbleToolbar
{
    if (self.isShowAnimation) {
        return;
    }
    
    if (self.suspendNimbleButton.selected == YES) {
        return;
    }
    
    if ([AXPWhiteboardToolbarManager sharedManager].isShowMnangerCollectionView) {
        return;
    }
    
    self.isShowAnimation = YES;
    self.suspendNimbleButton.hidden = NO; 
    
    [self.nimbleButtons enumerateObjectsUsingBlock:^(AXPNimbleButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectMake(0, 0, 40, 40);
        button.center = self.suspendNimbleButton.center;
        [self.nimbleSuper addSubview:button];
    }];
    [self.nimbleSuper bringSubviewToFront:self.suspendNimbleButton];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.suspendNimbleButton.transform = CGAffineTransformMakeRotation(-M_PI/4);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            [self.nimbleButtons enumerateObjectsUsingBlock:^(AXPNimbleButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CGPoint center        = button.center;
                center.y              -= kNimbleManagerButtonWH/2 + (kMarginWH + kNimbleButtonWH)*(self.nimbleButtons.count - idx) - kNimbleButtonWH/2;
                button.center         = center;

                AXPNimbleLabel *lable = self.explainLables[idx];
                lable.center          = center;
            }];
            
        } completion:^(BOOL finished) {
            
            [self.explainLables enumerateObjectsUsingBlock:^(AXPNimbleLabel *explainLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.nimbleSuper addSubview:explainLabel];
                [self.nimbleSuper insertSubview:explainLabel belowSubview:self.nimbleButtons.firstObject];
            }];
            
            [UIView animateWithDuration:kAnimationDuration animations:^{
                
                [self.explainLables enumerateObjectsUsingBlock:^(AXPNimbleLabel *explainLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    explainLabel.alpha = 1.0;
                    CGPoint center = explainLabel.center;
                    
                    if ([[AXPWhiteboardConfiguration sharedConfiguration].toolbar isEqualToString:@"左侧"]) {
                        
                        center.x -= (kNimbleButtonWH/2+kMarginBL+explainLabel.frame.size.width/2);
                        
                    }else
                    {
                        center.x += (kNimbleButtonWH/2+kMarginBL+explainLabel.frame.size.width/2);
                    }
                    
                    explainLabel.center = center;
                }];
                
            } completion:^(BOOL finished) {
                if (finished) {
                    self.suspendNimbleButton.selected = YES;
                    self.isShowAnimation = NO;
                }
            }];
        }];
    }];
}

//隐藏4个按钮
-(void)hiddenNimbleToolbarCompletion:(void (^)())completionHandle
{
    if (self.isShowAnimation) {
        
        if (completionHandle) {
            completionHandle();
        }
        
        return;
    }
    
    if (self.suspendNimbleButton.selected != YES) {
        
        if (completionHandle) {
            completionHandle();
        }
        
        return;
    }
    
    self.isShowAnimation = YES;
    
    NSLog(@"hiddenNimbleToolbarCompletion");
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.suspendNimbleButton.transform = CGAffineTransformMakeRotation(0);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            [self.explainLables enumerateObjectsUsingBlock:^(AXPNimbleLabel *explainLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                explainLabel.alpha = 0.01;
                CGPoint center = explainLabel.center;
                
                if ([[AXPWhiteboardConfiguration sharedConfiguration].toolbar isEqualToString:@"左侧"]) {
                    
                    center.x += (kNimbleButtonWH/2+kMarginBL+explainLabel.frame.size.width/2);
                    
                }else
                {
                    center.x -= (kNimbleButtonWH/2+kMarginBL+explainLabel.frame.size.width/2);
                }
                
                explainLabel.center = center;
            }];
            
        } completion:^(BOOL finished) {
            
            [self.explainLables enumerateObjectsUsingBlock:^(AXPNimbleLabel *explainLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [explainLabel removeFromSuperview];
                
            }];
            
            [UIView animateWithDuration:kAnimationDuration animations:^{
                
                [self.nimbleButtons enumerateObjectsUsingBlock:^(AXPNimbleButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    CGPoint center = button.center;
                    center.y += kNimbleManagerButtonWH/2 + (kMarginWH + kNimbleButtonWH)*(self.nimbleButtons.count - idx) - kNimbleButtonWH/2;
                    button.center = center;
                }];
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [self.nimbleButtons enumerateObjectsUsingBlock:^(AXPNimbleButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                        [button removeFromSuperview];
                    }];
                    
                    if (completionHandle) {
                        completionHandle();
                    }
                    self.isShowAnimation = NO;
                    self.suspendNimbleButton.selected = NO;
                }
            }];
        }];
    }];
}

-(void)creatNimbleFunctionButton
{
    [self.nimbleArray enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *normalImage      = [NSString stringWithFormat:@"fab_%@_default",imageName];
        NSString *highlightedImage = [NSString stringWithFormat:@"fab_%@_pressed",imageName];

        AXPNimbleButton *button    = [self creatButtonWithNormalImageName:normalImage highlightedImageName:highlightedImage];
        button.tag                 = 10000 + idx;

        button.center              = self.suspendNimbleButton.center;
        
        [self.nimbleButtons addObject:button];
    }];
}

-(void)loadNimbelImages
{
    self.nimbleArray = [NSMutableArray arrayWithObjects:@"moreboard",@"manage", nil];
}

-(void)creatExplainLable
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"新建白板",@"白板管理",nil];
    
    [array enumerateObjectsUsingBlock:^(NSString *explain, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AXPNimbleLabel *lable        = [[AXPNimbleLabel alloc] init];
        lable.userInteractionEnabled = YES;
        lable.text                   = explain;
        lable.tag                    = 10000 +idx;
        
        if (explain.length == 2) {
            
            lable.frame = CGRectMake(0, 0, 75, 25);
        }else
        {
            lable.frame = CGRectMake(0, 0, 55, 25);
        }
        
        lable.font                = [UIFont systemFontOfSize:13];
        lable.textColor           = kAXPTEXTCOLORf2;
        lable.textAlignment       = NSTextAlignmentCenter;
        lable.backgroundColor     = [UIColor whiteColor];
        lable.layer.cornerRadius  = 5;
        lable.layer.masksToBounds = YES;
        lable.alpha               = 0.01;
        
        [self.explainLables addObject:lable];
    }];
}

-(NSMutableArray *)nimbleArray
{
    if (!_nimbleArray) {
        _nimbleArray = [NSMutableArray array];
    }
    return _nimbleArray;
}

-(NSMutableArray *)nimbleButtons
{
    if (!_nimbleButtons) {
        _nimbleButtons = [NSMutableArray array];
    }
    return _nimbleButtons
    ;
}

-(NSMutableArray *)explainLables
{
    if (!_explainLables) {
        _explainLables = [NSMutableArray array];
    }
    return _explainLables;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(kWIDTH - kNimbleManagerButtonWH - kMarginWH, kHEIGHT - kNimbleManagerButtonWH - kMarginWH, kNimbleManagerButtonWH, kNimbleManagerButtonWH);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"---------");
}

@end
