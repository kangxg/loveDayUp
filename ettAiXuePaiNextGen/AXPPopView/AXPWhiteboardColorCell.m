//
//  AXPWhiteboardColorCell.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardColorCell.h"

@implementation AXPWhiteboardColorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if (![reuseIdentifier isEqualToString:@"AXPWhiteboardPolygonStyleCell"]) {
            
            UIImage *colorImage = [UIImage imageNamed:@"colorImage"];
            self.imageView.image = colorImage;
            self.imageView.layer.cornerRadius = 4;
        }
        
        if ([reuseIdentifier isEqualToString:@"AXPWhiteboardApexStyleCell"]) {
        
            self.imageView.layer.cornerRadius = 0;
        }

        self.imageView.center  = CGPointMake(30, 22);

        self.colorLabel        = [UILabel creatColorLabel];
        self.selectedImageView = [UIImageView creatSelectedImageView];

        UIView *bottomLine     = [[UIView alloc] initWithFrame:CGRectMake(60, 43.5, kAXPPopWidth-60, 0.5)];
        bottomLine.backgroundColor = kAXPLINECOLORl3;
        
        [self.contentView addSubview:bottomLine];
        [self.contentView addSubview:self.colorLabel];
        [self.contentView addSubview:self.selectedImageView];

    }
    
    return self;
}

@end
