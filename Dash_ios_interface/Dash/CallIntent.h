//
//  CallIntent.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentInfo.h"

@interface CallIntent : NSObject

@property (assign) StudentInfo* studentInfo;
@property BOOL isHappy;
@end
