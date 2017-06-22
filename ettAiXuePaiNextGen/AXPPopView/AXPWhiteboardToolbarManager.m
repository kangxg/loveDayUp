//
//  AXPWhiteboardToolbarManager.m
//  test
//
//  Created by Li Kaining on 16/9/23.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardToolbarManager.h"
#import "ETTImageManager.h"
#import "ETTPaintbrushManager.h"
#import "ETTImagePickerManager.h"
#import "UIView+UIImage.h"
#import "UIColor+RGBColor.h"
#import "AXPSetPopViewController.h"
#import "AXPPopViewController.h"
#import "ETTAlertController.h"
#import "AXPPolygonView.h"
#import "AXPNextWhiteboardPageView.h"
#import "AXPWhiteboardManagerCollectionView.h"
#import "AXPCarouselViewLayout.h"
#import "AXPPolygonManager.h"
#import "AXPUserInformation.h"
#import "AXPGetRootVcTool.h"

#define kAddImageViewXDefault 0
#define kAddImageViewYDefault 0

typedef NS_ENUM(NSInteger, AXPNimbleViewManager) {//右边的管理
    
    AXPNimbleAddWhiteboard = 0,//快捷
    AXPNimbleWhiteboardsManager = 1,
    AXPNimbleAirplayManager = 2,
    AXPNimbleLockScreeenManager = 3,
};

typedef void(^setUpCompletionHandle)();

@interface AXPWhiteboardToolbarManager ()

@property(nonatomic ,strong) NSMutableDictionary *whiteboardDataConfig;
@property(nonatomic ,strong) NSMutableArray *imagesName;
@property(nonatomic ,strong) UIButton *forwardButton;
@property(nonatomic ,strong) UIButton *backButton;
@property(nonatomic ,strong) UIButton *currentButton;

@property(nonatomic ,strong) AXPWhiteboardManagerCollectionView *managerView;

@end

@implementation AXPWhiteboardToolbarManager

// 移动图片
- (void)moveImage
{
    // 关闭悬浮按钮
    [self.suspendNimbleView hiddenNimbleToolbarCompletion:nil];
    [self.whiteboardView addPinchAndRotationGestureRecognizer];
}

// 添加特殊图形
- (void)addPolygon
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self.whiteboardView addTapGesture];
    });
}

// 清除白板
- (void)clearWhiteBoard
{
    __weak typeof(self)wself = self;
    
    ETTAlertController *alert = [ETTAlertController createAlertControllerWithTitle:@"清空白板" Message:@"这将清空当前白板内\n所有的内容" YesHandle:^{
        //
        [wself.whiteboardView clearWhiteboard];
        
        [wself checkoutSelectedButton];
        
    } NoHandle:^{
        //
        [wself checkoutSelectedButton];
    }];
    
    [self.vc presentViewController:alert animated:YES completion:nil];
}

// 前一步
- (void)forward
{
    [self.whiteboardView forward];
    [self checkoutSelectedButton];
}

// 后一步
- (void)next
{
    [self.whiteboardView next];
    [self checkoutSelectedButton];
}

-(void)checkoutSelectedButton
{
    UIButton *button = self.whiteboardToolbar.buttons[self.whiteboardConfig.brushSelected - 2];
    
    [self.whiteboardToolbar checkoutSelectedButton:button];
    
}

// 保存当前白板内容到相册
- (void)save
{
    // 1. 获取当前View截图
    UIImage *image = [UIView snapshot:self.whiteboardView];
    [self checkoutSelectedButton];
    [ETTImagePickerManager saveImageToPhotosAlbum:image];
}

// 3. 上一步
// 4. 下一步
// 5. 设置 --- pop 导航 导航
// 6. 删除白板 --- 弹框/提示
// 7. 保存图片
// 8. 文件夹
// 9. 移动
// 10.添加图片
// 11.画笔 --- pop 导航
// 12.橡皮擦 --- pop 导航
// 13.画桶/填充色 --- pop 导航
// 14.添加文字
// 15.添加直线 --- pop
// 16.添加三角形 --- pop
// 17.添加多边形 --- pop
// 18.添加圆 --- pop

