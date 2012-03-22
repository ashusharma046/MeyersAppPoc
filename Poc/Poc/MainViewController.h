//
//  MainViewController.h
//  Poc
//
//  Created by Aneesh on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"
#import "DashBoardController.h"
@interface MainViewController : UIViewController < UIPopoverControllerDelegate,UITextFieldDelegate>{
    MapViewController *controller;
    IBOutlet UITextField *userName;
    IBOutlet UITextField *passWord;
    DashBoardController *dashBoardController;
}
@property(nonatomic,retain) MapViewController *controller;
@property(nonatomic,retain) DashBoardController *dashBoardController;
@property(nonatomic,retain) IBOutlet UITextField *userName;
@property(nonatomic,retain) IBOutlet UITextField *passWord;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(IBAction)send:(id)sender;
@end
