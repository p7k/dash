//
//  ContactInfo.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo
@synthesize firstName;
@synthesize lastName;
@synthesize contactId;
@synthesize homeNumber, mobileNumber, workNumber, relation;

NSString * const CONTACT_ID_KEY = @"id";
NSString * const CONTACT_FIRST_NAME_KEY = @"first_name";
NSString * const CONTACT_LAST_NAME_KEY = @"last_name";
NSString * const PHONE_NUMBER_KEY = @"phones";
NSString * const HOME_NUMBER_KEY = @"home";
NSString * const MOBILE_NUMBER_KEY = @"cell";
NSString * const WORK_NUMBER_KEY = @"day";



NSString * const CONTACT_RELATIONSHIP_KEY = @"relationship";


+ (ContactInfo *)createFromDict:(NSDictionary*) input{
    
    ContactInfo *retVal = [[ContactInfo alloc] init];
    // combine names for simplicity, we can separate them later
    //NSString* first_name = (NSString *)[input objectForKey:CONTACT_FIRST_NAME_KEY];
    //NSString* last_name = (NSString *)[input objectForKey:CONTACT_LAST_NAME_KEY];
    //[retVal setName:[NSString stringWithFormat:@"%@ %@", first_name, last_name]];
    
    [retVal setFirstName:(NSString *)[input objectForKey:CONTACT_FIRST_NAME_KEY]];
     [retVal setLastName:(NSString *)[input objectForKey:CONTACT_LAST_NAME_KEY]];
      
    
    [retVal setContactId:(NSNumber *)[input objectForKey:CONTACT_ID_KEY]];
    //[retVal setPhoneNumber:(NSString *)[input objectForKey:PHONE_NUMBER_KEY]]; 
    
    NSArray* phonesArray = [input objectForKey:PHONE_NUMBER_KEY];//array of phon number dicts
    
    for(NSDictionary* phoneDict in phonesArray){
        NSString* type = [phoneDict objectForKey:@"type"];
        if([type isEqualToString:HOME_NUMBER_KEY]) [retVal setHomeNumber:(NSString *)[phoneDict objectForKey:@"number"]]; 
        if([type isEqualToString:MOBILE_NUMBER_KEY]) [retVal setMobileNumber:(NSString *)[phoneDict objectForKey:@"number"]]; 
        if([type isEqualToString: WORK_NUMBER_KEY]) [retVal setWorkNumber:(NSString *)[phoneDict objectForKey:@"number"]]; 
    }
    
    [retVal setRelation:(NSString*)[input objectForKey:CONTACT_RELATIONSHIP_KEY]];
    
   
    
    return retVal;
}

-(NSString*)bestPhoneNumber{
    if(homeNumber)return homeNumber;
    else if (mobileNumber) return mobileNumber;
    else if (workNumber) return workNumber;
    return nil;
}

-(int)bestPhoneNumberType{//0-2 for home, mobile, work
    if(homeNumber)return 0;
    else if (mobileNumber) return 1;
    else if (workNumber) return 2;
    return -1;
}

+ (NSArray *) createContactListFromArray:(NSArray *) input{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for(NSDictionary *contact in input){ 
        [retVal addObject:[ContactInfo createFromDict:contact]];
    }
    return retVal;
}

//for local storage
- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:firstName forKey:@"firstName"];
    [coder encodeObject:lastName forKey:@"lastName"];
    [coder encodeObject:contactId forKey:@"contactId"];
    //[coder encodeObject:phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:homeNumber forKey:@"homeNumber"];
    [coder encodeObject:mobileNumber forKey:@"mobileNumber"];
    [coder encodeObject:workNumber forKey:@"workNumber"];
    
    [coder encodeObject:relation forKey:@"relation"];
    //[coder encodeObject:contactType forKey:@"contactType"];

    
}

- (id)initWithCoder:(NSCoder *)coder {
    if(self=[super init]){
		firstName = [[coder decodeObjectForKey:@"firstName"] retain];
        lastName = [[coder decodeObjectForKey:@"lastName"] retain];
        
        contactId = [[coder decodeObjectForKey:@"contactId"] retain];
        homeNumber = [[coder decodeObjectForKey:@"homeNumber"] retain];
         mobileNumber = [[coder decodeObjectForKey:@"mobileNumber"] retain];
         workNumber = [[coder decodeObjectForKey:@"workNumber"] retain];
        relation = [[coder decodeObjectForKey:@"relation"] retain];  
        //contactType = [[coder decodeObjectForKey:@"contactType"] retain];  
    }
    return self;
}
-(NSString*)fullName{
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

@end
