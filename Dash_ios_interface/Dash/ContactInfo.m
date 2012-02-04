//
//  ContactInfo.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo
@synthesize name;
@synthesize contactId;
@synthesize phoneNumber;

NSString * const CONTACT_ID_KEY = @"id";
NSString * const CONTACT_FIRST_NAME_KEY = @"first_name";
NSString * const CONTACT_LAST_NAME_KEY = @"last_name";
NSString * const PHONE_NUMBER_KEY = @"phone";

+ (ContactInfo *)createFromDict:(NSDictionary*) input{
    
    ContactInfo *retVal = [[ContactInfo alloc] init];
    // combine names for simplicity, we can separate them later
    NSString* first_name = (NSString *)[input objectForKey:CONTACT_FIRST_NAME_KEY];
    NSString* last_name = (NSString *)[input objectForKey:CONTACT_LAST_NAME_KEY];
    [retVal setName:[NSString stringWithFormat:@"%@ %@", first_name, last_name]];
    
    [retVal setContactId:(NSNumber *)[input objectForKey:CONTACT_ID_KEY]];
    [retVal setPhoneNumber:(NSString *)[input objectForKey:PHONE_NUMBER_KEY]]; 
    
    return retVal;
}

+ (NSArray *) createContactListFromArray:(NSArray *) input{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for(NSDictionary *contact in input){ 
        [retVal addObject:[ContactInfo createFromDict:contact]];
    }
    return retVal;
}

@end
