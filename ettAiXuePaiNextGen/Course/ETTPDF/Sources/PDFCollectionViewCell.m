//
//  CollectionViewCell.m
//  Reader
//
//  Created by Liu Chuanan on 16/8/31.
//
//

#import "PDFCollectionViewCell.h"



@implementation PDFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        CGRect rect = CGRectMake(0, 5, 70, 90);
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = rect;
        
        _readerPagerThumb = [[ReaderPagebarThumb alloc] initWithFrame:CGRectMake(1.5, 1.5, 67, 87) small:YES];
        
        _readerPagerThumb.backgroundColor = [UIColor whiteColor];
        
        [_imageView addSubview:_readerPagerThumb];
        
        _imageView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_imageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLabel) name:@"hiddenLabel" object:nil];
        
        
        _pageNumb = [[UILabel alloc]initWithFrame:CGRectMake(70, self.bounds.size.height - 25, 25, 30)];
        _pageNumb.textAlignment = NSTextAlignmentLeft;
        _pageNumb.font = [UIFont systemFontOfSize:12.0];
        _pageNumb.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.contentView addSubview:_pageNumb];
        
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.pageNumb.textColor = [UIColor blackColor];
    self.imageView.backgroundColor = [UIColor whiteColor];

}

-(void)hiddenLabel
{
    self.label.hidden = YES;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

@end
