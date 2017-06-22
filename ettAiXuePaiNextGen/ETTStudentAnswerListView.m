//
//  ETTStudentAnswerListView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentAnswerListView.h"
#import "UIColor+RGBColor.h"

@implementation ETTStudentAnswerListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
     
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpHolderView];
        
    }
    return self;
}

-(void)setUpHolderView
{
    UIView *holderView         = [[UIView alloc] init];
    holderView.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, 300)];
    imageView.image            = [UIImage imageNamed:@"image_none_student"];
    UILabel *label             = [[UILabel alloc] init];
    label.text                 = @"暂无学生答题";
    self.explainLabel          = label;
    label.textColor            = kAXPTEXTCOLORf1;
    label.font                 = [UIFont systemFontOfSize:20];
    [label sizeToFit];

    label.center               = CGPointMake(imageView.center.x, imageView.center.y + 70 + 150 + label.frame.size.height/2);
    holderView.frame           = CGRectMake(0, 0, 450, 300+70+label.frame.size.height);
    holderView.center          = self.center;
    
    [holderView addSubview:imageView];
    [holderView addSubview:label];
    
    [self addSubview:holderView];
}

@end
