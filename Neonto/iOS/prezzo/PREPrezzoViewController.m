/*
  This code was generated in Neonto Studio Personal Edition:
  
    http://www.neonto.com
  
  You may use this code ONLY for non-commercial purposes and evaluation.
  Reusing any part of this code for commercial purposes is not permitted.
  
  Would you like to remove this restriction?
  With Neonto's flexible licensing options, you can have your own copyright
  in all this code.
  
  Find out more -- click 'Upgrade to Pro' in Neonto Studio's toolbar.
  
*/

#import "PREPrezzoViewController.h"
#import "PREAppDelegate.h"
#import "PREDataSheet.h"

@interface PREPrezzoViewController ()
- (void)backgroundClicked:(id)sender;
@property (nonatomic) PREPrezzoBackgroundShapeView *elemBackgroundShape;
@property (nonatomic) PREPrezzoPrezzologoaloneView *elemPrezzologoalone;
@property (nonatomic) PREDataSheet *elemListDataSheet;
@property (nonatomic) PREListItem1ViewController *vc_elemList;
@property (nonatomic) UICollectionView *elemList;
@property (nonatomic) CGSize visibleKeyboardSize;
@property (nonatomic) CGPoint originalScrollContentOffset;
@property (nonatomic) NSMutableDictionary *elemListRowHeights;
@property (nonatomic) NSArray *elemListFilteredRowIndexes;
@end

@interface PREPrezzo_TappableBackgroundView : UIView
@property (nonatomic, weak) PREPrezzoViewController *viewController;
@end

@implementation PREPrezzo_TappableBackgroundView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewController backgroundClicked:self];
}

@end

@implementation PREPrezzoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        // Before iOS 8, screen size did not take orientation into account
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            screenSize = CGSizeMake(screenSize.height, screenSize.width);
        }
    }
    PREPrezzo_TappableBackgroundView *rootView = [[PREPrezzo_TappableBackgroundView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    rootView.viewController = self;
    rootView.tintColor = [UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0];

    rootView.clipsToBounds = YES;

    PREPrezzoBackgroundShapeView *elemBackgroundShape = [[PREPrezzoBackgroundShapeView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 568.0)];
    self.elemBackgroundShape = elemBackgroundShape;

    elemBackgroundShape.userInteractionEnabled = NO;

    [rootView addSubview:self.elemBackgroundShape];
    
    PREPrezzoPrezzologoaloneView *elemPrezzologoalone = [[PREPrezzoPrezzologoaloneView alloc] initWithFrame:CGRectMake(78.5, 110.0, 163.0, 217.0)];
    self.elemPrezzologoalone = elemPrezzologoalone;

    elemPrezzologoalone.userInteractionEnabled = NO;

    [rootView addSubview:self.elemPrezzologoalone];
    
    {
      // Grid element 'list' setup.
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 400, 600) collectionViewLayout:layout];
        collection.dataSource = (id)self;
        collection.delegate = (id)self;
        [collection registerClass:[PREListItem1ViewControllerCollectionCell class] forCellWithReuseIdentifier:@"elemListItem"];
        collection.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        collection.contentInset = UIEdgeInsetsMake(0.0, 0, 0.0, 0);
        
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        
        self.elemList = collection;
        // default data source for this collection
        self.elemListDataSheet = [(id)[[UIApplication sharedApplication] delegate] dataSheetListData1];
    }

    [rootView addSubview:self.elemList];
    
    
    self.navigationItem.title = @"prezzo";
    
    
    self.elemListRowHeights = [NSMutableDictionary dictionary];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view = rootView;
    [self viewDidLoad];
}

