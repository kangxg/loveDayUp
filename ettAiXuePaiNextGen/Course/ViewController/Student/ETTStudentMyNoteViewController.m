//
//  ETTMyNoteViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentMyNoteViewController.h"

@implementation ETTStudentMyNoteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = kETTRANDOM_COLOR;

    UILabel *label            = [[UILabel alloc]initWithFrame:CGRectMake(200, 200, 200, 200)];

    label.text                = @"我的笔记";

    label.textColor           = [UIColor blueColor];

    label.font                = [UIFont systemFontOfSize:50];

    [self.view addSubview:label];
}

@end
