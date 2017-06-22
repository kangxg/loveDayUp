//
//  ETTStudentSelectTeacherView.m
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
//  Created by zhaiyingwei on 2016/10/11.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentSelectTeacherView.h"
#import "ETTBackToPageManager.h"
#import "ETTRadarIndictorView.h"

const NSTimeInterval    transitionTime     =   0.1;
const CGFloat           scaleFloat         =   0.7;

@interface ETTStudentSelectTeacherView ()
{
    UIColor *backgroundColor;
    CADisplayLink *_disPlayLink;
    NSInteger counts;
    UIView *_circleView;
}

@property (nonatomic,strong) ETTStudentSelectTeacherModel       *model;

@property (nonatomic,strong) ETTLabel                           *titleLabel;

@property (nonatomic,strong) UICollectionView                   *selectClassroomButtonCollectionView;

@property (nonatomic,strong) ETTSelectClassroomConfirmButton    *confirmButton;

@property (nonatomic,strong) ETTButton                          *exitButton;

@property (nonatomic,strong) NSMutableArray                     *modelArray;

@property (nonatomic,strong) NSString                           *selectedClassroomId;

@property (nonatomic,strong) NSIndexPath                        *lastIndexPath;

@property (nonatomic,strong) ETTRadarIndictorView               *indicatorView;   // 扫描指针
@end

@implementation ETTStudentSelectTeacherView

static  NSString * const kIdentifierCell = @"cell";

@synthesize MDelegate   =   _MDelegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[self updateAttributes]updateUI];

    }
    
    return self;
}

-(instancetype)updateAttributes
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCreateClassroomDataSourceHandler:) name:kREDIS_CREATE_CLASSROOM_DATASOURCES object:nil];
    backgroundColor = kETTRGBCOLOR(233.0, 242.0, 248.0);
    self.backgroundColor = backgroundColor;
    counts = 0;
    // 设置循环调用
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(delayAnimation)];
    _disPlayLink.frameInterval = 20;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self startAnimation];
    return self;
}

/**
 *  @author xumeina, 17-03-23
 *
 *  @brief 寻找老师动画效果
 *
 *
 *  @since
 */
- (void)delayAnimation
{
    counts++;
    [self startAnimation];
}

- (void)setupRadarView
{
    if (!self.indicatorView) {
        self.indicatorView = [[ETTRadarIndictorView alloc] initWithFrame:self.bounds];
        self.indicatorView.radius = 300;
        self.indicatorView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.indicatorView];
        [self.indicatorView startScan];
    }
}

- (void)startAnimation
{
    CGFloat delay = 1.0;
    CGFloat scale = 150;
    
    UIView *animationView = [self circleView];
    animationView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:animationView belowSubview:_selectClassroomButtonCollectionView];
    
    [UIView
     animateWithDuration:5
     delay:counts * delay
     options:UIViewAnimationOptionCurveLinear
     animations:^{
         animationView.transform = CGAffineTransformMakeScale(scale, scale);
         animationView.backgroundColor = self.backgroundColor;
         animationView.alpha = 0;
     } completion:^(BOOL finished) {
         [animationView removeFromSuperview];
     }];
}


- (UIView *)circleView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.center = self.center;
    view.backgroundColor = [UIColor whiteColor];
    // 设置视图圆角
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds = YES;
    
    return view;
}

// 进入课堂后将_disPlayLink关闭
- (void)closePlayLink
{
    _disPlayLink.paused = YES;
    [_disPlayLink invalidate];
    _disPlayLink = nil;
}

