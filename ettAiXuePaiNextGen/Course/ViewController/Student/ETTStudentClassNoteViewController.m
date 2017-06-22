//
//  ETTStudentClassNoteViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentClassNoteViewController.h"

@implementation ETTStudentClassNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kETTRANDOM_COLOR;

    UILabel *label            = [[UILabel alloc]initWithFrame:CGRectMake(200, 200, 200, 200)];

    label.text                = @"课中笔记";

    label.textColor           = [UIColor blueColor];

    label.font                = [UIFont systemFontOfSize:50];

    [self.view addSubview:label];
}

@end
