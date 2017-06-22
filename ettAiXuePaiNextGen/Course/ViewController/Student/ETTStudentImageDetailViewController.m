//
//  ETTStudentImageDetailViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentImageDetailViewController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "ETTImageManager.h"
#import "AppDelegate.h"
#import "AXPWhiteboardToolbarManager.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "AXPGetRootVcTool.h"
@interface ETTStudentImageDetailViewController ()<UIGestureRecognizerDelegate>
{
    UIPinchGestureRecognizer *_pinchGes;//缩放手势
    UIPanGestureRecognizer   *_panGes;//移动手势
    CGPoint                  _startPoint;
}
@property (strong, nonatomic) UIImageView *contentView;

@property (strong, nonatomic) UIImageView *detailImageView;

@property (strong, nonatomic) UIImage *image;

@end

@implementation ETTStudentImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    
    [self setupNavBar];
    
    _pinchGes          = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    _pinchGes.delegate = self;
    [_detailImageView addGestureRecognizer:_pinchGes];

    _panGes            = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    _panGes.delegate   = self;
    [_detailImageView addGestureRecognizer:_panGes];
    
}

#pragma mark - gestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

/**
 缩放手势事件

 @param pinch <#pinch description#>
 */
- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    UIImageView *imageView = (UIImageView *)pinch.view;
    imageView.transform    = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
}


/**
 移动手势

 @param pan <#pan description#>
 */
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    UIImageView *imageView = (UIImageView *)pan.view;
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        CGPoint startPoint = [pan locationInView:pan.view.superview];
        
        self->_startPoint = startPoint;
    }
    
    CGPoint movePoint = [pan locationInView:pan.view.superview];

    CGFloat increaseX = movePoint.x - self->_startPoint.x;
    CGFloat increaseY = movePoint.y - self->_startPoint.y;

    CGPoint center;
    
    center = CGPointMake(imageView.center.x + increaseX, imageView.center.y + increaseY);
    
    
    imageView.center = center;
    
    self->_startPoint = movePoint;
}

//设置导航栏
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationItem.title = self.navigationTitle;
    
    //左边返回按钮
    UIButton *backButton       = [UIButton new];
    backButton.frame           = CGRectMake(15, 0, 80, 44);

    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 50);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    //右边推送按钮
    UIButton *pushButton       = [UIButton new];
    CGFloat pushButtonWidth    = 80;
    CGFloat pushButtonHeight   = 44;
    [pushButton setTitle:@"插入白板" forState:UIControlStateNormal];
    pushButton.frame           = CGRectMake(0, 0, pushButtonWidth, pushButtonHeight);
    [pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    pushButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    pushButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
    [pushButton addTarget:self action:@selector(pushButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//返回按钮的事件方法
- (void)backButtonDidClick {

    [ETTCoursewarePresentViewControllerManager sharedManager].indexPath = nil;
    
    if ([ETTCoursewarePresentViewControllerManager sharedManager].isOpenVideo == YES) {
        [ETTCoursewarePresentViewControllerManager sharedManager].isOpenVideo = NO;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//右边按钮点击事件
- (void)pushButtonDidClick {
    
    ETTLog(@"插入白板按钮被点击了当前图片的URLString:%@",self.imageURLString);
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    [[AXPWhiteboardToolbarManager sharedManager].whiteboardView addImage:self.image from:AXPCoursewareImage];
    
    [rootVc presentViewControllerToIndex:2 title:@"电子白板"];
}

- (void)setupSubview {
    
    //容器
    _contentView                            = [[UIImageView alloc]init];
    _contentView.backgroundColor            = [UIColor whiteColor];
    _contentView.userInteractionEnabled     = YES;
    _contentView.frame                      = self.view.frame;
    [self.view addSubview:_contentView];

    _detailImageView                        = [[UIImageView alloc]init];
    _detailImageView.userInteractionEnabled = YES;
    [_contentView addSubview:_detailImageView];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageURLString] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        self.image     = image;

        CGSize maxSize = CGSizeMake(self.view.frame.size.width * 0.9, self.view.frame.size.height * 0.9);

        CGSize size    = [ETTImageManager getImageSizeWithImage:image maxSize:maxSize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _detailImageView.frame  = CGRectMake(0, 0, size.width, size.height);
            _detailImageView.center = self.view.center;

            _detailImageView.image  = image;
        });
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
