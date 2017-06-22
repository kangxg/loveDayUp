//
//	ReaderContentPage.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
/*
 document = MyGetPDFDocumentRef (filename);                                   // 1 创建PDFDocument对象
 page = CGPDFDocumentGetPage (document, pageNumber);                          // 2 获取指定页的PDF文档
 CGContextDrawPDFPage (myContext, page);                                      // 3 将PDF绘制到图形上下文中
 CGPDFDocumentRelease (document);
 CGPDFPageGetDrawingTransform()                                               // 4 为PDF页创建一个转换
 
 */
//

#import "ReaderConstants.h"
#import "ReaderContentPage.h"
#import "ReaderContentTile.h"
#import "CGPDFDocument.h"
#import "ETTJudgeIdentity.h"
#import "AppDelegate.h"

@implementation ReaderContentPage
{
    NSMutableArray *_links;
    
    CGPDFDocumentRef _PDFDocRef;
    
    CGPDFPageRef _PDFPageRef;
    
    NSInteger _pageAngle;
    
    CGFloat _pageWidth;
    CGFloat _pageHeight;
    
    CGFloat _pageOffsetX;
    CGFloat _pageOffsetY;
}

static CGRect theViewRect;

#pragma mark - ReaderContentPage class methods

+ (Class)layerClass
{
    return [ReaderContentTile class];
}

#pragma mark - ReaderContentPage PDF link methods
//调用已经被注释,为了调试时候用的
- (void)highlightPageLinks
{
    if (_links.count > 0) // Add highlight views over all links
    {
        UIColor *hilite = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.15f];
        
        for (ReaderDocumentLink *link in _links) // Enumerate the links array
        {
            UIView *highlight = [[UIView alloc] initWithFrame:link.rect];
            
            highlight.autoresizesSubviews = NO;
            highlight.userInteractionEnabled = NO;
            highlight.contentMode = UIViewContentModeRedraw;
            highlight.autoresizingMask = UIViewAutoresizingNone;
            highlight.backgroundColor = hilite; // Color
            
            [self addSubview:highlight];
        }
    }
}

- (ReaderDocumentLink *)linkFromAnnotation:(CGPDFDictionaryRef)annotationDictionary
{
    ReaderDocumentLink *documentLink = nil; // Document link object
    
    CGPDFArrayRef annotationRectArray = NULL; // Annotation co-ordinates array
    
    if (CGPDFDictionaryGetArray(annotationDictionary, "Rect", &annotationRectArray))
    {
        CGPDFReal ll_x = 0.0f; CGPDFReal ll_y = 0.0f; // PDFRect lower-left X and Y
        CGPDFReal ur_x = 0.0f; CGPDFReal ur_y = 0.0f; // PDFRect upper-right X and Y
        
        CGPDFArrayGetNumber(annotationRectArray, 0, &ll_x); // Lower-left X co-ordinate
        CGPDFArrayGetNumber(annotationRectArray, 1, &ll_y); // Lower-left Y co-ordinate
        
        CGPDFArrayGetNumber(annotationRectArray, 2, &ur_x); // Upper-right X co-ordinate
        CGPDFArrayGetNumber(annotationRectArray, 3, &ur_y); // Upper-right Y co-ordinate
        
        if (ll_x > ur_x) { CGPDFReal t = ll_x; ll_x = ur_x; ur_x = t; } // Normalize Xs
        if (ll_y > ur_y) { CGPDFReal t = ll_y; ll_y = ur_y; ur_y = t; } // Normalize Ys
        
        ll_x -= _pageOffsetX; ll_y -= _pageOffsetY; // Offset lower-left co-ordinate
        ur_x -= _pageOffsetX; ur_y -= _pageOffsetY; // Offset upper-right co-ordinate
        
        switch (_pageAngle) // Page rotation angle (in degrees)
        {
            case 90: // 90 degree page rotation
            {
                CGPDFReal swap;
                swap = ll_y; ll_y = ll_x; ll_x = swap;
                swap = ur_y; ur_y = ur_x; ur_x = swap;
                break;
            }
                
            case 270: // 270 degree page rotation
            {
                CGPDFReal swap;
                swap = ll_y; ll_y = ll_x; ll_x = swap;
                swap = ur_y; ur_y = ur_x; ur_x = swap;
                ll_x = ((0.0f - ll_x) + _pageWidth);
                ur_x = ((0.0f - ur_x) + _pageWidth);
                break;
            }
                
            case 0: // 0 degree page rotation
            {
                ll_y = ((0.0f - ll_y) + _pageHeight);
                ur_y = ((0.0f - ur_y) + _pageHeight);
                break;
            }
        }
        
        NSInteger vr_x = ll_x; NSInteger vr_w = (ur_x - ll_x); // Integer X and width
        NSInteger vr_y = ll_y; NSInteger vr_h = (ur_y - ll_y); // Integer Y and height
        
        CGRect viewRect = CGRectMake(vr_x, vr_y, vr_w, vr_h); // View CGRect from PDFRect
        
        documentLink = [ReaderDocumentLink newWithRect:viewRect dictionary:annotationDictionary];
    }
    
    return documentLink;
}

