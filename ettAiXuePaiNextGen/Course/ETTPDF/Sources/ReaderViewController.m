//
//	ReaderViewController.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//


#import "ReaderConstants.h"
#import "ReaderViewController.h"
#import "ThumbsViewController.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ReaderContentView.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbQueue.h"
#import "ETTBackToPageManager.h"
#import "AppDelegate.h"
#import "ETTSideNavigationViewController.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "AXPRedisManager.h"
#import "ETTJudgeIdentity.h"
#import "ETTCoverView.h"
#import <UIView+Toast.h>

#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTStudentCourseViewController.h"
#import "ETTCoursewarePushAnimationView.h"



#import "ETTScenePorter.h"
#import "ETTNormalGuardModel.h"

#import <MessageUI/MessageUI.h>

@interface ReaderViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate,
ReaderMainToolbarDelegate, ReaderMainPagebarDelegate, ReaderContentViewDelegate, ThumbsViewControllerDelegate, ETTCoursewarePushAnimationViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *lastTeacherCoursewareEndPushDict;

@property (assign, nonatomic) NSInteger           toPage;

@property (assign, nonatomic) NSInteger           theToPage;

@property (assign, nonatomic) NSInteger           didToPage;

@property (assign, nonatomic) NSInteger           theThumbPage;



@end

@implementation ReaderViewController
{
    /* 成员变量 */
    ReaderDocument *document;//文件
    
    UIScrollView *theScrollView;//scrollView
    
    NSMutableDictionary *contentViews;
    
    UIUserInterfaceIdiom userInterfaceIdiom;
    
    NSInteger currentPage, minimumPage, maximumPage;//当前页,最小页数,最大页数
    
    UIDocumentInteractionController *documentInteraction;
    
    UIPrintInteractionController *printInteraction;
    
    CGFloat scrollViewOutset;
    
    CGSize lastAppearSize;
    
    NSDate *lastHideTime;
    
    BOOL ignoreDidScroll;
    
    NSTimer *timer;
    
    ETTCoursewarePushAnimationView *coursewarePushAnimationView;
    
}

#pragma mark - Constants

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 44.0f
#define PAGEBAR_HEIGHT 48.0f

#define SCROLLVIEW_OUTSET_SMALL 4.0f
#define SCROLLVIEW_OUTSET_LARGE 8.0f

#define TAP_AREA_SIZE 0.0f

#pragma mark - Properties

