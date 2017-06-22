//
//  AXPRewardManagerView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPRewardManagerView.h"
#import "AXPUserInformation.h"
#import "AXPWhiteboardConfiguration.h"
#import "ETTUSERDefaultManager.h"

#define kMarginTop 23
#define kMarginLeft 15
#define kMarginMid 26
#define kButtonW 90
#define kButtonH 30

@interface AXPRewardManagerView ()


@property(nonatomic ) BOOL isAnimation;

@property(nonatomic ,weak) UIView *shadowView;

@property(nonatomic ,strong) NSMutableArray *buttons;

@property(nonatomic) NSInteger viewHeight;

@property(nonatomic ,copy) NSString *direction;

@property(nonatomic ,copy) void(^pushHandle)();

@property(nonatomic ,copy) void(^endPushHandle)();

@property(nonatomic ,copy) void(^rewardHandle)();


@end

@implementation AXPRewardManagerView

-(instancetype)initWithButtonType:(NSArray *)buttonType
{
    self = [super init];
    
    if (self) {
        
        [buttonType enumerateObjectsUsingBlock:^(NSString *buttonStr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIColor *color;
            
            if ([buttonStr isEqualToString:@"奖励"]) {
                color = kAXPMAINCOLORc12;
            }else
            {
                color = kAXPMAINCOLORc1;
            }
            
            UIButton *button = [self creatButtonWithTitle:buttonStr backgroudColor:color];
            
            [self.buttons addObject:button];
            
            NSString *userType = [AXPUserInformation sharedInformation].userType;
            
            if ([userType isEqualToString:@"teacher"]) {
                
                self.viewHeight = 300;
                [self setUpTeacherView];
                
            }else
            {
                if (buttonType.count == 1) {
                    self.viewHeight = 65;
                } else if (buttonType.count == 2) {
                    self.viewHeight = 170;
                } else if (buttonType.count == 3) {
                    self.viewHeight = 200;
                } else {
                    self.viewHeight = 270;
                }
                
                
                [self setUpStudentView];
            }
        }];
    }

    return self;
}

-(void)pushImageToStudentHandle:(void(^)())pushHandle endPushImageToStudentHandle:(void(^)())endPushHandle;
{
    if (pushHandle) {
        self.pushHandle = pushHandle;
    }
    if (endPushHandle) {
        self.endPushHandle = endPushHandle;
    }
}

-(void)rewardStudent:(void(^)())rewardHandle
{
    if (rewardHandle) {
        self.rewardHandle = rewardHandle;
    }
}

-(void)clickButton:(UIButton *)button
{
    // 老师
    if ([button.currentTitle isEqualToString:@"奖励"]) {
        
        if (self.rewardHandle) {
            self.rewardHandle();
        }
        return;
    }
    
    // 老师
    if ([button.currentTitle isEqualToString:@"推给学生"])
    {
        [self setPushImageSuccessHandle:^{
            
            [button setTitle:@"结束推送" forState:UIControlStateNormal];
            [button setTitle:@"结束推送" forState:UIControlStateHighlighted];
        }];
        
        [self setPushImageFailHandle:^{
            
            // 弹框 推送失败请重试!
            NSLog(@"推送失败请重试!");
        }];
        
        if (self.pushHandle) {
           self.pushHandle();
        }
        
        return;
    }
    
    // 老师: 推给学生-->结束推送-->推给学生...
    if ([button.currentTitle isEqualToString:@"结束推送"])
    {
        // 结束推送被点击
        if (self.endPushHandle) {
            self.endPushHandle();
            [button setTitle:@"推给学生" forState:UIControlStateNormal];
            [button setTitle:@"推给学生" forState:UIControlStateHighlighted];
        }
        
        return;
    }
    
    // 老师 / 学生
    if ([button.currentTitle isEqualToString:@"查看原题"])
    {
        [self checkOriginalSubject];
        
        return;
    }
    
    // 老师
    if ([button.currentTitle isEqualToString:@"学生作答"])
    {
        [self checkStudentRespondImage];
        
        return;
    }
    
    // 学生
    if ([button.currentTitle isEqualToString:@"查看批阅"])
    {
        [self checkCommentImage];
        
        return;
    }
}

