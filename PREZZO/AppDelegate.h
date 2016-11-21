//
//  AppDelegate.h
//  PREZZO
//
//  Created by Itay Pincas on 11/20/16.
//  Copyright © 2016 Itay Pincas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

