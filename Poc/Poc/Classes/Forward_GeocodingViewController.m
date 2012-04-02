
#import "Forward_GeocodingViewController.h"
#import <MapKit/MapKit.h>
#import "State.h"
#import "MKMapView+ZoomLevel.h"
#import "StateViewContrller.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "BottemView.h"

#import "State_housing_data.h"
#define GEORGIA_TECH_LATITUDE 37.46
#define GEORGIA_TECH_LONGITUDE 122.25
#define ZOOM_LEVEL 14
#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395


#define kViewHeight 748
#define kViewWidth 1024
#define kResultBarHeight 135

@implementation Forward_GeocodingViewController
@synthesize forwardGeocoder = _forwardGeocoder;
@synthesize mapView = _mapView;
@synthesize searchBar = _searchBar;
@synthesize stateDetailPopOverController=_stateDetailPopOverController;
@synthesize popOver=_popOver;
@synthesize currentState;
@synthesize region1;
@synthesize stateViewContrller;
@synthesize managedObjectContext;



- (void)viewDidLoad 
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"app delgate setting status is %d",appDelegate.settingStatus);
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
    self.mapView.zoomEnabled=YES;
    
    //set us map
  
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
    
    NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Poc" ofType:@"sqlite"];
    if (!defaultStorePath) {
    NSLog(@"file exist at defalut store");
    }
    else{
        NSLog(@"no datat  filled");
    }
    self.mapView.zoomEnabled=NO;
    if (!appDelegate.isDatatableFilled) {
       [self fillDataTable];  
        NSLog(@"filling data");
        appDelegate.isDatatableFilled=YES;
    }
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(settingDetails:)];      
    self.navigationItem.rightBarButtonItem = anotherButton;
  
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.settingStatus==1) {
        [self reDrawMapView];
        [self setBottemViewForNewHomeSales];    
    
    }
    else if(appDelegate.settingStatus==2){
        [self reDrawMapView];
        [self setBottemViewForNewHomePrice]; 
    
    }
    else if(appDelegate.settingStatus==3){
        [self reDrawMapView];
        [self setBottemViewForaffordabilityView]; 
    }
    else if(appDelegate.settingStatus==4){
        [self reDrawMapView];
        [self setBottemViewForapartmentoccupencyView]; 
    }
    
}


-(void) removeBootemView:(UIButton *)sender{
    [bView removeFromSuperview];
    [sender removeFromSuperview];
}
-(void) reDrawMapView{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"State_housing_data" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
   
    NSError *error;
    staterecordsArray = [context executeFetchRequest:request error:&error]; 
//    for (State_housing_data *rec in staterecordsArray) {
//    }
    
    [self.mapView removeOverlays:[self.mapView overlays]];
    [self drawOverLay]; 
}

//*****************************************************************************************************************//

  //   Tap on Map                                                                                            
  //   1) Get the Geocode of toch point                     
  //   2) Get Info of State for Geo Code Pont and Present a Popover of details
                                                                                                                //
 //*****************************************************************************************************************//




