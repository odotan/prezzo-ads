#import "PRETabsViewController.h"

@interface PRETabsViewController () {
}
@end

@implementation PRETabsViewController

+ (UIImage *)_imageNamed:(NSString *)name withTintColor:(UIColor *)tintColor
{
    UIImage *image = [UIImage imageNamed:name];
    
    CGRect bounds = CGRectMake(0, 0, ceil(image.size.width), ceil(image.size.height));
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);  // 0.0f means the scale factor of the device's main screen.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextFillRect(context, bounds);
    
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [tintedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  // request to keep the original color always.
}

- (void)loadView
{
    [super loadView];
    NSMutableArray *tabCtrls = [NSMutableArray array];
    UIViewController *tabCtrl;

    tabCtrl = [[PREMeViewController alloc] initWithNibName:nil bundle:nil];
    tabCtrl.tabBarItem.title = @"Profile";
    // unselected
    tabCtrl.tabBarItem.image = [PRETabsViewController _imageNamed:@"PRETabsTabIcon0" withTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [tabCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]} forState:UIControlStateNormal];
    // selected
    tabCtrl.tabBarItem.selectedImage = [PRETabsViewController _imageNamed:@"PRETabsTabIcon0" withTintColor:[UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]];
    [tabCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]} forState:UIControlStateSelected];
    [tabCtrls addObject:tabCtrl];

    tabCtrl = [[PREPrezzoViewController alloc] initWithNibName:nil bundle:nil];
    tabCtrl.tabBarItem.title = @"Around me";
    // unselected
    tabCtrl.tabBarItem.image = [PRETabsViewController _imageNamed:@"PRETabsTabIcon1" withTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [tabCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]} forState:UIControlStateNormal];
    // selected
    tabCtrl.tabBarItem.selectedImage = [PRETabsViewController _imageNamed:@"PRETabsTabIcon1" withTintColor:[UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]];
    [tabCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]} forState:UIControlStateSelected];
    [tabCtrls addObject:tabCtrl];

    tabCtrl = [[PRENotificationsViewController alloc] initWithNibName:nil bundle:nil];
    tabCtrl.tabBarItem.title = @"notifications";
    // unselected
    tabCtrl.tabBarItem.image = [PRETabsViewController _imageNamed:@"PRETabsTabIcon2" withTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [tabCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]} forState:UIControlStateNormal];
    // selected
    tabCtrl.tabBarItem.selectedImage = [PRETabsViewController _imageNamed:@"PRETabsTabIcon2" withTintColor:[UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]];
    [tabCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]} forState:UIControlStateSelected];
    [tabCtrls addObject:tabCtrl];

    self.viewControllers = tabCtrls;
    
    // This is a silly fix that ensures the unselected button images are loaded:
    self.selectedIndex = 2;
    self.selectedIndex = 1;
    self.selectedIndex = 0;
}

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

#ifdef __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    UIViewController *vc;
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        vc = [(id)self.selectedViewController topViewController];
    } else {
        vc = self.selectedViewController;
    }
    return vc.supportedInterfaceOrientations;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    
    if ([parent isKindOfClass:[UINavigationController class]]) {
        [(id)parent setNavigationBarHidden:YES];
    }
}

@end
