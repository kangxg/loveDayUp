
 //
//  AXPWhiteboardManagerView.m
//  test
//
//  Created by Li Kaining on 16/9/18.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardManagerView.h"
#import "UIColor+RGBColor.h"
#import "AXPWhiteboardToolbarManager.h"

@interface AXPWhiteboardManagerView ()

@property(nonatomic ,strong) NSMutableDictionary *whiteboardDataConfig;

@end


@implementation AXPWhiteboardManagerView

-(instancetype)initWithConfig:(NSArray *)config
{
    self = [super init];
    
    if (self) {
    
        self.backgroundColor = kAXPMAINCOLORc3;
        
//        [self addPartitionLine];
        [self setupManagerButtonWithConfig:config];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBrushIcon:) name:@"AXPWhiteboardManagerViewChangeBrushIcon" object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBucketIcon:) name:@"AXPWhiteboardManagerViewChangeBucketIcon" object:nil];
    }

    return self;
}

-(void)changeBrushIcon:(NSNotification *)notify
{
    NSString *imageStr = [NSString stringWithFormat:@"whiteboard_tools_brush_%@_pressed",notify.object];
    [self.brushButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
}

-(void)changeBucketIcon:(NSNotification *)notify
{
    NSString *imageStr = [NSString stringWithFormat:@"whiteboard_tools_bucket_%@_pressed",notify.object];
    [self.bucketButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
}

-(void)addPartitionLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 125, 1)];
    line.backgroundColor = kAXPLINECOLORl1;
    
    [self addSubview:line];
}


-(void)setupManagerButtonWithConfig:(NSArray *)config
{
    CGFloat kXL = 33.5;
    CGFloat kXR = 91.5;
    CGFloat kYTop = 17+17.5;
    CGFloat kMarginH = 35;
    CGFloat kBH_2 = 13.5;
    
    CGPoint center;
    
    for (int i = 0; i < config.count; i++) {
    
        CGFloat cols = i%2;
        CGFloat rows = i/2;
        
        center.x = cols == 0 ? kXL : kXR;
        center.y = rows == 0 ? kYTop : kMarginH/2 + kMarginH*(rows+1) +(rows-1)*kBH_2*2 + kBH_2;
        
        [self addButtonWithImageName:config[i] buttonCenter:center buttonTag:i];
    }
    
//    AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
    
    UIButton *button = self.buttons[AXPWhiteboardBrush - 2];
    button.selected = YES;
    self.selectedButton = button;
    
    if (button.tag == buttonTagBase+AXPWhiteboardBrush) {
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteboard_tools_brush_%@_pressed",@"black"]] forState:UIControlStateSelected];
    }
    
    //        if (button.tag == buttonTagBase+12) {
    //
    //            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteboard_tools_bucket_%@_pressed",manager.whiteboardConfig.bucketColorStr]] forState:UIControlStateSelected];
    //        }




}

-(void)addButtonWithImageName:(NSString *)imageName buttonCenter:(CGPoint)center buttonTag:(NSInteger)tag
{
    NSString *normalName      = [NSString stringWithFormat:@"whiteboard_tools_%@_default",imageName];
    NSString *highlightedName = [NSString stringWithFormat:@"whiteboard_tools_%@_pressed",imageName];
    NSString *selectedName    = [NSString stringWithFormat:@"whiteboard_tools_%@_selected",imageName];

    UIImage *normalImage      = [UIImage imageNamed:normalName];
    UIImage *selectedImage    = [UIImage imageNamed:selectedName];
    UIImage *highlightedImage = [UIImage imageNamed:highlightedName];

    UIButton *button          = [UIButton buttonWithType:UIButtonTypeCustom];
    
    /*
     new      : Modify
     time     : 2017.4.11
     modifier : 徐梅娜
     version  ：Epic-0331-AIXUEPAIOS-1157
     branch   ：Epic-0331-AIXUEPAIOS-1157/origin/bugfix/AIXUEPAIOS-1192
     describe : 对白板工具的修复
     */
    
    button.tag = buttonTagBase + tag + 2;// buttonTagBase在原来的基础上加2的原因是先移除"录制"和"对勾",为了保证之前的判断准确
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize buttonSize = CGSizeMake(70, 70);
    button.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    button.center = center;
    
    [self addSubview:button];
    
    [self.buttons addObject:button];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
//        
//        UIButton *button = self.buttons[manager.whiteboardConfig.brushSelected - 2];
//        button.selected = YES;
//        self.selectedButton = button;
//
//        if (button.tag == buttonTagBase+AXPWhiteboardBrush) {
//        
//            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteboard_tools_brush_%@_pressed",manager.whiteboardConfig.brushColorStr]] forState:UIControlStateSelected];
//        }
//        
////        if (button.tag == buttonTagBase+12) {
////            
////            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteboard_tools_bucket_%@_pressed",manager.whiteboardConfig.bucketColorStr]] forState:UIControlStateSelected];
////        }
//    });
    
    if ((tag + 2) == AXPWhiteboardBrush) {
        
        self.brushButton = button;
        
    }
//    else if (tag == 12)
//    {
//        self.bucketButton = button;
//    }
}

