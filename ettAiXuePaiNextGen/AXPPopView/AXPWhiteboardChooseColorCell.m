//
//  AXPWhiteboardChooseColorCell.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardChooseColorCell.h"

@implementation AXPWhiteboardChooseColorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        self.titleLable     = [UILabel creatTitleLable];
        self.arrowImageView = [UISwitch creatArrowImageView];
        self.colorView      = [UIView creatColorView];
        
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.colorView];
    }
    
    return self;
}

@end
