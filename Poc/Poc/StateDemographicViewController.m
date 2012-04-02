//
//  StateDemographicViewController.m
//  Poc
//
//  Created by Aneesh on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StateDemographicViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "State_housing_data.h"

@implementation StateDemographicViewController
@synthesize currentState;
@synthesize delegate=_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
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
    UIColor *backgroundImageColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"popups_bg.png"]];
    navigationBar = [[UINavigationBar alloc] init];

	navigationBar.barStyle = UIBarStyleBlackOpaque;
	[navigationBar setBackgroundColor:[UIColor whiteColor]];
	navigationBar.frame = CGRectMake(0, 0, 330, 50);
	[self.view addSubview:navigationBar];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonClick)];
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.title=@"Demographics";
    item.rightBarButtonItem = rightButton;
    [navigationBar setItems:[NSArray arrayWithObject:item]];
    
    self.contentSizeForViewInPopover = CGSizeMake(330.0, 320.0);
    

    self.view.backgroundColor = backgroundImageColor;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
   
    UILabel *demographicLb=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 220, 55)];
    
    demographicLb.backgroundColor=[UIColor clearColor];
    [self.view addSubview:demographicLb];
    
    UILabel *demographicLb1=[[UILabel alloc] initWithFrame:CGRectMake(10, 105, 220, 55)];
    demographicLb1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:demographicLb1];
    
    UILabel *demographicLb2=[[UILabel alloc] initWithFrame:CGRectMake(10, 160, 280, 55)];
    demographicLb2.backgroundColor=[UIColor clearColor];
    [self.view addSubview:demographicLb2];
    
    
    UILabel *demographicLb3=[[UILabel alloc] initWithFrame:CGRectMake(10, 205, 220, 55)];
    demographicLb3.backgroundColor=[UIColor clearColor];
    [self.view addSubview:demographicLb3];
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"State_housing_data" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *myPred=[NSPredicate predicateWithFormat:@"stateName== %@",currentState];
    request.predicate=myPred;  
    NSError *error;
    NSArray *recordsArray = [context executeFetchRequest:request error:&error]; 
    if ([recordsArray count]>0) {
        
    
        demographicLb.text=[NSString stringWithFormat:@" Population  37,691,912"];
        demographicLb1.text=[NSString stringWithFormat:@" Per capita income $27,344"];
        demographicLb2.text=[NSString stringWithFormat:@"Persons under 18 years 9,691,912"];    
//        demographicLb3.text=[NSString stringWithFormat:@"Affordability %@",[[recordsArray objectAtIndex:0] valueForKey:@"affordability"]]; 
    }

}
-(void)doneButtonClick{

    if (_delegate != nil) {
        [_delegate doneButtonPressed];
    }	

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
