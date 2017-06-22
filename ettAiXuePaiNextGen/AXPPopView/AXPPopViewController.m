//
//  AXPPopViewController.m
//  test
//
//  Created by Li Kaining on 16/9/18.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPPopViewController.h"
#import "UIColor+RGBColor.h"
#import "AXPWhiteboardToolbarCell.h"
#import "AXPWhiteboardSwitchCell.h"
#import "AXPWhiteboardChooseColorCell.h"
#import "AXPWhiteboardChooseSizeCell.h"
#import "AXPColorSelectedViewController.h"
#import "AXPWhiteboardApexStyleCell.h"
#import "AXPWhiteboardColorCell.h"
#import "AXPApexStyleViewController.h"
#import "AXPToolbarViewController.h"
#import "AXPSetPopViewController.h"
#import "AXPWhiteboardToolbarManager.h"
#import "ETTImagePickerManager.h"

typedef enum : NSUInteger {
    AXPSetGridLineShow = 20000,
    AXPSetSymbolShow   = 20001,
    AXPBrushAlphaValue = 20002,
    AXPBrushSizeValue  = 20003,
    AXPEraserSizeValue = 20004,
    AXPTextSizeValue   = 20005
} AXPSelectedViewValue;


@interface AXPPopViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AXPPopViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.title isEqualToString:@"设置"]) {
        
        return;
    }
    
    if (self.isPush) {
        return;
    }
    
    // 保存白板配置
    [self.defalutConfig saveConfiguration];
    
    [[AXPWhiteboardToolbarManager sharedManager] checkoutSelectedButton];
    
    // 通知白板管理者改变 白板/白板工具栏 位置,是否显示网格线等.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWhiteboardToolbarAndWhiteboardView" object:nil];    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
}

-(void)saveSwitchValue:(UISwitch *)axpSwitch
{
    switch (axpSwitch.tag) {
    
        case AXPSetGridLineShow:
            
            self.defalutConfig.showGridLine = axpSwitch.on;

            break;
            
        case AXPSetSymbolShow:
        
            self.defalutConfig.showSymbol = axpSwitch.on;
            break;
            
        default:
            break;
    }
    
    [[AXPWhiteboardConfiguration sharedConfiguration] saveConfiguration];
    
    [[AXPWhiteboardToolbarManager sharedManager] checkoutSelectedButton];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWhiteboardToolbarAndWhiteboardView" object:nil];
}

-(void)saveSliderValue:(UISlider *)slider
{
    switch (slider.tag) {
    
        case AXPBrushAlphaValue:
        
            self.defalutConfig.brushAlpha = slider.value;
            [self.tableView reloadData];
            break;
            
        case AXPBrushSizeValue:
            
            self.defalutConfig.brushSize = slider.value;
            [self.tableView reloadData];
            break;
            
        case AXPEraserSizeValue:
            
            self.defalutConfig.eraserSize = slider.value;
            [self.tableView reloadData];
            break;
            
        case AXPTextSizeValue:
            self.defalutConfig.textFontSize = slider.value;
            [self.tableView reloadData];
            
            break;
            
        default:
            break;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAXPPopViewCellDefalutCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSources.count) {
        
        switch (self.whiteboardManager) {
            case AXPWhiteboardSet:
                return [self setupSetCellForRowAtIndexPath:indexPath tableView:tableView];
                break;
                
            case AXPWhiteboardImage:
                return [self setupImageCellForRowAtIndexPath:indexPath tableView:tableView];
                break;
                
            case AXPWhiteboardBrush:
                return [self setupBrushCellForRowAtIndexPath:indexPath tableView:tableView];
                break;
                
            case AXPWhiteboardEraser:
                return [self setupEraserCellForRowAtIndexPath:indexPath tableView:tableView];
                break;
                
//            case AXPWhiteboardBucket:
//                return [self setupBuckerCellForRowAtIndexPath:indexPath tableView:tableView];
//                break;
                
            case AXPWhiteboardText:
                return [self setupTextCellForRowAtIndexPath:indexPath tableView:tableView];
                break;
                
            default:
                break;
        }
        
        return [self setupPolygonCellForRowAtIndexPath:indexPath tableView:tableView];
        
    }else
    {
        return [[AXPPopViewBasicCell alloc] init];
    }
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.whiteboardManager) {
    
        case AXPWhiteboardSet:
            
            [self didSetSelectRowWithTableView:tableView indexPath:indexPath];
            break;
            
        case AXPWhiteboardImage:
            return [self didImageSelectRowWithTableView:tableView indexPath:indexPath];
            break;
    
        case AXPWhiteboardBrush:
        
            [self didBrushSelectRowWithTableView:tableView indexPath:indexPath];
            break;
            
        case AXPWhiteboardEraser:

            break;
            
//        case AXPWhiteboardBucket:
//        
//            [self didBuckerSelectRowWithTableView:tableView indexPath:indexPath];
//            
//            break;
            
        case AXPWhiteboardText:
        
            [self didTextSelectRowWithTableView:tableView indexPath:indexPath];
            
            break;
            
        default:
            break;
    }
    
    if (self.whiteboardManager >= AXPWhiteboardLine && self.whiteboardManager <= AXPWhiteboardCircle) {
        
        [self didPolygonSelectRowWithTableView:tableView indexPath:indexPath];
    }
}

