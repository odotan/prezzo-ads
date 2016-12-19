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

#import <UIKit/UIKit.h>
#import "PREDataSheet.h"

#import "PRECampaignBackgroundShapeView.h"

@interface PRECampaignViewController : UIViewController

@property (nonatomic) NSDictionary *overrideElementLayoutDescriptors;
@property (nonatomic) CGFloat maxDisplayHeight;
@property (nonatomic) CGFloat layoutYOffset;

@property (nonatomic, readonly) CGSize contentSize;

- (void)sizeToFitContentHeight;


- (void)takeValuesFromDataSheet:(id)dataSheet atRow:(NSInteger)row;

@property (nonatomic, weak) UIViewController *containerViewController;

@end


@interface PRECampaignViewControllerCollectionCell : UICollectionViewCell

@property (nonatomic) PRECampaignViewController *containedViewController;

@end


@interface PRECampaignViewControllerTableCell : UITableViewCell

@property (nonatomic) PRECampaignViewController *containedViewController;

@end
