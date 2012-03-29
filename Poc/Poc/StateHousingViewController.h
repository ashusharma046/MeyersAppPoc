//
//  StateHousingViewController.h
//  Poc
//
//  Created by Aneesh on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@protocol StateDemographicViewControllerDelegate
-(void)doneButtonPressed;
@end

#import <UIKit/UIKit.h>

@interface StateHousingViewController : UIViewController{
    NSString *currentState;
    UINavigationBar *navigationBar; 
    id<StateDemographicViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) NSString *currentState;
@property (nonatomic,retain)id<StateDemographicViewControllerDelegate> delegate;;
-(void)doneButtonClick;

@end
