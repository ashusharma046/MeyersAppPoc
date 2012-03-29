#import "Forward_GeocodingViewController.h"
#import <MapKit/MapKit.h>
#import "State.h"
#import "MKMapView+ZoomLevel.h"
#import "CountyDetailViewController.h"
#import "StateViewContrller.h"
#import "MKMapView+ZoomLevel.h"
#import "StateDemographicViewController.h"
#import "AppDelegate.h"
#import "State_housing_data.h"
#import <CoreData/CoreData.h>
#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
@implementation StateViewContrller
@synthesize mapView,searchBar;
@synthesize forwardGeocoder = _forwardGeocoder;
@synthesize state;
@synthesize region;
@synthesize geocodeArray;
@synthesize mianScreenNavigation;
@synthesize countyDetailViewController;
@synthesize popOver=_popOver;
@synthesize stateDetailPopOverController=_stateDetailPopOverController;
@synthesize currentStateName;
@synthesize overLayBackGround;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithState:(State *)st{
    if (self) {
        self.state=st;
    }
    return self;
}
- (id)initRegion:(MKCoordinateRegion )rg{
    if (self) {
        self.region=rg;    
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
  
    self.mapView.delegate = self;
	self.searchBar.delegate = self;
    CLLocationDistance centerToBorderMeters = 400000;
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(region.center.latitude,region.center.longitude);
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance 
    (centerCoord, 
     centerToBorderMeters ,   
     centerToBorderMeters );  
   
    [self.mapView setRegion:rgn animated:YES];
   
    if ((geocodeArray==nil || [geocodeArray count]==0) || [currentStateName isEqualToString:@"Colorado"]) {
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(38,-104);    
        MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance 
        (centerCoord, 
         centerToBorderMeters ,   
         centerToBorderMeters );  
        [self.mapView setRegion:rgn animated:YES];    
        k=0;
        CLLocationCoordinate2D  points2[4];
        points2[0] = CLLocationCoordinate2DMake(40.946714, -108.984375);
        points2[1] = CLLocationCoordinate2DMake(40.963308, -105.095215);
        points2[2] = CLLocationCoordinate2DMake(39.300299, -105.183105);
        points2[3] = CLLocationCoordinate2DMake(39.095963, -108.940430);
        
        
        MKPolygon* poly2 = [MKPolygon polygonWithCoordinates:points2 count:4];
        [self.mapView addOverlay:poly2];
        
        CLLocationCoordinate2D  points3[4];    
        points3[0] = CLLocationCoordinate2DMake(40.963308, -105.095215);
        points3[1] = CLLocationCoordinate2DMake(39.300299, -105.183105);
        points3[2] = CLLocationCoordinate2DMake(39.113014, -102.106934);
        points3[3] = CLLocationCoordinate2DMake(40.913513, -102.128906);
        
        
        MKPolygon* poly3 = [MKPolygon polygonWithCoordinates:points3 count:4];
        [self.mapView addOverlay:poly3];
        
        
        CLLocationCoordinate2D  points4[4];    
        
        points4[0] = CLLocationCoordinate2DMake(39.300299, -105.183105);
        points4[1] = CLLocationCoordinate2DMake(39.113014, -102.106934);
        points4[2] = CLLocationCoordinate2DMake(36.985003, -102.128906);
        points4[3] = CLLocationCoordinate2DMake(36.985003, -105.688477);
        
        
        MKPolygon* poly4 = [MKPolygon polygonWithCoordinates:points4 count:4];
        [self.mapView addOverlay:poly4];
        
        
        CLLocationCoordinate2D  points5[4];    
        
        points5[0] = CLLocationCoordinate2DMake(39.300299, -105.183105);
        points5[1] = CLLocationCoordinate2DMake(39.095963, -108.940430); 
        points5[3] = CLLocationCoordinate2DMake(36.985003, -105.688477);

        points5[2] = CLLocationCoordinate2DMake(36.985003,-109.039307);
        
        
        MKPolygon* poly5 = [MKPolygon polygonWithCoordinates:points5 count:4];
        [self.mapView addOverlay:poly5];
        
        

        
           
    
    
    
        k=0;
        mianScreenNavigation=YES;
    
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped :)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    [self.mapView addGestureRecognizer:tap];

    
    int j;
    if (![currentStateName isEqualToString:@"Colorado"]) {
    CLLocationCoordinate2D  pointsDrawn[[geocodeArray count]];
   
    for (j=0; j<[geocodeArray count]; j++) {
        NSDictionary *dict=[geocodeArray objectAtIndex:j];
        pointsDrawn[j]=CLLocationCoordinate2DMake([[dict valueForKey:@"lat"] floatValue],[[dict valueForKey:@"lng"] floatValue]);;
        
    }
    MKPolygon *polynew = [MKPolygon polygonWithCoordinates:pointsDrawn count:[geocodeArray count]];
    
        
    
    [self.mapView addOverlay:polynew];
    }    
    firstlaunch=1;
    currentCounty=[[NSString alloc] init];
    self.mapView.zoomEnabled=NO;

}






-(void)mapTapped:(UITapGestureRecognizer *)recognizer{
    NSLog(@"map tapped");
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[recognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
    float latitude=coordinate.latitude;
    float longitude=coordinate.longitude;
    
    if( (latitude>=39.300299) && (latitude<=40.946714)){
        if( (longitude>=-108.984375) && (longitude<=-105.095215)){  
            
            [self drawPopOver:[recognizer locationInView:self.view] andCoord:coordinate];
        }
    }
    
    if( (latitude>=39.113014) && (latitude<=40.963308)){
        if( (longitude>=-105.183105) && (longitude<=-102.106934)){  
            
          [self drawPopOver:[recognizer locationInView:self.view] andCoord:coordinate];
        }
    }
    
    
    if( (latitude>=36.985003) && (latitude<=39.300299)){
        if( (longitude>=-105.688477) && (longitude<=-102.106934)){  
            
             [self drawPopOver:[recognizer locationInView:self.view] andCoord:coordinate];
        }
    }

    if( (latitude>=36.985003) && (latitude<=39.300299)){
        if( (longitude>=-109.039307) && (longitude<=-105.183105)){  
            
            [self drawPopOver:[recognizer locationInView:self.view] andCoord:coordinate];
        }
    }
        

    //[self stateHosingDataForStateName:currentStateName withView:a];
       
}
-(void) drawPopOver:(CGPoint)pt andCoord:(CLLocationCoordinate2D) coordinate{
    
    currentCounty=[self countyForGeocodeForLatitude:coordinate.latitude andLongitude:coordinate.longitude];
    self.stateDetailPopOverController=[[StateDetailPopOverController alloc] initWithStateName:[self countyForGeocodeForLatitude:coordinate.latitude andLongitude:coordinate.longitude]]  ; 
    self.stateDetailPopOverController.delegate=self;
    self.popOver=[[UIPopoverController alloc] initWithContentViewController:self.stateDetailPopOverController];
    
    
    CGRect rect=CGRectMake(pt.x,pt.y, 290, 120);
    [self.popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    

}
-(IBAction)showDemogrphics:(id)sender{
    stateDemographicViewController=[[StateDemographicViewController alloc] init];
    stateDemographicViewController.currentState=currentStateName;
    stateDemographicViewController.delegate=self;
    stateDemographicViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    stateDemographicViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:stateDemographicViewController animated:NO];
    stateDemographicViewController.view.superview.frame= CGRectMake(252,200, 332, 507);
}
-(IBAction)showEconomicsics:(id)sender{
    stateEconomicsViewController=[[StateEconomicsViewController alloc] init];
    stateEconomicsViewController.currentState=currentStateName;
    stateEconomicsViewController.delegate=self;
    stateEconomicsViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    stateEconomicsViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:stateEconomicsViewController animated:YES];
    stateEconomicsViewController.view.superview.frame= CGRectMake(252,200, 332, 507);
}
-(IBAction)showHousing:(id)sender{
    stateHousingViewController=[[StateHousingViewController alloc] init];
     stateHousingViewController.currentState=currentStateName;
     stateHousingViewController.delegate=self;
     stateHousingViewController.modalPresentationStyle=UIModalPresentationFormSheet;
     stateHousingViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
     [self presentModalViewController: stateHousingViewController animated:YES];
     stateHousingViewController.view.superview.frame= CGRectMake(252,200, 332, 507);

  
    
//    self.popOver=[[UIPopoverController alloc] initWithContentViewController:stateHousingViewController];
//    CGRect rect=CGRectMake(252,200, 330, 38);
//    [self.popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];     
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
    MKPolygonView*    aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
    if ([currentStateName isEqualToString:@"Colorado"]) {
        
      if ([overlay isKindOfClass:[MKPolygon class]])
      {
        
        
        if (k==0) {
        aView.fillColor = [UIColor redColor];
            NSLog(@"red");    
        }
        else if(k==1){
        aView.fillColor = [UIColor purpleColor];  
        NSLog(@"purple");    
        }
        else if(k==2){
        aView.fillColor = [UIColor greenColor];
        NSLog(@"yellow");       
        }
        else{
        aView.fillColor = [UIColor yellowColor];    
        }
        
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        aView.lineWidth = 3; 
        aView.alpha=.3;
        aView.alpha=.2;
        k=k+1;
        return aView;
      
        
      }
    }
    else{
        NSLog(@"different color");
        aView.fillColor = overLayBackGround;
        aView.alpha=.2;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (appDelegate.settingStatus > 0) {
            [self stateHosingDataForStateName:currentStateName withView:aView];
        }
        return aView;
    }
    return nil;
}



-(NSString *)countyForGeocodeForLatitude : (float)latitude andLongitude:(float)longitude{
    
    NSString *stateName=@"county 4";
    
           
       if( (latitude>=39.300299) && (latitude<=40.946714)){
            if( (longitude>=-108.984375) && (longitude<=-105.095215)){  
                
                stateName= @"County1";
            }
       }
        
       if( (latitude>=39.113014) && (latitude<=40.963308)){
          if( (longitude>=-105.183105) && (longitude<=-102.106934)){  
            
            stateName= @"County2";
           }
       }
    
      if( (latitude>=36.985003) && (latitude<=39.300299)){
          if( (longitude>=-105.688477) && (longitude<=-102.106934)){  
            
            stateName= @"County 3";
          }
      }
    
    return stateName;
}


#pragma mark - BSForwardGeocoderDelegate methods

- (void)forwardGeocoderConnectionDidFail:(BSForwardGeocoder *)geocoder withErrorMessage:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
													message:errorMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
    
}


