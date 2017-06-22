//
//	ReaderMainPagebar.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-09-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//


/*
 
 下边的预览bar
 
 */

#import "ReaderConstants.h"
#import "ReaderMainPagebar.h"
#import "ReaderThumbCache.h"
#import "ReaderDocument.h"
#import "PDFCollectionViewCell.h"
#import "ReaderContentView.h"
#import "ReaderThumbView.h"
#import "ReaderContentPage.h"
#import <QuartzCore/QuartzCore.h>
#import "ETTSideNavigationViewController.h"
#import "ETTJudgeIdentity.h"
#import "ETTJSonStringDictionaryTransformation.h"

@interface ReaderMainPagebar () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NSMutableArray      *array;

@property (nonatomic ,strong) NSMutableDictionary *images;

@property (nonatomic ,assign) NSInteger           theToPage;

@property (assign, nonatomic) NSInteger           currentPage;

@end

/**
 增加一个字段记住本次推送的课件url,用于老师点击返回了又打开了其它课件做比较
 */

@implementation ReaderMainPagebar
{
    ReaderDocument *document;
    
    ReaderTrackControl *trackControl;
    
    NSMutableDictionary *miniThumbViews;
    
    ReaderPagebarThumb *pageThumbView;//缩略图
    
    UILabel *pageNumberLabel;
    
    UIView *pageNumberView;
    
    NSTimer *enableTimer;
    NSTimer *trackTimer;
    
    
}