-(void)presentControllerWithSelectedButton:(UIButton *)button isPopVc:(BOOL)isPopVc;
{
    // 关闭悬浮按钮
    [self.suspendNimbleView hiddenNimbleToolbarCompletion:nil];
    
    if (self.whiteboardView.currentTextView) {
         [self.whiteboardView textViewDidDone];
    }
    
    [self.whiteboardView selectedMovedImageWithPoint:CGPointZero];
    
    self.currentButton = button;
    
    NSInteger index = button.tag - buttonTagBase;
    
    if (index != AXPWhiteboardMove) {
        
        [self.whiteboardView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.whiteboardView removeGestureRecognizer:obj];
        }];
    }
    
    switch (index) {
//        case AXPWhiteboardRecord:
//            // 开始录制
//            break;
//            
//        case AXPWhiteboardEnd:
//            // 停止录制
//            break;
            
        case AXPWhiteboardForward:
            // 前一步
            [self forward];
            break;
            
        case AXPWhiteboardBackward:
            // 后一步
            [self next];
            break;
            
        case AXPWhiteboardSet:
            // 设置
            if (isPopVc) {
             
                if (self.whiteboardConfig.isWhiteboardPushing) {
                    isPopVc = NO;
                }
            }
            [self popViewControllerWithSelectedButton:button title:@"设置" isPopVc:isPopVc];
            [self.whiteboardView removeNotCompletedPolygon];
            break;
            
        case AXPWhiteboardTrash:
            // 垃圾桶/删除
            [self clearWhiteBoard];
            break;
            
        case AXPWhiteboardSave:
            // 保存
            [self save];
            [self.whiteboardView removeNotCompletedPolygon];
            break;
            
//        case AXPWhiteboardFolder:
//            [self.whiteboardView removeNotCompletedPolygon];
//
//            // 文件夹
//            break;
            
        case AXPWhiteboardMove:
            // 移动
            self.whiteboardManager              = index;
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];

            [self moveImage];
            break;
            
        case AXPWhiteboardImage:
            // 添加图片
            self.whiteboardManager              = index;
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self popViewControllerWithSelectedButton:button title:@"添加图片" isPopVc:isPopVc];
            [self.whiteboardView removeNotCompletedPolygon];
            break;
            
        case AXPWhiteboardBrush:
            // 画笔
            self.whiteboardManager = index;
            
            if (isPopVc) {
            
                if (self.whiteboardConfig.isFirstUseBrush) {
                    
                    self.whiteboardConfig.isFirstUseBrush = NO;
                    isPopVc = YES;
                    
                }else
                {
                    if (self.whiteboardConfig.brushSelected == AXPWhiteboardBrush) {
                        
                        isPopVc = YES;
                    }else
                    {
                        isPopVc = NO;
                    }
                }
            }
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"属性" isPopVc:isPopVc];
            
            break;
            
        case AXPWhiteboardEraser:
            // 橡皮擦
            self.whiteboardManager = index;
            
            if (isPopVc) {
                
                if (self.whiteboardConfig.isFirstUseEraser) {
                    
                    self.whiteboardConfig.isFirstUseEraser = NO;
                    isPopVc = YES;
                    
                }else
                {
                    if (self.whiteboardConfig.brushSelected == AXPWhiteboardEraser) {
                        
                        isPopVc = YES;
                    }else
                    {
                        isPopVc = NO;
                    }
                }
            }
            
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"属性" isPopVc:isPopVc];
            break;
            
//        case AXPWhiteboardBucket:
//            // 画桶
//            self.whiteboardManager = index;
//            self.whiteboardConfig.brushSelected = self.whiteboardManager;
//            [self.whiteboardView removeNotCompletedPolygon];
//            [self popViewControllerWithSelectedButton:button title:@"属性" isPopVc:isPopVc];
//            break;
            
        case AXPWhiteboardText:
            // 添加文字
            self.whiteboardManager = index;
            
            if (isPopVc) {
            
                if (self.whiteboardConfig.isFirstUseText) {
                    
                    self.whiteboardConfig.isFirstUseText = NO;
                    isPopVc = YES;
                    
                }else
                {
                    if (self.whiteboardConfig.brushSelected == AXPWhiteboardText) {
                        
                        isPopVc = YES;
                    }else
                    {
                        isPopVc = NO;
                    }
                }
            }
            
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"属性" isPopVc:isPopVc];
            break;
            
        case AXPWhiteboardLine:
            // 添加线
            self.whiteboardManager = index;
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"线" isPopVc:NO];
            [self.whiteboardView addTapGesture];
            [self showAddLinePrompt];
            break;
            
        case AXPWhiteboardTriangle:
            // 添加三角形
            self.whiteboardManager = index;
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"三角形" isPopVc:isPopVc];
            [self.whiteboardView addTapGesture];
            
            break;
            
        case AXPWhiteboardQuadrangle:
            // 添加四边形
            self.whiteboardManager = index;
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"四边形" isPopVc:isPopVc];
            [self.whiteboardView addTapGesture];
            
            break;
            
        case AXPWhiteboardCircle:
            // 添加圆
            self.whiteboardManager = index;
            self.whiteboardConfig.brushSelected = self.whiteboardManager;
            [self.whiteboardView removeNotCompletedPolygon];
            [self popViewControllerWithSelectedButton:button title:@"圆" isPopVc:NO];
            [self.whiteboardView addTapGesture];
            [self showAddCirclePrompt];

            break;
            
        default:
            break;
    }
    
    [self.whiteboardView setNeedsDisplay];
}

