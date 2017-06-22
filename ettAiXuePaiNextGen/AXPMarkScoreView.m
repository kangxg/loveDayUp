//
//  AXPMarkScoreView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPMarkScoreView.h"
#import "AXPScoreView.h"

typedef void(^markScoreHandle)(NSInteger markScore);

@interface AXPMarkScoreView ()

@property(nonatomic ,strong) NSMutableArray *scoreViews;

@property(nonatomic ,assign) NSInteger selectedScore;

@property(nonatomic ,copy) markScoreHandle markScoreBlock;


@end

@implementation AXPMarkScoreView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kAXPCOLORblack_t60;
                
        [self setUpMarkScoreView];
        [self setUpDeleteView];
    }
    
    return self;
}

-(void)markScoreCompletionHandle:(void(^)(NSInteger markScore))completion
{
    __weak typeof(self)wself = self;
    
    if (completion) {
        
        wself.markScoreBlock = completion;
    }
}

-(void)setUpMarkScoreView
{
    UIView *markScoreView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 675, 240)];
    markScoreView.center             = self.center;
    markScoreView.backgroundColor    = [UIColor whiteColor];
    markScoreView.layer.cornerRadius = 5;

    UILabel *label                   = [[UILabel alloc] initWithFrame:CGRectMake(27, 27, 100, 20)];
    label.text                       = @"请打分:";
    label.textColor                  = kAXPTEXTCOLORf1;
    label.font                       = [UIFont systemFontOfSize:18];
    [markScoreView addSubview:label];

    CGFloat kMarginLeft              = 55;
    CGFloat kMargin                  = 60;
    CGFloat kWH                      = 44;
    
    for (int i = 0; i < 6; i++) {
        
        CGRect rect = CGRectMake(kMarginLeft+(i*(kMargin+kWH)), 120-22, kWH, kWH);
        
        AXPScoreView *scoreView = [[AXPScoreView alloc] initWithFrame:rect];
        scoreView.scoreLabel.text = [NSString stringWithFormat:@"%zd",i];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markScore:)];
        
        [scoreView addGestureRecognizer:tap];
        
        [self.scoreViews addObject:scoreView];
        
        [markScoreView addSubview:scoreView];
    }
    
    [self addSubview:markScoreView];

}

-(void)setUpDeleteView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"socre_close_default"] forState:UIControlStateNormal];
    button.frame = CGRectMake(kWIDTH - 48 - 18, 75, 48, 48);
    
    [button addTarget:self action:@selector(colseMarkScoreView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

-(void)colseMarkScoreView
{
    [self removeFromSuperview];
}

-(void)markScore:(UITapGestureRecognizer *)tap
{
    AXPScoreView *selectedScoreView = (AXPScoreView *)tap.view;
    
    NSInteger selecScore = [self.scoreViews indexOfObject:selectedScoreView];
    
    [self deselectedScore:self.selectedScore];
    [self selectedScore:selecScore];
    
    self.selectedScore = [self.scoreViews indexOfObject:selectedScoreView];
    
    if (self.markScoreBlock) {
        self.markScoreBlock(self.selectedScore);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)deselectedScore:(NSInteger)score
{
    if (score == -1) {
        return;
    }

    AXPScoreView *scoreView     = self.scoreViews[score];
    scoreView.backgroundColor   = [UIColor whiteColor];
    scoreView.layer.borderWidth = 2;
    scoreView.layer.borderColor = kAXPLINECOLORl1.CGColor;
    scoreView.scoreLabel.textColor = kAXPTEXTCOLORf7;
}

-(void)selectedScore:(NSInteger)score
{
    if (score == -1) {
        return;
    }
    
    self.selectedScore             = score;

    AXPScoreView *scoreView        = self.scoreViews[score];

    scoreView.backgroundColor      = kAXPMAINCOLORc20;
    scoreView.layer.borderWidth    = 0;
    scoreView.scoreLabel.textColor = [UIColor whiteColor];
}

-(NSMutableArray *)scoreViews
{
    if (!_scoreViews) {
        _scoreViews = [NSMutableArray array];
    }
    return _scoreViews;
}



@end