-(void)dealloc
{
    _selectClassroomButtonCollectionView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)updateUI
{

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 40;
    
    UICollectionView *selectClassroomButtonCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    selectClassroomButtonCollectionView.delegate = self;
    selectClassroomButtonCollectionView.dataSource = self;
    selectClassroomButtonCollectionView.backgroundColor = [UIColor clearColor];
    selectClassroomButtonCollectionView.allowsSelection = YES;
    selectClassroomButtonCollectionView.allowsMultipleSelection = NO;
    [self addSubview:selectClassroomButtonCollectionView];
    _selectClassroomButtonCollectionView = selectClassroomButtonCollectionView;
    [selectClassroomButtonCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifierCell];
    [self setupRadarView];

    ETTLabel *titleLabel = [[ETTLabel alloc]init];
    [titleLabel setTextColor:kETTRGBCOLOR(136, 136, 136)];
    [titleLabel setFont:[UIFont systemFontOfSize:kSelectClassroomTitleTextSize weight:kSelectClassroomTitleWeight]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:kSelectClassroomTitleTextString];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    ETTSelectClassroomConfirmButton *confirmButton = [[ETTSelectClassroomConfirmButton alloc]init];
    confirmButton.userInteractionEnabled = YES;
    [confirmButton setTitleText:kSelectClassroomConfirmTitleTextString];
    confirmButton.layer.cornerRadius = 5.0;
    confirmButton.MDelegate = self;
    [self addSubview:confirmButton];
    _confirmButton = confirmButton;
    
    ETTButton *exitButton = [ETTButton buttonWithType:UIButtonTypeInfoDark];
    [exitButton setImage:[ETTImage imageNamed:kExitButtonBackgroundImage] forState:UIControlStateNormal];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton.titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:10.0]];
    [exitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(onExitButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitButton];
    _exitButton = exitButton;
    
    [self judgmentButtonType];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(self.width/2.0-200.0/2.0, kSelectClassroomTitleTopMargin, 200.0, 40.0);
    
    _selectClassroomButtonCollectionView.frame = CGRectMake(self.width/2.0-kSelectClassroomButtonBoxWidth/2.0 , kSelectClassroomButtonBoxTopMargin, kSelectClassroomButtonBoxWidth, self.height-kSelectClassroomButtonBoxTopMargin-kSelectClassroomConfirmBottomMargin*2.0-kSelectClassroomConfirmHeight);
    _confirmButton.frame = CGRectMake(self.width/2.0-kSelectClassroomButtonBoxWidth/2.0, self.height - kSelectClassroomConfirmBottomMargin*2.0, kSelectClassroomButtonBoxWidth, kSelectClassroomConfirmBottomMargin);
    _exitButton.frame = CGRectMake(_confirmButton.x+kSelectClassroomButtonBoxWidth+(self.width-kSelectClassroomButtonBoxWidth)/4.0-kExitButtonWidth/2.0, _confirmButton.y, kExitButtonWidth, kSelectClassroomConfirmBottomMargin);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_modelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *collectionViewCell          = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCell forIndexPath:indexPath];
    collectionViewCell.layer.cornerRadius             = 5.0;

    ETTStudentSelectTeacherModel *model               = [_modelArray objectAtIndex:[indexPath row]];
    ETTSelectClassroomButtonCell *selectClassroomCell = [[ETTSelectClassroomButtonCell alloc]initWithModel:model];
    [selectClassroomCell setTitle:[model titlName]];
    [collectionViewCell setBackgroundView:selectClassroomCell];
    if ([model.classroomId isEqualToString:_selectedClassroomId]) {
        [selectClassroomCell setMType:ETTSelectClassroomButtonTypeSelected];
    }
    
    return collectionViewCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSelectClassroomButtonSidelength, kSelectClassroomButtonSidelength);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"_lastIndexPath===%@",_lastIndexPath);
    NSLog(@"indexPath===%@",indexPath);
    if (_lastIndexPath) {
        UICollectionViewCell *lastCell                        = (ETTSelectClassroomButtonCell *)[collectionView cellForItemAtIndexPath:_lastIndexPath];
        ETTSelectClassroomButtonCell *lastSelectCell          = (ETTSelectClassroomButtonCell *)lastCell.backgroundView;
        [lastSelectCell setMType:ETTSelectClassroomButtonTypeUnSelected];
    }

    
    UICollectionViewCell *cell                        = (ETTSelectClassroomButtonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ETTSelectClassroomButtonCell *selectCell          = (ETTSelectClassroomButtonCell *)cell.backgroundView;
    _model                                            = selectCell.sModel;
    CAKeyframeAnimation * bounceAnimation             = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values                            = @[@(0.7),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    bounceAnimation.duration                          = transitionTime;
    bounceAnimation.calculationMode                   = kCAAnimationCubic;
    [selectCell.layer addAnimation:bounceAnimation forKey:@"ImageViewAnimation"];

    [selectCell setMType:ETTSelectClassroomButtonTypeSelected];

    ETTSelectClassroomButtonCell *selectClassroomCell = (ETTSelectClassroomButtonCell *)cell.backgroundView;
    ETTStudentSelectTeacherModel *model               = selectClassroomCell.sModel;
    _selectedClassroomId = model.classroomId;
    
    if (_lastIndexPath != indexPath) {
        _lastIndexPath = indexPath;
    }
    
    [self judgmentButtonType];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (ETTSelectClassroomButtonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ETTSelectClassroomButtonCell *selectCell = (ETTSelectClassroomButtonCell *)cell.backgroundView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [selectCell setMType:ETTSelectClassroomButtonTypeUnSelected];
    });
}

-(void)onExitButtonClickHandler:(ETTButton *)sender
{
    NSLog(@"onExitButtonClickHandler");
    [self closePlayLink];
    if (_MDelegate && [_MDelegate respondsToSelector:@selector(onClickExitButton)]) {
        [self.MDelegate onClickExitButton];
    }
}

#pragma mark - ETTSelectClassroomConfirmButtonDelegate   选择课堂点击进入

-(void)onSelectClassroomConfirmButtonClick:(ETTSelectClassroomConfirmButton *)sender
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.17  18:39
     modifier : 康晓光
     version  ：Epic-0315-AIXUEPAIOS-1077
     branch   ：Epic-0315-AIXUEPAIOS-1077/AIXUEPAIOS-0315-984
     describe :学生在爱学派应用内按ipad的开关锁屏后，教师发起指令（推送或者同步进课）时，学生解锁，学生的应用黑屏后退出
     operation: 进行定位检查判断
     */
    [self checkLoactionServeropen];
    /////////////////////////////////////////////////////
    
    
}
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.3.17  18:39
 modifier : 康晓光
 version  ：Epic-0315-AIXUEPAIOS-1077
 branch   ：Epic-0315-AIXUEPAIOS-1077/AIXUEPAIOS-0315-984
 describe :学生在爱学派应用内按ipad的开关锁屏后，教师发起指令（推送或者同步进课）时，学生解锁，学生的应用黑屏后退出
 operation: 开启定位后回调
 */

