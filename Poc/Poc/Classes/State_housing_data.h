//
//  State_housing_data.h
//  Poc
//
//  Created by Aneesh on 22/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface State_housing_data : NSManagedObject

@property (nonatomic, retain) NSNumber * new_Home_Sales;
@property (nonatomic, retain) NSNumber * new_Home_Price;
@property (nonatomic, retain) NSNumber * resale_Home_Sales;
@property (nonatomic, retain) NSNumber * resale_home_Sales;
@property (nonatomic, retain) NSNumber * affordability;
@property (nonatomic, retain) NSNumber * multifamily_Rents;
@property (nonatomic, retain) NSNumber * apartment_occupency;
@property (nonatomic, retain) NSString * stateName;

@end