- (void)forwardGeocodingDidSucceed:(BSForwardGeocoder *)geocoder withResults:(NSArray *)results
{
    
    for (int i = 0, resultCount = [results count]; i < resultCount; i++) {
        BSKmlResult *place = [results objectAtIndex:i];
        
        // Add a placemark on the map
        CustomPlacemark *placemark = [[CustomPlacemark alloc] initWithRegion:place.coordinateRegion] ;
        placemark.title = place.address;
        placemark.subtitle = place.countryName;
        
        [self.mapView addAnnotation:placemark];	
    }
    
    if ([results count] == 1) {
        BSKmlResult *place = [results objectAtIndex:0];
        
        // Zoom into the location		
        [self.mapView setRegion:place.coordinateRegion animated:YES];
    }
    
    // Dismiss the keyboard
    [self.searchBar resignFirstResponder];
}

- (void)forwardGeocodingDidFail:(BSForwardGeocoder *)geocoder withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage
{
    NSString *message = @"";
    
    switch (errorCode) {
        case G_GEO_BAD_KEY:
            message = @"The API key is invalid.";
            break;
            
        case G_GEO_UNKNOWN_ADDRESS:
            message = [NSString stringWithFormat:@"Could not find %@", @"searchQuery"];
            break;
            
        case G_GEO_TOO_MANY_QUERIES:
            message = @"Too many queries has been made for this API key.";
            break;
            
        case G_GEO_SERVER_ERROR:
            message = @"Server error, please try again.";
            break;
            
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" 
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
    
}


#pragma mark - UI Events
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
	NSLog(@"Searching for: %@", self.searchBar.text);
	if (self.forwardGeocoder == nil) {
		self.forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	// Forward geocode!    
#if NS_BLOCKS_AVAILABLE
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil success:^(NSArray *results) {
        [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results];
    } failure:^(int status, NSString *errorMessage) {
        if (status == G_GEO_NETWORK_ERROR) {
            [self forwardGeocoderConnectionDidFail:self.forwardGeocoder withErrorMessage:errorMessage];
        }
        else {
            [self forwardGeocodingDidFail:self.forwardGeocoder withErrorCode:status andErrorMessage:errorMessage];
        }
    }];
#else
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil];    
#endif
}

