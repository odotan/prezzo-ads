//
//  PRZMainAdvertisersTVC.h
//  PREZZO
//
//  Created by Itay Pincas on 11/21/16.
//  Copyright © 2016 Itay Pincas. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;
@import FirebaseCore;


@interface PRZMainAdvertisersTVC : UITableViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