// 查看学生作答
-(void)checkStudentRespondImage
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"checkStudentRespondImage" object:nil];
}

// 查看批阅
-(void)checkCommentImage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkCommentImage" object:nil];
}

// 查看原题
-(void)checkOriginalSubject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkOriginalSubject" object:nil];
}

-(void)showOrHiddenManagerView
{
    if (self.isShow) {
        self.isShow = NO;
        [self hiddenRewardManagerViewTimeDuring:0.25];
        
    }else
    {
        self.isShow = YES;
        [self showRewardManagerViewWithTimeDuring:0.25];
    }
}

- (void)hiddenRewardManagerView {
    if (self.isShow) {
        self.isShow = NO;
        [self hiddenRewardManagerViewTimeDuring:0.25];
    }
}

-(void)showRewardManagerViewWithTimeDuring:(NSTimeInterval)duration
{
    if (self.isAnimation) {
        return;
    }
    
    self.isAnimation = YES;
    
    if ([[AXPUserInformation sharedInformation].userType isEqualToString:@"teacher"]) {
        
        [UIView animateWithDuration:duration animations:^{
            //
            self.frame = CGRectMake(kWIDTH - 127 - 34 + 11, 64, 127 + 34, self.viewHeight);
            
        } completion:^(BOOL finished) {
            
            self.shadowView.layer.shadowOffset = CGSizeMake(-2, 2);
            self.frame                         = CGRectMake(kWIDTH - 127 - 34 + 11, 64, 127 + 34, self.viewHeight);
            self.isAnimation                   = NO;
            
        }];
        
    }else
    {
        if ([self.direction isEqualToString:@"左侧"]) {
            
            [UIView animateWithDuration:duration animations:^{
                //
                self.frame = CGRectMake(kWIDTH - 127 - 34 + 11, 64, 127 + 34, self.viewHeight);
                
            } completion:^(BOOL finished) {
                
                self.shadowView.layer.shadowOffset = CGSizeMake(-2, 2);
                self.frame = CGRectMake(kWIDTH - 127 - 34 + 11, 64, 127 + 34, self.viewHeight);
                self.isAnimation = NO;
                
            }];
            
        }else
        {
            [UIView animateWithDuration:duration animations:^{
                //
                self.frame = CGRectMake(-9, 64, 127 + 34, self.viewHeight);
                
            } completion:^(BOOL finished) {
                
                self.shadowView.layer.shadowOffset = CGSizeMake(-2, 2);
                self.frame = CGRectMake(-9, 64, 127 + 34, self.viewHeight);
                self.isAnimation = NO;
                
            }];
        }
    }
}

-(void)hiddenRewardManagerViewTimeDuring:(NSTimeInterval)duration
{
    if (self.isAnimation) {
        return;
    }
    
    self.isAnimation = YES;
    if ([[AXPUserInformation sharedInformation].userType isEqualToString:@"teacher"]) {
        
        [UIView animateWithDuration:duration animations:^{
            //
            self.frame = CGRectMake(kWIDTH - 30, 64, 127 + 34, self.viewHeight);
            
        } completion:^(BOOL finished) {
            
            self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
            self.frame = CGRectMake(kWIDTH - 30, 64, 127 + 34, self.viewHeight);
            self.isAnimation = NO;
        }];
        
    }else
    {
        if ([self.direction isEqualToString:@"左侧"]) {
            
            [UIView animateWithDuration:duration animations:^{
                //
                self.frame = CGRectMake(kWIDTH - 30, 64, 127 + 34, self.viewHeight);
                
            } completion:^(BOOL finished) {
                
                self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
                self.frame = CGRectMake(kWIDTH - 30, 64, 127 + 34, self.viewHeight);
                self.isAnimation = NO;
            }];
            
        }else
        {
            [UIView animateWithDuration:duration animations:^{
                //
                self.frame = CGRectMake(-130, 64, 127 + 34, self.viewHeight);
                
            } completion:^(BOOL finished) {
                
                self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
                self.frame = CGRectMake(-130, 64, 127 + 34, self.viewHeight);
                self.isAnimation = NO;
            }];
        }
    }
}