-(NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

-(NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

#pragma mark - Constants

#define THUMB_SMALL_GAP 2
#define THUMB_SMALL_WIDTH 22
#define THUMB_SMALL_HEIGHT 28

#define THUMB_LARGE_WIDTH 32
#define THUMB_LARGE_HEIGHT 42

#define PAGE_NUMBER_WIDTH 80.0f  //显示页码的宽度
#define PAGE_NUMBER_HEIGHT 80.0f

#define PAGE_NUMBER_SPACE_SMALL 16.0f
#define PAGE_NUMBER_SPACE_LARGE 32.0f

#define SHADOW_HEIGHT 4.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - ReaderMainPagebar class methods

+ (Class)layerClass
{
#if (READER_FLAT_UI == FALSE) // Option
    return [CAGradientLayer class];
#else
    return [CALayer class];
#endif // end of READER_FLAT_UI Option
}

#pragma mark - ReaderMainPagebar instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame document:nil];
}

- (void)updatePageThumbView:(NSInteger)page
{
    //pdf总页数
    NSInteger pages = [document.pageCount integerValue];
    
    
    if (pages > 1) // Only update frame if more than one page
    {
        CGFloat controlWidth = trackControl.bounds.size.width;
        
        CGFloat useableWidth = (controlWidth - THUMB_LARGE_WIDTH);
        
        CGFloat stride       = (useableWidth / (pages - 1));// Page stride
        
        NSInteger X          = (stride * (page - 1));
        
        CGFloat pageThumbX   = X;
        
        CGRect pageThumbRect = pageThumbView.frame;// Current frame
        
        if (pageThumbX != pageThumbRect.origin.x) // Only if different
        {
            pageThumbRect.origin.x = pageThumbX;// The new X position
            
            pageThumbView.frame = pageThumbRect; // Update the frame
        }
    }
    
    if (page != pageThumbView.tag) // Only if page number changed
    {
        pageThumbView.tag           = page;
        
        [pageThumbView reuse]; // Reuse the thumb view  重用缩略图
        
        CGSize size                 = CGSizeMake(THUMB_LARGE_WIDTH, THUMB_LARGE_HEIGHT);// Maximum thumb size
        
        NSURL *fileURL              = document.fileURL;
        
        NSString *guid              = document.guid;
        
        NSString *phrase            = document.password;
        
        ReaderThumbRequest *request = [ReaderThumbRequest newForView:pageThumbView fileURL:fileURL password:phrase guid:guid page:page size:size];
        
        UIImage *image              = [[ReaderThumbCache sharedInstance] thumbRequest:request priority:YES];// Request the thumb
        
        UIImage *thumb              = ([image isKindOfClass:[UIImage class]] ? image : nil); [pageThumbView showImage:thumb];
    }
}


//更新当前页码
- (void)updatePageNumberText:(NSInteger)page
{
    if (page != pageNumberLabel.tag) // Only if page number changed
    {
        NSInteger pages = [document.pageCount integerValue]; // Total pages
        
        NSString *format = NSLocalizedString(@"%i of %i", @"format"); // Format
        
        NSString *number = [[NSString alloc] initWithFormat:format, (int)page, (int)pages];
        
        pageNumberLabel.text = number; // Update the page number label text
        
        pageNumberLabel.tag = page; // Update the last page number tag
        
    }
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)object
{
    assert(object != nil); // Must have a valid ReaderDocument
    /**
     *  @author LiuChuanan, 17-03-31 17:22:57
     *  
     *  @brief 判断是否是损坏的课件
     *
     *  branch origin/bugfix/AIXUEPAIOS-1161
     *   
     *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
     * 
     *  @since 
     */
    if (object.pageCount && object.pageCount != nil) 
    {
        
        if (self = [super initWithFrame:frame]) {
            self.backgroundColor = [UIColor clearColor];
            document                               = object;
            
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
            flowLayout.sectionInset                = UIEdgeInsetsMake(0, 20, 0, 20);
            flowLayout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
            
            _theCollectionView                     = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
            
            _theCollectionView.delegate            = self;
            _theCollectionView.dataSource          = self;
            
            [_theCollectionView registerClass:[PDFCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
            
            _theCollectionView.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:_theCollectionView];
            
            [self addDataSourceWithStartIndex:0 range:20];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCurrentPageWithNotify:) name:@"ShowCurrentPage" object:nil];
            
            CGFloat space   = (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? PAGE_NUMBER_SPACE_LARGE : PAGE_NUMBER_SPACE_SMALL);
            CGFloat numberY = (0.0f - (PAGE_NUMBER_HEIGHT + space)); CGFloat numberX = ((self.bounds.size.width - PAGE_NUMBER_WIDTH) * 0.5f);
            CGRect numberRect = CGRectMake(numberX, numberY, PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
            
            ETTLog(@"%@",NSStringFromCGRect(numberRect));
            
            ETTLog(@"%f",self.bounds.size.width);
            
            //显示当前页码的,需要的时候在打开
            pageNumberView = [[UIView alloc] initWithFrame:numberRect]; // Page numbers view
            
            pageNumberView.autoresizesSubviews = NO;
            pageNumberView.userInteractionEnabled = NO;
            pageNumberView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            CGRect textRect = CGRectInset(pageNumberView.bounds, 4.0f, 2.0f); // Inset the text a bit
            
            pageNumberLabel                           = [[UILabel alloc] initWithFrame:textRect];// Page numbers label
            
            pageNumberLabel.autoresizesSubviews       = NO;
            pageNumberLabel.autoresizingMask          = UIViewAutoresizingNone;
            pageNumberLabel.textAlignment             = NSTextAlignmentCenter;
            pageNumberLabel.backgroundColor           = [UIColor colorWithRed:38.0/225 green:147.0/255 blue:220.0/255 alpha:1.0];
            pageNumberLabel.textColor                 = [UIColor whiteColor];
            
            pageNumberLabel.font                      = [UIFont systemFontOfSize:16.0f];
            pageNumberLabel.shadowOffset              = CGSizeMake(0.0f, 1.0f);
            pageNumberLabel.adjustsFontSizeToFitWidth = YES;
            pageNumberLabel.minimumScaleFactor = 0.75f;
            
            [pageNumberView addSubview:pageNumberLabel]; // Add label view
            
            //[self addSubview:pageNumberView]; // Add page numbers display view
            
            self.selectIndex = document.pageNumber.integerValue - 1;
            self.currentPage = document.pageNumber.integerValue;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
            
            ETTLog(@"self.selectIndex: %ld, self.currentPage: %ld, document.pageNumber.integerValue :%ld",self.selectIndex,self.currentPage,document.pageNumber.integerValue);
            
            //初始化的时候
            //CollectionView滚动到当前页
            [_theCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickTopThumbnailPage:) name:@"clickTopThumbnailPage" object:nil];
        }
        
        return self;
    } else
    {
        return nil;
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"clickTopThumbnailPage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//点击了顶部缩略图collectionview滚动当当前页
- (void)clickTopThumbnailPage:(NSNotification *)notify {
    NSString *page         = notify.object;
    
    self.selectIndex       = page.integerValue - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
    
    //CollectionView滚动到当前页
    [_theCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [_theCollectionView reloadData];
    
}

-(void)showCurrentPageWithNotify:(NSNotification *)notify
{   
    if (notify.object!= self)
    {
        
        return;
    }
    NSNumber *number = [notify.userInfo objectForKey:@"pageNumber"];
    
    
    NSInteger currentPage = number.integerValue;
    
    if (self.currentPage != currentPage) {
        
        self.currentPage = currentPage;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentPage - 1 inSection:0];
        
        //CollectionView滚动到当前页
        [_theCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.selectIndex = indexPath.item;
        [_theCollectionView reloadData];
        
    }
}


-(void)addDataSourceWithStartIndex:(NSInteger)startIndex range:(NSInteger)range
{
    NSURL *fileURL = document.fileURL;
    NSString *phrase = document.password;
    
    for (NSInteger i = startIndex; i < startIndex+range; i++) {
        
        ReaderContentPage *reader = [[ReaderContentPage alloc] initWithURL:fileURL page:i password:phrase];
        UIImage *image  = [self getImageFromView:reader];
        [self.array addObject:image];
    }
    
    [_theCollectionView reloadData];
    
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *data   = UIImageJPEGRepresentation(image, 0.2);
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:data];
}

- (void)removeFromSuperview
{
    [trackTimer invalidate];
    
    [enableTimer invalidate];
    
    [super removeFromSuperview];
}

NSMutableArray *array;
static NSString * const reuseIdentifier = @"cell";

#pragma mark - collectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return document.pageCount.integerValue;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.pageNumb.text          = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    cell.label.hidden           = YES;
    
    ReaderThumbRequest *request = [ReaderThumbRequest newForView:cell.readerPagerThumb fileURL:document.fileURL password:document.password guid:document.guid page:indexPath.item+1 size:CGSizeMake(70, 90)];
    
    UIImage *image = [[ReaderThumbCache sharedInstance] thumbRequest:request priority:YES]; // Request the page thumb
    
    if ([image isKindOfClass:[UIImage class]]) {
        
        [cell.readerPagerThumb showImage:image];
        
    }else
    {
        cell.label.hidden = NO;
    }
    
    if (self.selectIndex == indexPath.item) {
        cell.pageNumb.textColor = kC2_COLOR;
        cell.imageView.backgroundColor = kC2_COLOR;
    }
    
    return cell;
    
}

#pragma mark - collectionViewDelegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(95, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger toPage               = indexPath.item;
    NSInteger fromPage             = self.currentPage;
    
    NSArray *array                 = [NSArray arrayWithObjects:[NSNumber numberWithInteger:fromPage],[NSNumber numberWithInteger:toPage], nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToPage" object:array];
    
    PDFCollectionViewCell *cell    = (PDFCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.pageNumb.textColor        = kC2_COLOR;
    cell.imageView.backgroundColor = kC2_COLOR;
    self.selectIndex               = indexPath.item;
    [collectionView reloadData];
    
    //老师获得当前页
    ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
    
    if (sideNav.identity == ETTSideNavigationViewIdentityTeacher) {
        
        if ([ETTBackToPageManager sharedManager].isPushing) {
            
            //比较老师当前打开的课件是否是推送课件
            if ([[ETTBackToPageManager sharedManager].coursewareUrl isEqualToString:self.coursewareUrl]) {
                
                NSString *time           = [ETTRedisBasisManager getTime];
                NSString *theCurrentPage = [NSString stringWithFormat:@"%ld",(long)toPage];
                NSDictionary *userInfo   = @{@"coursewareUrl":[NSString stringWithFormat:@"%@*%@*%@",self.coursewareUrl,self.coursewareID,self.navigationTitle],
                                             @"CO_02_state":@"CO_02_state3",
                                             @"currentPage":theCurrentPage
                                             };
                
                NSDictionary  *dict                = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                                       @"to":@"ALL",
                                                       @"from":[AXPUserInformation sharedInformation].jid,
                                                       @"type":@"CO_02",
                                                       @"userInfo":userInfo
                                                       };
                
                NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
                ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
                NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
                
                NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
                NSDictionary *theUserInfo = @{
                                              @"type":@"CO_02",
                                              @"theUserInfo":dict
                                              };
                NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
                [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
                    if (!error) {
                        if (self.theToPage == toPage) {
                            return;
                        } else {
                            self.theToPage = toPage;
                            
                            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                                if (!error) {
                                    //ETTLog(@"成功发送消息%@",dict);
                                }else{
                                    ETTLog(@"发送消息%@失败！",dict);
                                }
                            }];
                        }
                    } else {
                        ETTLog(@"老师点击下面缩略图协同浏览错误原因:%@",error);
                        
                    }
                }];
                
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    PDFCollectionViewCell *cell = (PDFCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.pageNumb.textColor     = [UIColor blackColor];
    cell.imageView.backgroundColor = [UIColor whiteColor];
}


- (void)updatePagebarViews
{
    NSInteger page = [document.pageNumber integerValue]; // #
    [self updatePageNumberText:page]; // Update page number text
    
    [self updatePageThumbView:page]; // Update page thumb view
}

- (void)updatePagebar
{
    if (self.hidden == NO) // Only if visible
    {
        [self updatePagebarViews]; // Update views
    }
}

- (void)hidePagebar
{
    if (self.hidden == NO) // Only if visible
    {
        [UIView animateWithDuration:0.5 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
    }
}

- (void)showPagebar
{
    if (self.hidden == YES) // Only if hidden
    {
        [self updatePagebarViews]; // Update views first
        
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
    }
}

#pragma mark - ReaderTrackControl action methods

- (void)trackTimerFired:(NSTimer *)timer
{
    [trackTimer invalidate]; trackTimer = nil; // Cleanup timer
    
    if (trackControl.tag != [document.pageNumber integerValue]) // Only if different
    {
        [delegate pagebar:self gotoPage:trackControl.tag]; // Go to document page
    }
}

- (void)enableTimerFired:(NSTimer *)timer
{
    [enableTimer invalidate]; enableTimer = nil; // Cleanup timer
    
    trackControl.userInteractionEnabled = YES; // Enable track control interaction
}

- (void)restartTrackTimer
{
    if (trackTimer != nil) { [trackTimer invalidate]; trackTimer = nil; } // Invalidate and release previous timer
    
    trackTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(trackTimerFired:) userInfo:nil repeats:NO];
}

- (void)startEnableTimer
{
    if (enableTimer != nil) { [enableTimer invalidate]; enableTimer = nil; } // Invalidate and release previous timer
    
    enableTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(enableTimerFired:) userInfo:nil repeats:NO];
}

- (NSInteger)trackViewPageNumber:(ReaderTrackControl *)trackView
{
    CGFloat controlWidth = trackView.bounds.size.width; // View width
    
    CGFloat stride = (controlWidth / [document.pageCount integerValue]);
    
    NSInteger page = (trackView.value / stride); // Integer page number
    
    return (page + 1); // + 1
}

- (void)trackViewTouchDown:(ReaderTrackControl *)trackView
{
    NSInteger page = [self trackViewPageNumber:trackView]; // Page
    
    if (page != [document.pageNumber integerValue]) // Only if different
    {
        [self updatePageNumberText:page]; // Update page number text
        
        [self updatePageThumbView:page]; // Update page thumb view
        
        [self restartTrackTimer]; // Start the track timer
    }
    
    trackView.tag = page; // Start page tracking
}

- (void)trackViewValueChanged:(ReaderTrackControl *)trackView
{
    NSInteger page = [self trackViewPageNumber:trackView]; // Page
    
    if (page != trackView.tag) // Only if the page number has changed
    {
        [self updatePageNumberText:page]; // Update page number text
        
        [self updatePageThumbView:page]; // Update page thumb view
        
        trackView.tag = page; // Update the page tracking tag
        
        [self restartTrackTimer]; // Restart the track timer
    }
}

- (void)trackViewTouchUp:(ReaderTrackControl *)trackView
{
    [trackTimer invalidate]; trackTimer = nil; // Cleanup
    
    if (trackView.tag != [document.pageNumber integerValue]) // Only if different
    {
        trackView.userInteractionEnabled = NO; // Disable track control interaction
        
        [delegate pagebar:self gotoPage:trackView.tag]; // Go to document page
        
        [self startEnableTimer]; // Start track control enable timer
    }
    
    trackView.tag = 0; // Reset page tracking
}

@end

#pragma mark -

//
//	ReaderTrackControl class implementation
//

@implementation ReaderTrackControl
{
    CGFloat _value;
}

#pragma mark - Properties

@synthesize value = _value;

#pragma mark - ReaderTrackControl instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {   
        self.autoresizesSubviews    = NO;
        self.userInteractionEnabled = YES;
        self.contentMode            = UIViewContentModeRedraw;
        self.autoresizingMask       = UIViewAutoresizingNone;
        self.backgroundColor        = [UIColor clearColor];
        self.exclusiveTouch = YES;
    }
    
    return self;
}