@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
    [sideNav removePdfCoverView];
    [sideNav removeCoursewarePushAnimation];
    
    //assert(document != nil); // Must have a valid Reader5
    
    /**
     *  @author LiuChuanan, 17-03-31 16:42:57
     *  
     *  @brief 判断是否是损坏的课件
     *
     *  branch origin/bugfix/AIXUEPAIOS-1161
     *   
     *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
     * 
     *  @since 
     */
    if (document && document != nil)
    {
        if (document.pageCount && document.pageCount != nil) 
        {
            /*ReaderViewController 上面添加 contentView(继承自scrollView) */
            
            //reader 的背景色 为灰色
            self.view.backgroundColor = [UIColor orangeColor]; // Neutral gray
            
            UIView *fakeStatusBar = nil;
            
            CGRect viewRect = self.view.bounds; // View bounds
            
            NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
            
            //设置状态栏
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
            {
                if ([self prefersStatusBarHidden] == NO) // Visible status bar
                {
                    CGRect statusBarRect                 = viewRect;
                    statusBarRect.size.height            = STATUS_HEIGHT;
                    fakeStatusBar                        = [[UIView alloc] initWithFrame:statusBarRect];// UIView
                    fakeStatusBar.autoresizingMask       = UIViewAutoresizingFlexibleWidth;
                    fakeStatusBar.backgroundColor        = kC2_COLOR;
                    fakeStatusBar.contentMode            = UIViewContentModeRedraw;
                    fakeStatusBar.userInteractionEnabled = NO;
                    viewRect.origin.y                    += STATUS_HEIGHT;
                    viewRect.size.height -= STATUS_HEIGHT;
                }
            }
            
            CGRect scrollViewRect = CGRectInset(viewRect, -scrollViewOutset, 0.0f);
            
            //ReaderViewController添加一个子View theScrollView,theScrollView 上面添加的是contentView(继承自scrollView)
            theScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect]; // All theScrollview的frame已经和ReaderViewController的view一样大了
            
            theScrollView.autoresizesSubviews            = NO;
            theScrollView.contentMode                    = UIViewContentModeRedraw;
            theScrollView.showsHorizontalScrollIndicator = NO;
            theScrollView.showsVerticalScrollIndicator   = NO;
            theScrollView.scrollsToTop                   = NO;
            theScrollView.delaysContentTouches           = NO;
            theScrollView.pagingEnabled                  = YES;
            theScrollView.autoresizingMask               = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            
            theScrollView.backgroundColor                = [UIColor whiteColor];
            
            theScrollView.delegate                       = self;
            [self.view addSubview:theScrollView];
            
            //上面的工具条
            CGRect toolbarRect           = viewRect;
            toolbarRect.size.height      = TOOLBAR_HEIGHT;
            
            _mainToolbar                 = [[ReaderMainToolbar alloc] initWithFrame:toolbarRect document:document];// ReaderMainToolbar
            _mainToolbar.currentVC       = self;
            _mainToolbar.EVDelegate      = self;
            
            //中间标题传过去
            _mainToolbar.titleLabel.text = self.navigationTitle;
            _mainToolbar.navigationTitle = self.navigationTitle;
            _mainToolbar.coursewareID    = self.coursewareID;;
            _mainToolbar.coursewareUrl   = self.coursewareUrl;
            _mainToolbar.courseId = self.courseId;
            
            //颜色设置
            _mainToolbar.backgroundColor = [UIColor colorWithRed:38.0/225 green:147.0/255 blue:220.0/255 alpha:1.0];
            
            _mainToolbar.delegate = self; // ReaderMainToolbarDelegate
            if ([ETTBackToPageManager sharedManager].isPushing)
            {
                if ([ETTBackToPageManager sharedManager].isPushing && [[ETTScenePorter shareScenePorter] queryWhetherCanPushOperation:self.EVGuardModel])
                {
                    [_mainToolbar setPushButtonViewHiden:false];
                }
                else
                {
                    [_mainToolbar setPushButtonViewHiden:YES];
                }
            }
            else
            {
                [_mainToolbar setPushButtonViewHiden:false];
                
            }
            
            [self.view addSubview:_mainToolbar];
            
            //下面的工具条
            CGRect pagebarRect           = self.view.bounds;
            pagebarRect.size.height      = PAGEBAR_HEIGHT + 60;
            pagebarRect.origin.y         = (self.view.bounds.size.height - pagebarRect.size.height);
            
            _mainPagebar                 = [[ReaderMainPagebar alloc] initWithFrame:pagebarRect document:document];// ReaderMainPagebar
            _mainPagebar.delegate        = self;// ReaderMainPagebarDelegate //跳转到想去的页面
            _mainPagebar.navigationTitle = self.navigationTitle;
            _mainPagebar.coursewareID    = self.coursewareID;;
            _mainPagebar.coursewareUrl   = self.coursewareUrl;
            _mainPagebar.courseId        = self.courseId;
            [self.view addSubview:_mainPagebar];
            
            if (fakeStatusBar != nil) [self.view addSubview:fakeStatusBar]; // Add status bar background view
            
            //单击弹出工具条
            UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTapOne.numberOfTouchesRequired = 1;
            singleTapOne.numberOfTapsRequired    = 1;
            singleTapOne.delegate                = self;
            [self.view addGestureRecognizer:singleTapOne];
            
            //双击放大
            UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            doubleTapOne.numberOfTouchesRequired = 1;//手指头个数
            doubleTapOne.numberOfTapsRequired    = 2;//点击次数
            doubleTapOne.delegate                = self;
            [self.view addGestureRecognizer:doubleTapOne];
            
            UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            doubleTapTwo.numberOfTouchesRequired = 2;//手指头个数
            doubleTapTwo.numberOfTapsRequired    = 2;//点击次数
            doubleTapTwo.delegate                = self;
            [self.view addGestureRecognizer:doubleTapTwo];
            [singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
            
            contentViews                         = [NSMutableDictionary new];
            lastHideTime                         = [NSDate date];
            
            minimumPage                          = 1;
            maximumPage                          = [document.pageCount integerValue];
            
            theScrollView.minimumZoomScale       = 1.0;
            theScrollView.maximumZoomScale = 2.0;
            
            //学生重连课堂时用到
            if (!([ETTJudgeIdentity getCurrentIdentity] == ETTSideNavigationViewIdentityTeacher)) {
                
                if (self.isAgainPushCourseware == YES) {
                    self.isAgainPushCourseware = NO;
                    [self showDocumentPage:self.pushedCurrentPage];
                }
                
                if (self.isReopen == YES) {
                    self.isReopen = NO;
                    [self showDocumentPage:self.pushedCurrentPage];
                }
                
                /**
                 *  @author LiuChuanan, 17-04-17 11:42:57
                 *  
                 *  @brief 学生端收到老次结束推送命令处理
                 *
                 *  branch origin/bugfix/AIXUEPAIOS-1220
                 *   
                 *  Epic   origin/bugfix/Epic-0417-AIXUEPAIOS-1218
                 * 
                 *  @since 
                 */

                if ([[ETTBackToPageManager sharedManager].pushingVc isKindOfClass:[self class]]) {
                    self.view.userInteractionEnabled = YES;
                } else {
                    self.view.userInteractionEnabled = NO;
                }
            }
            
            //老师点击结束推送后 让_mainPagebar和_mainToolbar出现
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherPushCoursewareInfo:) name:kREDIS_COMMAND_TYPE_CO_02 object:nil];
            
            //同步音视频
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherSynchronizeVideoAudioInfo:) name:kREDIS_COMMAND_TYPE_CO_03 object:nil];
            
        } else
        {
            
        }
    }
}