-(void)mapTapped:(UITapGestureRecognizer *)recognizer{
  
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[recognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
    
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    for (id overlay in self.mapView.overlays) 
    {
        if ([overlay isKindOfClass:[MKPolygon class]])
        {
            MKPolygon *poly = (MKPolygon*) overlay;
            id view = [self.mapView viewForOverlay:poly];
            if ([view isKindOfClass:[MKPolygonView class]])
            {
                MKPolygonView *polyView = (MKPolygonView*) view;
                CGPoint polygonViewPoint = [polyView pointForMapPoint:mapPoint];
                BOOL mapCoordinateIsInPolygon = CGPathContainsPoint(polyView.path, NULL, polygonViewPoint, NO);   
                if (mapCoordinateIsInPolygon) {
                    
                    NSLog(@"find it  %@",poly.title);
                    currentState=poly.title;
                } else {
                    NSLog(@"did notfind it"); 
                }
            }
        }
    }
    

    self.stateDetailPopOverController=[[StateDetailPopOverController alloc] initWithStateName:currentState withRegion:[self regionForStateName:currentState]];  
        
    self.stateDetailPopOverController.delegate=self;
    //NSLog(@"current color is %@",[self colorForStateName:currentState]);
    
    if (currentState) {
    self.popOver=[[UIPopoverController alloc] initWithContentViewController:self.stateDetailPopOverController];
    CGRect rect=CGRectMake(200,300, 290, 100);
    [self.popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                            target: self
                                           selector:@selector(onTick)
                                          userInfo: nil repeats:NO];    
    
    
    region1 = [self regionForStateName:currentState];
    [self.mapView setRegion:region1 animated:YES];  
    [self.mapView setCenterCoordinate:region1.center];
        
            
        
   }
  
}


- (void)zoomToFitOverlays {
   
}


-(void)onTick{
   
    [self.popOver dismissPopoverAnimated:YES];
    [timer invalidate];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{ 


}


-(void)fillDataTable{

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (self.managedObjectContext == nil) { 
        self.managedObjectContext = [appDelegate managedObjectContext]; 
	}
    
    
   
    int i;
    for (i=0;i<[stateArray count] ; i++) {
    State *st=[stateArray objectAtIndex:i];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"State_housing_data" 
                               
                                                            inManagedObjectContext:context];
    
    [object setValue:st.name forKey:@"stateName"];
    [object setValue:[NSNumber numberWithInt:(i*1400)] forKey:@"new_Home_Sales"];
    [object setValue:[NSNumber numberWithInt:(i*1000)] forKey:@"new_Home_Price"];
    [object setValue:[NSNumber numberWithInt:(i*12000)] forKey:@"multifamily_Rents"];  
    [object setValue:[NSNumber numberWithInt:(i*900)] forKey:@"affordability"]; 
    [object setValue:[NSNumber numberWithInt:(i*1200)] forKey:@"apartment_occupency"];     
     NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }

    }

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
     poly2.title=st.name;    
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.settingStatus==0) {
        return [self defaultView:overlay];
    }
    else if (appDelegate.settingStatus==1) {
         NSLog(@"newHomeSalesView");
        return [self newHomeSalesView:overlay];
    }
    else if(appDelegate.settingStatus==2){
         NSLog(@"newHomePriceView");
      return [self newHomePriceView:overlay];
    }
    else if(appDelegate.settingStatus==3){
        NSLog(@"affordabilityView");
      return [self affordabilityView:overlay];   
    }
    else if(appDelegate.settingStatus==4){
         NSLog(@"apartmentoccupencyView");
        return [self apartmentoccupencyView:overlay];   
    }
    return nil;
}

/*
 *-----------------------------------------------------------------------------
 *	Method for default View of overlays 
 *-----------------------------------------------------------------------------
 */
-(MKPolygonView *) defaultView :(id <MKOverlay>)overlay{ 
     if ([overlay isKindOfClass:[MKPolygon class]])
     {
     int j=0;
     MKPolygonView *aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
     UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dothis)];
     tap.delegate=self;
     tap.numberOfTapsRequired=1;
     [aView addGestureRecognizer:tap];
     aView.userInteractionEnabled=YES;
         
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
-(void)dothis{

    NSLog(@"tapped");
}
/*
 *-----------------------------------------------------------------------------
 *	Method for View of overlays for New Home Sales Settings
 *-----------------------------------------------------------------------------
 */
-(MKPolygonView *) newHomeSalesView :(id <MKOverlay>)overlay{
    
    MKPolygonView *aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped :)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    [aView addGestureRecognizer:tap];
    MKPolygon *pk=(MKPolygon *)overlay;
    NSString *statname=pk.title;
     aView.alpha=.3;
   
    int n;
    for(n=0;n<[staterecordsArray count];n++)  {
        if([statname isEqualToString:[[staterecordsArray objectAtIndex:n] valueForKey:@"stateName"]] ){
            
            
            int newhomeSale =[[[staterecordsArray objectAtIndex:n] valueForKey:@"new_Home_Sales"] intValue];
            if (newhomeSale>0 && newhomeSale<=20000) {
                aView.fillColor=[UIColor redColor];
            }
            else if(newhomeSale>20000 && newhomeSale<=80000){
                aView.fillColor=[UIColor magentaColor];
            }
            else if(newhomeSale>80000 && newhomeSale<100000){
                aView.fillColor=[UIColor greenColor];;
            }
            
        }
       
    } 
    return aView;
}

/*
 *-----------------------------------------------------------------------------
 *	Method for View of overlays for New Home Price Settings
 *-----------------------------------------------------------------------------
 */

