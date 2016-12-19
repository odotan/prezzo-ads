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

#import "PREAdvertiserViewController.h"
#import "PREAppDelegate.h"

static const CGSize DEFAULT_CONTENT_SIZE = {319.0, 79.0};

@interface PREAdvertiserViewController ()
- (void)backgroundClicked:(id)sender;
@property (nonatomic) PREAdvertiserBackgroundShapeView *elemBackgroundShape;
@property (nonatomic) PREAdvertiserImageView *elemImage;
@property (nonatomic) PREDataSheet *dataSheet;
@property (nonatomic) NSInteger dataSheetRowIndex;
@property (nonatomic) NSMutableArray *pendingDataTasks;  // Holds pointers to tasks loading data for dynamic content updates.
@end

@interface PREAdvertiser_TappableBackgroundView : UIView
@property (nonatomic, weak) PREAdvertiserViewController *viewController;
@end

@implementation PREAdvertiser_TappableBackgroundView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewController backgroundClicked:self];
}

@end

@implementation PREAdvertiserViewController

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
    PREAdvertiser_TappableBackgroundView *rootView = [[PREAdvertiser_TappableBackgroundView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_CONTENT_SIZE.width, DEFAULT_CONTENT_SIZE.height)];
    
    rootView.viewController = self;
    rootView.tintColor = [UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0];

    rootView.clipsToBounds = YES;

    PREAdvertiserBackgroundShapeView *elemBackgroundShape = [[PREAdvertiserBackgroundShapeView alloc] initWithFrame:CGRectMake(0.0, 0.0, 319.0, 79.0)];
    self.elemBackgroundShape = elemBackgroundShape;

    elemBackgroundShape.userInteractionEnabled = NO;

    [rootView addSubview:self.elemBackgroundShape];
    
    PREAdvertiserImageView *elemImage = [[PREAdvertiserImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 319.0, 78.5)];
    self.elemImage = elemImage;

    elemImage.userInteractionEnabled = NO;

    [rootView addSubview:self.elemImage];
    
    
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
    NSArray *layoutDescs_elemBackgroundShape = @[
    @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 323.0, 80.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphoneclassic_portrait
    @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 319.0, 79.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphone5_portrait
    @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 302.67, 75.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphone6plus_portrait
    @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 317.0, 79.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // ipad_portrait
    @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 319.0, 79.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], @{ @"bottomEdgeOffset": @(0.0+yOff) } ],  // iphone6_portrait
    ];
    NSDictionary *override_elemBackgroundShape = [_overrideElementLayoutDescriptors objectForKey:@"background shape"];
    if ((val = [override_elemBackgroundShape objectForKey:@"layoutDescs"]))
       layoutDescs_elemBackgroundShape = val;
    [self applyLayout:layoutDescs_elemBackgroundShape toView:self.elemBackgroundShape format:format associatedData:nil flowIsHorizontal:flowIsHoriz flowPosPtr:&flowPos];
    
    NSArray *layoutDescs_elemImage = @[
    @[@4, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 323.0, 79.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphoneclassic_portrait
    @[@6, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 319.0, 78.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone5_portrait
    @[@20, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 302.67, 74.33)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6plus_portrait
    @[@16, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 317.0, 78.0)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // ipad_portrait
    @[@18, [NSValue valueWithCGRect:CGRectMake(0.0, 0.0+yOff, 319.0, 78.5)], [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]],  // iphone6_portrait
    ];
    NSDictionary *override_elemImage = [_overrideElementLayoutDescriptors objectForKey:@"image"];
    if ((val = [override_elemImage objectForKey:@"layoutDescs"]))
       layoutDescs_elemImage = val;
    NSArray *layoutAssocData_elemImage = @[
      @[@4, @{
        @"contentTransformMatricesString": @"[0.171808511, 0.0, 0.0, 0.171808511, 0.0, -51.136702128]; [0.171808511, 0.0, 0.0, 0.171808511, 0.0, -51.136702128]",
      }],
      @[@6, @{
        @"contentTransformMatricesString": @"[0.169680851, 0.0, 0.0, 0.169680851, 0.0, -50.511170213]; [0.169680851, 0.0, 0.0, 0.169680851, 0.0, -50.511170213]",
      }],
      @[@20, @{
        @"contentTransformMatricesString": @"[0.160992908, 0.0, 0.0, 0.160992908, 0.0, -47.998581560]; [0.160992908, 0.0, 0.0, 0.160992908, 0.0, -47.998581560]",
      }],
      @[@16, @{
        @"contentTransformMatricesString": @"[0.168617021, 0.0, 0.0, 0.168617021, 0.0, -50.198404255]; [0.168617021, 0.0, 0.0, 0.168617021, 0.0, -50.198404255]",
      }],
      @[@18, @{
        @"contentTransformMatricesString": @"[0.169680851, 0.0, 0.0, 0.169680851, 0.0, -50.511170213]; [0.169680851, 0.0, 0.0, 0.169680851, 0.0, -50.511170213]",
      }],
    ];
    if ((val = [override_elemImage objectForKey:@"associatedData"]))
       layoutAssocData_elemImage = val;
    [self applyLayout:layoutDescs_elemImage toView:self.elemImage format:format associatedData:layoutAssocData_elemImage flowIsHorizontal:flowIsHoriz flowPosPtr:&flowPos];
    

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
        val = [rowDesc objectForKey:@"image"];
        id value = [val objectForKey:@"value"];
        NSString *type = [val objectForKey:@"type"];
        if ([type isEqual:@"image"]) {
            NSString *url = [val objectForKey:@"value"];
            const BOOL isWebUrl = [url hasPrefix:@"http"];
            self.elemImage.hidden = isWebUrl;  // Prevent flash of old content when loading from a web url
            id task = [_dataSheet loadImageForColumnNamed:@"image" atRow:_dataSheetRowIndex completionHandler:^(UIImage *image) {
                self.elemImage.overrideImage = image;
                if (isWebUrl) {
                    self.elemImage.hidden = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StencilContentUpdated" object:self];
                }
                if (task) [self.pendingDataTasks removeObject:task];
            }];
            if (task) [self.pendingDataTasks addObject:task];
        } else {
            self.elemImage.overrideImage = nil;
        }
    }
}

@end



// A wrapper for using this view controller as a cell in a UICollectionView

@implementation PREAdvertiserViewControllerCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    PREAdvertiserViewController *vc = [[PREAdvertiserViewController alloc] initWithNibName:nil bundle:nil];
    UIView *contentView = vc.view;
    
    self = [super initWithFrame:contentView.frame];

    [self.contentView addSubview:contentView];
    
    self.clipsToBounds = YES;
    self.containedViewController = vc;
    
    return self;
}

@end



// A wrapper for using this view controller as a cell in a UITableView

@implementation PREAdvertiserViewControllerTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    PREAdvertiserViewController *vc = [[PREAdvertiserViewController alloc] initWithNibName:nil bundle:nil];
    UIView *contentView = vc.view;

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    [self.contentView addSubview:contentView];

    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.containedViewController = vc;

    return self;
}

@end
