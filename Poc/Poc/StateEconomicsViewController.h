//
//  StateEconomicsViewController.h
//  Poc
//
//  Created by Aneesh on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@protocol StateEconomicsViewControllerDelegate
-(void)doneButtonPressed;
@end

#import <UIKit/UIKit.h>

@interface StateEconomicsViewController : UIViewController{
    NSString *currentState;
    UINavigationBar *navigationBar; 
    id<StateEconomicsViewControllerDelegate> _delegate;

}
@property(nonatomic,retain) NSString *currentState;
@property (nonatomic,retain)id<StateEconomicsViewControllerDelegate> delegate;;
-(void)doneButtonClick;

@end
