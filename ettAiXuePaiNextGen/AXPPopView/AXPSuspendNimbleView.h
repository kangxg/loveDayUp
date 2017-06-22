//
//  AXPSuspendNimbleView.h
//  test
//
//  Created by Li Kaining on 16/9/29.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPNimbleLabel.h"
#import "AXPNimbleButton.h"

@interface AXPSuspendNimbleView : UIView

@property(nonatomic ,strong) AXPNimbleButton *suspendNimbleButton;

@property(nonatomic ,strong) NSMutableArray *nimbleButtons;
@property(nonatomic ,strong) NSMutableArray *explainLables;
@property(nonatomic ) BOOL isShowAnimation;

-(instancetype)initSuspendNimbleViewWithNimbleButtonRect:(CGRect)rect superView:(UIView *)superView;

-(void)showNimbleToolbar;

-(void)hiddenNimbleToolbarCompletion:(void (^)())completion;

@end
