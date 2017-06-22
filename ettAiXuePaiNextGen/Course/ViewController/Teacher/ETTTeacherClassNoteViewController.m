//
//  ETTClassNoteViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherClassNoteViewController.h"

@implementation ETTTeacherClassNoteViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kETTRANDOM_COLOR;

    UILabel *label            = [[UILabel alloc]initWithFrame:CGRectMake(200, 200, 200, 200)];

    label.text                = @"课中笔记";

    label.textColor           = [UIColor grayColor];

    label.font                = [UIFont systemFontOfSize:50];

    [self.view addSubview:label];
}

@end
