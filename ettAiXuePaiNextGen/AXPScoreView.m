//
//  AXPScoreView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPScoreView.h"

@implementation AXPScoreView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.scoreLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        self.scoreLabel.userInteractionEnabled = YES;
        self.scoreLabel.font                   = [UIFont systemFontOfSize:24];
        self.scoreLabel.textAlignment          = NSTextAlignmentCenter;
        self.scoreLabel.textColor              = kAXPTEXTCOLORf7;

        self.layer.cornerRadius                = 22;
        self.layer.borderColor                 = kAXPLINECOLORl1.CGColor;
        self.layer.borderWidth                 = 2;
        
        [self addSubview:self.scoreLabel];
        
    }
    
    return self;
}

@end
