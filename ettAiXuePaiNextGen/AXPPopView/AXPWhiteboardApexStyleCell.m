//
//  AXPWhiteboardApexStyleCell.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardApexStyleCell.h"

@implementation AXPWhiteboardApexStyleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        self.titleLable     = [UILabel creatTitleLable];
        self.arrowImageView = [UIImageView creatArrowImageView];
        self.apexImageView  = [UIImageView creatApexImageView];

        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.apexImageView];
        [self.contentView addSubview:self.titleLable];
        
    }
    return self;
}
@end