- (void)studentGetTeacherSynchronizeVideoAudioInfo:(NSNotification *)notify {
    
    NSDictionary *dict = notify.object;
    NSString *type = [dict objectForKey:@"type"];
    
    if ([type isEqualToString:@"CO_03"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
            ETTSideNavigationViewController *sideNav                                        = [ETTJudgeIdentity getSideNavigationViewController];
            
            [ETTBackToPageManager sharedManager].pushingVc                                  = nil;
            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = nil;
            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware      = NO;
            [sideNav removePdfCoverView];
            [sideNav removeCoursewarePushAnimation];
            [sideNav removeSynchronizeCoverView];
            
        }];
    }
}


- (void)studentGetTeacherPushCoursewareInfo:(NSNotification *)notify {
    
    NSDictionary *dict     = notify.object;
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    NSString *CO_02_state  = [userInfo objectForKey:@"CO_02_state"];
    NSInteger currentP = [[userInfo objectForKey:@"currentPage"] integerValue];
    
    if ([CO_02_state isEqualToString:@"CO_02_state1"]) {
        self.view.userInteractionEnabled = NO;
        self.mainToolbar.hidden = YES;
        self.mainPagebar.hidden = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showDocumentPage:currentP];
        });
    }
    
    //老师与学生同步浏览
    if ([CO_02_state isEqualToString:@"CO_02_state2"]) {//老师滚动学生跟着到相应页面
        
        if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[self class]]) {
            
            NSString *theCurrentPage = [userInfo objectForKey:@"currentPage"];
            
            NSInteger toPage         = theCurrentPage.integerValue;
            
            if (toPage == self.toPage) {
                return;
            } else {
                self.toPage = toPage;
                
                [self showDocumentPage:toPage];
            }
        }
    }
    
    if ([CO_02_state isEqualToString:@"CO_02_state3"]) {//老师点击缩略图跳到相应页面
        
        if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[self class]]) {
            
            NSString *theCurrentPage = [userInfo objectForKey:@"currentPage"];
            
            NSInteger toPage         = theCurrentPage.integerValue;
            
            if (toPage == self.didToPage) {
                return;
            } else {
                self.didToPage = toPage;
                
                [self showDocumentPage:toPage + 1];
            }
        }
    }
    
    if ([CO_02_state isEqualToString:@"CO_02_state4"]) {//老师滚动学生跟着到相应页面
        
        if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[self class]]) {
            
            NSString *theCurrentPage = [userInfo objectForKey:@"currentPage"];
            
            NSInteger toPage         = theCurrentPage.integerValue;
            
            if (toPage == self.toPage) {
                return;
            } else {
                self.toPage = toPage;
                
                [self showDocumentPage:toPage];
            }
        }
    }
    
    //显示返回
    if ([CO_02_state isEqualToString:@"CO_02_state5"]) {//结束推送
        [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = YES;
        [ETTCoursewarePresentViewControllerManager sharedManager].isAgainPush = NO;
        self.isAgainPushCourseware = NO;
        ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
        
        if (sideNav.identity != ETTSideNavigationViewIdentityTeacher) {
            
            /**
             *  @author LiuChuanan, 17-04-06 19:42:57
             *  
             *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
             *
             *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
             *   
             *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
             * 
             *  @since 
             */
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window.userInteractionEnabled = YES;
            
            [_mainToolbar showToolbar]; [_mainPagebar showPagebar];
            
            NSString *endPushCurrentPage = [userInfo objectForKey:@"endPushCurrentPage"];
            
            _mainPagebar.selectIndex = endPushCurrentPage.integerValue - 1;
            
            if (endPushCurrentPage.integerValue == -1) {
                _mainPagebar.selectIndex = 0;
            }
            
            NSIndexPath *indexPath           = [NSIndexPath indexPathForItem:_mainPagebar.selectIndex inSection:0];
            
            //CollectionView滚动到当前页
            [_mainPagebar.theCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            [_mainPagebar.theCollectionView reloadData];
            
            self.view.userInteractionEnabled = YES;
            
            [self.view toast:@"推送已结束"];
            
            [sideNav removeSynchronizeCoverView];
        }
    }
}

//点击pageBar上的item滚动到相应的page
-(void)scrollToPage:(NSNotification *)notify
{
    NSArray *array = notify.object;
    NSInteger toPage = [array.lastObject integerValue];
    [self showDocumentPage:toPage + 1];
    
    if ([ETTJudgeIdentity getCurrentIdentity] == ETTSideNavigationViewIdentityTeacher) {
        
        self.mainToolbar.currentPage = toPage + 1;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToPage:) name:@"ScrollToPage" object:nil];
    if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == true)
    {
        [self performSelector:@selector(showDocument) withObject:nil afterDelay:0.0];
    }
    
    
    
#if (READER_DISABLE_IDLE == TRUE) // Option
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    lastAppearSize = self.view.bounds.size; // Track view size
    