-(void)checkoutSelectedButton:(UIButton *)button
{
    [self selectedButton:button isPresentVC:NO];
}

-(void)selectedButton:(UIButton *)button
{
    
    AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
    
    if (manager.whiteboardConfig.isMutualCorrect && ([button isEqual:self.brushButton]||[button isEqual:self.buttons[13]])) {
        
        [self selectedButton:button isPresentVC:NO];
    }else
    {
        [self selectedButton:button isPresentVC:YES];
    }
}

-(void)selectedButton:(UIButton *)button isPresentVC:(BOOL)isPresentVC
{

    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
    
    if (button.tag - buttonTagBase == AXPWhiteboardBrush) {
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteboard_tools_brush_%@_pressed",manager.whiteboardConfig.brushColorStr]] forState:UIControlStateSelected];
        
    }
    
//    else if (button.tag - buttonTagBase == AXPWhiteboardBucket)
//    {
//        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteboard_tools_bucket_%@_pressed",manager.whiteboardConfig.bucketColorStr]] forState:UIControlStateSelected];
//    }
    
    [manager presentControllerWithSelectedButton:button isPopVc:isPresentVC];
}


-(void)test
{
    NSMutableArray *set    = [NSMutableArray arrayWithObjects:@"工具栏",@"顶点样式",@"网格线",@"分配标签", nil];

    NSMutableArray *image  = [NSMutableArray arrayWithObjects:@"相册",@"相机",@"文件夹", nil];

    NSMutableArray *brush  = [NSMutableArray arrayWithObjects:@"颜色",@"填充度",@"大小",@"类型", nil];

    NSMutableArray *eraser = [NSMutableArray arrayWithObjects:@"大小", nil];

    NSMutableArray *bucker = [NSMutableArray arrayWithObjects:@"颜色", nil];

    NSMutableArray *text = [NSMutableArray arrayWithObjects:@"颜色",@"大小", nil];
    
    NSMutableArray *triangle = [NSMutableArray arrayWithObjects:@{@"polygonName":@"三角形",@"polygonImage":@"triangle"},@{@"polygonName":@"直角三角形",@"polygonImage":@"righttriangle"},@{@"polygonName":@"等腰三角形",@"polygonImage":@"isocelestriangle"},@{@"polygonName":@"等边三角形",@"polygonImage":@"regulartriangle"}, nil];
    
    NSMutableArray *quadrangle = [NSMutableArray arrayWithObjects:@{@"polygonName":@"正方形",@"polygonImage":@"square"},@{@"polygonName":@"长方形",@"polygonImage":@"rectangle"},@{@"polygonName":@"平行四边形",@"polygonImage":@"parallelogram"},@{@"polygonName":@"任意多边形",@"polygonImage":@"quadrilateral"}, nil];
    
    NSMutableArray *line = [NSMutableArray arrayWithObjects:@{@"polygonName":@"直线",@"polygonImage":@"line"},nil];
    
    NSMutableArray *circle = [NSMutableArray arrayWithObjects:@{@"polygonName":@"圆",@"polygonImage":@"circle"},nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:set forKey:@"set"];
    [dict setObject:image forKey:@"image"];
    [dict setObject:brush forKey:@"brush"];
    [dict setObject:eraser forKey:@"eraser"];
    [dict setObject:bucker forKey:@"bucker"];
    [dict setObject:text forKey:@"text"];
    [dict setObject:line forKey:@"line"];
    [dict setObject:triangle forKey:@"triangle"];
    [dict setObject:quadrangle forKey:@"quadrangle"];
    [dict setObject:circle forKey:@"circle"];
    
    
    [dict writeToFile:@"/Users/DeveloperLx/Desktop/whiteboardConfig.plist" atomically:YES];
    
}

-(NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