-(void)didImageSelectRowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (indexPath.row == 0) {
        // 从相册添加图片
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[AXPWhiteboardToolbarManager sharedManager] addImageWithImagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        });
        
    }else if(indexPath.row == 1){
        // 从相机拍照添加图片
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[AXPWhiteboardToolbarManager sharedManager] addImageWithImagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera];
        });

    }
//    else if (indexPath.row == 2){
//        // 从文件夹添加图片
//        [[AXPWhiteboardToolbarManager sharedManager] addImageFromLocalFolder];
//    }
}

-(void)didSetSelectRowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {// 工具栏
        
        AXPToolbarViewController *vc = [[AXPToolbarViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        self.isPush = vc.isPush;
        
    }else if (indexPath.row == 1)// 顶点样式
    {
        AXPApexStyleViewController *vc = [[AXPApexStyleViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        self.isPush = vc.isPush;
    }
}

-(void)didBrushSelectRowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self pushColorSelectionViewController];
    }
}

-(void)didBuckerSelectRowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self pushColorSelectionViewController];
    }
}

-(void)didTextSelectRowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        [self pushColorSelectionViewController];
    }
}

-(void)pushColorSelectionViewController
{
    AXPColorSelectedViewController *vc = [[AXPColorSelectedViewController alloc] init];

    vc.whiteboardManager = self.whiteboardManager;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didPolygonSelectRowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.dataSources.count-1) {
        return;
    }
    
    switch (self.whiteboardManager) {
    
        case AXPWhiteboardLine:
            
            self.defalutConfig.selectedLine = indexPath.row;
            
            break;
            
        case AXPWhiteboardTriangle:
            
            self.defalutConfig.selectedTriangle = indexPath.row;
            
            break;
            
        case AXPWhiteboardQuadrangle:
            
            self.defalutConfig.selectedQuadrangle = indexPath.row;
            
            break;
            
        case AXPWhiteboardCircle:
            
            self.defalutConfig.selectedCircle = indexPath.row;
            
            break;
            
        default:
            break;
    }
    
    [tableView reloadData];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kAXPPopWidth ,0.5)];
    
    line.backgroundColor = kAXPLINECOLORl3;
    
    return line;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kAXPPopWidth ,0.5)];
    
    line.backgroundColor = kAXPLINECOLORl3;
    
    return line;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

static NSString *whiteboardToolbarCell = @"AXPWhiteboardToolbarCell";
static NSString *whiteboardSwitchCell = @"AXPWhiteboardSwitchCell";
static NSString *whiteboardChooseColorCell = @"AXPWhiteboardChooseColorCell";
static NSString *whiteboardChooseSizeCell = @"AXPWhiteboardChooseSizeCell";
static NSString *whiteboardApexStyleCell = @"AXPWhiteboardApexStyleCell";
static NSString *whiteboardPolygonStyleCell = @"AXPWhiteboardPolygonStyleCell";

- (UITableViewCell *)setupImageCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    AXPWhiteboardColorCell *cell = [self createWhiteboardColorCellWithTableView:tableView indexPath:indexPath];
    
    NSDictionary *dict = self.dataSources[indexPath.row];
    
    
    NSString *imageStr = dict[@"name"];
    cell.colorLabel.text = imageStr;
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
    
    return cell;
}

