//
//  PRZAdvertiserTVC.h
//  PREZZO
//
//  Created by Itay Pincas on 12/3/16.
//  Copyright © 2016 Itay Pincas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRZAdvertiserTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *advertiserCoverImageView;
- (IBAction)remindMeToggle:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *remindMeToggleButton;
@end
