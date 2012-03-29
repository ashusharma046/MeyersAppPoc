//
//  StateDetailPopOverController.m
//  Poc
//
//  Created by Aneesh on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StateDetailPopOverController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "State_housing_data.h"

@implementation StateDetailPopOverController
@synthesize  delegate;
@synthesize stateName=_stateName;
@synthesize region;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithStateName:(NSString *)stName withRegion:(MKCoordinateRegion )rg{
    self = [super init];
   
    if (self) {
        self.stateName=stName;
        self.region=rg;
     
    }
    return self;
}
- (id)initWithStateName:(NSString *)stName{
    self = [super init];
    
    if (self) {
        self.stateName=stName;
      
        
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"hello";
    UIColor *backgroundImageColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"popups_bg.png"]];
    self.view.backgroundColor = backgroundImageColor;
    self.contentSizeForViewInPopover = CGSizeMake(290.0, 100.0);
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, 15,230, 55)];
    lb.text=[NSString stringWithFormat:@"Location  Name is %@",self.stateName];
    lb.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lb];
    UIButton *detailBtn=[UIButton buttonWithType:UIButtonTypeCustom] ;
    [detailBtn setImage:[UIImage imageNamed:@"VINCompareAccessoryButton.png"] 
              forState: UIControlStateNormal];
    
    detailBtn.frame=CGRectMake(230, 15,40, 55);
    detailBtn.titleLabel.text=@"Detail";
    [detailBtn addTarget:self action:@selector(drawDetailMap) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:detailBtn];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"State_housing_data" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *myPred=[NSPredicate predicateWithFormat:@"stateName==%@",self.stateName];
    request.predicate=myPred;  
    NSError *error;
    NSArray *recordsArray = [context executeFetchRequest:request error:&error]; 
    NSLog(@"record array count is %d",[recordsArray count]);
  
    for (State_housing_data *rec in recordsArray) {
        NSLog(@"matched string is %@and price is %@ and home sales is %@  ",rec.stateName,rec.new_Home_Price,rec.new_Home_Sales);
    }
   
}

-(void)drawDetailMap{
    [delegate drawDetailedMap];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