-(UIButton *)creatButtonWithTitle:(NSString *)title backgroudColor:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setBackgroundColor:color];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)setUpTeacherView
{
    self.frame                           = CGRectMake(kWIDTH - 127 - 34 + 11, 64, 127 + 34, self.viewHeight);

    self.backgroundColor                 = [UIColor clearColor];

    UIView *mainContaintView             = [[UIView alloc] initWithFrame:CGRectMake(34, 0, 127, self.viewHeight)];

    mainContaintView.layer.shadowColor   = [UIColor blackColor].CGColor;
    mainContaintView.layer.shadowOpacity = 0.2;
    mainContaintView.layer.shadowOffset  = CGSizeMake(-2, 2);

    self.shadowView                      = mainContaintView;

    UIView *managerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 127, self.viewHeight)];
    managerView.layer.borderWidth        = 1;
    managerView.layer.borderColor        = kAXPLINECOLORl1.CGColor;
    managerView.backgroundColor          = kAXPMAINCOLORc21;
    managerView.layer.cornerRadius       = 9;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        button.frame = CGRectMake(kMarginLeft, kMarginTop + idx *(kMarginMid + kButtonH), kButtonW, kButtonH);
        
        [managerView addSubview:button];
        
    }];
    
    UIView *drawerView                  = [self setUpDrawerViewWithFrame:CGRectMake(5, 0, 43, 80)];

    UIView *drawContainView             = [[UIView alloc] initWithFrame:CGRectMake(0, 56, 43, 80)];
    drawContainView.backgroundColor     = [UIColor clearColor];
    drawContainView.layer.shadowColor   = [UIColor blackColor].CGColor;
    drawContainView.layer.shadowOpacity = 0.2;
    drawContainView.layer.shadowOffset  = CGSizeMake(-2, 2);
    
    [drawContainView addSubview:drawerView];
    [mainContaintView addSubview:managerView];
    
    [self addSubview:drawContainView];
    [self addSubview:mainContaintView];
    
    [self hiddenRewardManagerViewTimeDuring:0.01];
}

-(UIView *)setUpDrawerViewWithFrame:(CGRect)frame
{
    UIView *drawerView            = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 43, 80)];
    drawerView.backgroundColor    = [UIColor whiteColor];
    drawerView.layer.cornerRadius = 9;
    drawerView.layer.borderColor  = kAXPLINECOLORl1.CGColor;
    drawerView.layer.borderWidth  = 1;

    UITapGestureRecognizer *tap   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenManagerView)];

    [drawerView addGestureRecognizer:tap];

    UIView *line                  = [[UIView alloc] initWithFrame:CGRectMake(12, 20, 5, 40)];
    line.backgroundColor          = kAXPMAINCOLORc6;
    line.layer.cornerRadius       = 2.5;
    
    [drawerView addSubview:line];
    
    return drawerView;
}

-(void)setUpStudentView
{
    AXPWhiteboardConfiguration *whiteboardConfig = [AXPWhiteboardConfiguration sharedConfiguration];
    
    self.direction = whiteboardConfig.toolbar;
    
    if ([whiteboardConfig.toolbar isEqualToString:@"左侧"]) {
        
        [self setUpRightStudentView];
        
    }else
    {
        [self setUpLeftStudentView];
    }
}

