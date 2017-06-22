//
//  ETTStudentMoreViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/1.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentMoreViewController.h"
#import "ETTSideNavigationViewController.h"

@interface ETTStudentMoreViewController ()

@property(nonatomic ,strong) UIViewController *testVc;

@end

@implementation ETTStudentMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self setupNavBar];
}

-(void)test
{
    UIViewController *vc    = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor greenColor];

    self.testVc             = vc;

    UIButton *button        = [[UIButton alloc] initWithFrame:CGRectMake(100,100, 100, 100)];
    button.backgroundColor  = [UIColor blueColor];

    [button addTarget:self action:@selector(test111) forControlEvents:UIControlEventTouchUpInside];

    [vc.view addSubview:button];

    [self presentViewController:vc animated:YES completion:nil];
}

-(void)test111
{
    [self.testVc dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test];
}

- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    //左侧菜单按钮
    UIButton *menuButton = [UIButton new];
    [menuButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [menuButton setTitle:@"更多" forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //[menuButton setBackgroundColor:[UIColor redColor]];
    menuButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    menuButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 100);//image距离button边框的距离
    menuButton.titleEdgeInsets = UIEdgeInsetsMake(2, -15, 2, 15);
    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    menuButton.frame = CGRectMake(15, 12, 120, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    
}

-(void)dealloc
{
    NSLog(@"-----------------学生更多控制器被销毁了!");
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
