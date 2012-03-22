//
//  MainViewController.m
//  Poc
//
//  Created by Aneesh on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "DashBoardController.h"
@implementation MainViewController
@synthesize controller;
@synthesize userName,passWord;
@synthesize dashBoardController;
@synthesize managedObjectContext = _managedObjectContext;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title=@"Log In";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Flipside View Controller

/*
 *-----------------------------------------------------------------------------
 *	IBAction  methods
 *
 *-----------------------------------------------------------------------------
 */

-(IBAction)send:(id)sender{
   
    dashBoardController=[self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardController"];
    [self.navigationController pushViewController:dashBoardController animated:YES];
}

/*
 *-----------------------------------------------------------------------------
 *	UITextFieldDelegate  methods
 *
 *-----------------------------------------------------------------------------
*/


- (BOOL) textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  	
    [textField resignFirstResponder];
	return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
	return YES;
}
@end
