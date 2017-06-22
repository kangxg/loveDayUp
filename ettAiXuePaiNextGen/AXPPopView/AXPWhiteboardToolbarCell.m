//
//  AXPWhiteboardToolbarCell.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardToolbarCell.h"

@interface AXPWhiteboardToolbarCell ()

@property(nonatomic ,strong) UIImageView *arrowImageView;

@end


@implementation AXPWhiteboardToolbarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLable  = [UILabel creatTitleLable];
        self.detailLable = [UILabel creatDetailLable];
        self.arrowImageView = [UIImageView creatArrowImageView];
        
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.detailLable];
        [self.contentView addSubview:self.arrowImageView];
        
    }
    return self;
}

@end
