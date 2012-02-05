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

NSString * const STATUS_KEY = @"status";
NSString * const CREATED_ON_KEY = @"created_on";
NSString * const INTENT_KEY = @"intent";
NSString * const PHONE_CALL_CONTACT_ID_KEY = @"contact_id";

-(NSString*) toJson
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"%Y-%m-%d %H:%M:%S"];
    
    NSDictionary *outputDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                contactInfo.contactId, PHONE_CALL_CONTACT_ID_KEY,
                                200, STATUS_KEY,
                                1,   INTENT_KEY,
                                [formatter stringFromDate: callDate], CREATED_ON_KEY];
    
    [formatter release];
    
    return [outputDict JSONString];
}


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