- (void)buildAnnotationLinksList
{
    _links = [NSMutableArray new]; // Links list array
    
    CGPDFArrayRef pageAnnotations = NULL; // Page annotations array
    
    CGPDFDictionaryRef pageDictionary = CGPDFPageGetDictionary(_PDFPageRef);
    
    if (CGPDFDictionaryGetArray(pageDictionary, "Annots", &pageAnnotations) == true)
    {
        NSInteger count = CGPDFArrayGetCount(pageAnnotations); // Number of annotations
        
        for (NSInteger index = 0; index < count; index++) // Iterate through all annotations
        {
            CGPDFDictionaryRef annotationDictionary = NULL; // PDF annotation dictionary
            
            if (CGPDFArrayGetDictionary(pageAnnotations, index, &annotationDictionary) == true)
            {
                const char *annotationSubtype = NULL; // PDF annotation subtype string
                
                if (CGPDFDictionaryGetName(annotationDictionary, "Subtype", &annotationSubtype) == true)
                {
                    if (strcmp(annotationSubtype, "Link") == 0) // Found annotation subtype of 'Link'
                    {
                        ReaderDocumentLink *documentLink = [self linkFromAnnotation:annotationDictionary];
                        
                        if (documentLink != nil) [_links insertObject:documentLink atIndex:0]; // Add link
                    }
                }
            }
        }
        
        [self highlightPageLinks]; // Link support debugging
    }
}

- (CGPDFArrayRef)destinationWithName:(const char *)destinationName inDestsTree:(CGPDFDictionaryRef)node
{
    CGPDFArrayRef destinationArray = NULL;
    
    CGPDFArrayRef limitsArray = NULL; // Limits array
    
    if (CGPDFDictionaryGetArray(node, "Limits", &limitsArray) == true)
    {
        CGPDFStringRef lowerLimit = NULL; CGPDFStringRef upperLimit = NULL;
        
        if (CGPDFArrayGetString(limitsArray, 0, &lowerLimit) == true) // Lower limit
        {
            if (CGPDFArrayGetString(limitsArray, 1, &upperLimit) == true) // Upper limit
            {
                const char *ll = (const char *)CGPDFStringGetBytePtr(lowerLimit); // Lower string
                const char *ul = (const char *)CGPDFStringGetBytePtr(upperLimit); // Upper string
                
                if ((strcmp(destinationName, ll) < 0) || (strcmp(destinationName, ul) > 0))
                {
                    return NULL; // Destination name is outside this node's limits
                }
            }
        }
    }
    
    CGPDFArrayRef namesArray = NULL; // Names array
    
    if (CGPDFDictionaryGetArray(node, "Names", &namesArray) == true)
    {
        NSInteger namesCount = CGPDFArrayGetCount(namesArray);
        
        for (NSInteger index = 0; index < namesCount; index += 2)
        {
            CGPDFStringRef destName; // Destination name string
            
            if (CGPDFArrayGetString(namesArray, index, &destName) == true)
            {
                const char *dn = (const char *)CGPDFStringGetBytePtr(destName);
                
                if (strcmp(dn, destinationName) == 0) // Found the destination name
                {
                    if (CGPDFArrayGetArray(namesArray, (index + 1), &destinationArray) == false)
                    {
                        CGPDFDictionaryRef destinationDictionary = NULL; // Destination dictionary
                        
                        if (CGPDFArrayGetDictionary(namesArray, (index + 1), &destinationDictionary) == true)
                        {
                            CGPDFDictionaryGetArray(destinationDictionary, "D", &destinationArray);
                        }
                    }
                    
                    return destinationArray; // Return the destination array
                }
            }
        }
    }
    
    CGPDFArrayRef kidsArray = NULL; // Kids array
    
    if (CGPDFDictionaryGetArray(node, "Kids", &kidsArray) == true)
    {
        NSInteger kidsCount = CGPDFArrayGetCount(kidsArray);
        
        for (NSInteger index = 0; index < kidsCount; index++)
        {
            CGPDFDictionaryRef kidNode = NULL; // Kid node dictionary
            
            if (CGPDFArrayGetDictionary(kidsArray, index, &kidNode) == true) // Recurse into node
            {
                destinationArray = [self destinationWithName:destinationName inDestsTree:kidNode];
                
                if (destinationArray != NULL) return destinationArray; // Return destination array
            }
        }
    }
    
    return NULL;
}

