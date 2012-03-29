//
//  StateDetailPopOverController.h
//  Poc
//
//  Created by Aneesh on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@protocol StateDetailPopOverControllerDelegate
//-(void) removePopOver;
-(void) drawDetailedMap;
@end
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface StateDetailPopOverController : UIViewController<UIPopoverControllerDelegate>{
id <StateDetailPopOverControllerDelegate> delegate;
    NSString *_stateName; 
    MKCoordinateRegion region;
   
}
@property(nonatomic,retain) id <StateDetailPopOverControllerDelegate> delegate;
@property(nonatomic,retain) NSString *stateName; 
@property(nonatomic,assign) MKCoordinateRegion  region;
- (id)initWithStateName:(NSString *)stName withRegion:(MKCoordinateRegion )rg;
- (id)initWithStateName:(NSString *)stName;
@end