/////////////////////////////////////////////////////
-(void)enterChoose
{   
    /**
     *  @author LiuChuanan, 17-03-20 15:32:57
     *  
     *  @brief 学生点击了进入课堂按钮
     *
     *
     *  @since 
     */
    [ETTBackToPageManager sharedManager].isEnterSideNav = YES;
        _confirmButton.userInteractionEnabled = NO;
//        NSLog(@"onSelectClassroomConfirmButtonClick:(ETTSelectClassroomConfirmButton *)sender == %@",sender);
        if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(onLoginClassroom:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.MDelegate onLoginClassroom:_model];
            });
            _confirmButton.userInteractionEnabled = YES;
        }else{
            _confirmButton.userInteractionEnabled = YES;
        }
    
    [self closePlayLink];
}
#pragma mark - kREDIS_CREATE_CLASSROOM_DATASOURCES 更新数据源
-(void)onCreateClassroomDataSourceHandler:(NSNotification *)notification
{
    /**
     *  @author LiuChuanan, 17-03-20 16:22:57
     *  
     *  @brief 如果学生没有点击进入课堂按钮,老师在线状态会一直更新
     *  [ETTBackToPageManager sharedManager].isEnterSideNav = NO,不刷新老师在线列表
     *  @since 
     */
    if (![ETTBackToPageManager sharedManager].isEnterSideNav) 
    {
        NSMutableArray *dataArray = [[ETTStudentSelectTeacherViewModel alloc]getDataSourceForStudentSelectTeacherModelWithArray:notification.object];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i=0; i<[dataArray count]; i++) {
            ETTStudentSelectTeacherModel *newModel = [dataArray objectAtIndex:i];
            for (id obj in _modelArray) {
                ETTStudentSelectTeacherModel *oldModel = (ETTStudentSelectTeacherModel *)obj;
                if (oldModel.selected&&[oldModel.classroomId isEqualToString:newModel.classroomId]) {
                    newModel.selected = YES;
                    [dataArray replaceObjectAtIndex:i withObject:newModel];
                }
            }
            
        }
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 将重复的老师剔除
            ETTStudentSelectTeacherModel *model = (ETTStudentSelectTeacherModel *)obj;
            if (!isEmptyString(model.userId)) {
                
                // 如果已有相同的对象存储在tempDic里,判断time,哪个time大就存哪个
                if ([[tempDic objectForKey:model.userId] isKindOfClass:[ETTStudentSelectTeacherModel class]]) {
                    ETTStudentSelectTeacherModel *alreadyExistModel = (ETTStudentSelectTeacherModel *)[tempDic objectForKey:model.userId];
                    NSString *alreadyExistTime = isEmptyString(alreadyExistModel.time)?@"":alreadyExistModel.time;
                    NSString *nowTime = isEmptyString(model.time)?@"":model.time;
                    
                    if ([alreadyExistTime compare:nowTime] == NSOrderedDescending) {
                        // alreadyExistTime时间晚于nowTime时间,说明alreadyExistTime是后来创建的
                        alreadyExistModel.selected = NO;
                        [tempDic setObject:alreadyExistModel forKey:model.userId];
                        
                    }else{
                        // alreadyExistTime时间早于nowTime时间,说明nowTime是后来创建的
                        model.selected = NO;
                        [tempDic setObject:model forKey:model.userId];
                    }
                }else{
                    [tempDic setObject:model forKey:model.userId];
                }
                
            }
        }];
        _modelArray = (NSMutableArray *)tempDic.allValues;
        [_selectClassroomButtonCollectionView reloadData];
        if (_modelArray.count>0&&self.indicatorView) {
            [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.indicatorView stopScan];
            } completion:^(BOOL finished) {
                [self.indicatorView removeFromSuperview];
            }];
            
        }
        [self judgmentButtonType];
    }
}


-(void)judgmentButtonType
{
    if ([_modelArray count]==0||_selectedClassroomId==nil||!_selectedClassroomId) {
        [_confirmButton setConfirmType:ETTCreateClassroomTypeUnAvailable];
    }else{
        if ([self judgmentIdInArray]) {
            [_confirmButton setConfirmType:ETTCreateClassroomTypeAvailable];
        }else{
            [_confirmButton setConfirmType:ETTCreateClassroomTypeUnAvailable];
        }
    }
}

-(BOOL)judgmentIdInArray
{
    for (ETTStudentSelectTeacherModel *obj in _modelArray) {
        if ([_selectedClassroomId isEqualToString:obj.classroomId]) {
            return YES;
        }
    }
    return NO;
}

@end
