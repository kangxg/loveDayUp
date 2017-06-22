//
//  AXPWhiteboardSelectedToolbarCell.m
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardSelectedToolbarCell.h"

@implementation AXPWhiteboardSelectedToolbarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLable        = [UILabel creatTitleLable];
        self.selectedImageView = [UIImageView creatSelectedImageView];
        
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.selectedImageView];
    }
    
    return self;
}

@end
