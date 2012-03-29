//
//  SettingsViewController.h
//  Poc
//
//  Created by Aneesh on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SettingsViewControllerControllerDelegate
-(void)closeSetting;
@end

@interface SettingsViewController : UITableViewController{
 id<SettingsViewControllerControllerDelegate> _delegate;
    NSIndexPath *lastindex;
     int checkmarkRow;
}
@property (nonatomic,retain)id<SettingsViewControllerControllerDelegate> delegate;

@end
