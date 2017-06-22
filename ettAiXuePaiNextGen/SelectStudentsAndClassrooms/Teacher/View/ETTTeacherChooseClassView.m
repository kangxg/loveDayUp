//
//  ETTTeacherChooseClassView.m
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
//  Created by zhaiyingwei on 2016/10/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherChooseClassView.h"

@interface ETTTeacherChooseClassView ()

/**
 *  @author LiuChuanan, 17-05-08 15:30:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 8 9 10 11
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong) ETTLabel                                 *titleLabel;
@property (nonatomic,strong) UICollectionView                         *chooseClassButtonBoxCollectionView;
@property (nonatomic,strong) ETTTeacherChooseClassroomConfirmButton   *confirmButtom;
@property (nonatomic,strong) ETTButton                                *exitButton;

@property (nonatomic,strong) UIColor                                *colorOfTitleLabeltext;
@property (nonatomic,strong) UIColor                                *colorOfBackground;

/**
 *  @author LiuChuanan, 17-05-08 15:30:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 12
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong) ETTTeacherChooseClassroomModel           *classmRoomModel;
@property (nonatomic,strong) NSMutableArray                         *modelMutableArray;

@end

static NSString *kCellIdentifier = @"collectionCellID";
static NSString *kHeaderIdentifier = @"headerIdentifier";

@implementation ETTTeacherChooseClassView

@synthesize MDelegate   =   _MDelegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[[self updateAttributes]createUI]createExitButton];
        [ETTUSERDefaultManager setCurrentIdentity:@"teacher"];
        ////////////////////////////////////////////////////////
        /*
         new      : Modify
         time     : 2017.3.14  10:56
         modifier : 康晓光
         version  ：Epic-0313-AIXUEPAIOS-1061
         branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1004rollback_Epic0313_1061
         describe : 对AIXUEPAIOS-1004_Epic0313_1061 分支代码的恢复
         */

         //[ETTUSERDefaultManager setReconnectionClass:NO];
        /////////////////////////////////////////////////////
    }
    return self;
}

-(instancetype)updateAttributes
{
    self.modelMutableArray = [[NSMutableArray alloc]init];
    
    self.colorOfTitleLabeltext = [UIColor grayColor];
    self.colorOfBackground = kETTRGBCOLOR(233.0, 242.0, 248.0);
    self.backgroundColor = _colorOfBackground;
    
    return self;
}

-(instancetype)createUI
{
    [[[self createTitle]createCollectionView]createConfirmButton];
    
    return self;
}

-(instancetype)createTitle
{
    ETTLabel *titleLabel = [[ETTLabel alloc]init];
    [titleLabel setFont:[UIFont systemFontOfSize:kTeacherChooseClassTitleTextSize weight:kTeacherChooseClassTitleTextWeight]];
    [titleLabel setTextColor:_colorOfTitleLabeltext];
    [titleLabel setText:kTeacherChooseClassTitleTextString];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return self;
}

-(instancetype)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout                     = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset                                    = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing                              = 40.0;

    UICollectionView * chooseClassButtonBoxCollectionView      = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    chooseClassButtonBoxCollectionView.delegate                = self;
    chooseClassButtonBoxCollectionView.dataSource              = self;
    chooseClassButtonBoxCollectionView.backgroundColor         = self.colorOfBackground;
    chooseClassButtonBoxCollectionView.allowsMultipleSelection = NO;
    [self addSubview:chooseClassButtonBoxCollectionView];
    _chooseClassButtonBoxCollectionView = chooseClassButtonBoxCollectionView;
    
    [self.chooseClassButtonBoxCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.chooseClassButtonBoxCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    
    return self;
}

-(void)createConfirmButton
{
    ETTTeacherChooseClassroomConfirmButton *confirmButtom = [[ETTTeacherChooseClassroomConfirmButton alloc]init];
    [confirmButtom setTitleText:@"进入课堂"];
    confirmButtom.userInteractionEnabled = YES;
    confirmButtom.MDelegate = self;
    [self addSubview:confirmButtom];
    _confirmButtom = confirmButtom;
    [self judgmentButtonState];
}

-(void)judgmentButtonState
{
    ETTTeacherChooseClassroomViewVM *teacherVM = [[ETTTeacherChooseClassroomViewVM alloc]init];
    NSLog(@"~~~~~~~%ld",[teacherVM getSelectedCellNumber:_modelMutableArray]);
    if (0 == [teacherVM getSelectedCellNumber:_modelMutableArray]) {
        [_confirmButtom setState:ETTTeacherChooseClassroomConfirmButtonTypeUnAvailable];
    }else{
        [_confirmButtom setState:ETTTeacherChooseClassroomConfirmButtonTypeAvailable];
    }
}

-(instancetype)createExitButton
{
    ETTButton *exitButton = [ETTButton buttonWithType:UIButtonTypeInfoDark];
    [exitButton setImage:[ETTImage imageNamed:kTeacherChooseClassExitButtonBackgroundImage] forState:UIControlStateNormal];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton.titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:10.0]];
    [exitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(onExitButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitButton];
    _exitButton = exitButton;
    
    return self;
}

-(void)onExitButtonClickHandler:(ETTButton *)sender
{
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(onClickExitButton)]) {
        [self.MDelegate onClickExitButton];
    }
}

