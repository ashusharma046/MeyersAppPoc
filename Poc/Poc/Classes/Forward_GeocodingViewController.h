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
#import "SettingsViewController.h"
#import "BottemView.h"
@class StateDetailPopOverController;
@class SettingsViewController;
@interface Forward_GeocodingViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, BSForwardGeocoderDelegate,MKOverlay,NSXMLParserDelegate,UIGestureRecognizerDelegate,StateDetailPopOverControllerDelegate,UIPopoverControllerDelegate,SettingsViewControllerControllerDelegate>{


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
    SettingsViewController *settingViewController;
    NSArray *staterecordsArray ;
    
    //bottem description view
    BottemView *bView;
    UIButton *crossButton;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) StateDetailPopOverController * stateDetailPopOverController;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain)  NSString *currentState;
@property (nonatomic, assign)  MKCoordinateRegion region1;
@property (strong,nonatomic) StateViewContrller *stateViewContrller;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) drawOverLay;
-(void) reDrawMapView;
-(void) removeBootemView:(UIButton *)sender;
- (UIColor *) colorFromHexString:(NSString *)hexString ;
-(NSString *)stateForGeocodeForLatitude : (float)latitude andLongitude:(float)longitude;
-(NSString *)colorForStateName:(NSString *)colorname;
-(float)minLongitudeForState:(State *)st;
-(float)maxLongitudeForState:(State *)st;

-(MKCoordinateRegion ) regionForStateName:(NSString *)stateName;
-(NSArray *)geoArrayForstateName:(NSString *) stName;
-(void)fillDataTable;
-(IBAction)settingDetails:(id)sender;
- (NSString *)applicationDocumentsDirectory;
//overLay settting methods
-(MKPolygonView *) defaultView :(id <MKOverlay>)overlay;
-(MKPolygonView *) newHomeSalesView :(id <MKOverlay>)overlay;
-(MKPolygonView *) newHomePriceView :(id <MKOverlay>)overlay;
-(MKPolygonView *) apartmentoccupencyView :(id <MKOverlay>)overlay;
-(MKPolygonView *) affordabilityView :(id <MKOverlay>)overlay;


//bottem decription view methods
- (void)setBottemViewForNewHomeSales;
- (void)setBottemViewForNewHomePrice;
- (void)setBottemViewForaffordabilityView;
- (void)setBottemViewForapartmentoccupencyView;
-(void)dothis;
@end