#if (READER_DISABLE_IDLE == TRUE) // Option
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
#endif // end of READER_DISABLE_IDLE Option
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeNotify];
}
-(void)pEvenFunctionOperation:(id)object withCommandType:(NSInteger)commandType withInfo:(id)sender
{
    if ([object isKindOfClass:[ReaderMainToolbar class]])
    {
        NSDictionary * dic = sender;
        BOOL isPush = [[dic valueForKey:@"push"] boolValue];
        if (isPush)
        {
            [[ETTScenePorter shareScenePorter] enterRegistration:self.EVGuardModel];
            
        }
        else
        {
            [[ETTScenePorter shareScenePorter] cancellationRegistration:self.EVGuardModel];
        }
    }
}

- (void)viewDidUnload
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    _mainToolbar        = nil; _mainPagebar = nil;
    
    theScrollView       = nil; contentViews = nil; lastHideTime = nil;
    
    documentInteraction = nil; printInteraction = nil;
    
    lastAppearSize = CGSizeZero; currentPage = 0;
    
    [super viewDidUnload];
}


#pragma mark - ReaderViewController methods

//contentSize  设置偏移范围 最大偏移范围:长度为高度*最大页数,宽度为屏幕宽度
- (void)updateContentSize:(UIScrollView *)scrollView
{
    CGFloat contentHeight = scrollView.bounds.size.height * maximumPage;// Height 偏移的高度范围1
    
    CGFloat contentWidth  = (scrollView.bounds.size.width);//偏移的宽度范围2
    
    scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

//更新字典中的ReaderContentView
- (void)updateContentViews:(UIScrollView *)scrollView
{
    [self updateContentSize:scrollView]; // Update content size first
    
    //遍历数组,字典,集合
    //想要对字典中的每个对象发送相同的消息或是访问同样的属性,使用以下方法对字典进行遍历
    [contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
     ^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
     {
         NSInteger page    = [key integerValue];// Page number value //页码总数
         
         CGRect viewRect   = CGRectZero;
         
         viewRect.size     = scrollView.bounds.size;
         
         //更新y值
         viewRect.origin.y = (viewRect.size.height * (page - 1));// Update y 3
         
         //重新设置contentView的frame
         contentView.frame = CGRectInset(viewRect, scrollViewOutset, 0.0f);
     }
     ];
    
    NSInteger page = currentPage; // Update scroll view offset to current page  //当前页码
    
    
    CGPoint contentOffset = CGPointMake(0.0,(scrollView.bounds.size.height * (page - 1)));//滚动范围4
    
    if (CGPointEqualToPoint(scrollView.contentOffset, contentOffset) == false) // Update
    {
        scrollView.contentOffset = contentOffset; // Update content offset
    }
    
    [_mainToolbar setBookmarkState:[document.bookmarks containsIndex:page]];
    
    [_mainPagebar updatePagebar]; // Update page bar
}

//添加contentView
- (void)addContentView:(UIScrollView *)scrollView page:(NSInteger)page
{
    CGRect viewRect   = CGRectZero;
    
    viewRect.size     = scrollView.bounds.size;
    
    viewRect.origin.y = (viewRect.size.height * (page - 1));
    
    viewRect          = CGRectInset(viewRect, scrollViewOutset, 0.0f);//改动 5
    
    NSURL *fileURL    = document.fileURL;
    NSString *phrase  = document.password;
    NSString *guid = document.guid; // Document properties
    
    /* 
     初始化contentView
     */
    
    ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:page password:phrase]; // ReaderContentView
    
    contentView.message = self;
    
    //根据页码把contentView保存到字典里面
    [contentViews setObject:contentView forKey:[NSNumber numberWithInteger:page]];
    
    //contentView被添加到scrollView上面
    [scrollView addSubview:contentView];
    
    [contentView showPageThumb:fileURL page:page password:phrase guid:guid]; // Request page preview thumb
}

//重新布局ContentView
- (void)layoutContentViews:(UIScrollView *)scrollView
{
    CGFloat viewHeight     = scrollView.bounds.size.height;//view Height 6
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;//Content offset Y 7
    
    NSInteger pageB        = (contentOffsetY + viewHeight - 1.0) / viewHeight;//8
    
    NSInteger pageA = (contentOffsetY / viewHeight); pageB += 2;//9
    
    if (pageA < minimumPage) pageA = minimumPage;//10
    if (pageB > maximumPage) pageB = maximumPage;//11
    
    NSRange pageRange = NSMakeRange(pageA, (pageB - pageA + 1)); // Make page range (A to B)
    
    //存储索引区间
    NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSetWithIndexesInRange:pageRange];
    
    for (NSNumber *key in [contentViews allKeys]) // Enumerate content views
    {
        NSInteger page = [key integerValue]; // Page number value
        
        if ([pageSet containsIndex:page] == NO) // Remove content view
        {
            ReaderContentView *contentView = [contentViews objectForKey:key];
            
            [contentView removeFromSuperview];
            
            [contentViews removeObjectForKey:key];
        }
        else // Visible content view - so remove it from page set
        {
            [pageSet removeIndex:page];
        }
    }
    
    NSInteger pages = pageSet.count;
    
    if (pages > 0) // We have pages to add
    {
        NSEnumerationOptions options = 0; // Default
        
        if (pages == 2) // Handle case of only two content views
        {
            if ((maximumPage > 2) && ([pageSet lastIndex] == maximumPage)) options = NSEnumerationReverse;
        }
        else if (pages == 3) // Handle three content views - show the middle one first
        {
            NSMutableIndexSet *workSet = [pageSet mutableCopy];
            
            options = NSEnumerationReverse;
            
            [workSet removeIndex:[pageSet firstIndex]]; [workSet removeIndex:[pageSet lastIndex]];
            
            NSInteger page = [workSet firstIndex]; [pageSet removeIndex:page];
            
            [self addContentView:scrollView page:page];
        }
        
        [pageSet enumerateIndexesWithOptions:options usingBlock: // Enumerate page set
         ^(NSUInteger page, BOOL *stop)
         {
             [self addContentView:scrollView page:page];
         }
         ];
    }
}