-(void)addImageWithImagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.whiteboardView.photoImages.count == 10) {
        
        [ETTImagePickerManager creatAlertViewWithMessage:@"最多不能超过10张图片"];
    }else
    {
        __weak typeof(self)wself = self;
        
        UIButton *button = self.whiteboardToolbar.buttons[AXPWhiteboardImage-2] ;
        [ETTImagePickerManager createManagerButton:button sourceType:sourceType completionHandle:^(UIImage *pickerImage) {
            
            if (self.whiteboardView.photoImages.count == 10) {
                [ETTImagePickerManager creatAlertViewWithMessage:@"最多不能超过10张图片"];
            }else
            {
                [wself.whiteboardView addImage:pickerImage from:AXPPhotoImage];
            }
        }];
    }
}

-(void)addImageFromLocalFolder
{
    NSLog(@"---------从本地文件夹选择图片-------");
}

-(void)resumeBeforePushedWhiteboard:(UIView *)whiteboardView
{
    [self.whiteboardView removeFromSuperview];
    
    self.whiteboardView = (ETTWhiteBoardView *)whiteboardView;
    
    [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
}

//创建新的白板页
-(void)addPushingWhiteboardView
{
    [self.whiteboardView removeFromSuperview];
   
    self.whiteboardView = [[ETTWhiteBoardView alloc] init];
    
    [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
    
    [self changeWhiteboardToolbarAndWhiteboardView];    
}
-(void)resetWhiteboardManager
{
    
}


+(instancetype)reginViewController:(UIViewController *)vc
{
    
    AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
    manager.vc = vc;
    
    if (!manager.axpWhiteboardView) {
        manager.axpWhiteboardView                 = [[AXPWhiteboardView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        manager.axpWhiteboardView.backgroundColor = kAXPMAINCOLORc3;
    }
    
    if (manager.managerView) {
        [manager.managerView removeFromSuperview];
        manager.suspendNimbleView.suspendNimbleButton.hidden = NO;
        
        manager.isShowMnangerCollectionView = NO;
    }
    
    // 如果白板数少于10,可以继续添加白板
    if (manager.whiteboards.count < 10) {
        
        [manager.whiteboardView removeFromSuperview];
        if(manager.whiteboards.count == 0)
        {
            manager.whiteboardView = [[ETTWhiteBoardView alloc] init];
            
            [manager.whiteboards addObject:manager.whiteboardView];
            
            [manager.axpWhiteboardView insertSubview:manager.whiteboardView aboveSubview:manager.whiteboardToolbar];
        }
        else
        {
            ETTWhiteBoardView  * view  = nil;
            for (UIView * rview in  manager.axpWhiteboardView.subviews)
            {
                if ([rview isKindOfClass:[ETTWhiteBoardView class]])
                {
                    view =(ETTWhiteBoardView  *) rview;
                    break;
                }
            }
            
            if(view == nil)
            {
                view = manager.whiteboards.firstObject;
                manager.whiteboardView = view;
                [manager.axpWhiteboardView insertSubview:manager.whiteboardView aboveSubview:manager.whiteboardToolbar];
                
            }
        }
        manager.axpWhiteboardView.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
        [vc.view addSubview:manager.axpWhiteboardView];
    }
    
    [manager addSuspendNimbleView];
    [manager changeWhiteboardToolbarAndWhiteboardView];
    [manager showInitPageNumber];

     return manager;
}


-(void)showInitPageNumber
{
    [self.axpWhiteboardView insertSubview:self.addMoreWhiteboardPageView aboveSubview:self.whiteboardView];
    
    NSUInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView] +1;
    NSUInteger count = self.whiteboards.count;
    
    NSString *pageNumberStr = [NSString stringWithFormat:@"%lu / %lu",(unsigned long)currentPage,(unsigned long)count];
    
    [self.addMoreWhiteboardPageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UILabel class]]) {
            
            UILabel *pageNumberLabel = obj;
            
            pageNumberLabel.text = pageNumberStr;
            
            *stop = YES;
        }
    }];
    
    [self updateButtonStatus];
}
// 添加一页白板内容到当前控制器.
+(instancetype)addWhiteboardToController:(UIViewController *)vc
{
    AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
    manager.vc = vc;
    
    if (manager.managerView) {
        [manager.managerView removeFromSuperview];
        manager.suspendNimbleView.suspendNimbleButton.hidden = NO;

        manager.isShowMnangerCollectionView = NO;
    }
    
    // 如果白板数少于10,可以继续添加白板
    if (manager.whiteboards.count < 10) {
        
        [manager.whiteboardView removeFromSuperview];
    
        manager.whiteboardView = [[ETTWhiteBoardView alloc] init];

        [manager.whiteboards addObject:manager.whiteboardView];
        
        [manager.axpWhiteboardView insertSubview:manager.whiteboardView aboveSubview:manager.whiteboardToolbar];
    
        manager.axpWhiteboardView.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
        [vc.view addSubview:manager.axpWhiteboardView];
    }
    
    [manager addSuspendNimbleView];
    [manager changeWhiteboardToolbarAndWhiteboardView];
    [manager showPageNumber];
    
    return manager;
}
-(void)byManagementViewWillAppear
{
    if (self.suspendNimbleView)
    {
        self.suspendNimbleView.isShowAnimation = false;
        self.suspendNimbleView.suspendNimbleButton.selected = false;
    }
}
-(void)addSuspendNimbleView
{
    CGRect rect = self.axpWhiteboardView.frame;
    //- 56
    CGRect suspendNimbleRect = CGRectMake(rect.size.width - 56 -16, rect.size.height-64 -16, 56, 56);

    if (!self.suspendNimbleView) {
        
        AXPSuspendNimbleView *suspendNimbleView = [[AXPSuspendNimbleView alloc] initSuspendNimbleViewWithNimbleButtonRect:suspendNimbleRect superView:self.axpWhiteboardView];
        
        self.suspendNimbleView = suspendNimbleView;
       
        
    }else
    {
        [self.axpWhiteboardView bringSubviewToFront:self.suspendNimbleView.suspendNimbleButton];
    }
    
    for (int i = 0; i < self.suspendNimbleView.nimbleButtons.count; i++) {
        
        UIButton *button = self.suspendNimbleView.nimbleButtons[i];

        [button addTarget:self action:@selector(clickNimbleViewWithSender:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = self.suspendNimbleView.explainLables[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNimbleViewWithSender:)];
        [label addGestureRecognizer:tap];
    }
}

-(void)clickNimbleViewWithSender:(id)sender
{
    if (self.suspendNimbleView.isShowAnimation) {
        return ;
    }
    
    UIView *view;
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        
        UITapGestureRecognizer *tap = sender;
        view = tap.view;
    }else
    {
        view = sender;
    }
    
    switch (view.tag - 10000) {
    
        case AXPNimbleAddWhiteboard:
        
            if (self.whiteboards.count == 10) {
                
                [self.axpWhiteboardView showPromptWithStr:@"最多不能超过10页白板"];
            }
            
            if (self.suspendNimbleView.suspendNimbleButton.hidden) {
            
                self.suspendNimbleView.suspendNimbleButton.hidden = NO;
                
                UIButton *button = self.suspendNimbleView.nimbleButtons.firstObject;
                button.frame = CGRectMake(0, 0, 40, 40);
                button.center = self.suspendNimbleView.suspendNimbleButton.center;
                [button removeFromSuperview];
                
                [self.suspendNimbleView hiddenNimbleToolbarCompletion:nil];
                [AXPWhiteboardToolbarManager addWhiteboardToController:self.vc];
            }else
            {
                [self.suspendNimbleView hiddenNimbleToolbarCompletion:^{
                   
                    [AXPWhiteboardToolbarManager addWhiteboardToController:self.vc];
                }];
            }

            break;
            
        case AXPNimbleWhiteboardsManager:
            
            // 白板管理
            [self managerWhiteboards];
            
            break;
            
        case AXPNimbleAirplayManager:
            
            break;
            
        case AXPNimbleLockScreeenManager:
            
            break;
            
        default:
            break;
    }
}

