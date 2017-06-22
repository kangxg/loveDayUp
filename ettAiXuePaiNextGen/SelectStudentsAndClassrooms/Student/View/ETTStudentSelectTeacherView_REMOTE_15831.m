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

@interface ETTStudentSelectTeacherView ()
{
    UIColor *backgroundColor;
}

@property (nonatomic,strong) ETTStudentSelectTeacherModel       *model;

@property (nonatomic,strong) ETTLabel                           *titleLabel;

@property (nonatomic,strong) UICollectionView                   *selectClassroomButtonCollectionView;

@property (nonatomic,strong) ETTSelectClassroomConfirmButton    *confirmButton;

@property (nonatomic,strong) ETTButton                          *exitButton;

@property (nonatomic,strong) NSMutableArray                     *modelArray;

@end

@implementation ETTStudentSelectTeacherView

static  NSString * const kIdentifierCell = @"cell";

@synthesize MDelegate   =   _MDelegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        ETTStudentSelectTeacherViewModel *vm = [[ETTStudentSelectTeacherViewModel alloc]init];
        [[self updateAttributes]updateUI];
    }
    
    return self;
}

-(instancetype)updateAttributes
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCreateClassroomDataSourceHandler:) name:kREDIS_CREATE_CLASSROOM_DATASOURCES object:nil];
    backgroundColor =   kETTRGBCOLOR(233.0, 242.0, 248.0);
    self.backgroundColor = backgroundColor;
    
    return self;
}

-(instancetype)updateUI
{
    ETTLabel *titleLabel = [[ETTLabel alloc]init];
    [titleLabel setTextColor:kETTRGBCOLOR(136, 136, 136)];
    [titleLabel setFont:[UIFont systemFontOfSize:kSelectClassroomTitleTextSize weight:kSelectClassroomTitleWeight]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:kSelectClassroomTitleTextString];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 40;
    
    UICollectionView *selectClassroomButtonCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    selectClassroomButtonCollectionView.delegate = self;
    selectClassroomButtonCollectionView.dataSource = self;
    selectClassroomButtonCollectionView.backgroundColor = backgroundColor;
    selectClassroomButtonCollectionView.allowsSelection = YES;
    selectClassroomButtonCollectionView.allowsMultipleSelection = NO;
    [self addSubview:selectClassroomButtonCollectionView];
    _selectClassroomButtonCollectionView = selectClassroomButtonCollectionView;
    [selectClassroomButtonCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifierCell];
    
    ETTSelectClassroomConfirmButton *confirmButton = [[ETTSelectClassroomConfirmButton alloc]init];
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
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCell forIndexPath:indexPath];
    collectionViewCell.layer.cornerRadius = 5.0;
    
    ETTStudentSelectTeacherModel *model = [_modelArray objectAtIndex:[indexPath row]];
    ETTSelectClassroomButtonCell *selectClassroomCell = [[ETTSelectClassroomButtonCell alloc]initWithModel:model];
    [selectClassroomCell setTitle:[model titlName]];
    [collectionViewCell setBackgroundView:selectClassroomCell];
    return collectionViewCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSelectClassroomButtonSidelength, kSelectClassroomButtonSidelength);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (ETTSelectClassroomButtonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ETTSelectClassroomButtonCell *selectCell = (ETTSelectClassroomButtonCell *)cell.backgroundView;
    _model = selectCell.sModel;
    [selectCell setMType:ETTSelectClassroomButtonTypeSelected];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (ETTSelectClassroomButtonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ETTSelectClassroomButtonCell *selectCell = (ETTSelectClassroomButtonCell *)cell.backgroundView;
    [selectCell setMType:ETTSelectClassroomButtonTypeUnSelected];
}

-(void)onExitButtonClickHandler:(ETTButton *)sender
{
    NSLog(@"onExitButtonClickHandler");
    if (_MDelegate && [_MDelegate respondsToSelector:@selector(onClickExitButton)]) {
        [self.MDelegate onClickExitButton];
    }
}

#pragma mark - ETTSelectClassroomConfirmButtonDelegate   选择课堂点击进入
-(void)onSelectClassroomConfirmButtonClick:(ETTSelectClassroomConfirmButton *)sender
{
    NSLog(@"onSelectClassroomConfirmButtonClick:(ETTSelectClassroomConfirmButton *)sender == %@",sender);
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(onLoginClassroom:)]) {
        [self.MDelegate onLoginClassroom:_model];
    }
}


#pragma mark - kREDIS_CREATE_CLASSROOM_DATASOURCES 更新数据源
-(void)onCreateClassroomDataSourceHandler:(NSNotification *)notification
{
    NSMutableArray *dataArray = [[ETTStudentSelectTeacherViewModel alloc]getDataSourceForStudentSelectTeacherModelWithArray:notification.object];
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
    _modelArray = dataArray;
    
    [_selectClassroomButtonCollectionView reloadData];
}

@end
