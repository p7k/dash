//
//  PhoneCall.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneCall.h"

@implementation PhoneCall
@synthesize callDate, callReport, wasCompleted, contactInfo;




- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:callDate forKey:@"callDate"];
    [coder encodeObject:callReport forKey:@"callReport"];
    [coder encodeObject:contactInfo forKey:@"contactInfo"];
    [coder encodeBool:wasCompleted forKey:@"wasCompleted"];
    
}

- (id)initWithCoder:(NSCoder *)coder {
    if(self=[super init]){
		callDate = [[coder decodeObjectForKey:@"callDate"] retain];
        callReport = [[coder decodeObjectForKey:@"callReport"] retain];
        contactInfo = [[coder decodeObjectForKey:@"contactInfo"] retain];
        wasCompleted = [[coder decodeBoolForKey:@"wasCompleted"] retain];
        
    }
    return self;
}


@end
