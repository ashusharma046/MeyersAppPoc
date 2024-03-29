//
//  SettingsViewController.m
//  Poc
//
//  Created by Aneesh on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
@implementation SettingsViewController
@synthesize delegate=_delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"Settings";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.toolbar.tintColor = [UIColor blackColor];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"app delgate setting status is %d",appDelegate.settingStatus);
    if (appDelegate.settingStatus>0) {
        checkmarkRow=appDelegate.settingStatus-1;
    }
    
    
   
}

/*

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	return YES;
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"New Home Sales";
    }   
    if (indexPath.row==1) {
        cell.textLabel.text=@"New Home Price";
        
    } 
    else if (indexPath.row==2) {
        cell.textLabel.text=@"Affordability";
        
    } 
    else if (indexPath.row==3) {
        cell.textLabel.text=@"Apartment Occupency";
        
    } 
   
    if (indexPath.row==checkmarkRow) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.settingStatus=indexPath.row+1;
    NSIndexPath *checkedPath=[NSIndexPath indexPathForRow:checkmarkRow inSection:indexPath.section];	
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastindex]; 
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:checkedPath]; 
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) 
    {   
        oldCell.accessoryType = UITableViewCellAccessoryNone;   
        
    }
     checkedCell.accessoryType = UITableViewCellAccessoryNone; 
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];     
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone) 
    {   
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;  
    }  
    lastindex=indexPath;
}

@end
