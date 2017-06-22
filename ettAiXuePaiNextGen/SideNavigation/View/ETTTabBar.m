//
//  ETTTabBar.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 16/9/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTabBar.h"
#import "ETTBackToPageManager.h"

@interface ETTTabBar ()

@property (nonatomic,weak) ETTTabBarItem *selectedItem;

/**
 *  当前上课的教师(只在学生端显示)
 */
@property (nonatomic,weak) ETTLabel *messageLable;

@end

@implementation ETTTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /**
         *  暂时没有添加对用户身份判断，建议使用USERDEFAULT判断。
         */
        if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
            [self setupItemWithDefaultImageName:@"menu_icon_student_selected" selectedImageName:@"menu_icon_student_default" title:@"学生管理"];
            [self setupItemWithDefaultImageName:@"menu_icon_course_default" selectedImageName:@"menu_icon_course_selected" title:@"我的课程"];
            [self setupItemWithDefaultImageName:@"menu_icon_whiteboard_selected" selectedImageName:@"menu_icon_whiteboard_default" title:@"电子白板"];
            [self setupItemWithDefaultImageName:@"menu_icon_more_default" selectedImageName:@"menu_icon_more_selected" title:@"更多"];
        }else if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"student"])
        {
            [self setupItemWithDefaultImageName:@"menu_icon_course_default" selectedImageName:@"menu_icon_course_selected" title:@"我的课程"];
            [self setupItemWithDefaultImageName:@"menu_icon_whiteboard_selected" selectedImageName:@"menu_icon_whiteboard_default" title:@"电子白板"];
            [self setupItemWithDefaultImageName:@"menu_icon_student_selected" selectedImageName:@"menu_icon_student_default" title:@"课堂表现"];
            [self setupItemWithDefaultImageName:@"menu_icon_more_default" selectedImageName:@"menu_icon_more_selected" title:@"更多"];
        }else if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"ObserveStudents"]){
            [self setupItemWithDefaultImageName:@"menu_icon_course_default" selectedImageName:@"menu_icon_course_selected" title:@"我的课程"];
            [self setupItemWithDefaultImageName:@"menu_icon_whiteboard_selected" selectedImageName:@"menu_icon_whiteboard_default" title:@"电子白板"];
            [self setupItemWithDefaultImageName:@"menu_icon_more_default" selectedImageName:@"menu_icon_more_selected" title:@"更多"];
        }
        
        if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"student"]||[[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"ObserveStudents"]) {
            [self setupLabel];
        }
    }
    return self;
}

-(void)setupItemWithImageName:(NSString *)imageName title:(NSString *)title
{
    ETTTabBarItem *item = [[ETTTabBarItem alloc]init];
    [item setTitle:title forState:UIControlStateNormal];
    UIImage *itemImage  = [UIImage imageNamed:imageName];
    [item setImage:itemImage forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:@"tabbar_separate_selected_bg"] forState:UIControlStateSelected];
    item.tag            = self.subviews.count;
    [item addTarget:self action:@selector(itemClickHandler:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:item];
}

-(instancetype)setupItemWithDefaultImageName:(NSString *)defaultImageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title
{
    ETTTabBarItem *item    = [[ETTTabBarItem alloc]init];
    [item setTitle:title forState:UIControlStateNormal];
    UIImage *defaultName   = [UIImage imageNamed:defaultImageName];
    [item setImage:defaultName forState:UIControlStateNormal];
    UIImage *selectedNamel = [UIImage imageNamed:selectedImageName];
    [item setImage:selectedNamel forState:UIControlStateSelected];
    [item setBackgroundImage:[UIImage imageNamed:@"tabbar_separate_selected_bg"] forState:UIControlStateSelected];
    item.tag               = self.subviews.count;
    [item addTarget:self action:@selector(itemClickHandler:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:item];
    
    return self;
}

-(void)itemClickHandler:(ETTTabBarItem *)sender
{
    NSLog(@"itemClickHandler is %ld",(long)sender.tag);
    
    if (self.MDelegate!=nil&&[self.MDelegate respondsToSelector:@selector(tabbar:fromIndex:toIndex:)]) {
        [self.MDelegate tabbar:self fromIndex:self.selectedItem.tag toIndex:sender.tag];
    }
    
    self.selectedItem.selected = NO;
    sender.selected            = YES;
    self.selectedItem          = sender;
}

-(void)rotateToLandscape:(BOOL)isLandscape
{
    NSUInteger count = self.subviews.count;

    self.width       = self.superview.width;
    self.height      = kDockItemHeight * 6;
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    for (int i = 0; i < count; i++) {
        UIButton *item = self.subviews[i];
        item.width     = self.width;
        item.height    = kDockItemHeight;
        item.y         = item.height * i;
    }
}

-(instancetype)setupLabel
{
    ETTLabel *messageLable = [[ETTLabel alloc]init];
    [messageLable setTextColor:kETTRGBCOLOR(84, 84, 84)];
    [messageLable setFont:[UIFont systemFontOfSize:15.0]];
    [messageLable setTextAlignment:NSTextAlignmentCenter];
    [messageLable setText:@"王小二老师 讲课中..."];
    [self addSubview:messageLable];
    [messageLable setFrame: CGRectMake(self.width/2 - messageLable.width/2, self.height-messageLable.height, messageLable.width, messageLable.height)];
    _messageLable = messageLable;
    
    return self;
}

-(void)setMessageLableText:(NSString *)messStr
{
    NSString *mess = [NSString stringWithFormat:@"%@  老师讲课中...",messStr];
    [_messageLable setText:mess];
}

-(void)unSelected
{
    self.selectedItem.selected = NO;
}

-(void)selectedFirst
{
    [self itemClickHandler:self.subviews[0]];
}



@end
