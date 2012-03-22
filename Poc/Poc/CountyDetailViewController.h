//
//  CountyDetailViewController.h
//  Poc
//
//  Created by Aneesh on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
#import "State.h"

@interface CountyDetailViewController : UIViewController<MKOverlay,MKMapViewDelegate,UISearchBarDelegate,BSForwardGeocoderDelegate>{
    
        int k;
        State *state;
        MKCoordinateRegion region;
        NSArray *geocodeArray;
        NSString *countyName;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) State *state;
@property (nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, retain) NSArray *geocodeArray;
@property (nonatomic, retain) NSString *countyName;
@end
