
#import "Forward_GeocodingViewController.h"
#import <MapKit/MapKit.h>
#import "State.h"
#import "MKMapView+ZoomLevel.h"
#import "StateViewContrller.h"

#define GEORGIA_TECH_LATITUDE 37.46
#define GEORGIA_TECH_LONGITUDE 122.25
#define ZOOM_LEVEL 14
#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395


@implementation Forward_GeocodingViewController
@synthesize forwardGeocoder = _forwardGeocoder;
@synthesize mapView = _mapView;
@synthesize searchBar = _searchBar;
@synthesize stateDetailPopOverController=_stateDetailPopOverController;
@synthesize popOver=_popOver;
@synthesize currentState;
@synthesize region1;
@synthesize stateViewContrller;




- (void)viewDidLoad 
{
    [super viewDidLoad];

	//self.mapView.showsUserLocation = YES;
	self.mapView.delegate = self;
	self.searchBar.delegate = self;
     
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://econym.org.uk/gmap/states.xml"]];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    stateArray=[[NSMutableArray alloc] init];
    parser=[[NSXMLParser alloc] initWithData:data];
    parser.delegate=self;
    [parser parse];
    
    k=0;
    [self drawOverLay];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped :)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    [self.mapView addGestureRecognizer:tap];
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude=GEORGIA_TECH_LATITUDE;
    centerCoordinate.longitude=GEORGIA_TECH_LONGITUDE;
    self.mapView.zoomEnabled=NO;
    
    
  
    CLLocationCoordinate2D cord;
    cord.latitude=37.423617;
    cord.longitude= -122.220154;
    CLLocationDistance centerToBorderMeters = 4000000;
   CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(cord.latitude,cord.longitude);
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance 
    (centerCoord, 
     centerToBorderMeters ,   
     centerToBorderMeters );  
    
    [self.mapView setRegion:rgn animated:YES];

}
//}

//*****************************************************************************************************************//

  //   Tap on Map                                                                                            
  //   1) Get the Geocode of toch point                     
  //   2) Get Info of State for Geo Code Pont and Present a Popover of details
                                                                                                                //
 //*****************************************************************************************************************//




