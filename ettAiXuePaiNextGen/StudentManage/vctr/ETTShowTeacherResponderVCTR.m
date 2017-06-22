//
//  ETTShowTeacherResponderVCTR.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTShowTeacherResponderVCTR.h"
#import "ETTClassUserModel.h"
#import "ETTTeacherResponderViewModel.h"
#import "ETTResponderUserCell.h"
#import "ETTUserInformationProcessingUtils.h"

@interface ETTShowTeacherResponderVCTR ()
@property(nonatomic,retain)UIButton * MVOverBtn;
@property (nonatomic,retain)UIImageView * MVResponderView;
@property (nonatomic,retain)UILabel     * MVPrompLabel;
@property (nonatomic,retain)ETTTeacherResponderViewModel  * MVModel;

@end

@implementation ETTShowTeacherResponderVCTR

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self createSubView];
}
-(void)initdata{
    _MVModel = [[ETTTeacherResponderViewModel alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processSMA07Handler:) name:kREDIS_COMMAND_TYPE_SMA_07 object:nil];
}
-(void)createSubView
{
    self.view.backgroundColor =[UIColor colorWithHexString:@"#fafafa"];
    [self setupNavBar];
    [self createImageView];
    [self createLabelView];
    [self createCollectionView];
    [self beginGifAnimation];

   
}
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
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
    [backButton addTarget:self action:@selector(clickBackHandle) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self createOverBtn];
}

-(void)createOverBtn
{
    if (_MVOverBtn == nil)
    {
        _MVOverBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image            = [UIImage imageNamed:@"responder_end"];
        [_MVOverBtn setImage:image forState:UIControlStateNormal];
        [_MVOverBtn setImage:[UIImage imageNamed:@"responder_start"] forState:UIControlStateSelected];
        _MVOverBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_MVOverBtn.titleLabel sizeToFit];
        _MVOverBtn.frame           = CGRectMake(0, 0, 60, 30);
        [_MVOverBtn addTarget:self action:@selector(overBtnHandle) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_MVOverBtn];
    }
    
}

-(void)createImageView
{
    [self.view addSubview:self.MVResponderView];
}
-(void)createLabelView
{
    [self.view addSubview:self.MVPrompLabel];
    
}
-(void)createCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing      = 11;
    layout.minimumLineSpacing           = 20;
    layout.sectionInset                 = UIEdgeInsetsMake(20, 41, 20,41 );
    if(_EVCollectionView == nil)
    {
        _EVCollectionView = [[ETTCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height -64) collectionViewLayout:layout];
        _EVCollectionView.backgroundColor = [UIColor whiteColor];
        _EVCollectionView.delegate        = self;
        _EVCollectionView.dataSource      = self;
        [self reginCollectCell];
        [self.view addSubview:_EVCollectionView];
        
    }
}
-(void)reginCollectCell
{
    [_EVCollectionView registerClass:[ETTResponderUserCell class] forCellWithReuseIdentifier:@"responderCell"];
    
}
-(UILabel *)MVPrompLabel
{
    if (_MVPrompLabel == nil)
    {
        _MVPrompLabel               = [[UILabel alloc]init];
        _MVPrompLabel.font          = [UIFont systemFontOfSize:14.0f];
        _MVPrompLabel.text          = @"暂无人抢答...";
        _MVPrompLabel.textAlignment = NSTextAlignmentCenter;
        _MVPrompLabel.textColor     = kAXPTEXTCOLORf1;
        _MVPrompLabel.frame         = CGRectMake(0, self.view.height-177, self.view.width, 20);
    }
    return _MVPrompLabel;
}
-(UIImageView *)MVResponderView
{
    if (_MVResponderView == nil)
    {
        _MVResponderView       = [[UIImageView alloc]init];
        _MVResponderView.frame = CGRectMake((self.view.width-450)/2, 134, 450, 300);
        _MVResponderView.image = [UIImage imageNamed:@"responder_gif_1"];
        NSMutableArray *imgArray = [NSMutableArray array];
        
        for (int i = 1; i<21; i++)
        {
            UIImage  * image = [UIImage imageNamed:[NSString stringWithFormat:@"responder_gif_%d",i]];
            [imgArray addObject:image];
        }
        
        self.MVResponderView.animationImages   = imgArray;
        //设置执行一次完整动画的时长
        self.MVResponderView.animationDuration = 2;
        //动画重复次数 （0为重复播放）
        self.MVResponderView.animationRepeatCount = 0;
    }
    return _MVResponderView;
}
-(void)clickBackHandle
{
    if (self.EVManagerVCTR)
    {

        ETTResponderModel *model = nil;
        if (_MVModel.EDResponderArr.count)
        {
            NSDate *date                = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
            NSNumber *eventTime         = [NSNumber numberWithInteger:timeInterval];
            model =_MVModel.EDResponderArr.firstObject;
            NSDictionary * dic = @{@"jid":model.jid,@"answerCount":@(_MVModel.EDResponderCount),@"eventTime":eventTime,@"raceArr":_MVModel.EDResponderArr};
          
            [self.EVManagerVCTR manageViewControllerClose:self withCommond:ETTVCTROMMANDTYPECLOSE withInfo:dic];
        }
        else
        {
             [self.EVManagerVCTR manageViewControllerClose:self withCommond:ETTVCTROMMANDTYPECLOSE withInfo:nil];
        }
       
        
       

    }
    if (!self.MVOverBtn.selected) {
         [self pushResponderData];
    }
   
    [self sendStopResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)overBtnHandle
{
   
    if (self.MVOverBtn.selected)
    {
        [self beginGifAnimation];
        [self sendStartResponder];
    }
    else
    {
        [self pushResponderData];
        [self endGifAnimation];
        [self sendStopResponder];
    }
     self.MVOverBtn.selected = !self.MVOverBtn.selected;
    
}

-(void)pushResponderData
{
 
    [self.EVManagerVCTR manageViewDataOperation:_MVModel.EDResponderArr];
}

-(void)startTiming
{
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf responderTimeout];
    });
}
                  
