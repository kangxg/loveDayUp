//
//  ETTShowUserCurrentOperationView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTShowUserCurrentOperationView.h"
#import <UIImageView+WebCache.h>
#import "ETTScenePorter.h"
@interface ETTShowUserCurrentOperationView()
@property (nonatomic,retain)UIButton      * MVCloseBtn;
@property (nonatomic,retain)UIImageView   * MVShowImageview;

@end
@implementation ETTShowUserCurrentOperationView
-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName
{
    if (self = [super initWithFrame:frame])
    {
          self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
       
          [self createShowView:[UIImage imageNamed:imageName]];
         [self createCloseView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withImag:(UIImage  *)image
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        
        [self createShowView:image];
        [self createCloseView];
    }
    return self;
}
-(void)createCloseView
{

    [self addSubview:self.MVCloseBtn];
   
    
}

-(void)createShowView:(UIImage *)image
{
    [self addSubview:self.MVShowImageview];
    [self reloadImageView:image];
}

-(void)reloadView:(UIImage *)image
{
    [self reloadImageView:image];
}

-(void)reloadImageView:(UIImage *)image
{
    if (image)
    {
        self.MVShowImageview.image = image;
    }
}

-(UIButton * )MVCloseBtn
{
    if (_MVCloseBtn == nil)
    {
        _MVCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVCloseBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MVCloseBtn;
}

-(void)closeView
{
    [self removeFromSuperview];
    [[ETTScenePorter shareScenePorter].EDViewRecordManager undoRecores:NSStringFromClass([self class])];
}
-(UIImageView *)MVShowImageview
{
    if (_MVShowImageview == nil)
    {
        _MVShowImageview = [[UIImageView alloc]init];
    }
    return _MVShowImageview;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _MVShowImageview.frame = self.bounds;
    _MVCloseBtn.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
