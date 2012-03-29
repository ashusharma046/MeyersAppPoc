//
//  State.h
//  Staes codes
//
//  Created by Aneesh on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface State : NSObject {
    NSString *name;
    NSString *color;
    NSMutableArray *geoArray;
     
}
@property(nonatomic,retain)  NSString *name;
@property(nonatomic,retain)  NSString *color;;
@property(nonatomic,retain)  NSMutableArray *geoArray;
@end
