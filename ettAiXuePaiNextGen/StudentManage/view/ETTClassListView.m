//
//  ETTClassListView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassListView.h"
#import "UIColor+RGBColor.h"
#import "UIView+Frame.h"
#import "ETTClassificationModel.h"
#import "ETTClassListCell.h"
#import "ETTTeacherCommandView.h"
#import "ETTUserInformationProcessingUtils.h"

@interface ETTClassListView()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView  * _mTableView;
}
@property (nonatomic,retain)ETTTeacherCommandView     * MVLockBtn;
@property (nonatomic,retain)ETTTeacherCommandView     * MVRollCallBtn;
@property (nonatomic,retain)ETTTeacherCommandView     * MVResponderBtn;
@property (nonatomic,retain)ETTTeacherCommandView     * MVGroupBtn;
@property (nonatomic,retain)ETTTeacherCommandView     * MVThrowBtn;

@property (nonatomic,retain)UITableView               * MVTableView;

@end

@implementation ETTClassListView
@synthesize MVTableView = _mTableView;
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self createListView];
        [self createButtonView];
    }
    return self;
    
}
-(void)setEVModel:(ETTStudentManageViewModel *)EVModel
{
    if (EVModel)
    {
        _EVModel = EVModel;
        [self reloadTableView];
    }
}

-(void)reloadView
{
    NSIndexPath * index = [_mTableView indexPathForSelectedRow];
    [_mTableView reloadData];
    [_mTableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
}
-(void)createListView
{
    [self addSubview:self.MVTableView];
}
-(void)setRollCallSelected:(BOOL)isSeleted
{
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    if (model.isRollCall)
    {
        model.isRollCall = isSeleted;
        [_MVRollCallBtn reloadView:model];
    }
   
}

-(void)setResponderSelected:(BOOL)isSeleted
{
    
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    if (model.isReponder)
    {
        model.isReponder = isSeleted;
        [_MVResponderBtn reloadView:model];
    }

}

-(void)serLockScreenSelected:(BOOL)isSeleted
{
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    if (model.isLockScreen)
    {
        model.isLockScreen = isSeleted;
        [_MVLockBtn reloadView:model];
    }

}
-(void)reloadTableView
{
    [_mTableView reloadData];
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [_mTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenChangeViewHandler:withCommandType:)])
    {
        ETTClassificationModel  *model = _EVModel.EDClassListArr[ip.row];
        [self.EVDelegate pEvenChangeViewHandler:model withCommandType:model.classType];
        
    }

}

-(void)reloadCommandViews
{
    
}

-(void)createButtonView
{
    [self addSubview:self.MVLockBtn];
    [self addSubview:self.MVRollCallBtn];
    [self addSubview:self.MVResponderBtn];
}

-(ETTTeacherCommandView *)MVLockBtn
{
    if (_MVLockBtn == nil)
    {
        _MVLockBtn = [[ETTLockScreenCommandView alloc]initWithFrame:CGRectZero];
        _MVLockBtn.EVOperationView = self;

    }
    return _MVLockBtn;
}
-(ETTTeacherCommandView  *)MVRollCallBtn
{
    if (_MVRollCallBtn == nil)
    {
        _MVRollCallBtn = [[ETTRollCallCommandView alloc]initWithFrame:CGRectZero];
        _MVRollCallBtn.EVOperationView = self;
        
    }
    return _MVRollCallBtn;
}

-(ETTTeacherCommandView *)MVResponderBtn
{
    if (_MVResponderBtn == nil)
    {
        _MVResponderBtn = [[ETTReponderCommandView alloc]init];
        _MVResponderBtn.EVOperationView = self;
      
        
    }
    return _MVResponderBtn;
}

-(ETTTeacherCommandView *)MVGroupBtn
{
    if (_MVGroupBtn == nil)
    {
        _MVGroupBtn = [[ETTGroupCommandView alloc]initWithFrame:CGRectZero];
        _MVGroupBtn.EVOperationView = self;
        
    }
    return _MVGroupBtn;
}

