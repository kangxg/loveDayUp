//
//  ETTCoursewareTitleHeader.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/29.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCoursewareTitleHeader.h"

@implementation ETTCoursewareTitleHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _sectionTitleLabel               = [[UILabel alloc]init];
        _sectionTitleLabel.textColor     = kF4_COLOR;
        _sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
        _sectionTitleLabel.font          = [UIFont systemFontOfSize:20.0];
        [self addSubview:_sectionTitleLabel];
        
    }
    return self;
}


@end
