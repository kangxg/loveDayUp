//
//  AXPWhiteboardManagerView.h
//左边工具栏
//  test
//
//  Created by Li Kaining on 16/9/18.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXPWhiteboardManagerView : UIView

-(instancetype)initWithConfig:(NSArray *)config;

@property(nonatomic ,strong) UIButton *brushButton;

@property(nonatomic ,strong) UIButton *bucketButton;

@property(nonatomic ,strong) NSMutableArray *buttons;

@property(nonatomic ,strong) UIButton *selectedButton;

-(void)checkoutSelectedButton:(UIButton *)button;

@end