- (UITableViewCell *)setupPolygonCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    AXPWhiteboardColorCell *cell = [self createWhiteboardColorCellWithTableView:tableView indexPath:indexPath];
    
    NSDictionary *dict = self.dataSources[indexPath.row];

    NSString *imageName = [NSString stringWithFormat:@"whiteboard_tools_%@_pressed",dict[@"polygonImage"]];
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.colorLabel.text = dict[@"polygonName"];
    
    switch (self.whiteboardManager) {
        case AXPWhiteboardLine:
            
            if (indexPath.row == self.defalutConfig.selectedLine) {
                cell.selectedImageView.hidden = NO;
                self.title = @"直线";

            }else
            {
                cell.selectedImageView.hidden = YES;
            }
            
            break;
            
        case AXPWhiteboardTriangle:
            
            if (indexPath.row == self.defalutConfig.selectedTriangle) {
                cell.selectedImageView.hidden = NO;
                self.title = @"三角形";
            }else
            {
                cell.selectedImageView.hidden = YES;
            }
            
            break;
            
        case AXPWhiteboardQuadrangle:
            
            if (indexPath.row == self.defalutConfig.selectedQuadrangle) {
                cell.selectedImageView.hidden = NO;
                self.title = @"多边形";
            }else
            {
                cell.selectedImageView.hidden = YES;
            }
            
            break;
            
        case AXPWhiteboardCircle:
            
            if (indexPath.row == self.defalutConfig.selectedCircle) {
                cell.selectedImageView.hidden = NO;
                self.title = @"圆";
            }else
            {
                cell.selectedImageView.hidden = YES;
            }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)setupTextCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (indexPath.row == 0) {
        
        AXPWhiteboardChooseColorCell *cell = [self createWhiteboardChooseColorCellWithTableView:tableView indexPath:indexPath];

        cell.colorView.backgroundColor     = self.defalutConfig.textColor;
        
        return cell;
        
    }else
    {
        AXPWhiteboardChooseSizeCell *cell = [self createWhiteboardChooseSizeCellWithTableView:tableView indexPath:indexPath];

        NSInteger size                    = self.defalutConfig.textFontSize;
        NSString *sizeStr                 = [NSString stringWithFormat:@"%zd",size];

        cell.slider.minimumValue          = 1;

        cell.slider.tag                   = AXPTextSizeValue;
        cell.slider.value                 = self.defalutConfig.textFontSize;
        cell.sliderLable.text             = sizeStr;
        
        return cell;
    }
}

- (UITableViewCell *)setupEraserCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    AXPWhiteboardChooseSizeCell *cell = [self createWhiteboardChooseSizeCellWithTableView:tableView indexPath:indexPath];

    NSInteger size                    = self.defalutConfig.eraserSize;
    NSString *sizeStr                 = [NSString stringWithFormat:@"%zdpx",size];

    cell.slider.tag                   = AXPEraserSizeValue;
    cell.slider.value                 = self.defalutConfig.eraserSize;
    cell.sliderLable.text             = sizeStr;

    return cell;
}

- (UITableViewCell *)setupBuckerCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    AXPWhiteboardChooseColorCell *cell = [self createWhiteboardChooseColorCellWithTableView:tableView indexPath:indexPath];
    
    cell.colorView.backgroundColor = self.defalutConfig.bucketColor;
    
    return cell;
}