-(void)mapTapped:(UITapGestureRecognizer *)recognizer{
  
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[recognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
    NSLog(@"lat and long are %F  ******%f",coordinate.latitude,coordinate.longitude);
    currentState=[self stateForGeocodeForLatitude:coordinate.latitude andLongitude:coordinate.longitude];
    CGPoint pt=[recognizer locationInView:self.view];
    self.stateDetailPopOverController=[[StateDetailPopOverController alloc] initWithStateName:currentState withRegion:[self regionForStateName:currentState]];  
    
    //self.stateDetailPopOverController=[[StateDetailPopOverController alloc] initWithStateName:currentState];    
    self.stateDetailPopOverController.delegate=self;
    self.popOver=[[UIPopoverController alloc] initWithContentViewController:self.stateDetailPopOverController];
   
       
    CGRect rect=CGRectMake(pt.x,pt.y, 290, 120);
    [self.popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
     NSLog(@"p3");
    timer = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                            target: self
                                           selector:@selector(onTick)
                                          userInfo: nil repeats:NO];    
    
    
    region1 = [self regionForStateName:currentState];
    [self.mapView setRegion:region1 animated:YES];  
    [self.mapView setCenterCoordinate:region1.center];
  
}
- (void)zoomToFitOverlays {
   // [self.mapView zoomToFitOverlaysAnimated:YES];
}


-(void)onTick{
   
    //[self.popOver dismissPopoverAnimated:YES];
    [timer invalidate];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{ 


}

//*****************************************************************************************************************//

   // Draw OverLay                                                                                           
   //   1) Create a Polygon of all geomatric Points of a state                    
   //   2) Draw Polygon on Map
   //
   //*****************************************************************************************************************//



-(void) drawOverLay{

     int i;
     for (i=0;i<[stateArray count] ; i++) {
     State *st=[stateArray objectAtIndex:i];
     CLLocationCoordinate2D  points2[[st.geoArray count]];
    
     int j;
     for (j=0; j<[st.geoArray count]; j++) {
     NSDictionary *dict=[st.geoArray objectAtIndex:j];
     points2[j]=CLLocationCoordinate2DMake([[dict valueForKey:@"lat"] floatValue],[[dict valueForKey:@"lng"] floatValue]);;
     
     }
     MKPolygon *poly2 = [MKPolygon polygonWithCoordinates:points2 count:[st.geoArray count]];
    [self.mapView addOverlay:poly2];
       
    }

}


-(MKCoordinateRegion ) regionForStateName:(NSString *)stateName{
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    int i;
    NSNumber *minLat;
    NSNumber *maxLat;
    float minLan;
    float maxLan;
    for (i=0;i<[stateArray count] ; i++) {
        State *st=[stateArray objectAtIndex:i];
        if ([st.name isEqualToString:stateName]) {
            minLat=[st.geoArray valueForKeyPath:@"@min.lat"];
            maxLat=[st.geoArray valueForKeyPath:@"@max.lat"];
            minLan=[self minLongitudeForState:st];
            maxLan=[self maxLongitudeForState:st];
            NSLog(@"find the match %@",st.name);
        }
        
    }
    
    region.center.longitude = (minLan + minLan) / 2.0;
    region.center.latitude = ([minLat floatValue] + [maxLat floatValue]) / 2.0;
    region.span.longitudeDelta = maxLan - minLan;
    region.span.latitudeDelta = [maxLat floatValue] - [minLat floatValue];
       
    
    return region; 

}

/*
 *-----------------------------------------------------------------------------
 *	Get State for a Geocode
 *
 *-----------------------------------------------------------------------------
 */
-(NSString *)stateForGeocodeForLatitude : (float)latitude andLongitude:(float)longitude{
    int i;
    NSNumber *minLat;
    NSNumber *maxLat;
    float minLan;
    float maxLan;
    NSString *stateName;
    
    for (i=0;i<[stateArray count] ; i++) {
        
        State *st=[stateArray objectAtIndex:i];
        minLat=[st.geoArray valueForKeyPath:@"@min.lat"];
        maxLat=[st.geoArray valueForKeyPath:@"@max.lat"];
        minLan=[self minLongitudeForState:st];
        maxLan=[self maxLongitudeForState:st];

            if( (latitude>=[minLat floatValue]) && (latitude<=[maxLat floatValue])){
            if( (longitude>=minLan) && (longitude<=maxLan)){  
               
                stateName= st.name;
            }
        }

    }
    return stateName;
}

/*
 *-----------------------------------------------------------------------------
 *	Get Geo array for a  StateName
 *
 *-----------------------------------------------------------------------------
 */
-(NSArray *)geoArrayForstateName:(NSString *) stName{
    int i;
    NSArray *ar=nil;
    for (i=0;i<[stateArray count] ; i++) {
          State *st=[stateArray objectAtIndex:i];
        if ([st.name isEqualToString:stName]) {
            return st.geoArray;
        }
            
        
    
    }
    return ar;
    
}


/*
 *-----------------------------------------------------------------------------
 *	MKOverlay Delegate methods
 *
 *-----------------------------------------------------------------------------
 */

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        int j=0;
        MKPolygonView*    aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
        if (k<[stateArray count]) {
            State *st=[stateArray objectAtIndex:k];
           
        aView.fillColor = [self colorFromHexString:st.color];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        aView.lineWidth = 3; 
        aView.alpha=.3;
        k=k+1;
        }  
        else{
            
            if(j==0){aView.fillColor = [UIColor redColor];}
            else if(j==1){
            aView.fillColor = [UIColor yellowColor];
            }
            else{
            aView.fillColor = [UIColor purpleColor];
            }
            
            aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
            aView.lineWidth = 3; 
            aView.alpha=.3;
            j=j+1;
        }
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





/*
 
 *-----------------------------------------------------------------------------
 *	NSXmlParse Delegate methods
 *
 *-----------------------------------------------------------------------------
 
*/






-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
       if(!currentStringValue){
        currentStringValue = [[NSMutableString alloc] init];
    }   
    
    [currentStringValue setString:elementName];
    
    if([elementName isEqualToString:@"state"])
    { 
        if(!state){   
            state=[[State alloc] init];
        }   
        state.name=[attributeDict valueForKey:@"name"];
        state.color=[attributeDict valueForKey:@"colour"];
    }
    if([elementName isEqualToString:@"point"]){
        
        
        if(!geoArray){   
            geoArray=[[NSMutableArray alloc] init];
        }   
        NSMutableDictionary *pt=[[NSMutableDictionary alloc] init];
        [pt setValue:[attributeDict valueForKey:@"lat"] forKey:@"lat"];
        [pt setValue:[attributeDict valueForKey:@"lng"] forKey:@"lng"];
        [geoArray addObject:pt];
       
        pt=nil;
        
        
    }
} 

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"state"]){
      
        [stateArray addObject:state];
        state.geoArray=[NSMutableArray arrayWithArray:geoArray];
        state=nil;
        state.geoArray=nil; 
        geoArray=nil;
    }
    if([elementName isEqualToString:@"point"]){
       
    }
    if([elementName isEqualToString:@"states"]){
       
    }

    currentStringValue=nil;
    
    
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
  
}

