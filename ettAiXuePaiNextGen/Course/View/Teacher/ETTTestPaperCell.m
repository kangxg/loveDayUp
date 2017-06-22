//
//  ETTExaminationPaperCell.m
//  ettAiXuePaiNextGen
/**
 主客观题数量超过1000显示1k,注意这里需要设置
 */
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTestPaperCell.h"

@implementation ETTTestPaperCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutSubview];
}

- (void)setupSubview {
    
    //cell背景
    _backgroundImageView = [[UIImageView alloc]init];
    _backgroundImageView.image = [UIImage imageNamed:@"textlist_bg"];
    _backgroundImageView.layer.cornerRadius = YES;
    _backgroundImageView.clipsToBounds = 25;
    _backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backgroundImageView];
    
    //试卷标题
    _testPaperNameLabel = [[UILabel alloc]init];
    _testPaperNameLabel.font = [UIFont systemFontOfSize:15.0];
    _testPaperNameLabel.textColor = [UIColor colorWithRed:(55) / 255.0 green:(55) / 255.0 blue:(55) / 255.0 alpha:1.0];
    _testPaperNameLabel.numberOfLines = 2;
    [_backgroundImageView addSubview:_testPaperNameLabel];
    
    //主观题按钮
    _subjectiveItemNumButton = [[UIButton alloc]init];
    _subjectiveItemNumButton.userInteractionEnabled = NO;
    [_subjectiveItemNumButton setTitle:@"主观题（999）" forState:UIControlStateNormal];
    [_subjectiveItemNumButton setTitleColor:kF2_COLOR forState:UIControlStateNormal];
    [_subjectiveItemNumButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    _subjectiveItemNumButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _subjectiveItemNumButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_backgroundImageView addSubview:_subjectiveItemNumButton];
    
    //客观题
    _objectiveItemNumButton = [[UIButton alloc]init];
    _objectiveItemNumButton.userInteractionEnabled = NO;
    [_objectiveItemNumButton setTitle:@"客观题（999）" forState:UIControlStateNormal];
    [_objectiveItemNumButton setTitleColor:kF2_COLOR forState:UIControlStateNormal];
    [_objectiveItemNumButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    _objectiveItemNumButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _objectiveItemNumButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_backgroundImageView addSubview:_objectiveItemNumButton];
    
    
}

- (void)layoutSubview {
    
    _backgroundImageView.frame = self.contentView.frame;
    
    //试卷标题
    CGFloat testPaperNameLabelX = (35.000 / 220) * _backgroundImageView.width;
    CGFloat testPaperNameLabelY = (38.000 / 166) * _backgroundImageView.height;
    CGFloat testPaperNameLabelWidth = (_backgroundImageView.width - testPaperNameLabelX * 2);
    CGFloat testPaperNameLabelHeight = (50.000 / 166) * _backgroundImageView.height;
    _testPaperNameLabel.frame = CGRectMake(testPaperNameLabelX, testPaperNameLabelY, testPaperNameLabelWidth, testPaperNameLabelHeight);
    
    //主观题
    CGFloat subjectiveItemNumButtonX = (16.000 / 220) * _backgroundImageView.width;
    CGFloat subjectiveItemNumButtonY = ((124.000) / 166) * _backgroundImageView.height;
    CGFloat subjectiveItemNumButtonWidth = (85.000 / 220) * _backgroundImageView.width;
    CGFloat subjectiveItemNumButtonHeight = (42.000 / 166) * _backgroundImageView.height;
    _subjectiveItemNumButton.frame = CGRectMake(subjectiveItemNumButtonX, subjectiveItemNumButtonY, subjectiveItemNumButtonWidth, subjectiveItemNumButtonHeight);
    
    //客观题
    CGFloat objectiveItemNumButtonWidth = (85.000 / 220) * _backgroundImageView.width;
    CGFloat objectiveItemNumButtonHeight = (42.000 / 166) * _backgroundImageView.height;
    CGFloat objectiveItemNumButtonX = _backgroundImageView.width - objectiveItemNumButtonWidth - ((16.000 / 220) * _backgroundImageView.width);
    CGFloat objectiveItemNumButtonY = ((124.000) / 166) * _backgroundImageView.height;
    _objectiveItemNumButton.frame = CGRectMake(objectiveItemNumButtonX, objectiveItemNumButtonY, objectiveItemNumButtonWidth, objectiveItemNumButtonHeight);
}

- (void)setTestPaperModel:(TestPaperModel *)testPaperModel {
    
    _testPaperModel = testPaperModel;
    
    NSMutableAttributedString *testPaperName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_testPaperModel.testPaperName]];
    [testPaperName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(55) / 255.0 green:(55) / 255.0 blue:(55) / 255.0 alpha:1.0] range:NSMakeRange(0, testPaperName.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 10.0;
    [testPaperName addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, testPaperName.length)];
    
    _testPaperNameLabel.attributedText = testPaperName;
    _testPaperNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [_subjectiveItemNumButton setTitle:[NSString stringWithFormat:@"主观题（%ld）",_testPaperModel.subjectiveItemNum] forState:UIControlStateNormal];
    [_objectiveItemNumButton setTitle:[NSString stringWithFormat:@"客观题（%ld）",_testPaperModel.objectiveItemNum] forState:UIControlStateNormal];
    
}


@end
