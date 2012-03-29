//
//  StateHousingViewController.h
//  Poc
//
//  Created by Aneesh on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@protocol StateHousingViewControllerDelegate
-(void)doneButtonPressed;
@end

#import <UIKit/UIKit.h>

@interface StateHousingViewController : UIViewController{
    NSString *currentState;
    UINavigationBar *navigationBar; 
    id<StateHousingViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) NSString *currentState;
@property (nonatomic,retain)id<StateHousingViewControllerDelegate> delegate;;
-(void)doneButtonClick;

@end
