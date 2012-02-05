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


@end
