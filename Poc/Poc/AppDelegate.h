//
//  AppDelegate.h
//  Poc
//
//  Created by Aneesh on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
   @private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;


}

@property (strong, nonatomic) UIWindow *window;

@end