-(void)responderTimeout
{
    if(self.MVOverBtn.selected)
    {
        return;
    }
    
    if(_MVModel.EDResponderArr.count <1)
    {
        [_MVOverBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
       
    }
}
-(void)beginGifAnimation
{
    
    [self startTiming];
    if (_MVModel.EDResponderArr.count)
    {
        [_MVModel.EDResponderArr removeAllObjects];
        [self.EVCollectionView reloadData];
        self.EVCollectionView.hidden = false;
    }
    self.EVCollectionView.hidden = YES;
    self.MVResponderView.hidden = false;
    [self.MVResponderView startAnimating];
    
    self.MVPrompLabel.hidden = false;

   
}


-(void)processSMA07Handler:(NSNotification *)notification
{
    NSDictionary *messageDic = notification.object;
    [self reciveStudentResponderMsg:@[messageDic]];
}

-(void)endGifAnimation
{
    [self.MVResponderView stopAnimating];
   

    if (_MVModel.EDResponderArr.count)
    {
      self.EVCollectionView.hidden = false;
      self.MVPrompLabel.hidden = YES;
        self.MVResponderView.hidden = YES;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
 
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    _MVModel.EDResponderArr.count?40:0;
    return _MVModel.EDResponderArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeZero;
    itemSize        = CGSizeMake(102, 136);
    return itemSize;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTResponderUserCell * cell =  (ETTResponderUserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"responderCell" forIndexPath:indexPath];
    
    [cell setUserModel:_MVModel.EDResponderArr[indexPath.row]];
    return cell;
}


-(void)ProcessingResponderBack:(ETTProcessingDataState )state
{
    switch (state) {
        case ETTPROCESSINGDATASUCCESS:
        {
            
            [self endGifAnimation];
            [self.EVCollectionView reloadData];
        }
            break;
        case ETTPROCESSINGDATAFAILT:
        {
            
            
        }
        case ETTPROCESSINGDATANONE:
        {
            
        }
        case ETTPROCESSINGDATAERROR:
        {
            
        }
            
        case ETTPROCESSINGDATANULL:
        {
           
        }
            break;
            
            
            
        default:
            break;
    }

}
#pragma mark -----------收到抢答数据-----------
-(void)reciveStudentResponderMsg:(NSArray *)arr
{
    WS(weakSelf);
    [_MVModel putArrData:arr withBlock:^(ETTProcessingDataState state) {
        [weakSelf ProcessingResponderBack:state];
    }];
    
    
    
    
}
#pragma mark   -------------发送开始抢答--------------
/**
 Description  发送开始抢答
 */
-(void)sendStartResponder
{
    _MVModel.EDResponderCount ++;
    [ETTUserInformationProcessingUtils publishMessageType:@"MA_07_BEGIN" toJid:nil];
}
#pragma mark   -------------发送结束抢答--------------
/**
 Description  发送结束抢答
 */
-(void)sendStopResponder
{
    [ETTUserInformationProcessingUtils publishMessageType:@"MA_07_END" toJid:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_SMA_07 object:nil];
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