- (void)handleScrollViewDidEnd:(UIScrollView *)scrollView
{
    CGFloat viewHeight = scrollView.bounds.size.height;//12
    CGFloat contentOffsetY = scrollView.contentOffset.y;//13
    
    NSInteger page = contentOffsetY / viewHeight; page++;//14
    NSNumber *currentPageNumber = [NSNumber numberWithInteger:page];
    
    
    //老师获得当前页
    ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
    
    if (sideNav.identity == ETTSideNavigationViewIdentityTeacher) {
        
        //获得当前页面显示的页码
        self.mainToolbar.currentPage        = page;
        self.mainPagebar.pushCurrentPage    = page;
        
        self.mainToolbar.endPushCurrentPage = page;
        
        self.mainPagebar.endPushCurrentPage = page;
        
        //如果老师这边正在推送,才将当前页码推送到学生
        if ([ETTBackToPageManager sharedManager].isPushing) {
            
            //判断老师当前打开课件是否是推送课件
            if ([[ETTBackToPageManager sharedManager].coursewareUrl isEqualToString:self.coursewareUrl]) {
                
                NSString *time           = [ETTRedisBasisManager getTime];
                NSString *theCurrentPage = [NSString stringWithFormat:@"%ld",(long)page];
                NSDictionary *userInfo   = @{@"coursewareUrl":[NSString stringWithFormat:@"%@*%@*%@",self.coursewareUrl,self.coursewareID,self.navigationTitle],
                                             @"CO_02_state":@"CO_02_state2",
                                             @"currentPage":theCurrentPage
                                             };
                
                NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                        @"to":@"ALL",
                                        @"from":[AXPUserInformation sharedInformation].jid,
                                        @"type":@"CO_02",
                                        @"userInfo":userInfo
                                        };
                
                NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
                ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
                NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];
                
                NSString *redisKey                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
                NSDictionary *theUserInfo = @{
                                              @"type":@"CO_02",
                                              @"theUserInfo":dict
                                              };
                NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
                [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
                    if (!error) {
                        if (self.theToPage == page) {
                            return;
                        } else {
                            self.theToPage = page;
                            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                                if (!error) {
                                    //ETTLog(@"成功发送消息%@",dict);
                                }else{
                                    ETTLog(@"发送消息%@失败！",dict);
                                }
                            }];
                        }
                    } else {
                        
                        ETTLog(@"老师滚动协同浏览错误原因:%@",error);
                    }
                }];
                
            }
        }
    }
    
    // 滚动结束,将当前页传递给控制栏
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowCurrentPage" object:_mainPagebar userInfo:@{@"pageNumber":currentPageNumber}];
    
    if (page != currentPage) // Only if on different page
    {
        currentPage = page; document.pageNumber = [NSNumber numberWithInteger:page];
        
        [contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
         ^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
         {
             if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
         }
         ];
        
        [_mainToolbar setBookmarkState:[document.bookmarks containsIndex:page]];
        
        [_mainPagebar updatePagebar]; // Update page bar
    }
}

- (void)showDocumentPage:(NSInteger)page
{
    if (page != currentPage) // Only if on different page
    {
        if ((page < minimumPage) || (page > maximumPage)) return;
        
        currentPage                         = page;
        
        self.mainToolbar.currentPage        = currentPage;
        self.mainToolbar.endPushCurrentPage = currentPage;
        
        document.pageNumber                 = [NSNumber numberWithInteger:page];
        
        CGPoint contentOffset = CGPointMake(0.0f,(theScrollView.bounds.size.height * (page - 1)));
        
        if (CGPointEqualToPoint(contentOffset,theScrollView.contentOffset) == true)
            [self layoutContentViews:theScrollView];
        else			[theScrollView setContentOffset:contentOffset];
        
        [contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
         ^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
         {
             if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
         }
         ];
        
        [_mainToolbar setBookmarkState:[document.bookmarks containsIndex:page]];
        
        [_mainPagebar updatePagebar]; // Update page bar
    }
}

- (void)showDocument
{
    [self updateContentSize:theScrollView]; // Update content size first
    
    [self showDocumentPage:[document.pageNumber integerValue]]; // Show page
    
    document.lastOpen = [NSDate date]; // Update document last opened date
}

