//
//  TestTwoViewController.m
//  ettAiXuePaiNextGen
//
//  Created by zhaiyingwei on 2016/12/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "TestTwoViewController.h"
#import "ETTRedisBasisManager.h"


@interface TestTwoViewController ()

@end

@implementation TestTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor yellowColor]];
    [self createUI];
}

-(void)createUI
{
    UIButton *cCBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cCBtn setFrame:CGRectMake(100, 100, 100 , 60)];
    [cCBtn setTitle:@"推送" forState:UIControlStateNormal];
    [cCBtn setBackgroundColor:[UIColor yellowColor]];
    [cCBtn addTarget:self action:@selector(oncCBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cCBtn];
}

-(void)oncCBtnHandler:(UIButton *)sender
{
    NSLog(@"tow 推送");
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:@"AA" message:@"TTTTTTT" respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"err");
        }else{
            NSLog(@"---->%@",value);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
