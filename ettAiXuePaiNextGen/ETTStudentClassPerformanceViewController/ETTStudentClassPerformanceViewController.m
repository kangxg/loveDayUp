//
//  ETTStudentClassPerformanceViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/1.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentClassPerformanceViewController.h"
#import "ETTSideNavigationViewController.h"

@interface ETTStudentClassPerformanceViewController ()

@end

@implementation ETTStudentClassPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    
}

- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};

    //左侧菜单按钮
    UIButton *menuButton                                        = [UIButton new];
    [menuButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [menuButton setTitle:@"学生管理" forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //[menuButton setBackgroundColor:[UIColor redColor]];
    menuButton.titleLabel.font                                  = [UIFont systemFontOfSize:17.0];
    menuButton.imageEdgeInsets                                  = UIEdgeInsetsMake(2, 0, 2, 100);//image距离button边框的距离
    menuButton.titleEdgeInsets                                  = UIEdgeInsetsMake(2, -15, 2, 15);
    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    menuButton.frame                                            = CGRectMake(15, 12, 120, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    
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
