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

#import "PREListItem1ViewController.h"
#import "PREAppDelegate.h"
#import "PREDataSheet.h"

static const CGSize DEFAULT_CONTENT_SIZE = {319.0, 437.0};

@interface PREListItem1ViewController ()
- (void)backgroundClicked:(id)sender;
@property (nonatomic) PREDataSheet *elemListDataSheet;
@property (nonatomic) PREAdvertiserViewController *vc_elemList;
@property (nonatomic) UICollectionView *elemList;
@property (nonatomic) NSMutableDictionary *elemListRowHeights;
@property (nonatomic) NSArray *elemListFilteredRowIndexes;
@property (nonatomic) PREDataSheet *dataSheet;
@property (nonatomic) NSInteger dataSheetRowIndex;
@property (nonatomic) NSMutableArray *pendingDataTasks;  // Holds pointers to tasks loading data for dynamic content updates.
@end

@interface PREListItem1_TappableBackgroundView : UIView
@property (nonatomic, weak) PREListItem1ViewController *viewController;
@end

@implementation PREListItem1_TappableBackgroundView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewController backgroundClicked:self];
}

@end

@implementation PREListItem1ViewController

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
    PREListItem1_TappableBackgroundView *rootView = [[PREListItem1_TappableBackgroundView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_CONTENT_SIZE.width, DEFAULT_CONTENT_SIZE.height)];
    
    rootView.viewController = self;
    rootView.tintColor = [UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0];

    rootView.clipsToBounds = YES;

    {
      // Grid element 'list' setup.
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 400, 600) collectionViewLayout:layout];
        collection.dataSource = (id)self;
        collection.delegate = (id)self;
        [collection registerClass:[PREAdvertiserViewControllerCollectionCell class] forCellWithReuseIdentifier:@"elemListItem"];
        collection.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        collection.contentInset = UIEdgeInsetsMake(0.0, 0, 0.0, 0);
        
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        
        self.elemList = collection;
    }

    [rootView addSubview:self.elemList];
    
    
    self.elemListRowHeights = [NSMutableDictionary dictionary];
    
    if (_dataSheet) {
        [self _updateValuesFromDataSheet];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view = rootView;
    [self viewDidLoad];
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

    id vc = self;
    while ([vc respondsToSelector:@selector(containerViewController)]) {
        id container = [vc containerViewController];
        if (!container) break;
        vc = container;
    }
    UINavigationController *nav = (id)[vc parentViewController];


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
    
    self.elemList.delegate = (id)self;
    [self.elemList reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stencilContentUpdated_elemList:) name:@"StencilContentUpdated" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (id view in [self.view subviews]) {
        if ([view respondsToSelector:@selector(setDelegate:)] && [view respondsToSelector:@selector(delegate)] && [view delegate] == (id)self)
            [view setDelegate:nil];
    }
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
    CGFloat flowPos = 0.0;
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
    NSArray *layoutDescs_elemList = @[
    @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 323.0, 440.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphoneclassic_portrait
    @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 319.0, 435.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone5_portrait
    @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 302.33, 412.33)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6plus_portrait
    @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 317.0, 433.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // ipad_portrait
    @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 318.5, 434.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6_portrait
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
        return 1;    }
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
        
        
        NSMutableDictionary *overrides = [NSMutableDictionary dictionary];
        
        [overrides setObject:@{ @"layoutDescs":     @[
            @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 323.0, 79.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphoneclassic_portrait
            @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 319.0, 78.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone5_portrait
            @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 302.33, 74.33)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6plus_portrait
            @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 317.0, 78.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // ipad_portrait
            @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 318.5, 78.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6_portrait
            ],
            @"associatedData": @[
                  @[@4, @{
                    @"contentTransformMatricesString": @"[0.171808511, 0.0, 0.0, 0.171808511, 0.0, -51.136702128]; [0.171808511, 0.0, 0.0, 0.171808511, 0.0, -51.136702128]",
              }],
                  @[@6, @{
                    @"contentTransformMatricesString": @"[0.169680851, 0.0, 0.0, 0.169680851, 0.0, -50.511170213]; [0.169680851, 0.0, 0.0, 0.169680851, 0.0, -50.511170213]",
              }],
                  @[@20, @{
                    @"contentTransformMatricesString": @"[0.160815603, 0.0, 0.0, 0.160815603, 0.0, -47.904787234]; [0.160815603, 0.0, 0.0, 0.160815603, 0.0, -47.904787234]",
              }],
                  @[@16, @{
                    @"contentTransformMatricesString": @"[0.168617021, 0.0, 0.0, 0.168617021, 0.0, -50.198404255]; [0.168617021, 0.0, 0.0, 0.168617021, 0.0, -50.198404255]",
              }],
                  @[@18, @{
                    @"contentTransformMatricesString": @"[0.169414894, 0.0, 0.0, 0.169414894, 0.0, -50.370478723]; [0.169414894, 0.0, 0.0, 0.169414894, 0.0, -50.370478723]",
              }],
            ]
        } forKey:@"image"];
        
        [overrides setObject:@{ @"layoutDescs":     @[
            @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 323.0, 80.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0) } ],  // iphoneclassic_portrait
            @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 319.0, 79.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0) } ],  // iphone5_portrait
            @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 302.33, 75.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0) } ],  // iphone6plus_portrait
            @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 317.0, 79.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0) } ],  // ipad_portrait
            @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 318.5, 79.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0) } ],  // iphone6_portrait
            ],
        } forKey:@"background shape"];
        
        [vc setMaxDisplayHeight:99.24];
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