- (void)dataSheetModified_elemList:(NSNotification *)notif
{
    [self.elemList reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#ifdef __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UINavigationController *)parentNavigationController
{
    // Dynamically determine whether we're within a hierarchical container
    // view controller (UINavigationController or something that works like it).

    UINavigationController *nav = (id)self.parentViewController;


    if ([nav isKindOfClass:[UIPageViewController class]] || [nav isKindOfClass:[UITabBarController class]]) {
        if ([nav respondsToSelector:@selector(containerViewController)] && [(id)nav containerViewController]) {
            // We're inside a multipage that is nested, so the nav is the container's parent
            id container = [(id)nav containerViewController];
            return (id)[container parentViewController];
        }
        nav = (id)nav.parentViewController;
    }
    if ([nav respondsToSelector:@selector(popToViewController:animated:)]) {
        return nav;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self repositionElements];
    
    UINavigationController *nav = [self parentNavigationController];
    nav.navigationBarHidden = YES;
    
    self.elemList.delegate = (id)self;
    [self.elemList reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stencilContentUpdated_elemList:) name:@"StencilContentUpdated" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(dataSheetModified_elemList:)
        name:@"DataSheetModified"
        object:[(id)[[UIApplication sharedApplication] delegate] dataSheetListData1]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (id view in [self.view subviews]) {
        if ([view respondsToSelector:@selector(setDelegate:)] && [view respondsToSelector:@selector(delegate)] && [view delegate] == (id)self)
            [view setDelegate:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)backgroundClicked:(id)sender
{
    [self.view endEditing:NO];
}

- (void)hideKeyboard:(id)sender
{
    [self.view endEditing:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}
- (void)keyboardDidShow:(NSNotification *)notif
{
    UIView *rootView = self.view;
    UIScrollView *scroll = nil;


    _visibleKeyboardSize = [[notif.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIView *firstResp = nil;
    for (UIView *subview in rootView.subviews) {
        if (subview.isFirstResponder) {
            firstResp = subview;
            break;
        }
    }
    const CGFloat margin = 20;
    const CGFloat minYToShow = firstResp.frame.origin.y + firstResp.frame.size.height + margin;
    
    if ( !scroll) {
        // If the content isn't in a scrollview, we can bump up the whole view
        CGRect frame = rootView.frame;
        
        CGFloat keyboardY = frame.size.height - _visibleKeyboardSize.height;
        if (minYToShow >= keyboardY) {
            frame.origin.y -= minYToShow - keyboardY;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            rootView.frame = frame;
        }];
        _originalScrollContentOffset = frame.origin;
    }
    else {
        // The content is in a scrollview, so move that
        CGSize contentSize = scroll.contentSize;
        contentSize.height += _visibleKeyboardSize.height;
        scroll.contentSize = contentSize;

        CGPoint contentOffset = scroll.contentOffset;
        CGFloat maxVisibleY = contentOffset.y + self.view.bounds.size.height - _visibleKeyboardSize.height;
        if (maxVisibleY < minYToShow) {
            _originalScrollContentOffset = contentOffset;
            contentOffset.y = MIN(firstResp.frame.origin.y - (firstResp.frame.size.height + margin), contentSize.height - scroll.frame.size.height);
            [scroll setContentOffset:contentOffset animated:YES];
        }
    }
}


- (void)keyboardWillHide:(NSNotification *)notif
{
    UIView *rootView = self.view;
    UIScrollView *scroll = nil;


    if (_visibleKeyboardSize.height > 0.0) {

        if ( !scroll) {
            CGRect frame = rootView.frame;
            frame.origin.y -= _originalScrollContentOffset.y;
            
            [UIView animateWithDuration:0.3 animations:^{
                rootView.frame = frame;
            }];
        }
        else {
            CGSize contentSize = scroll.contentSize;
            contentSize.height -= _visibleKeyboardSize.height;
            CGPoint contentOffset = scroll.contentOffset;
            if (contentOffset.y > contentSize.height - scroll.frame.size.height) {
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     scroll.contentOffset = _originalScrollContentOffset;
                                 }
                                 completion:^(BOOL finished) {
                                     scroll.contentSize = contentSize;
                                 }];
            } else {
                scroll.contentSize = contentSize;
            }
        }
    }
    _visibleKeyboardSize = CGSizeZero;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self repositionElements];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration*0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self repositionElements];
    });
}

- (void)setOverrideElementLayoutDescriptors:(NSDictionary *)d
{
    _overrideElementLayoutDescriptors = d;
    [self repositionElements];
}