-(MKPolygonView *) newHomePriceView :(id <MKOverlay>)overlay{
    MKPolygonView *aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped :)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    [aView addGestureRecognizer:tap];
    MKPolygon *pk=(MKPolygon *)overlay;
    NSString *statname=pk.title;
     aView.alpha=.3;
    
    int n;
    for(n=0;n<[staterecordsArray count];n++)  {
        if([statname isEqualToString:[[staterecordsArray objectAtIndex:n] valueForKey:@"stateName"]] ){
            
            
            int newhomeSale =[[[staterecordsArray objectAtIndex:n] valueForKey:@"new_Home_Price"] intValue];
            if (newhomeSale>=0 && newhomeSale<=20000) {
                aView.fillColor=[UIColor redColor];
            }
            else if(newhomeSale>20000 && newhomeSale<=80000){
                aView.fillColor=[UIColor blueColor];
            }
            else if(newhomeSale>80000){
                aView.fillColor=[UIColor grayColor];
            }
           
        }
       
    } 
    
    
     return aView;;

}

/*
 *-----------------------------------------------------------------------------
 *	Method for View of overlays for Apartment Occupancy  Settings
 *-----------------------------------------------------------------------------
 */

-(MKPolygonView *) apartmentoccupencyView :(id <MKOverlay>)overlay{
    
    MKPolygonView *aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped :)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    [aView addGestureRecognizer:tap];
    MKPolygon *pk=(MKPolygon *)overlay;
    NSString *statname=pk.title;
    aView.alpha=.3;
    int n;
    for(n=0;n<[staterecordsArray count];n++)  {
      //  NSLog(@"iteration is %d",n);
        if([statname isEqualToString:[[staterecordsArray objectAtIndex:n] valueForKey:@"stateName"]] ){
            
            
            int newhomeSale =[[[staterecordsArray objectAtIndex:n] valueForKey:@"apartment_occupency"] intValue];
        
            if (newhomeSale>=0 && newhomeSale<=20000) {
                aView.fillColor=[UIColor redColor];
            }
            else if(newhomeSale>20000 && newhomeSale<=80000){
                aView.fillColor=[UIColor blueColor];
            }
            else if(newhomeSale>80000 ){
                aView.fillColor=[UIColor purpleColor];
            }
        }
       
    } 
    return aView;

}

/*
 *-----------------------------------------------------------------------------
 *	Method for View of overlays for Affordablity  Settings
 *-----------------------------------------------------------------------------
 */
-(MKPolygonView *) affordabilityView :(id <MKOverlay>)overlay{
    
    MKPolygonView *aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] ;
    aView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped :)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    [aView addGestureRecognizer:tap];
    MKPolygon *pk=(MKPolygon *)overlay;
    NSString *statname=pk.title;
     aView.alpha=.3;
    
    int n;
    for(n=0;n<[staterecordsArray count];n++)  {
        if([statname isEqualToString:[[staterecordsArray objectAtIndex:n] valueForKey:@"stateName"]] ){
            
            
            int newhomeSale =[[[staterecordsArray objectAtIndex:n] valueForKey:@"affordability"] intValue];
            if (newhomeSale>0 && newhomeSale<=20000) {
                aView.fillColor=[UIColor redColor];
            }
            else if(newhomeSale>20000 && newhomeSale<=80000){
                aView.fillColor=[UIColor blueColor];
            }
            else if(newhomeSale>80000 ){
                aView.fillColor=[UIColor purpleColor];
            }
        }
       
    } 
     return aView;;
    
}




 /*
 *-----------------------------------------------------------------------------
 *	Methods for Creating bottem view  For Different Settings
 *
 *-----------------------------------------------------------------------------
 */