-(ETTTeacherCommandView *)MVThrowBtn
{
    if (_MVThrowBtn == nil)
    {
        _MVThrowBtn = [[ETTTVCommandView alloc]init];
        _MVThrowBtn.EVOperationView = self;
    }
    return _MVThrowBtn;
}
-(void)commandView:(id)object
{
    ETTTeacherCommandView  * view = object;
    switch (view.EVType)
    {
        case ETTTEACHERMOMMANDLOCKSCREEN:
        {
            ///老师锁屏
            [self lockBtnCallBack];
        }
            break;
        case ETTTEACHERMOMMANDROLLCALL:
        {
            ///老师点名
            [self rollCallBtnCallback];
        }
            break;
        case ETTTEACHERMOMMANDGROUP:
        {
            [self groupBtnCallBack];
        }
            break;
        case ETTTEACHERMOMMANDTV:
        {
            [self throwBtnCallback];
        }
            break;
        case ETTTEACHERMOMMANDREPONDER:
        {
            ///老师抢答
            [self responderBtnCallBack];
           
        }
            break;

        default:
            break;
    }
}
-(void)lockBtnCallBack
{
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    model.isLockScreen = !model.isLockScreen;
    [_MVLockBtn reloadView:model];
    if (!model.isLockScreen) {
        [ETTUserInformationProcessingUtils publishMessageType:@"MA_05_END" toJid:nil];
    }else{
        [ETTUserInformationProcessingUtils publishMessageType:@"MA_05" toJid:nil];
    }
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDLOCKSCREEN withInfo:nil];
    }
}

-(void)rollCallBtnCallback
{
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    if (model.isReponder)
    {
        model.isReponder = !model.isReponder;
        [_MVResponderBtn reloadView:model];
    }
    model.isRollCall = !model.isRollCall;
    [_MVRollCallBtn reloadView:model];
    
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDROLLCALL withInfo:nil];
        
    }
}

-(void)responderBtnCallBack
{
   
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    if (model.isRollCall)
    {
        model.isRollCall = !model.isRollCall;
        [_MVRollCallBtn reloadView:model];
    }
    model.isReponder = !model.isReponder;
     [_MVResponderBtn reloadView:model];
    
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDREPONDER withInfo:nil];
        
    }
}

-(void)groupBtnCallBack
{
    
    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    model.isGroup = !model.isGroup;
    [_MVGroupBtn reloadView:model];
    
    [_MVResponderBtn reloadView:model];
    
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDGROUP withInfo:nil];
        
    }

}

-(void)throwBtnCallback
{

    ETTClassificationModel  *model = _EVModel.EDClassListArr.firstObject;
    if (!model)
    {
        return;
    }
    model.isTV = !model.isTV;
    [_MVThrowBtn reloadView:model];
    
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDTV withInfo:nil];
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVLockBtn.frame      = CGRectMake(10, self.height-36-64, 64, 64);
    _MVRollCallBtn.frame  = CGRectMake(_MVLockBtn.v_right+10, self.height-36-64, 64, 64);
    _MVResponderBtn.frame =CGRectMake(_MVRollCallBtn.v_right+10, self.height-36-64, 64, 64);

}

-(UITableView *)MVTableView
{
    if (_mTableView == nil)
    {
        _mTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0 ,self.width,  self.height -162) style:UITableViewStylePlain];
        _mTableView.delegate       = self;
        _mTableView.dataSource     = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.separatorColor =[UIColor colorWithHexString:@"#d8d8d8"];

    }
    return _mTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_EVModel)
    {
        return _EVModel.EDClassListArr.count;
    }
    return  0;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.frame   = CGRectMake(0, 0, kWIDTH, 10);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassificationModel * model = _EVModel.EDClassListArr[indexPath.row];
    ETTClassListCell * cell = nil;
    switch (model.classType) {
        case ETTCLASSTYPEONLINE:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"onlineCell"];
            if (cell == nil)
            {
                cell = [[ETTClassOnlineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onlineCell"];
            }
        }
            break;
        case ETTCLASSTYPEATTEND:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"attendCell"];
            if (cell == nil)
            {
                cell = [[ETTClassAttendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"attendCell"];
            }
        }
            break;
        case ETTCLASSESTABLISH:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"establishCell"];
            if (cell == nil)
            {
                cell = [[ETTClassEstablishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"establishCell"];
                
            }
        }
            break;
        default:
            break;
    }
    [cell updateCellViews:model];
    return cell;
}
-(nullable NSIndexPath *)tableView:(UITableView *)tableView  willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenChangeViewHandler:withCommandType:)])
    {
        ETTClassificationModel  *model = _EVModel.EDClassListArr[indexPath.row];
        [self.EVDelegate pEvenChangeViewHandler:model withCommandType:model.classType];
        
    }
}


-(ETTClassificationModel  * )getCurrentViewModel
{
    NSIndexPath * index = [_mTableView indexPathForSelectedRow];
    return _EVModel.EDClassListArr[index.row];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