// tableview cellForRow 配置"画笔"
- (UITableViewCell *)setupBrushCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (indexPath.row == 0) {// 颜色
        
        AXPWhiteboardChooseColorCell *cell = [self createWhiteboardChooseColorCellWithTableView:tableView indexPath:indexPath];
        
        cell.colorView.backgroundColor = self.defalutConfig.brushColor;
        
        return cell;
        
    }else
    {
        AXPWhiteboardChooseSizeCell *cell = [self createWhiteboardChooseSizeCellWithTableView:tableView indexPath:indexPath];
        
        if (indexPath.row == 1) {  // 填充度

            NSInteger alpha    = self.defalutConfig.brushAlpha;
            NSString *alphaStr = [NSString stringWithFormat:@"%zd",alpha];

            alphaStr           = [alphaStr stringByAppendingString:@"%"];

            cell.slider.tag    = AXPBrushAlphaValue;
            cell.slider.value  = self.defalutConfig.brushAlpha;
            cell.sliderLable.text = alphaStr;
            
        }else                    // 大小
        {
            NSInteger size           = self.defalutConfig.brushSize;
            NSString *sizeStr        = [NSString stringWithFormat:@"%zd",size];

            cell.slider.minimumValue = 1;
            cell.slider.maximumValue = 20;

            cell.slider.tag          = AXPBrushSizeValue;
            cell.slider.value        = self.defalutConfig.brushSize;
            cell.sliderLable.text    = sizeStr;
        }
        
        return cell;
    }
}

// tableview cellForRow 配置"设置"
- (UITableViewCell *)setupSetCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (indexPath.row == 0) {// 工具栏
        
        AXPWhiteboardToolbarCell *cell = [self createWhiteboardToolbarCellWithTableView:tableView indexPath:indexPath];
        
        cell.detailLable.text = self.defalutConfig.toolbar;
        
        return cell;
        
    } else if (indexPath.row == 1)// 顶点样式
    {
        AXPWhiteboardApexStyleCell *cell = [self createWhiteboardApexStyleCellWithTableView:tableView indexPath:indexPath];
        
        cell.apexImageView.image = [UIImage imageNamed:self.defalutConfig.apexStyle];
        
        return cell;
        
    } else
    {
        AXPWhiteboardSwitchCell *cell = [self createWhiteboardSwitchCellWithTableView:tableView indexPath:indexPath];
        
        if (indexPath.row == 2) {// 网格线
            
            cell.axpSwitch.tag =  AXPSetGridLineShow;
            cell.axpSwitch.on  = self.defalutConfig.showGridLine;
            
        }else                    // 分配标签
        {
            cell.axpSwitch.tag =  AXPSetSymbolShow;
            cell.axpSwitch.on  = self.defalutConfig.showSymbol;

        }
        
        
        return cell;
    }
}

-(AXPWhiteboardColorCell *)createWhiteboardColorCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardColorCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardPolygonStyleCell];
    
    if (!cell) {
        cell = [[AXPWhiteboardColorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardPolygonStyleCell];
    }
    
    return cell;
}

-(AXPWhiteboardApexStyleCell *)createWhiteboardApexStyleCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardApexStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardApexStyleCell];
    
    if (!cell) {
        cell = [[AXPWhiteboardApexStyleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardApexStyleCell];
    }
    
    cell.titleLable.text = self.dataSources[indexPath.row];
    
    return cell;
}

-(AXPWhiteboardSwitchCell *)createWhiteboardSwitchCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardSwitchCell];
    
    if (!cell) {
        cell = [[AXPWhiteboardSwitchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardSwitchCell];
    }
    
    cell.titleLable.text = self.dataSources[indexPath.row];
    
    UISwitch *axpSwitch  = cell.axpSwitch;
    
    [axpSwitch addTarget:self action:@selector(saveSwitchValue:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

-(AXPWhiteboardChooseColorCell *)createWhiteboardChooseColorCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardChooseColorCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardChooseColorCell];
    
    if (!cell) {
        cell = [[AXPWhiteboardChooseColorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardChooseColorCell];
    }
    
    cell.titleLable.text = self.dataSources[indexPath.row];
    
    return cell;
}

-(AXPWhiteboardChooseSizeCell *)createWhiteboardChooseSizeCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardChooseSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardChooseSizeCell];
    
    if (!cell) {
        cell = [[AXPWhiteboardChooseSizeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardChooseSizeCell];
    }
    
    cell.titleLable.text = self.dataSources[indexPath.row];
    
    UISlider *slider = cell.slider;
    [slider addTarget:self action:@selector(saveSliderValue:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

-(AXPWhiteboardToolbarCell *)createWhiteboardToolbarCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardToolbarCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardToolbarCell];
    
    if (!cell) {
        cell = [[AXPWhiteboardToolbarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardToolbarCell];
    }
    
    cell.titleLable.text = self.dataSources[indexPath.row];
    
    return cell;
}

@end