-(void)managerWhiteboards
{
    self.isShowMnangerCollectionView = YES;
    
    NSInteger currentWhiteboard = [self.whiteboards indexOfObject:self.whiteboardView];
    
    NSMutableArray *array = [NSMutableArray array];
    [self.whiteboards enumerateObjectsUsingBlock:^(ETTWhiteBoardView *whiteboardView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = [UIView snapshot:whiteboardView];
        [array addObject:image];
    }];
    
    if (self.managerView) {
        self.managerView.whiteboards = array.mutableCopy;
        self.managerView.currentSelectedIndex = currentWhiteboard;
        [self.managerView reloadData];
    }else
    {
        AXPWhiteboardManagerCollectionView *managerView = [[AXPWhiteboardManagerCollectionView alloc] initWithWhiteboards:array currentWhiteboard:currentWhiteboard frame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        self.managerView = managerView;
    }
    
    AXPCarouselViewLayout *layout =(AXPCarouselViewLayout *)self.managerView.collectionViewLayout;
    layout.selectedIndex = currentWhiteboard;
    
    self.managerView.contentOffset = CGPointMake(-540 + (currentWhiteboard)*286 + 143, 0);
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    [rootVc.view insertSubview:self.managerView belowSubview:self.suspendNimbleView];
    
    [self.suspendNimbleView hiddenNimbleToolbarCompletion:^{
        
        self.suspendNimbleView.suspendNimbleButton.hidden = YES;
        
        UIButton *button = self.suspendNimbleView.nimbleButtons.firstObject;
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, 56, 56);
        button.center = self.suspendNimbleView.suspendNimbleButton.center;
        
        [rootVc.view addSubview:button];
    }];
}

