//
//  AXPWhiteboardPromptView.m
//  test
//
//  Created by Li Kaining on 16/9/30.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardPromptView.h"

@implementation AXPWhiteboardPromptView

-(instancetype)initWithPromptStr:(NSString *)promptStr;
{
    self = [super init];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self createPromptLabelWithTitle:promptStr];
    
    return self;
}

-(void)createPromptLabelWithTitle:(NSString *)title
{
    UILabel *label            = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAXPWhiteboardPromptW, kAXPWhiteboardPromptH)];

    label.backgroundColor     = [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.5];

    label.layer.cornerRadius  = 5;
    label.layer.masksToBounds = YES;

    label.textAlignment       = NSTextAlignmentCenter;

    label.font                = [UIFont systemFontOfSize:18];
    label.textColor           = [UIColor whiteColor];
    label.text                = title;
    
    [self addSubview:label];
}

@end
