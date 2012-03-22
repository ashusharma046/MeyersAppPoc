//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
#import "State.h"
#import "StateDetailPopOverController.h"
#import "StateViewContrller.h"
@class StateDetailPopOverController;
@interface Forward_GeocodingViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, BSForwardGeocoderDelegate,MKOverlay,NSXMLParserDelegate,UIGestureRecognizerDelegate,StateDetailPopOverControllerDelegate,UIPopoverControllerDelegate>{


    NSXMLParser *parser;
    NSMutableString *currentStringValue;
    State *state;
    NSMutableArray *stateArray;
    NSMutableArray *geoArray;
    
    
    int k;
    StateDetailPopOverController * _stateDetailPopOverController;
    UIPopoverController * _popOver;
    NSString *currentState;
    NSTimer *timer;
    
    MKCoordinateRegion region1;
    StateViewContrller *stateViewContrller;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) StateDetailPopOverController * stateDetailPopOverController;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain)  NSString *currentState;
@property (nonatomic, assign)  MKCoordinateRegion region1;
@property (strong,nonatomic) StateViewContrller *stateViewContrller;

-(void) drawOverLay;

- (UIColor *) colorFromHexString:(NSString *)hexString ;
-(NSString *)stateForGeocodeForLatitude : (float)latitude andLongitude:(float)longitude;
-(float)minLongitudeForState:(State *)st;
-(float)maxLongitudeForState:(State *)st;

-(MKCoordinateRegion ) regionForStateName:(NSString *)stateName;
-(NSArray *)geoArrayForstateName:(NSString *) stName;
@end


