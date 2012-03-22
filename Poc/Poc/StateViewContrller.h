//
//  StateViewContrller.h
//  Poc
//
//  Created by Aneesh on 15/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
#import "State.h"
#import "StateDetailPopOverController.h"
#import "CountyDetailViewController.h"
@interface StateViewContrller : UIViewController<MKOverlay,MKMapViewDelegate,UISearchBarDelegate,BSForwardGeocoderDelegate,StateDetailPopOverControllerDelegate,UIGestureRecognizerDelegate>{
    int k;
    State *state;
    MKCoordinateRegion region;
    NSArray *geocodeArray; 
    BOOL mianScreenNavigation;
    CountyDetailViewController * countyDetailViewController;
    int firstlaunch;
    
     StateDetailPopOverController * _stateDetailPopOverController;
     UIPopoverController * _popOver;
    NSString *currentCounty;
    NSString *currentStateName;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) State *state;
@property (nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, retain) NSArray *geocodeArray;
@property (nonatomic, assign) BOOL mianScreenNavigation;
 @property (nonatomic,retain) NSString *currentStateName;
@property (strong,nonatomic)  CountyDetailViewController * countyDetailViewController;
@property (nonatomic, retain) StateDetailPopOverController * stateDetailPopOverController;
@property (nonatomic, retain) UIPopoverController *popOver;
-(NSString *)countyForGeocodeForLatitude : (float)latitude andLongitude:(float)longitude;

-(void) drawPopOver:(CGPoint)pt andCoord:(CLLocationCoordinate2D) coordinate;
@end