-(void)changeToWhiteboardView:(NSNotification *)notify
{
    NSIndexPath *indexPath = notify.object;
    
    [self.whiteboardView removeFromSuperview];
    
    ETTWhiteBoardView *whiteboardView = self.whiteboards[indexPath.row];
    self.whiteboardView = whiteboardView;
    [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
    [self showPageNumber];
    
    UIButton *button = self.suspendNimbleView.nimbleButtons.firstObject;
    [button removeFromSuperview];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.center = self.suspendNimbleView.suspendNimbleButton.center;
    self.suspendNimbleView.suspendNimbleButton.hidden = NO;
    
    self.isShowMnangerCollectionView = NO;
}

static id _instance;
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWhiteboardToolbarAndWhiteboardViewNotification:) name:@"changeWhiteboardToolbarAndWhiteboardView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToWhiteboardView:) name:@"didSelectedWhiteboardView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSelectedWhiteboardView) name:@"deleteSelectedWhiteboardView" object:nil];
        
        

        self.axpWhiteboardView                 = [[AXPWhiteboardView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        self.axpWhiteboardView.backgroundColor = kAXPMAINCOLORc3;
        
        [self resetToolBarManager];
    }
    
    return self;
}

/*
 new      : Modify
 time     : 2017.4.11
 modifier : 徐梅娜
 version  ：Epic-0331-AIXUEPAIOS-1157
 branch   ：Epic-0331-AIXUEPAIOS-1157/origin/bugfix/AIXUEPAIOS-632-new
 describe : 以任何形式重进进入时都将白板工具属性设置为默认值
 */
- (void)resetToolBarManager
{
    self.whiteboardConfig  = [AXPWhiteboardConfiguration sharedConfiguration];
    [self.whiteboardConfig setUpDefaultConfiguration];
    self.whiteboardManager = self.whiteboardConfig.brushSelected;
    if (!self.whiteboardToolbar) {
        self.whiteboardToolbar = [[AXPWhiteboardManagerView alloc] initWithConfig:self.imagesName];
    }
    
    [self.axpWhiteboardView addSubview:self.whiteboardToolbar];
}

-(void)popViewControllerWithSelectedButton:(UIButton *)button title:(NSString *)title isPopVc:(BOOL)isPopVc
{
    if (!isPopVc) {
        return;
    }
    
    NSInteger index = button.tag - buttonTagBase - 2;
    
    NSArray *array = [self.whiteboardDataConfig objectForKey:self.imagesName[index]];
    
    AXPSetPopViewController *pop = [AXPSetPopViewController creatPopViewControllerWithSelectedView:button sourceArray:array title:title];
    
    [self.vc presentViewController:pop animated:YES completion:nil];
}

-(NSMutableArray *)imagesName
{
    if (!_imagesName) {
        _imagesName = [NSMutableArray arrayWithObjects:@"forward",@"backward",@"set",@"trash",@"save",@"move",@"image",@"brush",@"eraser",@"text",@"line",@"triangle",@"quadrangle",@"circle",nil];// @"record",@"end",@"forward",@"backward",@"set",@"trash",@"save",@"folder",@"move",@"image",@"brush",@"eraser",@"bucket",@"text",@"line",@"triangle",@"quadrangle",@"circle"
        
    }
    return _imagesName;
}

