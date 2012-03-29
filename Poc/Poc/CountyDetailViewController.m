//
//  CountyDetailViewController.m
//  Poc
//
//  Created by Aneesh on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountyDetailViewController.h"
#import "MKMapView+ZoomLevel.h"
@implementation CountyDetailViewController
@synthesize mapView,searchBar;
@synthesize forwardGeocoder = _forwardGeocoder;
@synthesize state;
@synthesize region;
@synthesize geocodeArray;
@synthesize countyName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    NSLog(@"county name is %@",countyName);
    self.mapView.delegate = self;
	self.searchBar.delegate = self;
  
    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(37.4719,-103);
    static MKCoordinateSpan texasSpan = {3.f, 3.f};
	const MKCoordinateRegion txreg = MKCoordinateRegionMake(centerCoord, texasSpan);
   // [self.mapView setCenterCoordinate:centerCoord];
    [self.mapView setRegion:txreg animated:YES]; 
//    CLLocationCoordinate2D  points1[4];
//    points1[0] = CLLocationCoordinate2DMake(37.0004, -103.0448);
//    points1[1] = CLLocationCoordinate2DMake(37.0004, -104.0424);
//    points1[2] = CLLocationCoordinate2DMake(38.0006, -103.0534);
//    points1[3] = CLLocationCoordinate2DMake(38.9996, -104.0489);
//    
//    MKPolygon* poly1 = [MKPolygon polygonWithCoordinates:points1 count:4];
//    poly1.title=@"County 1";
//    [self.mapView addOverlay:poly1];
//    
//    CLLocationCoordinate2D  points2[4];
//    points2[0] = CLLocationCoordinate2DMake(40.0004, -105.0448);
//    points2[1] = CLLocationCoordinate2DMake(40.0004, -108.0424);
//    points2[2] = CLLocationCoordinate2DMake(39.0006, -105.0534);
//    points2[3] = CLLocationCoordinate2DMake(39.9996, -108.0489);
//    
//    
//    MKPolygon* poly2 = [MKPolygon polygonWithCoordinates:points2 count:4];
//      poly1.title=@"County 2";
//    [self.mapView addOverlay:poly2];
//    NSLog(@"zoo level is %d",[self.mapView zoomLevel]);
    self.mapView.zoomEnabled=NO;
    if ([countyName isEqualToString:@"County1"]) {
        
   
    CLLocationCoordinate2D  points3[5];
    points3[0] = CLLocationCoordinate2DMake(37.004, -105.0448);
    points3[1] = CLLocationCoordinate2DMake(37.004, -104.0424);
    points3[2] = CLLocationCoordinate2DMake(38.004, -102.0448);
    points3[3] = CLLocationCoordinate2DMake(39.004,-104.0424);
    points3[4] = CLLocationCoordinate2DMake(40.004,-105.0424);
    
    MKPolygon* poly3 = [MKPolygon polygonWithCoordinates:points3 count:5];
    [self.mapView addOverlay:poly3];
    }
    
    
    if ([countyName isEqualToString:@"County2"]) {
    CLLocationCoordinate2D  points4[4];
    points4[0] = CLLocationCoordinate2DMake(38.1, -106.4);
    points4[1] = CLLocationCoordinate2DMake(38.5, -107.33);
    points4[2] = CLLocationCoordinate2DMake(39.3, -106.12);
    points4[3] = CLLocationCoordinate2DMake(39.67 ,-107.75);
    
    
    MKPolygon* poly4 = [MKPolygon polygonWithCoordinates:points4 count:4];
    [self.mapView addOverlay:poly4];
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(38.5,-106);
        static MKCoordinateSpan texasSpan = {3.f, 3.f};
        const MKCoordinateRegion txreg = MKCoordinateRegionMake(centerCoord, texasSpan);   
        [self.mapView setRegion:txreg];
    }
    
    else if(([countyName length]==0) || ([countyName isEqualToString:@"county"])){
        CLLocationCoordinate2D  points1[4];
        points1[0] = CLLocationCoordinate2DMake(37.0004, -107.0448);
        points1[1] = CLLocationCoordinate2DMake(37.0004, -107.0424);
        points1[2] = CLLocationCoordinate2DMake(38.0006, -108.0534);
        points1[3] = CLLocationCoordinate2DMake(38.9996, -108.0489);
        
        MKPolygon* poly1 = [MKPolygon polygonWithCoordinates:points1 count:4];
        [self.mapView addOverlay:poly1];

        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(38.005,-107);
        static MKCoordinateSpan texasSpan = {3.f, 3.f};
        const MKCoordinateRegion txreg = MKCoordinateRegionMake(centerCoord, texasSpan);   
        [self.mapView setRegion:txreg];
    
    }
        
    int j;
    CLLocationCoordinate2D  pointsDrawn[[geocodeArray count]];
    for (j=0; j<[geocodeArray count]; j++) {
        NSDictionary *dict=[geocodeArray objectAtIndex:j];
        pointsDrawn[j]=CLLocationCoordinate2DMake([[dict valueForKey:@"lat"] floatValue],[[dict valueForKey:@"lng"] floatValue]);;
        NSLog(@"***************%F************%f",[[dict valueForKey:@"lat"] floatValue],[[dict valueForKey:@"lng"] floatValue]);
        
    }
    MKPolygon *polynew = [MKPolygon polygonWithCoordinates:pointsDrawn count:[geocodeArray count]];
    [self.mapView addOverlay:polynew];

    self.mapView.zoomEnabled=NO;

}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"overlay delegtae method");
    
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        
        MKPolygonView*    aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
        if (k==0) {
            aView.fillColor = [UIColor redColor];
            NSLog(@"red");    
        }
        else{ 
            aView.fillColor = [UIColor purpleColor];  
            NSLog(@"purple");    
        }
        
        
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        aView.lineWidth = 3; 
        aView.alpha=.3;
        aView.alpha=.2;
        k=k+1;
        return aView;
        
        
    }
    
    return nil;
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    
//       NSLog(@"zoom level is%d",self.mapView.zoomLevel);
//       if(self.mapView.zoomLevel<6) {
//            NSLog(@"ppped");
//            [self.navigationController popViewControllerAnimated:YES];
//    }
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
