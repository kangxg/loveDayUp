//
//  AXPWhiteboardToolbarManager.h
//  test
//
//  Created by Li Kaining on 16/9/23.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXPWhiteboardManagerView.h"
#import "ETTWhiteBoardView.h"
#import "AXPWhiteboardView.h"
#import "AXPSuspendNimbleView.h"

typedef enum : NSUInteger {
//    AXPWhiteboardRecord = 0,
//    AXPWhiteboardEnd = 1,
    AXPWhiteboardForward = 2,
    AXPWhiteboardBackward = 3,
    AXPWhiteboardSet = 4,
    AXPWhiteboardTrash = 5,
    AXPWhiteboardSave = 6,
    AXPWhiteboardMove = 7,
    AXPWhiteboardImage = 8,
    AXPWhiteboardBrush = 9,
    AXPWhiteboardEraser = 10,
    AXPWhiteboardText = 11,
    AXPWhiteboardLine = 12,
    AXPWhiteboardTriangle = 13,
    AXPWhiteboardQuadrangle = 14,
    AXPWhiteboardCircle = 15,
} AXPWhiteboardManager;//AXPWhiteboardFolder = 7,AXPWhiteboardBucket = 12,

@interface AXPWhiteboardToolbarManager : NSObject

@property(nonatomic, strong) AXPWhiteboardView *axpWhiteboardView;

@property(nonatomic ,strong) UIView *addMoreWhiteboardPageView;

@property(nonatomic ,strong) AXPWhiteboardManagerView *whiteboardToolbar;
@property(nonatomic ,strong) ETTWhiteBoardView *whiteboardView;

@property(nonatomic ,strong) AXPWhiteboardConfiguration *whiteboardConfig;

@property(nonatomic) AXPWhiteboardManager whiteboardManager;

@property(nonatomic ,strong) AXPSuspendNimbleView *suspendNimbleView;

@property(nonatomic ,strong) NSMutableArray *whiteboards;

@property(nonatomic ) BOOL isShowMnangerCollectionView;

@property(nonatomic ,weak) UIViewController *vc;


+(instancetype)sharedManager;

+(instancetype)addWhiteboardToController:(UIViewController *)vc;


+(instancetype)reginViewController:(UIViewController *)vc;
-(void)presentControllerWithSelectedButton:(UIButton *)button isPopVc:(BOOL)isPopVc;

-(void)addImageWithImagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType;

-(void)addImageFromLocalFolder;

-(void)checkoutSelectedButton;

// 将白板工具属性设置为默认值
- (void)resetToolBarManager;

// 推送的时候,新建一个专门用来推送的白板页
-(void)addPushingWhiteboardView;

// 恢复到推送之前的白板页
-(void)resumeBeforePushedWhiteboard:(UIView *)whiteboardView;


-(void)resetWhiteboardManager;

-(void)byManagementViewWillAppear;

-(NSString *)getUserType;
@end