- (id)annotationLinkTarget:(CGPDFDictionaryRef)annotationDictionary
{
    id linkTarget = nil; // Link target object
    
    CGPDFStringRef destName = NULL; const char *destString = NULL;
    
    CGPDFDictionaryRef actionDictionary = NULL; CGPDFArrayRef destArray = NULL;
    
    if (CGPDFDictionaryGetDictionary(annotationDictionary, "A", &actionDictionary) == true)
    {
        const char *actionType = NULL; // Annotation action type string
        
        if (CGPDFDictionaryGetName(actionDictionary, "S", &actionType) == true)
        {
            if (strcmp(actionType, "GoTo") == 0) // GoTo action type
            {
                if (CGPDFDictionaryGetArray(actionDictionary, "D", &destArray) == false)
                {
                    CGPDFDictionaryGetString(actionDictionary, "D", &destName);
                }
            }
            else // Handle other link action type possibility
            {
                if (strcmp(actionType, "URI") == 0) // URI action type
                {
                    CGPDFStringRef uriString = NULL; // Action's URI string
                    
                    if (CGPDFDictionaryGetString(actionDictionary, "URI", &uriString) == true)
                    {
                        const char *uri = (const char *)CGPDFStringGetBytePtr(uriString); // Destination URI string
                        
                        NSString *target = [NSString stringWithCString:uri encoding:NSUTF8StringEncoding]; // NSString - UTF8
                        
                        linkTarget = [NSURL URLWithString:[target stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        
                        if (linkTarget == nil) NSLog(@"%s Bad URI '%@'", __FUNCTION__, target);
                    }
                }
            }
        }
    }
    else // Handle other link target possibilities
    {
        if (CGPDFDictionaryGetArray(annotationDictionary, "Dest", &destArray) == false)
        {
            if (CGPDFDictionaryGetString(annotationDictionary, "Dest", &destName) == false)
            {
                CGPDFDictionaryGetName(annotationDictionary, "Dest", &destString);
            }
        }
    }
    
    if (destName != NULL) // Handle a destination name
    {
        CGPDFDictionaryRef catalogDictionary = CGPDFDocumentGetCatalog(_PDFDocRef);
        
        CGPDFDictionaryRef namesDictionary = NULL; // Destination names in the document
        
        if (CGPDFDictionaryGetDictionary(catalogDictionary, "Names", &namesDictionary) == true)
        {
            CGPDFDictionaryRef destsDictionary = NULL; // Document destinations dictionary
            
            if (CGPDFDictionaryGetDictionary(namesDictionary, "Dests", &destsDictionary) == true)
            {
                const char *destinationName = (const char *)CGPDFStringGetBytePtr(destName); // Name
                
                destArray = [self destinationWithName:destinationName inDestsTree:destsDictionary];
            }
        }
    }
    
    if (destString != NULL) // Handle a destination string
    {
        CGPDFDictionaryRef catalogDictionary = CGPDFDocumentGetCatalog(_PDFDocRef);
        
        CGPDFDictionaryRef destsDictionary = NULL; // Document destinations dictionary
        
        if (CGPDFDictionaryGetDictionary(catalogDictionary, "Dests", &destsDictionary) == true)
        {
            CGPDFDictionaryRef targetDictionary = NULL; // Destination target dictionary
            
            if (CGPDFDictionaryGetDictionary(destsDictionary, destString, &targetDictionary) == true)
            {
                CGPDFDictionaryGetArray(targetDictionary, "D", &destArray);
            }
        }
    }
    
    if (destArray != NULL) // Handle a destination array
    {
        NSInteger targetPageNumber = 0; // The target page number
        
        CGPDFDictionaryRef pageDictionaryFromDestArray = NULL; // Target reference
        
        if (CGPDFArrayGetDictionary(destArray, 0, &pageDictionaryFromDestArray) == true)
        {
            NSInteger pageCount = CGPDFDocumentGetNumberOfPages(_PDFDocRef); // Pages
            
            for (NSInteger pageNumber = 1; pageNumber <= pageCount; pageNumber++)
            {
                CGPDFPageRef pageRef = CGPDFDocumentGetPage(_PDFDocRef, pageNumber);
                
                CGPDFDictionaryRef pageDictionaryFromPage = CGPDFPageGetDictionary(pageRef);
                
                if (pageDictionaryFromPage == pageDictionaryFromDestArray) // Found it
                {
                    targetPageNumber = pageNumber; break;
                }
            }
        }
        else // Try page number from array possibility
        {
            CGPDFInteger pageNumber = 0; // Page number in array
            
            if (CGPDFArrayGetInteger(destArray, 0, &pageNumber) == true)
            {
                targetPageNumber = (pageNumber + 1); // 1-based
            }
        }
        
        if (targetPageNumber > 0) // We have a target page number
        {
            linkTarget = [NSNumber numberWithInteger:targetPageNumber];
        }
    }
    
    return linkTarget;
}

- (id)processSingleTap:(UITapGestureRecognizer *)recognizer
{
    id result = nil; // Tap result object
    
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        if (_links.count > 0) // Process the single tap
        {
            CGPoint point = [recognizer locationInView:self];
            
            for (ReaderDocumentLink *link in _links) // Enumerate links
            {
                if (CGRectContainsPoint(link.rect, point) == true) // Found it
                {
                    result = [self annotationLinkTarget:link.dictionary]; break;
                }
            }
        }
    }
    
    return result;
}

#pragma mark - ReaderContentPage instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.autoresizesSubviews = NO;
        self.userInteractionEnabled = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase
{
    
    
    CGRect viewRect = CGRectZero; // View rect
    
    if (fileURL != nil) // Check for non-nil file URL
    {
        //这个是封装好的一个方法:CGPDFDocumentCreateUsingUrl(点进去看);可以使用CGPDFDocumentCreateWithProvider或CGPDFDocumentCreateWithURL来创建CGPDFDocument对象。在创建CGPDFDocument对象后，我们可以将其绘制到图形上下文中。
        _PDFDocRef = CGPDFDocumentCreateUsingUrl((__bridge CFURLRef)fileURL, phrase); //使用CGPDFDocumentRef来读取PDF文件,解析pdf(需要传入pdf的路径)  一个PDF文档对象 (CGPDFDocument)包含了所有的信息,涉及到一个PDF文档,包括它的目录和内容。目录中的条目的递归地描述了PDF文档的内容。你可以访问一个PDF文档的内容通过调用函数CGPDFDocumentGetCatalog。
        
        if (_PDFDocRef != NULL) // Check for non-NULL CGPDFDocumentRef
        {
            if (page < 1) page = 1; // Check the lower page bounds 如果页码小于1,就显示1页
            
            NSInteger pages = CGPDFDocumentGetNumberOfPages(_PDFDocRef);//获取pdf文档总页数
            
            if (page > pages) page = pages; // Check the upper page bounds 如果页数大于pdf文件页数,显示当前pdf总页数
            
            _PDFPageRef = CGPDFDocumentGetPage(_PDFDocRef, page); // Get page  获取当前页 使用CGPDFDocumentGetPage方法取到指定页的CGPDFPageRef  一个PDF页面对象(CGPDFPage)代表PDF文档中的一页且包含此特定的页面所有信息,包括页面字典和页面内容。您可以获得一个页面字典通过调用该函数CGPDFPageGetDictionary。
            
            if (_PDFPageRef != NULL) // Check for non-NULL CGPDFPageRef
            {
                CGPDFPageRetain(_PDFPageRef); // Retain the PDF page  释放旧的对象，将旧对象的值赋予输入的新对象，再提高输入对象的索引计数为1
                
                CGRect cropBoxRect = CGPDFPageGetBoxRect(_PDFPageRef, kCGPDFCropBox);
                CGRect mediaBoxRect = CGPDFPageGetBoxRect(_PDFPageRef, kCGPDFMediaBox);
                CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
                
                _pageAngle = CGPDFPageGetRotationAngle(_PDFPageRef); // Angle  旋转角度
                
                switch (_pageAngle) // Page rotation angle (in degrees)
                {
                    default: // Default case
                    case 0: case 180: // 0 and 180 degrees
                    {
                        _pageWidth = effectiveRect.size.width;
                        _pageHeight = effectiveRect.size.height;
                        _pageOffsetX = effectiveRect.origin.x;
                        _pageOffsetY = effectiveRect.origin.y;
                        break;
                    }
                        
                    case 90: case 270: // 90 and 270 degrees
                    {
                        
                        
                        _pageWidth = effectiveRect.size.height;
                        _pageHeight = effectiveRect.size.width;
                        _pageOffsetX = effectiveRect.origin.y;
                        _pageOffsetY = effectiveRect.origin.x;
                        break;
                    }
                }
                //添加
                //                _pageWidth = effectiveRect.size.width;
                //                _pageHeight = effectiveRect.size.height;
                
                NSInteger page_w = _pageWidth; // Integer width
                NSInteger page_h = _pageHeight; // Integer height
                
                if (page_w % 2) page_w--; if (page_h % 2) page_h--; // Even
                
                viewRect.size = CGSizeMake(page_w, page_h); // View size
            }
            else // Error out with a diagnostic
            {
                CGPDFDocumentRelease(_PDFDocRef), _PDFDocRef = NULL;
                
                /**
                 *  @author LiuChuanan, 17-03-31 13:42:57
                 *  
                 *  @brief 课件已损坏
                 *
                 *  branch origin/bugfix/AIXUEPAIOS-1161
                 *   
                 *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
                 * 
                 *  @since 
                 */
                ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
                [sideNav removePdfCoverView];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate.window toast:@"课件已损坏"];
                
                //NSAssert(NO, @"CGPDFPageRef == NULL");
            }
        }
        else // Error out with a diagnostic
        {   
            /**
             *  @author LiuChuanan, 17-03-31 13:42:57
             *  
             *  @brief 课件已损坏
             *
             *  branch origin/bugfix/AIXUEPAIOS-1161
             *   
             *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
             * 
             *  @since 
             */
            ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
            [sideNav removePdfCoverView];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window toast:@"课件已损坏"];
            //NSAssert(NO, @"CGPDFDocumentRef == NULL");
        }
    }
    else // Error out with a diagnostic
    {   
        /**
         *  @author LiuChuanan, 17-03-31 13:42:57
         *  
         *  @brief 课件已损坏
         *
         *  branch origin/bugfix/AIXUEPAIOS-1161
         *   
         *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
         * 
         *  @since 
         */
        ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
        [sideNav removePdfCoverView];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window toast:@"课件已损坏"];
        //NSAssert(NO, @"fileURL == nil");
    }
    
    
    //初始化
    //	ReaderContentPage *view = [self initWithFrame:viewRect];
    
    ETTLog(@"原始pdf尺寸 宽:%f  高:%f  高/宽比值:%.2f",viewRect.size.width,viewRect.size.height,viewRect.size.height/viewRect.size.width);
    
    ETTLog(@"屏幕的尺寸  宽:%f  高:%f  高/宽比值:%.2f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width);
    
    theViewRect = viewRect;
    
    NSLog(@"%@",NSStringFromCGRect(theViewRect));
    
    //readerContentPage的尺寸一定得是屏幕的宽高
    CGFloat HWScale = theViewRect.size.height / theViewRect.size.width;
    
    ReaderContentPage *view;
    
    
    CGRect rect  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (HWScale < 1.0) {//这种情况是原始pdf单张页面高度小于宽度
        
        view  = [self initWithFrame:viewRect];
        
    } else {//这种情况是原始pdf单张页面高度大于宽度
        
        view  = [self initWithFrame:rect];
    }
    
    
    //if (view != nil) [self buildAnnotationLinksList];
    
    
    return view;
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)context
{
    
    ReaderContentPage *readerContentPage = self; // Retain self
    
    NSLog(@"%@",NSStringFromCGRect(theViewRect));
    
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // White
    //CGContextSetRGBFillColor(context, 23.0/255, 222.0/255, 23.0/255, 1.0);
    
    CGContextFillRect(context, CGContextGetClipBoundingBox(context)); // Fill
    
    //NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(CGContextGetClipBoundingBox(context)));
    
    CGFloat HWScale = theViewRect.size.height / theViewRect.size.width;
    
    if (HWScale < 1.0) { //这种情况是原始pdf单张页面高度小于宽度
        
        //转换矩阵 倒置y值
        CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
        
        //缩放比例 x y分别缩放比例  CGContextScaleCTM函数来指定x, y缩放因子
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        
        CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_PDFPageRef, kCGPDFCropBox, self.bounds, 0, true));
        
    } else { //这种情况是原始pdf单张页面高度大于宽度
        
        //这里self height 和 屏幕的高度一样,因为上面self 已经设置成屏幕的frame了
        ETTLog(@"self heigth %f  [UIScreen mainScreen] height %f",self.bounds.size.height,[UIScreen mainScreen].bounds.size.height);
        
        //转换矩阵 倒置y值
        CGContextTranslateCTM(context, 0.0f - (theViewRect.size.width - (theViewRect.size.height - theViewRect.size.width)/(HWScale)/1.0), self.bounds.size.height);
        
        //缩放比例 x y分别缩放比例  CGContextScaleCTM函数来指定x, y缩放因子
        CGContextScaleCTM(context, 1.8f, -1.0);
        
        
        CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_PDFPageRef, kCGPDFCropBox, self.bounds, 0, true));
        
    }
    
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width / HWScale - 200);
    
    
    
    ETTLog(@"%f  %f",margin,theViewRect.size.height);
    
    // Quartz提供了函数CGPDFPageGetDrawingTransform来创建一个仿射变换，该变换基于将PDF页的BOX映射到指定的矩形中。
    /*
     该函数通过如下算法来返回一个仿射变换：
     · 将在box参数中指定的PDF box的类型相关的矩形(media, crop, bleed, trim, art)与指定的PDF页的/MediaBox入口求交集。相交的部分即为一个有效的矩形(effectiverectangle)。
     · 将effective rectangle旋转参数/Rotate入口指定的角度。
     · 将得到的矩形放到rect参数指定的中间。
     · 如果rotate参数是一个非零且是90的倍数，函数将effective rectangel旋转该值指定的角度。正值往右旋转；负值往左旋转。需要注意的是我们传入的是角度，而不是弧度。记住PDF页的/Rotate入口也包含一个旋转，我们提供的rotate参数是与/Rotate入口接合在一起的。
     · 如果需要，可以缩放矩形，从而与我们提供的矩形保持一致。
     · 如果我们通过传递true值给preserveAspectRadio参数以指定保持长宽比，则最后的矩形将与rect参数的矩形的边一致。
     */
    
    //CGContextSetRenderingIntent(context, kCGRenderingIntentDefault); CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
    
    CGContextDrawPDFPage(context, _PDFPageRef); // Render the PDF page into the context  重新绘制pdf  渲染
    
    if (readerContentPage != nil) readerContentPage = nil; // Release self
}


