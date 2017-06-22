//
//  AXPWhiteboardManagerCell.m
//  test
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardManagerCell.h"

@implementation AXPWhiteboardManagerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.imageView                        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 282, 210)];
    self.imageView.center                 = self.contentView.center;
    self.imageView.userInteractionEnabled = YES;

    self.imageView.layer.cornerRadius     = 8;
    self.imageView.layer.masksToBounds    = YES;

    self.deleteButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"whiteboard_moreboard_delete"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteSelectedWhiteboardView) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.frame               = CGRectMake(282-50, 0, 50, 45);
    [self.imageView addSubview:self.deleteButton];
    self.deleteButton.hidden              = YES;

    [self.contentView addSubview:self.imageView];

    self.pageLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.pageLabel.textAlignment          = NSTextAlignmentCenter;

    self.pageLabel.center                 = CGPointMake(kCellWidth/2, kCellHeight-20);
    self.pageLabel.textColor = kAXPCOLORblack_t60;
    
    [self.contentView addSubview:self.pageLabel];
    
    
    return self;
}

-(void)deleteSelectedWhiteboardView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteSelectedWhiteboardView" object:nil];
}


@end