- (void)repositionElements
{
    if ( !self.isViewLoaded) {
        return;
    }
    
    const double yOff = self.layoutYOffset;
    const BOOL flowIsHoriz = NO;
    CGFloat flowPos = 20.0;  // start right below the status bar.
    id val;

    const BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    const BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    NSInteger format = 0;
    if (isPad) {
        format = (isPortrait) ? 16 : 15;
    } else {
        double screenDim = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        format = (screenDim <= 480.0) ? 3 : (screenDim <= 568.0 ? 5 : (screenDim <= 667.0 ? 17 : 19));
        if (isPortrait) format++;
    }
    NSArray *layoutDescs_elemBackgroundShape = @[
    @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 320.0, 480.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, -20.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphoneclassic_portrait
    @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 320.0, 568.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, -20.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphone5_portrait
    @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 414.0, 736.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, -20.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphone6plus_portrait
    @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 768.0, 1024.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, -20.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // ipad_portrait
    @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 375.0, 667.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, -20.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphone6_portrait
    ];
    NSDictionary *override_elemBackgroundShape = [_overrideElementLayoutDescriptors objectForKey:@"background shape"];
    if ((val = [override_elemBackgroundShape objectForKey:@"layoutDescs"]))
       layoutDescs_elemBackgroundShape = val;
    [self applyLayout:layoutDescs_elemBackgroundShape toView:self.elemBackgroundShape format:format associatedData:nil flowIsHorizontal:flowIsHoriz flowPosPtr:&flowPos];
    
    NSArray *layoutDescs_elemPrezzologoalone = @[
    @[@4, [NSValue valueWithCGRect:CGRectMake(79.5, 111.5+yOff, 161.0, 124.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 91.5)], @{ @"bottomEdgeOffset": @(244.0+yOff) } ],  // iphoneclassic_portrait
    @[@6, [NSValue valueWithCGRect:CGRectMake(78.5, 110.0+yOff, 163.0, 217.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 90.0)], @{ @"bottomEdgeOffset": @(241.0+yOff) } ],  // iphone5_portrait
    @[@20, [NSValue valueWithCGRect:CGRectMake(74.67, 104.33+yOff, 265.0, 403.33)], [NSValue valueWithCGPoint:CGPointMake(0.0, 84.33)], @{ @"bottomEdgeOffset": @(228.33+yOff) } ],  // iphone6plus_portrait
    @[@16, [NSValue valueWithCGRect:CGRectMake(78.0, 109.0+yOff, 612.0, 675.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 89.0)], @{ @"bottomEdgeOffset": @(240.0+yOff) } ],  // ipad_portrait
    @[@18, [NSValue valueWithCGRect:CGRectMake(78.5, 110.0+yOff, 218.0, 316.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 90.0)], @{ @"bottomEdgeOffset": @(240.5+yOff) } ],  // iphone6_portrait
    ];
    NSDictionary *override_elemPrezzologoalone = [_overrideElementLayoutDescriptors objectForKey:@"prezzo-logo-alone"];
    if ((val = [override_elemPrezzologoalone objectForKey:@"layoutDescs"]))
       layoutDescs_elemPrezzologoalone = val;
    NSArray *layoutAssocData_elemPrezzologoalone = @[
      @[@4, @{
        @"contentTransformMatricesString": @"[0.298148148, 0.0, 0.0, 0.298148148, 0.0, -44.188888889]; [0.298148148, 0.0, 0.0, 0.298148148, 0.0, -44.188888889]",
      }],
      @[@6, @{
        @"contentTransformMatricesString": @"[0.303921569, 0.0, 0.0, 0.303921569, -0.558823529, 0.0]; [0.303921569, 0.0, 0.0, 0.303921569, -0.558823529, 0.0]",
      }],
      @[@20, @{
        @"contentTransformMatricesString": @"[0.564892624, 0.0, 0.0, 0.564892624, -20.021008403, 0.0]; [0.564892624, 0.0, 0.0, 0.564892624, -20.021008403, 0.0]",
      }],
      @[@16, @{
        @"contentTransformMatricesString": @"[1.133333333, 0.0, 0.0, 1.133333333, 0.0, -67.1]; [1.133333333, 0.0, 0.0, 1.133333333, 0.0, -67.1]",
      }],
      @[@18, @{
        @"contentTransformMatricesString": @"[0.443277311, 0.0, 0.0, 0.443277311, -10.684873950, 0.0]; [0.443277311, 0.0, 0.0, 0.443277311, -10.684873950, 0.0]",
      }],
    ];
    if ((val = [override_elemPrezzologoalone objectForKey:@"associatedData"]))
       layoutAssocData_elemPrezzologoalone = val;
    [self applyLayout:layoutDescs_elemPrezzologoalone toView:self.elemPrezzologoalone format:format associatedData:layoutAssocData_elemPrezzologoalone flowIsHorizontal:flowIsHoriz flowPosPtr:&flowPos];
    
    NSArray *layoutDescs_elemList = @[
    @[@4, [NSValue valueWithCGRect:CGRectMake(-0.5, 84.0+yOff, 323.5, 929.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 64.0)]],  // iphoneclassic_portrait
    @[@6, [NSValue valueWithCGRect:CGRectMake(-0.5, 83.0+yOff, 319.5, 918.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 63.0)]],  // iphone5_portrait
    @[@20, [NSValue valueWithCGRect:CGRectMake(-0.67, 78.67+yOff, 302.67, 870.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 58.67)]],  // iphone6plus_portrait
    @[@16, [NSValue valueWithCGRect:CGRectMake(-1.0, 82.0+yOff, 318.0, 912.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 62.0)]],  // ipad_portrait
    @[@18, [NSValue valueWithCGRect:CGRectMake(-0.5, 83.0+yOff, 319.0, 917.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 63.0)]],  // iphone6_portrait
    ];
    NSDictionary *override_elemList = [_overrideElementLayoutDescriptors objectForKey:@"list"];
    if ((val = [override_elemList objectForKey:@"layoutDescs"]))
       layoutDescs_elemList = val;
    [self applyLayout:layoutDescs_elemList toView:self.elemList format:format associatedData:nil flowIsHorizontal:flowIsHoriz flowPosPtr:&flowPos];
    {
        UICollectionViewFlowLayout *layout = (id)self.elemList.collectionViewLayout;
        CGSize itemSize = layout.itemSize;
        NSArray *desc = findLayoutDescForFormat(format, layoutDescs_elemList);
        itemSize.width = [[desc objectAtIndex:1] CGRectValue].size.width;
        layout.itemSize = itemSize;
    }
    
    

}

