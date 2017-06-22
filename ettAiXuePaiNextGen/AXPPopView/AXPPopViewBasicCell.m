//
//  AXPPopViewBasicCell.m
//  test
//
//  Created by Li Kaining on 16/9/22.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPPopViewBasicCell.h"

@implementation AXPPopViewBasicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


-(instancetype)init
{
    self = [super init];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

@end