- (void)closeDocument
{
    if (printInteraction != nil) [printInteraction dismissAnimated:NO];
    
    [document archiveDocumentProperties]; // Save any ReaderDocument changes
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.7  16:50
     modifier : 康晓光
     version  ：Dev-0224
     branch   ：1043
     describe : 将新疆成都老客户端xinjiangHIRedis0305 分支上代码优化move到Dev-0224上的工作任务   将这行代码注释，防止线程的操作造成问题
     */
    [[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:document.guid];
    /////////////////////////////////////////////////////
    
    
    [[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache
    
    ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
    
    //不是老师
    if (sideNav.identity != ETTSideNavigationViewIdentityTeacher) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [ETTBackToPageManager sharedManager].pushingVc                                  = nil;
            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = nil;
            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware      = NO;
            [sideNav removePdfCoverView];
            [sideNav removeCoursewarePushAnimation];
            [sideNav removeSynchronizeCoverView];
            
            
        }];
        
    } else {//是老师
        
        [[ETTScenePorter shareScenePorter] removeGurad:self.EVGuardModel];
        [self dismissViewControllerAnimated:NO completion:^{
            [sideNav removePdfCoverView];
            [sideNav removeCoursewarePushAnimation];
        }];
    }
}

-(void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScrollToPage" object:nil];
}
#pragma mark - UIViewController methods

- (instancetype)initWithReaderDocument:(ReaderDocument *)object
{
    if ((self = [super initWithNibName:nil bundle:nil])) // Initialize superclass
    {
        if ((object != nil) && ([object isKindOfClass:[ReaderDocument class]])) // Valid object
        {
            
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
                userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom; // User interface idiom
                
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter]; // Default notification center
                
                //设备即将进入后台
                [notificationCenter addObserver:self selector:@selector(applicationWillResign:) name:UIApplicationWillTerminateNotification object:nil];
                
                //设备即将进入前台
                [notificationCenter addObserver:self selector:@selector(applicationWillResign:) name:UIApplicationWillResignActiveNotification object:nil];
                
                scrollViewOutset = ((userInterfaceIdiom == UIUserInterfaceIdiomPad) ? SCROLLVIEW_OUTSET_LARGE : SCROLLVIEW_OUTSET_SMALL);
                
                [object updateDocumentProperties]; document = object; // Retain the supplied ReaderDocument object for our use
                
                [ReaderThumbCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory
            } else
            {
                
            }
        }
        else // Invalid ReaderDocument object
        {
            self = nil;
        }
    }
    
    return self;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kREDIS_COMMAND_TYPE_CO_02 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kREDIS_COMMAND_TYPE_CO_03 object:nil];
    [self removeNotify];
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (userInterfaceIdiom == UIUserInterfaceIdiomPad) if (printInteraction != nil) [printInteraction dismissAnimated:NO];
    
    ignoreDidScroll = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == false)
    {
        [self updateContentViews:theScrollView]; lastAppearSize = CGSizeZero;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    ignoreDidScroll = NO;
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate methods
//scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (ignoreDidScroll == NO) [self layoutContentViews:scrollView];//在这里调用layoutContentViews这个方法
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollViewDidEnd:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self handleScrollViewDidEnd:scrollView];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIScrollView class]]) return YES;
    
    return NO;
}

#pragma mark - UIGestureRecognizer action methods

- (void)decrementPageNumber
{
    if ((maximumPage > minimumPage) && (currentPage != minimumPage))
    {
        CGPoint contentOffset = theScrollView.contentOffset; // Offset
        
        contentOffset.x -= theScrollView.bounds.size.width; // View X--
        
        [theScrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)incrementPageNumber
{
    if ((maximumPage > minimumPage) && (currentPage != maximumPage))
    {
        CGPoint contentOffset = theScrollView.contentOffset; // Offset
        
        contentOffset.x += theScrollView.bounds.size.width; // View X++
        
        [theScrollView setContentOffset:contentOffset animated:YES];
    }
}

//
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGRect viewRect = recognizer.view.bounds; // View bounds
        
        CGPoint point = [recognizer locationInView:recognizer.view]; // Point
        
        CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area rect
        
        if (CGRectContainsPoint(areaRect, point) == true) // Single tap is inside area 单击在内部区域
        {
            NSNumber *key = [NSNumber numberWithInteger:currentPage]; // Page number key
            
            ReaderContentView *targetView = [contentViews objectForKey:key]; // View
            
            id target = [targetView processSingleTap:recognizer]; // Target object
            
            if (target != nil) // Handle the returned target object
            {
                if ([target isKindOfClass:[NSURL class]]) // Open a URL
                {
                    NSURL *url = (NSURL *)target; // Cast to a NSURL object
                    
                    if (url.scheme == nil) // Handle a missing URL scheme
                    {
                        NSString *www = url.absoluteString; // Get URL string
                        
                        if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
                        {
                            NSString *http = [[NSString alloc] initWithFormat:@"http://%@", www];
                            
                            url = [NSURL URLWithString:http]; // Proper http-based URL
                        }
                    }
                    
                    if ([[UIApplication sharedApplication] openURL:url] == NO)
                    {
#ifdef DEBUG
                        NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
#endif
                    }
                }
                else // Not a URL, so check for another possible object type
                {
                    if ([target isKindOfClass:[NSNumber class]]) // Goto page
                    {
                        NSInteger number = [target integerValue]; // Number
                        
                        [self showDocumentPage:number]; // Show the page
                    }
                }
            }
            else // Nothing active tapped in the target content view
            {
                if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
                {
                    if ((_mainToolbar.alpha < 1.0f) || (_mainPagebar.alpha < 1.0f)) // Hidden
                    {
                        [_mainToolbar showToolbar]; [_mainPagebar showPagebar]; // Show
                    }
                }
            }
            
            return;
        }
        
        CGRect nextPageRect = viewRect;
        nextPageRect.size.width = TAP_AREA_SIZE;
        nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(nextPageRect, point) == true) // page++
        {
            [self incrementPageNumber]; return;
        }
        
        CGRect prevPageRect = viewRect;
        prevPageRect.size.width = TAP_AREA_SIZE;
        
        if (CGRectContainsPoint(prevPageRect, point) == true) // page--
        {
            [self decrementPageNumber]; return;
        }
    }
}