-(void)deleteSelectedWhiteboardView
{
    if (self.whiteboards.count == 1) {
        
        [self.whiteboardView clearWhiteboard];
        
        [self.managerView removeFromSuperview];
        self.isShowMnangerCollectionView = NO;
        
        UIButton *button = self.suspendNimbleView.nimbleButtons.firstObject;
        button.frame = CGRectMake(0, 0, 40, 40);
        button.center = self.suspendNimbleView.suspendNimbleButton.center;
        [button removeFromSuperview];
        
        self.suspendNimbleView.suspendNimbleButton.hidden = NO;
        
    }else
    {
        NSInteger currentIndex = (self.managerView.contentOffset.x + 540)/286;
        
        ETTWhiteBoardView *deleteWhiteboardView = self.whiteboards[currentIndex];
        
        [deleteWhiteboardView removeFromSuperview];
        [self.whiteboards removeObject:deleteWhiteboardView];
        
        if (deleteWhiteboardView == self.whiteboardView) {
            
            if (currentIndex < self.whiteboards.count-1) {
                
                self.whiteboardView = self.whiteboards[currentIndex +1];
                
            }else
            {
                self.whiteboardView = self.whiteboards[currentIndex -1];
            }
            
            [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
        }
        
        if (currentIndex == self.whiteboards.count) {
            
            self.managerView.contentOffset = CGPointMake(self.managerView.contentOffset.x - 286, 0);
        }
        
        [self.managerView.whiteboards removeObjectAtIndex:currentIndex];
        self.managerView.isScroll = NO;
        [self.managerView reloadData];
    }
    
    [self showPageNumber];
}

-(NSMutableDictionary *)whiteboardDataConfig
{
    if (!_whiteboardDataConfig) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"whiteboardDataConfig.plist" ofType:nil];
        
        _whiteboardDataConfig = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return _whiteboardDataConfig;
}
-(NSString *)getUserType
{
    NSString *identity =nil;
    
    if ([[AXPUserInformation sharedInformation].userType isEqualToString:@"teacher"]) {
        
        identity = @"teacher";
    }else
    {
        identity = @"student";
    }
    return identity;

}
- (void)changeWhiteboardToolbarAndWhiteboardViewNotification:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    if (dic&&[dic.allKeys containsObject:@"disappear"]) {
        NSString *disappear = [dic objectForKey:@"disappear"];
        if ([disappear isEqualToString:@"YES"]) {
           AXPSetPopViewController *pop = (AXPSetPopViewController *)[self.vc presentedViewController];
            [pop dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    [self changeWhiteboardToolbarAndWhiteboardView];
}
// 接收设置通知,改变工具栏的位置/是否显示网格线
-(void)changeWhiteboardToolbarAndWhiteboardView
{
//    NSString *identity;
//    
//    if ([[AXPUserInformation sharedInformation].userType isEqualToString:@"teacher"]) {
//        
//        identity = @"teacher";
//    }else
//    {
//        identity = @"student";
//    }
    
    NSString *identity = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentIdentity"];
    
    
    // 白板工具栏 左侧/右侧 位置改变
    if ([self.whiteboardConfig.toolbar isEqualToString:@"左侧"]) {
        
        if ([identity isEqualToString:@"student"]) {
        
            self.whiteboardToolbar.frame = CGRectMake(0, 0, kAXPWhiteboardManagerWidth, kHEIGHT - 64);
        }else
        {
            self.whiteboardToolbar.frame = CGRectMake(0, 0, kAXPWhiteboardManagerWidth, kHEIGHT - 64);
        }
        
        self.whiteboardView.frame = CGRectMake(kAXPWhiteboardManagerWidth, 0, kWIDTH-kAXPWhiteboardManagerWidth, kHEIGHT-64);
        
        CGRect suspendNimbleRect = CGRectMake(kWIDTH - 56 -16, kHEIGHT - 56 -16-64, 56, 56);
        self.suspendNimbleView.suspendNimbleButton.frame = suspendNimbleRect;
        [self.suspendNimbleView.nimbleButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            
            button.center = self.suspendNimbleView.suspendNimbleButton.center;
        }];
        
        _addMoreWhiteboardPageView.center = CGPointMake((kAXPWhiteboardManagerWidth + kWIDTH)/2, self.whiteboardView.bounds.size.height - 12 - 16);
        
    }else
    {
        
        
        if ([identity isEqualToString:@"student"]) {
            
            self.whiteboardToolbar.frame = CGRectMake(kWIDTH-kAXPWhiteboardManagerWidth, 0, kAXPWhiteboardManagerWidth, kHEIGHT - 64);
        }else
        {
            self.whiteboardToolbar.frame = CGRectMake(kWIDTH-kAXPWhiteboardManagerWidth, 0, kAXPWhiteboardManagerWidth, kHEIGHT - 64);
        }
        
        self.whiteboardView.frame = CGRectMake(0, 0, kWIDTH-kAXPWhiteboardManagerWidth, kHEIGHT - 64);

        CGRect suspendNimbleRect = CGRectMake(16, kHEIGHT - 56 -16-64, 56, 56);
        self.suspendNimbleView.suspendNimbleButton.frame = suspendNimbleRect;
        [self.suspendNimbleView.nimbleButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            
            button.center = self.suspendNimbleView.suspendNimbleButton.center;
        }];
        
        _addMoreWhiteboardPageView.center = CGPointMake((kWIDTH - kAXPWhiteboardManagerWidth)/2, self.whiteboardView.bounds.size.height - 12 - 16);
    }
    
    if (!self.whiteboardConfig.isWhiteboardPushing) {
    
        // 白板是否显示网格线
        if (self.whiteboardConfig.showGridLine) {
            
            // 显示网格线
            UIImage *image = [UIImage imageNamed:@"test"];
            self.whiteboardView.backgroundColor = [UIColor colorWithPatternImage:image];
            
        }else
        {
            self.whiteboardView.backgroundColor = kAXPMAINCOLORc17;
            
        }
    }
    
    // 是否分配标签/顶点样式
    [self.whiteboardView.polygonContantView setNeedsDisplay];
    
    [self showPrompt];
    
    
}

-(void)showPrompt
{
    switch (self.whiteboardManager) {
    
//        case AXPWhiteboardBucket:
//            
//            [self showAddBucketPrompt];
//            
//            break;
            
        case AXPWhiteboardLine:
            
            [self showAddLinePrompt];
            
            break;
            
        case AXPWhiteboardTriangle:
            
            [self showAddTrianglePrompt];
            
            break;
            
        case AXPWhiteboardQuadrangle:
            
            [self showAddQuadranglePrompt];
            
            break;
            
        case AXPWhiteboardCircle:
            
            [self showAddCirclePrompt];
            
            break;
            
        default:
            break;
    }
}

