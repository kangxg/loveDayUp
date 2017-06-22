//
//  AXPWhiteboardSwitchCell.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardSwitchCell.h"

@interface AXPWhiteboardSwitchCell ()

@end

@implementation AXPWhiteboardSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
                
        self.titleLable = [UILabel creatTitleLable];
        self.axpSwitch  = [UISwitch creatSwitch];
        
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.axpSwitch];
    }
    
    return self;
}

@end
