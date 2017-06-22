//
//  AXPStudentAnswerListCollectionViewCell.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPStudentAnswerListCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "ETTCoursewarePresentViewControllerManager.h"
#import "AXPUserInformation.h"

@interface AXPStudentAnswerListCollectionViewCell ()

@property (nonatomic ,strong) UIImageView *iconView;

@property (nonatomic ,strong) UILabel     *nameLabel;

@property (nonatomic ,strong) UIImageView *detailWhiteboardView;

@property (nonatomic ,strong) UIImageView *scoreImageView;

@property (nonatomic ,strong) UILabel      *annotateLabel;

@end

@implementation AXPStudentAnswerListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpAnswerListSubViews];
        
    }
    
    return self;
}

-(void)setUpPaperAnswerDetailWithDict:(NSDictionary *)dict isMarkScore:(BOOL)isMarkScore
{
    self.nameLabel.text = dict[kuserName];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dict[kuserPhoto]]];
    
    NSString *urlStr;
    
    //没有互批
    if (!isMarkScore) {
        
        urlStr = dict[kAnswerImgUrl];
        
    } else { //互批了
    
        NSString *answerImgUrl  = dict[kAnswerImgUrl];//http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//50043_20170106_3162002_1483673996921.png

        NSString *imageUrl      = answerImgUrl.lastPathComponent;//50043_20170106_3162002_1483673996921.png

        NSArray *array          = [imageUrl componentsSeparatedByString:@"."];

        NSString *imageU        = [array firstObject];

        imageUrl                = [NSString stringWithFormat:@"%@_p.jpg",imageU];//50043_20170106_3162002_1483673996921_p.png

        answerImgUrl            = [answerImgUrl stringByDeletingLastPathComponent];//http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//

        answerImgUrl            = [NSString stringWithFormat:@"%@//%@",answerImgUrl,imageUrl];


        urlStr                  = answerImgUrl;

        self.annotateLabel.text = [NSString stringWithFormat:@"批注人 : %@",dict[kmarkName]];
        NSString *scoreImageName;
        
        if ([dict[kmarkPoint] isEqualToString:@"-1"]) {
            
            scoreImageName = @"score_none";
        } else {
            scoreImageName = [NSString stringWithFormat:@"score_%@",dict[kmarkPoint]];
        }
        
        self.scoreImageView.image = [UIImage imageNamed:scoreImageName];
        
        self.scoreImageView.hidden= NO;
        
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.detailWhiteboardView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_small_loading"] options:SDWebImageLowPriority];
}

-(void)setUpAttributesWithDict:(NSDictionary *)dict isMarkScore:(BOOL)isMarkScore;
{
    self.nameLabel.text = dict[kuserName];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dict[kuserPhoto]]];
    
    NSString *urlStr;
    if (!isMarkScore) {
        
        if ([ETTCoursewarePresentViewControllerManager sharedManager].cacheHost) {
            urlStr = [NSString stringWithFormat:@"%@%@",[ETTCoursewarePresentViewControllerManager sharedManager].cacheHost,dict[kuserWbImg]];
        } else {
            
            urlStr = [NSString stringWithFormat:@"http://%@%@%@",[AXPUserInformation sharedInformation].redisIp,@"/ettschoolmitm/mitm2ettschool/localok//",dict[kuserWbImg]];
            
        }
        
    }else
    {
        self.annotateLabel.text = [NSString stringWithFormat:@"批注人 : %@",dict[kmarkName]];
        NSString *scoreImageName;
        
        
        if ([dict[kmarkPoint] isEqualToString:@"-1"]) {
            
            scoreImageName = @"score_none";
            
        }else
        {
            scoreImageName = [NSString stringWithFormat:@"score_%@",dict[kmarkPoint]];
        }
        
        self.scoreImageView.image = [UIImage imageNamed:scoreImageName];
        
        self.scoreImageView.hidden = NO;
        
        urlStr = dict[kcommentImageUrl];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self.detailWhiteboardView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_small_loading"] options:SDWebImageLowPriority];
}

-(void)setUpAnswerListSubViews
{
    CGFloat kCellW                              = self.frame.size.width;
    CGFloat kCellH                              = self.frame.size.height;

    UIView *containView                         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellW, kCellH)];
    containView.layer.cornerRadius              = 5;
    containView.backgroundColor                 = kAXPMAINCOLORc17;
    containView.layer.borderColor               = kAXPLINECOLORl1.CGColor;
    containView.layer.borderWidth               = 1;


    self.iconView                               = [[UIImageView alloc] initWithFrame:CGRectMake(14, 11, 44, 44)];
    self.iconView.layer.cornerRadius            = 22;
    self.iconView.clipsToBounds                 = YES;
    self.iconView.backgroundColor               = [UIColor greenColor];
    self.iconView.layer.borderWidth             = 1.0;
    self.iconView.layer.borderColor             = [UIColor whiteColor].CGColor;

    self.nameLabel                              = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.frame.origin.x + self.iconView.frame.size.width + 15, 20, 100, 15)];
    self.nameLabel.font                         = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor                    = kAXPTEXTCOLORf9;

    self.scoreImageView                         = [[UIImageView alloc] initWithFrame:CGRectMake(220-15-49, 0, 49, 69)];
    self.scoreImageView.image                   = [UIImage imageNamed:@"score_5"];
    self.scoreImageView.hidden                  = YES;

    self.annotateLabel                          = [[UILabel alloc] initWithFrame:CGRectMake(220 - 110 - 10, 225, 110, 18)];
    self.annotateLabel.textAlignment            = NSTextAlignmentRight;
    self.annotateLabel.textColor                = kAXPTEXTCOLORf3;
    self.annotateLabel.font                     = [UIFont systemFontOfSize:12];

    self.detailWhiteboardView                   = [[UIImageView alloc] initWithFrame:CGRectMake(9, 63, 202, 158)];
    self.detailWhiteboardView.backgroundColor   = [UIColor whiteColor];
    self.detailWhiteboardView.layer.borderWidth = 1;
    self.detailWhiteboardView.layer.borderColor = kAXPLINECOLORl1.CGColor;
    
    if (kCellH - 235.0 == 0) {
    
        self.annotateLabel.hidden = YES;
    }
    
    [containView addSubview:self.iconView];
    [containView addSubview:self.nameLabel];
    [containView addSubview:self.detailWhiteboardView];
    [containView addSubview:self.scoreImageView];
    [containView addSubview:self.annotateLabel];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:containView.frame];
    shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    shadowView.layer.shadowOpacity = 0.3;
    [shadowView addSubview:containView];
    
    [self.contentView addSubview:shadowView];
}
@end