-(void)showAddCirclePrompt
{
    switch (self.whiteboardConfig.selectedCircle) {
            
        case AXPPolygonAddCircle:
            
            if (self.whiteboardConfig.isFirstDrawCircle) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击两点以创建圆型"];
                
                self.whiteboardConfig.isFirstDrawCircle = NO;
            }

            break;
            
        default:
            break;
    }
}

-(void)showAddQuadranglePrompt
{
    switch (self.whiteboardConfig.selectedQuadrangle) {
            
        case AXPPolygonAddSquare:
        
            if (self.whiteboardConfig.isFirstDrawSquare) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击两点位置以创建正方形"];
                
                self.whiteboardConfig.isFirstDrawSquare = NO;
            }
            
            break;
            
        case AXPPolygonAddRectangle:
        
            if (self.whiteboardConfig.isFirstDrawRectangle) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击三点位置以创建长方形"];
                
                self.whiteboardConfig.isFirstDrawRectangle = NO;
            }
            
            break;
            
        case AXPPolygonAddRegularParallelogram:
        
            if (self.whiteboardConfig.isFirstDrawParallelogram) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击三点位置以创建平行四边形"];
                
                self.whiteboardConfig.isFirstDrawParallelogram = NO;
            }
            
            break;
            
        case AXPPolygonAddRegularQuadrilateral:
            
            if (self.whiteboardConfig.isFirstDrawQuadrilateral) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击一点确认顶点,创建完成后点击 '完成' 按钮"];
                
                self.whiteboardConfig.isFirstDrawQuadrilateral = NO;
            }
            
            break;
            
        default:
            break;
    }
}

-(void)showAddTrianglePrompt
{
    switch (self.whiteboardConfig.selectedTriangle) {
            
        case AXPPolygonAddTriangle:
            
            if (self.whiteboardConfig.isFirstDrawTriangle) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击三处位置以创建三角形"];
                
                self.whiteboardConfig.isFirstDrawTriangle = NO;
            }
            
            break;
            
        case AXPPolygonAddRightTriangle:
            
            if (self.whiteboardConfig.isFirstDrawRightTriangle) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击三处位置以创建直角三角形"];
                
                self.whiteboardConfig.isFirstDrawRightTriangle = NO;
            }
            
            break;
            
        case AXPPolygonAddIsocelesTriangle:
            
            if (self.whiteboardConfig.isFirstDrawIsocelesTriangle) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击三处位置以创建等腰三角形"];
                
                self.whiteboardConfig.isFirstDrawIsocelesTriangle = NO;
            }
            
            break;
            
        case AXPPolygonAddRegularTriangle:
            
            if (self.whiteboardConfig.isFirstDrawRegularTriangle) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击两处位置以创建等边三角形"];
                
                self.whiteboardConfig.isFirstDrawRegularTriangle = NO;
            }
            
            break;
            
        default:
            break;
    }
}

-(void)showAddLinePrompt
{
    switch (self.whiteboardConfig.selectedLine) {
            
        case AXPPolygonAddLine:
            
            if (self.whiteboardConfig.isFirstDrawLine) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击两处位置以创建两点连接线"];
                self.whiteboardConfig.isFirstDrawLine = NO;
            }
            
            break;
            
        case AXPolygonAddRayLine:
            
            if (self.whiteboardConfig.isFirstDrawLine) {
                
                [self.axpWhiteboardView showPromptWithStr:@"点击两处位置以创建射线"];
                self.whiteboardConfig.isFirstDrawLine = NO;
            }
            
            break;
            
        default:
            break;
    }
}

-(void)showAddBucketPrompt
{
    if (self.whiteboardConfig.isFirstDrawLine) {
        
        [self.axpWhiteboardView showPromptWithStr:@"请选择自建图形"];
        self.whiteboardConfig.isFirstDrawLine = NO;
    }
}

-(void)showPageNumber
{
//    [self.addMoreWhiteboardPageView removeFromSuperview];
//    [self.whiteboardView addSubview:self.addMoreWhiteboardPageView];
    
    [self.axpWhiteboardView insertSubview:self.addMoreWhiteboardPageView aboveSubview:self.whiteboardView];
    
    NSUInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView] + 1;
    NSUInteger count       = self.whiteboards.count;

    NSString *pageNumberStr = [NSString stringWithFormat:@"%lu / %lu",(unsigned long)currentPage,(unsigned long)count];
    
    [self.addMoreWhiteboardPageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UILabel class]]) {
            
            UILabel *pageNumberLabel = obj;
            
            pageNumberLabel.text = pageNumberStr;
            
            *stop = YES;
        }
    }];
    
     [self updateButtonStatus];
}

-(UIButton *)addManagerButtonWithImage:(NSString *)imageName
{
    NSString *normalImage   = [NSString stringWithFormat:@"whiteboard_page_%@_default",imageName];

    NSString *disabledImage = [NSString stringWithFormat:@"whiteboard_page_%@_disabled",imageName];

    UIButton *button        = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:disabledImage] forState:UIControlStateDisabled];
    
    return button;
}