- (CGSize)contentSize
{
    CGSize size = DEFAULT_CONTENT_SIZE;
    return size;
}

- (void)sizeToFitContentHeight
{
    CGRect frame = self.view.frame;
    frame.size.height = self.contentSize.height;
    self.view.frame = frame;
    
    [self repositionElements];
}

- (BOOL)loadImageForColumnNamed:(NSString *)col atRow:(NSInteger)rowIdx completionHandler:(void (^)(UIImage *image))done
{
    return NO;
}

- (void)takeValuesFromDataSheet:(id)dataSheet atRow:(NSInteger)row
{
    self.dataSheet = dataSheet;
    self.dataSheetRowIndex = row;
    
    if (self.isViewLoaded) {
        [self _updateValuesFromDataSheet];
    }
}

- (void)_updateValuesFromDataSheet
{
    NSDictionary *rowDesc = nil;
    @try {
        rowDesc = [[_dataSheet rows] objectAtIndex:_dataSheetRowIndex];
    } @catch (NSException *exc) {
        // If there's no such row, the data sheet's contents may have changed under us.
        // A reload will be triggered eventually, so do nothing here.
        return;
    }
    
    id val;
    
    // Clear unfinished tasks that were loading data for the previous values.
    if (self.pendingDataTasks) {
        for (id task in self.pendingDataTasks) {
            if ([task respondsToSelector:@selector(cancel)]) {
                [task cancel];
                //NSLog(@"%s: canceled loading data from url '%@'", __func__, [task originalRequest].URL);
            }
        }
    }
    self.pendingDataTasks = [NSMutableArray array];
    
    {
        val = [rowDesc objectForKey:@"list"];
        id value = [val objectForKey:@"value"];
        NSString *type = [val objectForKey:@"type"];
    }
}

@end



// A wrapper for using this view controller as a cell in a UICollectionView

@implementation PREListItem1ViewControllerCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    PREListItem1ViewController *vc = [[PREListItem1ViewController alloc] initWithNibName:nil bundle:nil];
    UIView *contentView = vc.view;
    
    self = [super initWithFrame:contentView.frame];

    [self.contentView addSubview:contentView];
    
    self.clipsToBounds = YES;
    self.containedViewController = vc;
    
    return self;
}

@end



// A wrapper for using this view controller as a cell in a UITableView

@implementation PREListItem1ViewControllerTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    PREListItem1ViewController *vc = [[PREListItem1ViewController alloc] initWithNibName:nil bundle:nil];
    UIView *contentView = vc.view;

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    [self.contentView addSubview:contentView];

    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.containedViewController = vc;

    return self;
}

@end
