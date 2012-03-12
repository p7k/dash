//
//  PhoneCall.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneCall.h"

@implementation PhoneCall
@synthesize callDate, callReport, wasCompleted, contactInfo, studentInfo, callIntent, callNotesString;

NSString * const STATUS_KEY = @"status";
NSString * const CREATED_ON_KEY = @"created_on";
NSString * const ATTEMPTED_ON_KEY = @"attempted_on";
NSString * const COMPLETED_ON_KEY = @"completed_on";
NSString * const INTENT_KEY = @"intent";
NSString * const PHONE_CALL_CONTACT_ID_KEY = @"contact_id";
NSString * const CALL_RESULTS_KEY = @"results";
NSString * const DATE_FORMAT =@"yyyy-MM-dd HH:mm:ss";

-(NSData*) toJson
{
    
    return [[self toDict] JSONData];
}

-(NSDictionary*) toDict
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    
    NSString * dateString = [formatter stringFromDate: callDate];
    
    
    NSDictionary *outputDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                contactInfo.contactId, PHONE_CALL_CONTACT_ID_KEY,
                                [NSNumber numberWithInt:200], STATUS_KEY,
                                callIntent, INTENT_KEY,
                                dateString, ATTEMPTED_ON_KEY,
                                dateString, COMPLETED_ON_KEY,
                                dateString, CREATED_ON_KEY, nil];
    
    [formatter release];
    return outputDict;
    
}


- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:callDate forKey:@"callDate"];
    [coder encodeObject:callReport forKey:@"callReport"];
    [coder encodeObject:contactInfo forKey:@"contactInfo"];
    [coder encodeBool:wasCompleted forKey:@"wasCompleted"];
    [coder encodeObject:callNotesString forKey:@"callNotesString"];
    
}

- (id)initWithCoder:(NSCoder *)coder {
    if(self=[super init]){
		callDate = [[coder decodeObjectForKey:@"callDate"] retain];
        callReport = [[coder decodeObjectForKey:@"callReport"] retain];
        contactInfo = [[coder decodeObjectForKey:@"contactInfo"] retain];
        wasCompleted = [[coder decodeBoolForKey:@"wasCompleted"] retain];
        callNotesString = [[coder decodeObjectForKey:@"callNotesString"] retain];
        
    }
    return self;
}

+ (PhoneCall*)createFromDict:(NSDictionary*) input withStudentInfo:(StudentInfo*) student{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    
    PhoneCall *retVal = [[PhoneCall alloc] init];
    [retVal setCallReport:(NSNumber *)[input objectForKey:STATUS_KEY]];
    [retVal setCallIntent:(NSNumber *)[input objectForKey:INTENT_KEY]];
    NSString *theDate = (NSString *)[input objectForKey:CREATED_ON_KEY];
    [retVal setCallDate:[formatter dateFromString:theDate]];
    // set contact info here, by searching student
    // need to set studentinfo for the phone call
    [retVal setContactInfo: [student findContactById: (NSNumber*) [input objectForKey:PHONE_CALL_CONTACT_ID_KEY]]];
    
    [formatter release];
    return retVal;
}

+ (NSMutableArray *) createCallListFromJson:(NSString *) input withStudentInfo:(StudentInfo*)student{
    NSDictionary *responseDict = [input objectFromJSONString];
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for(NSDictionary *call in [responseDict objectForKey:CALL_RESULTS_KEY]){ 
        [retVal addObject:[PhoneCall createFromDict:call withStudentInfo:student]];
    }
    // reverse the array so latest comes first
    retVal = [[retVal reverseObjectEnumerator] allObjects];
    return retVal;
}


@end