static inline NSArray *findLayoutDescForFormat(NSInteger v, NSArray *descs)
{
    for (NSArray *desc in descs) {
        if ([[desc objectAtIndex:0] integerValue] == v)
            return desc;
    }
    return nil;
}

- (void)applyLayout:(NSArray *)layoutDescs toView:(UIView *)view format:(NSInteger)format associatedData:(NSArray *)assocDatas flowIsHorizontal:(BOOL)flowIsH flowPosPtr:(CGFloat *)pFlowPos
{
    NSArray *desc = findLayoutDescForFormat(format, layoutDescs);
    if ( !desc) {
        NSLog(@"no layout desc for this screen format: %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
        return;
    }

    CGRect frame = [desc[1] CGRectValue];
    CGPoint layoutOffset = [desc[2] CGPointValue];
    NSDictionary *props = (desc.count > 3) ? desc[3] : nil;

    if ([props[@"fitHeightToContent"] boolValue]) {
        CGRect r = view.frame;
        r.size.width = frame.size.width;
        view.frame = r;
        
        [(id)view sizeToFit];
        
        frame.size.height = view.frame.size.height;

        // If we have a known maximum display size, constrain text to it.
        if (self.maxDisplayHeight > 0.0 && ![props[@"inFlow"] boolValue]) {
            CGFloat maxH = MIN(self.maxDisplayHeight, self.view.bounds.size.height);
            if (frame.size.height > maxH) {
                frame.size.height = maxH;
            }
        }
    }
    
    const BOOL attachedToTop = !isnan(frame.origin.y);
    const BOOL attachedToBottom = [props objectForKey:@"bottomEdgeOffset"] != nil;
    CGFloat bottomEdgeOffset = [[props objectForKey:@"bottomEdgeOffset"] doubleValue];
    
    if (attachedToTop && attachedToBottom) {
        // Determine height dynamically if the view is aligned from top and bottom.
        frame.size.height = self.view.frame.size.height - bottomEdgeOffset - frame.origin.y;
    }
    if ( !attachedToTop && attachedToBottom) {
        // Aligned from bottom, calculate y-coordinate using the bottom offset.
        frame.origin.y = self.view.frame.size.height - bottomEdgeOffset - frame.size.height;
    }

    // If the view is in the scroll flow, the frame position is computed by
    // applying the layout offset to the accumulated 'flowPos' value.
    if ([props[@"inFlow"] boolValue]) {
        BOOL floats = [props[@"floats"] boolValue];
        if (flowIsH) {
            frame.origin.x = *pFlowPos + layoutOffset.x;
            if ( !floats) *pFlowPos = frame.origin.x + frame.size.width;
        } else {
            frame.origin.y = *pFlowPos + layoutOffset.y;
            if ( !floats) *pFlowPos = frame.origin.y + frame.size.height;
        }
    }
    
    view.frame = frame;

    NSArray *assocData = findLayoutDescForFormat(format, assocDatas);
    if (assocData.count > 1) {
        NSDictionary *dict = assocData[1];
        for (NSString *key in dict) {
            @try {
                [view setValue:[dict objectForKey:key] forKey:key];
            } @catch (id exc) {
                NSLog(@"%s: %@", __func__, exc);
            }
        }
    }
}

#pragma mark --- collection view data source ---

- (BOOL)_collectionViewHasHead:(UICollectionView *)collectionView
{
    return NO;
}

- (BOOL)_collectionViewHasTail:(UICollectionView *)collectionView
{
    return NO;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (view == self.elemList) {
        if (section == 0) {
            return ([self _collectionViewHasHead:view]?1:0);
        } else if (section == 2) {
            return ([self _collectionViewHasTail:view]?1:0);
        } else {
            NSInteger numRows;
            if (self.elemListFilteredRowIndexes) {
                numRows = [self.elemListFilteredRowIndexes count];
            } else {
                id dataSheet = self.elemListDataSheet;
                numRows = [[dataSheet rows] count];
            }
            return numRows;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.elemList) {
        return 3;  // head, content, tail
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.elemList) {
        UICollectionViewFlowLayout *layout = (id)collectionViewLayout;
        CGSize size = layout.itemSize;
        NSNumber *rowHeight = [self.elemListRowHeights objectForKey:indexPath];
        if (rowHeight) {
            size.height = [rowHeight floatValue];
        }
        return size;
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)view cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    
    if (view == self.elemList) {
        
        cell = [view dequeueReusableCellWithReuseIdentifier:@"elemListItem" forIndexPath:indexPath];
        
        id vc = [(id)cell containedViewController];
        
        id dataSheet = self.elemListDataSheet;
        NSInteger dataSheetRowIndex;
        if (self.elemListFilteredRowIndexes) {
            dataSheetRowIndex = [[self.elemListFilteredRowIndexes objectAtIndex:indexPath.row] integerValue];
        } else {
            dataSheetRowIndex = indexPath.row;
        }
        [vc takeValuesFromDataSheet:dataSheet atRow:dataSheetRowIndex];
        
        // Expand to fill width of the container.
        CGRect frame = [vc view].frame;
        frame.size.width = view.frame.size.width;
        [vc view].frame = frame;
        
        NSMutableDictionary *overrides = [NSMutableDictionary dictionary];
        
        [overrides setObject:@{ @"layoutDescs":     @[
            @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 323.0, 440.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphoneclassic_portrait
            @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 319.0, 435.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone5_portrait
            @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 302.33, 412.33)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6plus_portrait
            @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 317.0, 433.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // ipad_portrait
            @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 318.5, 434.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6_portrait
            ],
        } forKey:@"list"];
        
        [vc setMaxDisplayHeight:456.93];
        [vc setOverrideElementLayoutDescriptors:overrides];
        
        [vc sizeToFitContentHeight];
        
        [self.elemListRowHeights setObject:[NSNumber numberWithFloat:[vc contentSize].height] forKey:indexPath];
        [view.collectionViewLayout invalidateLayout];
        
        [vc setContainerViewController:self];
    }
    return cell;
}

- (void)stencilContentUpdated_elemList:(NSNotification *)notification
{
    id vc = notification.object;
    
    UICollectionViewCell *cell = nil;
    for (UICollectionViewCell *c in [self.elemList visibleCells]) {
        if ([(id)c containedViewController] == vc) {
            cell = c;
            break;
        }
    }
    if ( !cell)
        return;
    
    NSIndexPath *indexPath = [self.elemList indexPathForCell:cell];
    if ( !indexPath)
        return;
    
    [vc sizeToFitContentHeight];
    
    [self.elemListRowHeights setObject:[NSNumber numberWithFloat:[vc contentSize].height] forKey:indexPath];
    [self.elemList.collectionViewLayout invalidateLayout];
}

@end
