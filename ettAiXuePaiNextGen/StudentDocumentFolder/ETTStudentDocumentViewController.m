//
//  ETTStudentDocumentViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/1.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentDocumentViewController.h"
#import "ETTSideNavigationViewController.h"

@interface ETTStudentDocumentViewController ()

@end

@implementation ETTStudentDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    
}

- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    
    UIView *leftView     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label       = [[UILabel alloc]init];
    label.textColor      = [UIColor whiteColor];
    label.font           = [UIFont systemFontOfSize:17];
    label.textAlignment  = NSTextAlignmentLeft;
    label.frame          = CGRectMake(42+5-10, 7, 75, 30);
    label.text           = @"文件夹";

    //左侧菜单按钮
    UIButton *menuButton = [UIButton new];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];
    menuButton.frame = CGRectMake(-10, 2, 42, 41);
    
    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:label];
    [leftView addSubview:menuButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
}

//左边我的课程菜单
- (void)menuButtonDidClick {
    
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