-(void)setUpRightStudentView
{
    self.frame                           = CGRectMake(kWIDTH - 127 - 34 + 11, 64, 127 + 34, self.viewHeight);

    self.backgroundColor                 = [UIColor clearColor];

    UIView *mainContaintView             = [[UIView alloc] initWithFrame:CGRectMake(34, 0, 127, self.viewHeight)];

    mainContaintView.layer.shadowColor   = [UIColor blackColor].CGColor;
    mainContaintView.layer.shadowOpacity = 0.2;
    mainContaintView.layer.shadowOffset  = CGSizeMake(-2, 2);

    self.shadowView                      = mainContaintView;

    UIView *managerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 127, self.viewHeight)];
    managerView.layer.borderWidth        = 1;
    managerView.layer.borderColor        = kAXPLINECOLORl1.CGColor;
    managerView.backgroundColor          = kAXPMAINCOLORc21;
    managerView.layer.cornerRadius       = 9;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        button.frame = CGRectMake(kMarginLeft, kMarginTop + idx *(kMarginMid + kButtonH), kButtonW, kButtonH);
        
        [managerView addSubview:button];
        
    }];
    
    UIView *drawerView                  = [self setUpDrawerViewWithFrame:CGRectMake(5, 0, 43, 80)];

    UIView *drawContainView             = [[UIView alloc] initWithFrame:CGRectMake(0, 56, 43, 80)];
    drawContainView.backgroundColor     = [UIColor clearColor];
    drawContainView.layer.shadowColor   = [UIColor blackColor].CGColor;
    drawContainView.layer.shadowOpacity = 0.2;
    drawContainView.layer.shadowOffset  = CGSizeMake(-2, 2);
    
    [drawContainView addSubview:drawerView];
    [mainContaintView addSubview:managerView];
    
    [self addSubview:drawContainView];
    [self addSubview:mainContaintView];
    
    [self hiddenRewardManagerViewTimeDuring:0.01];

}

-(void)setUpLeftStudentView
{
    self.frame                           = CGRectMake(-9, 64, 127 + 34, self.viewHeight);

    self.backgroundColor                 = [UIColor clearColor];

    UIView *mainContaintView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 127, self.viewHeight)];

    mainContaintView.layer.shadowColor   = [UIColor blackColor].CGColor;
    mainContaintView.layer.shadowOpacity = 0.2;
    mainContaintView.layer.shadowOffset  = CGSizeMake(2, -2);

    self.shadowView                      = mainContaintView;

    UIView *managerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 127, self.viewHeight)];
    managerView.layer.borderWidth        = 1;
    managerView.layer.borderColor        = kAXPLINECOLORl1.CGColor;
    managerView.backgroundColor          = kAXPMAINCOLORc21;
    managerView.layer.cornerRadius       = 9;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        button.frame = CGRectMake(kMarginLeft + 7, kMarginTop + idx *(kMarginMid + kButtonH), kButtonW, kButtonH);
        
        [managerView addSubview:button];
        
    }];
    
    UIView *drawerView            = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, 43, 80)];
    drawerView.backgroundColor    = [UIColor whiteColor];
    drawerView.layer.cornerRadius = 9;
    drawerView.layer.borderColor  = kAXPLINECOLORl1.CGColor;
    drawerView.layer.borderWidth  = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenManagerView)];
    
    [drawerView addGestureRecognizer:tap];
    
    UIView *line                        = [[UIView alloc] initWithFrame:CGRectMake(27, 20, 5, 40)];
    line.backgroundColor                = kAXPMAINCOLORc6;
    line.layer.cornerRadius             = 2.5;

    [drawerView addSubview:line];

    UIView *drawContainView             = [[UIView alloc] initWithFrame:CGRectMake(127 - 12, 56, 43, 80)];
    drawContainView.backgroundColor     = [UIColor clearColor];
    drawContainView.layer.shadowColor   = [UIColor blackColor].CGColor;
    drawContainView.layer.shadowOpacity = 0.2;
    drawContainView.layer.shadowOffset  = CGSizeMake(2, -2);
    
    [drawContainView addSubview:drawerView];
    [mainContaintView addSubview:managerView];
    
    [self addSubview:drawContainView];
    [self addSubview:mainContaintView];
    
    [self hiddenRewardManagerViewTimeDuring:0.01];
}


-(NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


@end
