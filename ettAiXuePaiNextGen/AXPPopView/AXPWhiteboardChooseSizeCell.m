//
//  AXPWhiteboardChooseSizeCell.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardChooseSizeCell.h"


@implementation AXPWhiteboardChooseSizeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        self.titleLable = [UILabel creatTitleLable];
        self.slider     = [UISlider creatSlider];
        self.sliderLable= [UISlider createSliderDescribeLabel];

        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.sliderLable];
        [self.contentView addSubview:self.slider];
    }
    
    return self;
}


@end