-(void)updateButtonStatus
{
    NSInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView];
    
    if (self.whiteboards.count == 1 || currentPage == 0) {
        
        self.forwardButton.enabled = NO;
    }else
    {
         self.forwardButton.enabled = YES;
    }
    
    if (self.whiteboards.count == 10 && currentPage == 9)
    {
        self.backButton.enabled = NO;
    }else
    {
        self.backButton.enabled = YES;
    }
    
    [self changeWhiteboardToolbarAndWhiteboardView];
    
//    [self.axpWhiteboardView bringSubviewToFront:self.suspendNimbleView.suspendNimbleButton];
}

-(UIView *)setUpNextPageManager
{
    AXPNextWhiteboardPageView *nextPageView = [[AXPNextWhiteboardPageView alloc] initWithFrame:CGRectMake(0, 0, 125, 36)];
    nextPageView.center                     = CGPointMake((kAXPWhiteboardManagerWidth + kWIDTH)/2, self.whiteboardView.bounds.size.height - 12 - 16);

    UIButton *forward                       = [self addManagerButtonWithImage:@"forward"];
    [forward addTarget:self action:@selector(forwardPage) forControlEvents:UIControlEventTouchUpInside];
    self.forwardButton                      = forward;

    UIButton *backward                      = [self addManagerButtonWithImage:@"backward"];
    [backward addTarget:self action:@selector(backwardPage) forControlEvents:UIControlEventTouchUpInside];
    self.backButton                         = backward;

    forward.frame                           = CGRectMake(0, 0, 37.5, 36);
    backward.frame                          = CGRectMake(125-37.5, 0, 37.5, 36);

    UILabel *pageNumberLabel                = [[UILabel alloc] initWithFrame:CGRectMake(37.5, 6, 50, 24)];
    pageNumberLabel.textColor               = kAXPTEXTCOLORf1;
    pageNumberLabel.font                    = [UIFont systemFontOfSize:14];
    pageNumberLabel.textAlignment           = NSTextAlignmentCenter;
    
    [nextPageView addSubview:forward];
    [nextPageView addSubview:backward];
    [nextPageView addSubview:pageNumberLabel];
    
    [self updateButtonStatus];
    
    return nextPageView;
}

// 返回上一页白板
-(void)forwardPage
{
    if (self.suspendNimbleView.suspendNimbleButton.selected) {
        [self.suspendNimbleView hiddenNimbleToolbarCompletion:^{
            //
            NSInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView];
            
            if (currentPage > 0) {
                
                [self.whiteboardView removeFromSuperview];
                
                ETTWhiteBoardView *whiteboardView = self.whiteboards[currentPage -1];
                self.whiteboardView = whiteboardView;
                [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
            }
            
            [self showPageNumber];
        }];
    }else
    {
        NSInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView];
        
        if (currentPage > 0) {
            
            [self.whiteboardView removeFromSuperview];
            
            ETTWhiteBoardView *whiteboardView = self.whiteboards[currentPage -1];
            self.whiteboardView = whiteboardView;
            [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
        }
        
        [self showPageNumber];
    }
}

// 添加一页新白板
-(void)backwardPage
{
    if (self.suspendNimbleView.suspendNimbleButton.selected) {
        
        [self.suspendNimbleView hiddenNimbleToolbarCompletion:^{
            //
            NSInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView];
            
            if (currentPage+1 == self.whiteboards.count) {
                //  添加一页新白板
                [AXPWhiteboardToolbarManager addWhiteboardToController:self.vc];
            }else
            {
                [self.whiteboardView removeFromSuperview];
                
                ETTWhiteBoardView *whiteboardView = self.whiteboards[currentPage +1];
                self.whiteboardView = whiteboardView;
                [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
                [self showPageNumber];
            }

        }];
    }else
    {
        NSInteger currentPage = [self.whiteboards indexOfObject:self.whiteboardView];
        
        if (currentPage+1 == self.whiteboards.count) {
            //  添加一页新白板
            [AXPWhiteboardToolbarManager addWhiteboardToController:self.vc];
        }else
        {
            [self.whiteboardView removeFromSuperview];
            
            ETTWhiteBoardView *whiteboardView = self.whiteboards[currentPage +1];
            self.whiteboardView = whiteboardView;
            [self.axpWhiteboardView insertSubview:self.whiteboardView aboveSubview:self.whiteboardToolbar];
            [self showPageNumber];
        }

    }
}

-(UIView *)addMoreWhiteboardPageView
{
    if (!_addMoreWhiteboardPageView) {
        
        _addMoreWhiteboardPageView = [self setUpNextPageManager];
    }
    return _addMoreWhiteboardPageView;
}

-(NSMutableArray *)whiteboards
{
    if (!_whiteboards) {
        _whiteboards = [NSMutableArray array];
    }
    return _whiteboards;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