- (void)removeFromSuperview
{
    self.layer.delegate = nil;
    
    //self.layer.contents = nil;
    
    [super removeFromSuperview];
}

- (void)dealloc
{
    CGPDFPageRelease(_PDFPageRef), _PDFPageRef = NULL;
    
    CGPDFDocumentRelease(_PDFDocRef), _PDFDocRef = NULL;
}

#if (READER_DISABLE_RETINA == TRUE) // Option

- (void)didMoveToWindow
{
    self.contentScaleFactor = 1.0f; // Override scale factor
}

#endif // end of READER_DISABLE_RETINA Option

#pragma mark - CATiledLayer delegate methods



@end

#pragma mark -

//
//	ReaderDocumentLink class implementation
//

@implementation ReaderDocumentLink
{
    CGPDFDictionaryRef _dictionary;
    
    CGRect _rect;
}

#pragma mark - Properties

@synthesize rect = _rect;
@synthesize dictionary = _dictionary;

#pragma mark - ReaderDocumentLink class methods

+ (instancetype)newWithRect:(CGRect)linkRect dictionary:(CGPDFDictionaryRef)linkDictionary
{
    return [[ReaderDocumentLink alloc] initWithRect:linkRect dictionary:linkDictionary];
}

#pragma mark - ReaderDocumentLink instance methods

- (instancetype)initWithRect:(CGRect)linkRect dictionary:(CGPDFDictionaryRef)linkDictionary
{
    if ((self = [super init]))
    {
        _dictionary = linkDictionary;
        
        _rect = linkRect;
    }
    
    return self;
}

@end