/*
 *-----------------------------------------------------------------------------
 *	Hes string to color  method
 *
 *-----------------------------------------------------------------------------
*/

- (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}



#pragma mark - Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    self.mapView = nil;
    self.searchBar = nil;
}


/*
 *-----------------------------------------------------------------------------
 *	StateDetailPopOverControllerDelegate  methods
 *
 *-----------------------------------------------------------------------------
 */

-(void) removePopOver{
    [self.stateDetailPopOverController dismissModalViewControllerAnimated:YES];
}




/*
*-----------------------------------------------------------------------------
 *	Methods for finding mimimum and maximum longitude of a Stae
 *
*-----------------------------------------------------------------------------
*/



-(float)minLongitudeForState:(State *)st{
    
    int i;
    float min1=[[[st.geoArray objectAtIndex:0] valueForKey:@"lng"] floatValue];
    for(i=0;i<[st.geoArray count];i++){
        float currentLng= [[[st.geoArray objectAtIndex:i] valueForKey:@"lng"] floatValue];   
        if (currentLng < min1) {
            min1=currentLng; 
        }    
        else{
            
            
        }
        
    }
    
    return min1;
}
-(float)maxLongitudeForState:(State *)st{
    
    int i;
    float max1=[[[st.geoArray objectAtIndex:0] valueForKey:@"lng"] floatValue];
    for(i=0;i<[st.geoArray count];i++){
        float currentLng= [[[st.geoArray objectAtIndex:i] valueForKey:@"lng"] floatValue];   
        
        if (currentLng > max1) {
            max1=currentLng; 
        }    
        else{
            
            
        }
        
    }
    
    return max1;
}

-(void)drawDetailedMap{
    NSLog(@"hello");
    
    [self.popOver dismissPopoverAnimated:YES];
    stateViewContrller=[self.storyboard instantiateViewControllerWithIdentifier:@"StateViewContrller"];
    stateViewContrller.region=region1;
    stateViewContrller.mianScreenNavigation=YES;
    stateViewContrller.geocodeArray=[self geoArrayForstateName:currentState];
    stateViewContrller.currentStateName=currentState;
    [self.navigationController pushViewController:stateViewContrller animated:YES];
    

}

@end