//双击事件方法
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGRect viewRect = recognizer.view.bounds; // View bounds
        
        CGPoint point = [recognizer locationInView:recognizer.view]; // Point
        
        CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE); // Area
        
        if (CGRectContainsPoint(zoomArea, point) == true) // Double tap is inside zoom area
        {
            NSNumber *key = [NSNumber numberWithInteger:currentPage]; // Page number key
            
            ReaderContentView *targetView = [contentViews objectForKey:key]; // View
            
            switch (recognizer.numberOfTouchesRequired) // Touches count
            {
                case 1: // One finger double tap: zoom++ 一个手指双击
                {
                    
                    [targetView zoomIncrement:recognizer];
                    
                    
                    break;
                }
                    
                case 2: // Two finger double tap: zoom--
                {
                    [targetView zoomDecrement:recognizer];
                    
                    break;
                }
            }
            
            return;
        }
        
        //下一页  双击右边48范围内
        CGRect nextPageRect = viewRect;
        nextPageRect.size.width = TAP_AREA_SIZE;
        nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(nextPageRect, point) == true) // page++
        {
            [self incrementPageNumber]; return;
        }
        
        //上一页  双击左边48范围内
        CGRect prevPageRect = viewRect;
        prevPageRect.size.width = TAP_AREA_SIZE;
        
        if (CGRectContainsPoint(prevPageRect, point) == true) // page--
        {
            [self decrementPageNumber]; return;
        }
    }
}

#pragma mark - ReaderContentViewDelegate methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
    if ((_mainToolbar.alpha > 0.0f) || (_mainPagebar.alpha > 0.0f))
    {
        if (touches.count == 1) // Single touches only
        {
            UITouch *touch = [touches anyObject]; // Touch info
            
            CGPoint point = [touch locationInView:self.view]; // Touch location
            
            CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);
            
            if (CGRectContainsPoint(areaRect, point) == false) return;
        }
        
        [_mainToolbar hideToolbar];
        
        [_mainPagebar hidePagebar]; // Hide
        
        lastHideTime = [NSDate date]; // Set last hide time
    }
}