- (void)setBottemViewForNewHomeSales{
    bView=[[BottemView alloc] initWithFrame:CGRectMake(0, 870+50, 980, 90)];
    [self.view addSubview:bView];
       
    crossButton=[UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame=CGRectMake(720, 867+50, 60, 40);
    [crossButton addTarget:self action:@selector(removeBootemView:) forControlEvents:UIControlEventTouchUpInside];
    
    [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:crossButton];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.5];
    
    crossButton.frame=CGRectMake(720, 867, 60, 40);
    bView.frame=CGRectMake(40, 870, 980, 90);
    [UIView commitAnimations];

    UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 150, 45)];
    lb1.text=@"New Home Sales";
    
    UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(30, 45, 140, 45)];
    lb2.text=@"Less then 20000$";
    UILabel *lb22=[[UILabel alloc] initWithFrame:CGRectMake(160, 60, 30, 20)];
    lb22.backgroundColor=[UIColor redColor];
    [bView addSubview:lb22];
    
    UILabel *lb3=[[UILabel alloc] initWithFrame:CGRectMake(200, 45, 230, 45)];
    lb3.text=@"Between 20000 and 80000 $";
    UILabel *lb33=[[UILabel alloc] initWithFrame:CGRectMake(430, 60, 30, 20)];
    lb33.backgroundColor=[UIColor magentaColor];;
    [bView addSubview:lb33];
    
    
    
    UILabel *lb4=[[UILabel alloc] initWithFrame:CGRectMake(500, 45, 170, 45)];
    lb4.text=@"Greater then 80000 $";
    
    UILabel *lb44=[[UILabel alloc] initWithFrame:CGRectMake(670, 60, 30, 20)];
    lb44.backgroundColor=[UIColor greenColor];
    [bView addSubview:lb44];
    
    lb22.alpha=.3;
    lb33.alpha=.3;
    lb44.alpha=.3;
    [bView addSubview:lb1];
    [bView addSubview:lb2];
    [bView addSubview:lb3];
    [bView addSubview:lb4];
    
}


- (void)setBottemViewForNewHomePrice{
    bView=[[BottemView alloc] initWithFrame:CGRectMake(40, 870+50, 980, 90)];
    [self.view addSubview:bView];
   
    crossButton=[UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame=CGRectMake(720, 867+50, 60, 40);
    [crossButton addTarget:self action:@selector(removeBootemView:) forControlEvents:UIControlEventTouchUpInside];
    
    [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:crossButton];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.5];
    
    crossButton.frame=CGRectMake(720, 867, 60, 40);
    bView.frame=CGRectMake(40, 870, 980, 90);
    [UIView commitAnimations];
    
    
    UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 150, 45)];
    lb1.text=@"New Home Price";
    
    UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(30, 45, 140, 45)];
    lb2.text=@"Less then 20000$";
    
    UILabel *lb22=[[UILabel alloc] initWithFrame:CGRectMake(160, 60, 30, 20)];
    lb22.backgroundColor=[UIColor redColor];
    [bView addSubview:lb22];
    
    UILabel *lb3=[[UILabel alloc] initWithFrame:CGRectMake(200, 45, 230, 45)];
    lb3.text=@"Between 20000 and 80000$";
    UILabel *lb33=[[UILabel alloc] initWithFrame:CGRectMake(430, 60, 30, 20)];
    lb33.backgroundColor=[UIColor blueColor];
    [bView addSubview:lb33];
    
    
    
    UILabel *lb4=[[UILabel alloc] initWithFrame:CGRectMake(500, 45, 170, 45)];
    lb4.text=@"Greater then 80000 $";
    
    UILabel *lb44=[[UILabel alloc] initWithFrame:CGRectMake(670, 60, 30, 20)];
    lb44.backgroundColor=[UIColor grayColor];
    [bView addSubview:lb44];
    
    [bView addSubview:lb1];
    [bView addSubview:lb2];
    [bView addSubview:lb3];
    [bView addSubview:lb4];
    lb22.alpha=.3;
    lb33.alpha=.3;
    lb44.alpha=.3;
}

