//
//  AppDelegate.h
//  Poc
//
//  Created by Aneesh on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    NSInteger settingStatus;
    BOOL isDatatableFilled;
   @private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
     

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign ) NSInteger settingStatus;
@property (nonatomic,assign ) BOOL isDatatableFilled;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