#pragma mark - ReaderMainToolbarDelegate methods

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
{
#if (READER_STANDALONE == FALSE) // Option
    
    [self closeDocument]; // Close ReaderViewController
    
#endif // end of READER_STANDALONE Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button
{
#if (READER_ENABLE_THUMBS == TRUE) // Option
    
    ThumbsViewController *thumbsViewController = [[ThumbsViewController alloc] initWithReaderDocument:document];
    
    thumbsViewController.navigationTitle = self.navigationTitle;
    
    thumbsViewController.delegate = self; // ThumbsViewControllerDelegate
    
    thumbsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    thumbsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [ETTCoursewarePresentViewControllerManager sharedManager].thumViewController = thumbsViewController;
    
    [self presentViewController:thumbsViewController animated:YES completion:NULL];
    
#endif // end of READER_ENABLE_THUMBS Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar exportButton:(UIButton *)button
{
    if (printInteraction != nil) [printInteraction dismissAnimated:YES];
    
    NSURL *fileURL = document.fileURL; // Document file URL
    
    documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    
    documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
    
    [documentInteraction presentOpenInMenuFromRect:button.bounds inView:button animated:YES];
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button
{
    if ([UIPrintInteractionController isPrintingAvailable] == YES)
    {
        NSURL *fileURL = document.fileURL; // Document file URL
        
        if ([UIPrintInteractionController canPrintURL:fileURL] == YES)
        {
            printInteraction = [UIPrintInteractionController sharedPrintController];
            
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = document.fileName;
            
            printInteraction.printInfo = printInfo;
            printInteraction.printingItem = fileURL;
            printInteraction.showsPageRange = YES;
            
            if (userInterfaceIdiom == UIUserInterfaceIdiomPad) // Large device printing
            {
                [printInteraction presentFromRect:button.bounds inView:button animated:YES completionHandler:
                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
#ifdef DEBUG
                     if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
#endif
                 }
                 ];
            }
            else // Handle printing on small device
            {
                [printInteraction presentAnimated:YES completionHandler:
                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
#ifdef DEBUG
                     if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
#endif
                 }
                 ];
            }
        }
    }
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button
{
    if ([MFMailComposeViewController canSendMail] == NO) return;
    
    if (printInteraction != nil) [printInteraction dismissAnimated:YES];
    
    unsigned long long fileSize = [document.fileSize unsignedLongLongValue];
    
    if (fileSize < 15728640ull) // Check attachment size limit (15MB)
    {
        NSURL *fileURL = document.fileURL; NSString *fileName = document.fileName;
        
        NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
        
        if (attachment != nil) // Ensure that we have valid document file attachment data available
        {
            MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
            
            [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
            
            [mailComposer setSubject:fileName]; // Use the document file name for the subject
            
            mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
            
            mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate
            
            [self presentViewController:mailComposer animated:YES completion:NULL];
        }
    }
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button
{
#if (READER_BOOKMARKS == TRUE) // Option
    
    if (printInteraction != nil) [printInteraction dismissAnimated:YES];
    
    if ([document.bookmarks containsIndex:currentPage]) // Remove bookmark
    {
        [document.bookmarks removeIndex:currentPage]; [_mainToolbar setBookmarkState:NO];
    }
    else // Add the bookmarked page number to the bookmark index set
    {
        [document.bookmarks addIndex:currentPage]; [_mainToolbar setBookmarkState:YES];
    }
    
#endif // end of READER_BOOKMARKS Option
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    documentInteraction = nil;
}

#pragma mark - ThumbsViewControllerDelegate methods

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
{
#if (READER_ENABLE_THUMBS == TRUE) // Option
    
    [self showDocumentPage:page];
    
    //老师获得当前页
    ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
    
    if (sideNav.identity == ETTSideNavigationViewIdentityTeacher) {
        
        //如果老师这边正在推送,才将当前页码推送到学生
        if ([ETTBackToPageManager sharedManager].isPushing) {
            NSString *time           = [ETTRedisBasisManager getTime];
            NSString *theCurrentPage = [NSString stringWithFormat:@"%ld",(long)page];
            NSDictionary *userInfo = @{@"coursewareUrl":[NSString stringWithFormat:@"%@*%@*%@",self.coursewareUrl,self.coursewareID,self.navigationTitle],
                                       @"CO_02_state":@"CO_02_state4",
                                       @"currentPage":theCurrentPage
                                       };
            
            NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                    @"to":@"ALL",
                                    @"from":[AXPUserInformation sharedInformation].jid,
                                    @"type":@"CO_02",
                                    @"userInfo":userInfo
                                    };
            
            NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
            NSDictionary *theUserInfo = @{@"type":@"CO_02",
                                          @"theUserInfo":dict
                                          };
            NSString *theUserInfoJson          = [ETTRedisBasisManager getJSONWithDictionary:theUserInfo];
            
            NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
            ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
            NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
            
            [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
                if (!error) {
                    
                    if (self.theThumbPage == page) {
                        return;
                    } else {
                        self.theThumbPage = page;
                        [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                            if (!error) {
                                //ETTLog(@"成功发送消息%@",dict);
                            }else{
                                ETTLog(@"发送消息%@失败！",dict);
                            }
                        }];
                    }
                    
                }else {
                    ETTLog(@"课件滚动协同浏览错误原因:%@",error);
                }
            }];
        }
    }
    
    
#endif // end of READER_ENABLE_THUMBS Option
}

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
{
#if (READER_ENABLE_THUMBS == TRUE) // Option
    
    [self dismissViewControllerAnimated:NO completion:NULL];
    
#endif // end of READER_ENABLE_THUMBS Option
}

#pragma mark - ReaderMainPagebarDelegate methods

- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page
{
    [self showDocumentPage:page];
}

#pragma mark - UIApplication notification methods

- (void)applicationWillResign:(NSNotification *)notification
{
    //归档
    [document archiveDocumentProperties]; // Save any ReaderDocument changes
    
    if (userInterfaceIdiom == UIUserInterfaceIdiomPad) if (printInteraction != nil) [printInteraction dismissAnimated:NO];
}

#pragma mark -点击推送按钮弹出浮层
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar pushButton:(UIButton *)button {
    
    coursewarePushAnimationView = [[ETTCoursewarePushAnimationView alloc]initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44) andTitle:@"正在同步中..." andAnimationTime:4];
    coursewarePushAnimationView.backgroundColor = [UIColor whiteColor];
    coursewarePushAnimationView.delegate = self;
    [self.view addSubview:coursewarePushAnimationView];
}

#pragma mark coursewarePushAnimationViewDelegate
- (void)removeCoursewarePushAnimationView {
    [coursewarePushAnimationView removeFromSuperview];
}

-(void)performTask:(id<ETTCommandInterface>)commond
{
    if (_mainToolbar)
    {
        [_mainToolbar performTask:commond];
    }
}
@end
