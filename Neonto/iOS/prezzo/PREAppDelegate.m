#import "PREAppDelegate.h"
#import "PRECampaignViewController.h"
#import "PREDataSheetListData1.h"
#import "PREAdViewController.h"
#import "PREAdvertiserViewController.h"
#import "PREPrezzoViewController.h"
#import "PRETabsViewController.h"
#import "PREListItem1ViewController.h"
#import "PREMeViewController.h"
#import "PRENotificationsViewController.h"


@implementation UINavigationController (StatusBarStyleOverride)
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end


// Dummy class for distinguishing root navigation controller.
@interface PRERootNavController : UINavigationController @end
@implementation PRERootNavController @end


@interface PREAppDelegate ()
@property (nonatomic) UIViewAnimationOptions transitionAnimation;
@end


@implementation PREAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.dataSheetListData1 = [[PREDataSheetListData1 alloc] init];
    UIColor *baseTintColor = [UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0];
    [UIView appearanceWhenContainedIn:[PRECampaignViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PREAdViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PREAdvertiserViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PREPrezzoViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PRETabsViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PREListItem1ViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PREMeViewController class], nil].tintColor = baseTintColor;
    [UIView appearanceWhenContainedIn:[PRENotificationsViewController class], nil].tintColor = baseTintColor;
    [UINavigationBar appearanceWhenContainedIn:[PRERootNavController class], nil].tintColor = baseTintColor;
    [UINavigationBar appearanceWhenContainedIn:[PRETabsViewController class], nil].tintColor = baseTintColor;
    
    UIColor *primaryTintColor = [UIColor colorWithRed:0.752376287 green:0.919842246 blue:0.934428625 alpha:1.0];
    [UITabBar appearance].barTintColor = primaryTintColor;
    [UINavigationBar appearanceWhenContainedIn:[PRERootNavController class], nil].barTintColor = primaryTintColor;
    [UINavigationBar appearanceWhenContainedIn:[PRETabsViewController class], nil].barTintColor = primaryTintColor;
    
    [UINavigationBar appearanceWhenContainedIn:[PRERootNavController class], nil].titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
        };
    [UINavigationBar appearanceWhenContainedIn:[PRETabsViewController class], nil].titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
        };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [PRERootNavController class], nil]
        setTitleTextAttributes: @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]
        } forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [PRETabsViewController class], nil]
        setTitleTextAttributes: @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.572306753 blue:0.837421346 alpha:1.0]
        } forState:UIControlStateNormal];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self _goToFirstLaunch];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)_goToFirstLaunch
{
    PRETabsViewController *firstLaunchViewCtrl = [[PRETabsViewController alloc] init];
    [firstLaunchViewCtrl setSelectedIndex:1];
    PRERootNavController *nav = [[PRERootNavController alloc] initWithRootViewController:firstLaunchViewCtrl];
    nav.delegate = (id)self;
    nav.interactivePopGestureRecognizer.delegate = (id)self;  // swipe back doesn't work without.
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
}

#pragma mark --- UINavigationControllerDelegate ---

#ifdef __IPHONE_9_0
- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
#else
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
#endif
{
    return navigationController.topViewController.supportedInterfaceOrientations;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        switch (fromVC.modalTransitionStyle) {
            case UIModalTransitionStyleCoverVertical:
                return nil; // use default horizontal slide transition
            case UIModalTransitionStyleFlipHorizontal:
                self.transitionAnimation = UIViewAnimationOptionTransitionFlipFromLeft;
                break;
            case UIModalTransitionStyleCrossDissolve:
                self.transitionAnimation = UIViewAnimationOptionTransitionCrossDissolve;
                break;
            case UIModalTransitionStylePartialCurl:
                self.transitionAnimation = UIViewAnimationOptionTransitionCurlDown;
                break;
        };
    } else {
        switch (toVC.modalTransitionStyle) {
            case UIModalTransitionStyleCoverVertical:
                return nil; // use default horizontal slide transition
            case UIModalTransitionStyleFlipHorizontal:
                self.transitionAnimation = UIViewAnimationOptionTransitionFlipFromRight;
                break;
            case UIModalTransitionStyleCrossDissolve:
                self.transitionAnimation = UIViewAnimationOptionTransitionCrossDissolve;
                break;
            case UIModalTransitionStylePartialCurl:
                self.transitionAnimation = UIViewAnimationOptionTransitionCurlUp;
                break;
        };
    }
    return self;
}

#pragma mark --- UIViewControllerAnimatedTransitioning ---

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView transitionFromView:fromVC.view
                        toView:toVC.view
                      duration:[self transitionDuration:transitionContext]
                       options:self.transitionAnimation
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:finished];
                    }];
}

#pragma mark --- UIApplicationDelegate ---

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [self.dataSheetListData1 releaseCachedData];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Called when the application receives an URL from the operating system.
    // By default we provide a '/screen' route that allows external apps like WatchKit to open screens.
    NSRange range;
    if ((range = [url.resourceSpecifier rangeOfString:@"//screen/"]).location == 0) {
        NSString *targetScreen = [url.resourceSpecifier substringFromIndex:range.length];
        #pragma unused (targetScreen)  // avoid compiler warning if we have no routes



        // If no other match, default to the first launch screen
        id viewCtrl = [[PRETabsViewController alloc] init];
        [self.window.rootViewController presentViewController:viewCtrl animated:NO completion:NULL];
    }

    return YES;
}


@end