-(NSArray *)getClassTagList
{
    NSArray *classList;
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(setClassList)]) {
        classList = [NSArray arrayWithArray:[self.MDelegate setClassList]];
    }
    return classList;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(self.width/2.0-kTeacherChooseClassTitleWidth/2.0, kTeacherChooseClassTitleTopMargin, kTeacherChooseClassTitleWidth, kTeacherChooseClassTitleHeight);
    
    _chooseClassButtonBoxCollectionView.frame = CGRectMake(self.width/2.0-kTeacherChooseClassButtonBoxWidth/2.0, kTeacherChooseClassButtonBoxTopMargin, kTeacherChooseClassButtonBoxWidth, self.height-kTeacherChooseClassConfirmHeight-kTeacherChooseClassConfirmBottomMargin*2.0-kTeacherChooseClassButtonBoxTopMargin);
    
    _confirmButtom.frame = CGRectMake(self.width/2.0-kTeacherChooseClassConfirmWidth/2.0, self.height-kTeacherChooseClassConfirmHeight-kTeacherChooseClassConfirmBottomMargin, kTeacherChooseClassConfirmWidth, kTeacherChooseClassConfirmHeight);
    
    _exitButton.frame = CGRectMake(_confirmButtom.x+kTeacherChooseClassConfirmWidth+(self.width-kTeacherChooseClassConfirmWidth)/4.0-kTeacherChooseClassExitButtonWidth/2.0, _confirmButtom.y, kTeacherChooseClassExitButtonWidth, kTeacherChooseClassConfirmHeight);
}

#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *classList = [NSArray arrayWithArray:[[[NSArray arrayWithArray:[self getClassTagList]]objectAtIndex:section]valueForKey:@"classList"]];
    return  [classList count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self getClassTagList]count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    collectionViewCell.layer.cornerRadius = 5.0;
    
    ETTTeacherChooseClassroomButton *teacherChooseClassroomBtn = [[ETTTeacherChooseClassroomButton alloc]init];
    [teacherChooseClassroomBtn setIndexPath:indexPath];
    [_modelMutableArray addObject:teacherChooseClassroomBtn];
    
    [collectionViewCell setBackgroundView:teacherChooseClassroomBtn];
    ETTTeacherChooseClassroomModel *classroomModel = [[ETTTeacherChooseClassroomModel alloc]initWithIndexPath:indexPath];
    [teacherChooseClassroomBtn setClassroomModel:classroomModel];
    
    
    return collectionViewCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ]){
        reuseIdentifier = kHeaderIdentifier;
    }else{
        NSLog(@"error for viewForSupplementaryElementOfKind!");
    }
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    NSDictionary *allClassDic = [[NSArray arrayWithArray:[self getClassTagList]]objectAtIndex:indexPath.section];
    
    ETTLabel *label = [[ETTLabel alloc]initWithFrame:CGRectMake(0, 0, 150.0, view.height)];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        label.text = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",[allClassDic valueForKey:@"classTag"]],indexPath.section];
        [label setFont:[UIFont systemFontOfSize:14.0 weight:10.0]];
        [label setTextColor:[UIColor grayColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [view addSubview:label];
    }
    
    return view;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [[ETTTeacherChooseClassroomViewVM alloc]changerCellTypeWithArray:_modelMutableArray inSection:indexPath.section];
    ETTTeacherChooseClassroomButton *teacherChooseClassroomButton = (ETTTeacherChooseClassroomButton *)cell.backgroundView;
    [teacherChooseClassroomButton changeType];
    
    [self judgmentButtonState];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self judgmentButtonState];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kTeacherChooseClassButtonSidelength, kTeacherChooseClassButtonSidelength);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kTeacherChooseClassButtonBoxSectionMargin;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return kTeacherChooseClassButtonBoxSectionHeadSize;
}

#pragma mark - ETTTeacherChooseClassroomConfirmButtonDelegate

-(void)onClickItemHandler
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
    _confirmButtom.userInteractionEnabled = NO;
    ETTTeacherChooseClassroomViewVM *teacherVM = [[ETTTeacherChooseClassroomViewVM alloc]init];
    if ([teacherVM getSelectedCellNumber:_modelMutableArray]) {
        [[ETTTeacherChooseClassroomViewVM alloc]openClassRoom:_modelMutableArray returnBack:^(ETTOpenClassroomDoBackModel *backModel,NSError *error) {
            _confirmButtom.userInteractionEnabled = YES;
            if (error) {
                [self toast:@"视乎与网络断开链接！"];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(teacherChooseClassroom:)]) {
                        [self.MDelegate teacherChooseClassroom:backModel];
                    }
                });
            }
        }];
    }else{
        [self toast:@"没有选择课堂!!"];
        NSLog(@"没有选择课堂!!");
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    ETTTeacherChooseClassroomButton *selectCell = (ETTTeacherChooseClassroomButton *)cell.backgroundView;
    CAKeyframeAnimation * bounceAnimation =  [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@(0.7),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    bounceAnimation.duration = 0.1;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [selectCell.layer addAnimation:bounceAnimation forKey:@"ImageViewAnimation"];
}

-(void)dealloc
{
    _colorOfBackground = nil;
    _colorOfTitleLabeltext = nil;
    _classmRoomModel = nil;
    _modelMutableArray = nil;
}

@end