#pragma mark - MKMap methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
	
	if ([annotation isKindOfClass:[CustomPlacemark class]]) {
		MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
		newAnnotation.pinColor = MKPinAnnotationColorGreen;
		newAnnotation.animatesDrop = YES; 
		newAnnotation.canShowCallout = YES;
		newAnnotation.enabled = YES;
		
		
		NSLog(@"Created annotation at: %f %f", ((CustomPlacemark*)annotation).coordinate.latitude, ((CustomPlacemark*)annotation).coordinate.longitude);
		
		[newAnnotation addObserver:self
						forKeyPath:@"selected"
						   options:NSKeyValueObservingOptionNew
						   context:@"GMAP_ANNOTATION_SELECTED"];
		
		
		
		return newAnnotation;
	}
	
	return nil;
}

-(UIView *)stateHosingDataForStateName:(NSString *)str withView:(MKPolygonView *)av{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"State_housing_data" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSError *error;
   
    NSPredicate *pred= [NSPredicate predicateWithFormat:@"stateName = %@",currentStateName]; 
    [request setPredicate:pred];
     NSArray *staterecordsArray = [context executeFetchRequest:request error:&error]; 
    State_housing_data *stData=[staterecordsArray objectAtIndex:0];
    
    if (appDelegate.settingStatus==1) {
         int newhomeSale= [[stData valueForKey:@"new_Home_Sales"] intValue];  
         if (newhomeSale>0 && newhomeSale<=20000) {
            av.fillColor=[UIColor redColor];
         }
         else if(newhomeSale>20000 && newhomeSale<=80000){
            av.fillColor=[UIColor magentaColor];
         }
         else if(newhomeSale>80000 && newhomeSale<100000){
            av.fillColor=[UIColor greenColor];
         }

        
    }
    else if(appDelegate.settingStatus==2){
        int new_Home_Price=[[stData valueForKey:@"new_Home_Price"] intValue];
        if (new_Home_Price>=0 && new_Home_Price<=20000) {
            av.fillColor=[UIColor redColor];
        }
        else if(new_Home_Price>20000 && new_Home_Price<=80000){
            av.fillColor=[UIColor blueColor];
        }
        else if(new_Home_Price>80000){
            av.fillColor=[UIColor grayColor];
        }

                
    }
    else if(appDelegate.settingStatus==3){
       int affordability=[[stData valueForKey:@"affordability"] intValue];
        if (affordability>=0 && affordability<=20000) {
            av.fillColor=[UIColor redColor];
        }
        else if(affordability>20000 && affordability<=80000){
            av.fillColor=[UIColor blueColor];
        }
        else if(affordability>80000 ){
            av.fillColor=[UIColor purpleColor];
        }

    }
    else if(appDelegate.settingStatus==4){
        int apartment_occupency=[[stData valueForKey:@"apartment_occupency"] intValue];
        if (apartment_occupency>0 && apartment_occupency<=20000) {
            av.fillColor=[UIColor redColor];
        }
        else if(apartment_occupency>20000 && apartment_occupency<=80000){
            av.fillColor=[UIColor blueColor];
        }
        else if(apartment_occupency>80000 ){
            av.fillColor=[UIColor purpleColor];
        }

    }
    
    return av;
    
   }

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context{
	
    NSLog(@"key value changed");
	NSString *action = (__bridge_transfer NSString*)context;
	
	// We only want to zoom to location when the annotation is actaully selected. This will trigger also for when it's deselected
	if([[change valueForKey:@"new"] intValue] == 1 && [action isEqualToString:@"GMAP_ANNOTATION_SELECTED"])  {
		if ([((MKAnnotationView*) object).annotation isKindOfClass:[CustomPlacemark class]]) {
			CustomPlacemark *place = ((MKAnnotationView*) object).annotation;
			
			// Zoom into the location		
			[self.mapView setRegion:place.coordinateRegion animated:TRUE];
			NSLog(@"annotation selected: %f %f", ((MKAnnotationView*) object).annotation.coordinate.latitude, ((MKAnnotationView*) object).annotation.coordinate.longitude);
		}
	}
}



-(void)doneButtonPressed{
	[self.modalViewController dismissModalViewControllerAnimated:YES];
}

-(void)drawDetailedMap{
   
     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
