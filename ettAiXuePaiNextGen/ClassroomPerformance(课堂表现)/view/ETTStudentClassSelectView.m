//
//  ETTStudentClassSelectView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentClassSelectView.h"
#import "ETTClassSelectCell.h"
@interface ETTStudentClassSelectView()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _mTableview;
    BOOL          _isShowlist;
}
@property (nonatomic,retain)UIButton    * MVSelectBtn;
@property (nonatomic,retain)UITableView * MVTableView;
@end

@implementation ETTStudentClassSelectView
@synthesize MVTableView  = _mTableview;
@synthesize EVShowList= _isShowlist;
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createSubView];
    }
    return self;
}

-(void)createSubView
{
    
    [self addSubview:self.MVTableView];
}
-(void)reloadView
{
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [_mTableview selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    if (self.EVModel &&  [self.EVModel respondsToSelector:@selector(pViewSelected:)])
    {
        [self.EVDelegate pViewSelected:self];
    }
    
}

-(void)setEVModel:(ETTClassPerformanceModel *)EVModel{
    if (EVModel)
    {
        _EVModel = EVModel;
        NSInteger  count =  MIN(_EVModel.EDClassModelArr.count, 3);
        if (_isShowlist)
        {
            self.frame =  CGRectMake(self.x, self.y, self.width, 45 * count);
            _mTableview.frame = CGRectMake(_mTableview.x, _mTableview.y, _mTableview.width, self.height);
        }
        else
        {
            self.frame =  CGRectMake(self.x,-45 * count, self.width, 45 * count);
            _mTableview.frame = CGRectMake(_mTableview.x, _mTableview.y, _mTableview.width, self.height);
        }
      
       
    }
}

-(UITableView *)MVTableView
{
    if (_mTableview == nil)
    {
        _mTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _mTableview.delegate = self;
        _mTableview.dataSource = self;
        _mTableview.scrollEnabled = false;
       
        
        
        _mTableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        [self addSubview: _mTableview];

    }
    return _mTableview;
}
-(void)show
{
    //把dropdownList放到前面，防止下拉框被别的控件遮住
    
    [self.superview bringSubviewToFront:self];
    if (self.y>=0)
    {
        CGRect frame = self.frame;
        frame.origin.x = -frame.size.height;
        self.frame = frame;
    }
 
    _isShowlist = YES;//显示下拉框
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, 0, weakSelf.width, weakSelf.height);
        //self.backgroundColor = [UIColor redColor];
    }];
}
-(void)hidenView
{
    WS(weakSelf);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        weakSelf.frame =CGRectMake(self.x, -self.height, self.width, weakSelf.height);
        
        _isShowlist = false;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)setEVSelectIndex:(NSInteger)EVSelectIndex
{
  
    
    NSInteger  count =  MIN([_EVModel getClassCount], 3);
    if (_isShowlist)
    {
        self.frame =  CGRectMake(self.x, self.y, self.width, 45 * count);
        _mTableview.frame = CGRectMake(_mTableview.x, _mTableview.y, _mTableview.width, self.height);
    }
    else
    {
        self.frame =  CGRectMake(self.x,-45 * count, self.width, 45 * count);
        _mTableview.frame = CGRectMake(_mTableview.x, _mTableview.y, _mTableview.width, self.height);
    }
    
    [_mTableview reloadData];
    if ([self.EVModel getClassCount]>0)
    {
        
        _EVSelectIndex = EVSelectIndex;
        NSIndexPath *ip=[NSIndexPath indexPathForRow:EVSelectIndex inSection:0];
        [_mTableview selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
        
    }
//    if (self.EVDelegate &&  [self.EVDelegate respondsToSelector:@selector(pViewSelected:)])
//    {
//        [self.EVDelegate pViewSelected:self];
//    }

}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.EVModel getClassCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ETTClassSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (cell == nil)
    {
        cell  = [[ETTClassSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectCell"];
    }
    
    cell.EVNameLabel.text = [self.EVModel getClassName:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _EVSelectIndex = indexPath.row;
    if (self.EVDelegate &&  [self.EVDelegate respondsToSelector:@selector(pViewSelected:)])
    {
        [self.EVDelegate pViewSelected:self];
    }
    [self hidenView];
}

@end
