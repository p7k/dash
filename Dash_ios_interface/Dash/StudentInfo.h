//
//  StudentInfo.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactInfo.h"
#import "PhoneCall.h"

@interface StudentInfo : NSObject

@property (retain) NSString* name;
@property (retain) NSMutableArray* contactsArray;
@property (retain) NSMutableArray* phoneCallArray;
@property (assign) ContactInfo* firstContactInfo;
@end