- (void)setBottemViewForapartmentoccupencyView{
    
    
    
    bView=[[BottemView alloc] initWithFrame:CGRectMake(40, 870+50, 980, 90)];
    [self.view addSubview:bView];
    
    crossButton=[UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame=CGRectMake(720, 867+50, 60, 40);
    [crossButton addTarget:self action:@selector(removeBootemView:) forControlEvents:UIControlEventTouchUpInside];
    
    [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:crossButton];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.5];
    
    crossButton.frame=CGRectMake(720, 867, 60, 40);
    bView.frame=CGRectMake(40, 870, 980, 90);
    [UIView commitAnimations];
    
    
    UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 250, 45)];
    lb1.text=@"Appartment Occupency";
    
    UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(30, 45, 140, 45)];
    lb2.text=@"Less then 20000";
    UILabel *lb22=[[UILabel alloc] initWithFrame:CGRectMake(160, 60, 30, 20)];
    lb22.backgroundColor=[UIColor redColor];
    [bView addSubview:lb22];
    
    UILabel *lb3=[[UILabel alloc] initWithFrame:CGRectMake(200, 45, 230, 45)];
    lb3.text=@"Between 20000 and 80000";
    UILabel *lb33=[[UILabel alloc] initWithFrame:CGRectMake(430, 60, 30, 20)];
    lb33.backgroundColor=[UIColor blueColor];
    [bView addSubview:lb33];
    
    
    
    UILabel *lb4=[[UILabel alloc] initWithFrame:CGRectMake(500, 45, 170, 45)];
    lb4.text=@"Greater then 80000 ";
    
    UILabel *lb44=[[UILabel alloc] initWithFrame:CGRectMake(670, 60, 30, 20)];
    lb44.backgroundColor=[UIColor purpleColor];
    [bView addSubview:lb44];
    
    [bView addSubview:lb1];
    [bView addSubview:lb2];
    [bView addSubview:lb3];
    [bView addSubview:lb4];
    lb22.alpha=.3;
    lb33.alpha=.3;
    lb44.alpha=.3;
    
}
- (void)setBottemViewForaffordabilityView{
    
    bView=[[BottemView alloc] initWithFrame:CGRectMake(40, 870+50, 980, 90)];
    [self.view addSubview:bView];
   
    
    crossButton=[UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame=CGRectMake(720, 867+50, 60, 40);
    [crossButton addTarget:self action:@selector(removeBootemView:) forControlEvents:UIControlEventTouchUpInside];
    
    [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:crossButton];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.5];
    
    crossButton.frame=CGRectMake(720, 867, 60, 40);
    bView.frame=CGRectMake(40, 870, 980, 90);
    [UIView commitAnimations];
    
    
    UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 150, 45)];
    lb1.text=@"Affordability";
    
    UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(30, 45, 140, 45)];
    lb2.text=@"Less then 20000$";
    UILabel *lb22=[[UILabel alloc] initWithFrame:CGRectMake(160, 60, 30, 20)];
    lb22.backgroundColor=[UIColor redColor];
    [bView addSubview:lb22];
    
    UILabel *lb3=[[UILabel alloc] initWithFrame:CGRectMake(200, 45, 230, 45)];
    lb3.text=@"Between 20000 and 80000$";
    UILabel *lb33=[[UILabel alloc] initWithFrame:CGRectMake(430, 60, 30, 20)];
    lb33.backgroundColor=[UIColor blueColor];
    [bView addSubview:lb33];
    
    
    
    UILabel *lb4=[[UILabel alloc] initWithFrame:CGRectMake(500, 45, 170, 45)];
    lb4.text=@"Greater then 80000 ";
    
    UILabel *lb44=[[UILabel alloc] initWithFrame:CGRectMake(670, 60, 30, 20)];
    lb44.backgroundColor=[UIColor purpleColor];
    [bView addSubview:lb44];
    
    [bView addSubview:lb1];
    [bView addSubview:lb2];
    [bView addSubview:lb3];
    [bView addSubview:lb4];
    
    lb22.alpha=.3;
    lb33.alpha=.3;
    lb44.alpha=.3;
    
}


-(NSString *)colorForStateName:(NSString *)stname{

    for( State *st in stateArray){
        if ([st.name isEqualToString:stname]) {
            NSLog(@"clor is st color %@",st.color);
            return st.color;
        }
    
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


-(IBAction)settingDetails:(id)sender{
   
    [bView removeFromSuperview];
    [crossButton removeFromSuperview];
    settingViewController=[[SettingsViewController alloc] init];
    
    settingViewController.delegate=self;
    [self.navigationController pushViewController:settingViewController animated:YES];
    settingViewController.view.superview.frame= CGRectMake(252,200, 320, 380);


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


-(void)closeSetting{
    [self dismissModalViewControllerAnimated:YES];
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
    [bView removeFromSuperview];
    [crossButton removeFromSuperview];
    [self.popOver dismissPopoverAnimated:YES];
    stateViewContrller=[self.storyboard instantiateViewControllerWithIdentifier:@"StateViewContrller"];
    stateViewContrller.region=region1;
    stateViewContrller.mianScreenNavigation=YES;
    stateViewContrller.overLayBackGround=[self colorFromHexString:[self colorForStateName:currentState]];
    stateViewContrller.geocodeArray=[self geoArrayForstateName:currentState];
    stateViewContrller.currentStateName=currentState;
    [self.navigationController pushViewController:stateViewContrller animated:YES];
    

}
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end
