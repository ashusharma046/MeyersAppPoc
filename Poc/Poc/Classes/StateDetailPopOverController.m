//
//  StateDetailPopOverController.m
//  Poc
//
//  Created by Aneesh on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StateDetailPopOverController.h"

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
     NSLog(@"regiion is %f  **********%f",region.center.latitude,region.center.longitude);
    self.title=@"hello";
    UIColor *backgroundImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"popups_bg.png"]];
    self.view.backgroundColor = backgroundImage;
    self.contentSizeForViewInPopover = CGSizeMake(290.0, 120.0);
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, 15,230, 55)];
    lb.text=[NSString stringWithFormat:@"Location  Name is %@",self.stateName];
  //  NSLog(@"lb text is %@",self.stateName);
    lb.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lb];
    UIButton *detailBtn=[UIButton buttonWithType:UIButtonTypeCustom] ;
    [detailBtn setImage:[UIImage imageNamed:@"VINCompareAccessoryButton.png"] 
              forState: UIControlStateNormal];
    
    detailBtn.frame=CGRectMake(230, 15,40, 55);
    detailBtn.titleLabel.text=@"Detail";
    [detailBtn addTarget:self action:@selector(drawDetailMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    
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
