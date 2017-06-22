//
//  AXPSetPopViewController.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPSetPopViewController.h"
#import "AXPPopViewController.h"
#import "UIColor+RGBColor.h"


@interface AXPSetPopViewController ()

@property(nonatomic ,copy) NSString *toolbarStr;
@property(nonatomic ,copy) NSString *apexStyle;
@property(nonatomic) BOOL isShowGridLine;
@property(nonatomic) BOOL isShowSymbol;

@property(nonatomic) CGFloat popViewHeight;

@end

@implementation AXPSetPopViewController

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.isPop = YES;
    
    AXPPopViewController *vc = (AXPPopViewController *)self.viewControllers.firstObject;
    
    vc.isPush = NO;
    
    return [super popViewControllerAnimated:animated];
}

+(instancetype)creatPopViewControllerWithSelectedView:(UIView *)selectedView sourceArray:(NSArray *)sourceArray title:(NSString *)title
{
    AXPPopViewController *vc     = [[AXPPopViewController alloc] init];
    vc.dataSources               = sourceArray.mutableCopy;
    vc.title                     = title;
    NSInteger index              = selectedView.tag - buttonTagBase;
    vc.whiteboardManager         = index;

    AXPSetPopViewController *pop = [[AXPSetPopViewController alloc] initWithRootViewController:vc];
    pop.modalPresentationStyle   = UIModalPresentationPopover;
    pop.preferredContentSize     = CGSizeMake(kAXPPopWidth, kAXPPopHeight-44);

    UIPopoverPresentationController *poper = pop.popoverPresentationController;
    
    if ([vc.defalutConfig.toolbar isEqualToString:@"左侧"]) {
        poper.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    }else
    {
        poper.permittedArrowDirections = UIPopoverArrowDirectionRight;
    }
        
    poper.backgroundColor = kAXPMAINCOLORc5;

    poper.sourceView      = selectedView;
    poper.sourceRect      = selectedView.bounds;
    
    return pop;
}

-(void)recordAxpWhiteboardSetStatus
{
//    self.toolbarStr     = [AXPWhiteboardConfiguration sharedConfiguration].toolbar;
//    self.apexStyle      = [AXPWhiteboardConfiguration sharedConfiguration].apexStyle;
//    self.isShowGridLine = [AXPWhiteboardConfiguration sharedConfiguration].showGridLine;
//    self.isShowSymbol   = [AXPWhiteboardConfiguration sharedConfiguration].showSymbol;
}

-(void)resumeAxpWhiteboardSetStatus
{
//    [AXPWhiteboardConfiguration sharedConfiguration].toolbar      = self.toolbarStr;
//    [AXPWhiteboardConfiguration sharedConfiguration].apexStyle    = self.apexStyle;
//    [AXPWhiteboardConfiguration sharedConfiguration].showGridLine = self.isShowGridLine;
//    [AXPWhiteboardConfiguration sharedConfiguration].showSymbol   = self.isShowSymbol;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)dealloc
{

}



@end
