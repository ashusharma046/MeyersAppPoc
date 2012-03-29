//
//  BottemView.m
//  Poc
//
//  Created by Aneesh on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BottemView.h"
#import <QuartzCore/QuartzCore.h>
@implementation BottemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
               self.backgroundColor=[UIColor whiteColor];
        [self addSubview:backgroundImageView];
        
         self.layer.cornerRadius = 12;

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