- (CGFloat)limitValue:(CGFloat)valueX
{
    CGFloat minX = self.bounds.origin.x; // 0.0f;
    CGFloat maxX = (self.bounds.size.width - 1.0f);
    
    if (valueX < minX) valueX = minX;// Minimum X
    if (valueX > maxX) valueX = maxX; // Maximum X
    
    return valueX;
}

#pragma mark - UIControl subclass methods

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self]; // Touch point
    
    _value = [self limitValue:point.x]; // Limit control value
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.touchInside == YES) // Only if inside the control
    {
        CGPoint point = [touch locationInView:touch.view]; // Touch point
        
        CGFloat x = [self limitValue:point.x]; // Potential new control value
        
        if (x != _value) // Only if the new value has changed since the last time
        {
            _value = x; [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];// Touch point
    
    _value = [self limitValue:point.x]; // Limit control value
}

@end

#pragma mark -

//
//	ReaderPagebarThumb class implementation
//

@implementation ReaderPagebarThumb

#pragma mark - ReaderPagebarThumb instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame small:NO];
}

- (instancetype)initWithFrame:(CGRect)frame small:(BOOL)small
{
    
    
    if ((self = [super initWithFrame:frame])) // Superclass init
    {
        CGFloat value = (small ? 0.6f : 0.7f); // Size based alpha value
        
        UIColor *background = [UIColor colorWithWhite:0.8f alpha:value];
        
        self.backgroundColor = background;
        
        imageView.backgroundColor = background;
        
        imageView.layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.6f].CGColor;
        
        imageView.layer.borderWidth = 1.0f; // Give the thumb image view a border
    }
    
    return self;
}

@end

#pragma mark -

//
//	ReaderPagebarShadow class implementation
//

@implementation ReaderPagebarShadow

#pragma mark - ReaderPagebarShadow class methods

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

#pragma mark - ReaderPagebarShadow instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.autoresizesSubviews    = NO;
        self.userInteractionEnabled = NO;
        self.contentMode            = UIViewContentModeRedraw;
        self.autoresizingMask       = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor        = [UIColor clearColor];
        
        CAGradientLayer *layer      = (CAGradientLayer *)self.layer;
        UIColor *blackColor         = [UIColor colorWithWhite:0.42f alpha:1.0f];
        UIColor *clearColor         = [UIColor colorWithWhite:0.42f alpha:0.0f];
        layer.colors = [NSArray arrayWithObjects:(id)clearColor.CGColor, (id)blackColor.CGColor, nil];
    }
    
    return self;
}



@end
