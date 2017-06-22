//
//  ETTPromptView.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/30.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTPromptView.h"
#import <Masonry.h>

@implementation ETTPromptView

- (instancetype)initPromptViewWithPromptString:(NSString *)promptString {
    
    if (self = [super init]) {
        [self initPromptLabelWithPromptString:promptString];
    }
    return self;
}

//创建提示label
- (void)initPromptLabelWithPromptString:(NSString *)promptString {
    
    UILabel *promptLabel      = [[UILabel alloc]init];
    promptLabel.text          = promptString;
    promptLabel.font          = [UIFont systemFontOfSize:13.0];
    promptLabel.textColor     = [UIColor whiteColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:promptLabel];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    
}


@end
