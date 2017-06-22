//
//  ETTPerformanceHeadView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTPerformanceHeadView.h"

@implementation ETTPerformanceHeadView
-(id)initWithFrame:(CGRect)frame  withTitle:(NSArray<NSString *>*)titleArr
{
    if (self = [super initWithFrame:frame])
    {
        [self createSubViews:titleArr];
    }
    return self;
}
-(void)createSubViews:(NSArray<NSString *>*)titleArr
{
    if (!titleArr ||!titleArr.count)
    {
        return;
    }

        //175;
    float heith = self.height;
    float sumWidth = kWIDTH-96*2-24-17-32-20 -91;
    float width  =sumWidth/4;

    float orx = 96+24+17+20+32+91;;
    for (int i = 0; i<titleArr.count; i++)
    {
        NSString * string = titleArr[i];
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(orx +width *i, 0, width, heith)];
        lab.font  = [UIFont systemFontOfSize:16.0f];
        lab.textColor  = kAXPTEXTCOLORf1;
        lab.text = string;
        
        [self addSubview:lab];
       
         lab.textAlignment = NSTextAlignmentCenter;
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
