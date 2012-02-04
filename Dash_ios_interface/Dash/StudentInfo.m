//
//  StudentInfo.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudentInfo.h"
#import "JSONKit.h"

@implementation StudentInfo

@synthesize name;
@synthesize studentId;
@synthesize contactsArray, phoneCallArray;
@synthesize firstContactInfo;


NSString * const STUDENT_ID_KEY = @"id";
NSString * const FIRST_NAME_KEY = @"first_name";
NSString * const LAST_NAME_KEY = @"last_name";
NSString * const RESULTS_KEY = @"results";
NSString * const CONTACTS_KEY = @"contacts";

-(id)init{
   self= [super init];
    contactsArray = [[NSMutableArray alloc]init];
    phoneCallArray = [[NSMutableArray alloc]init];
    return self;
}


+ (StudentInfo *)createFromDict:(NSDictionary*) input{
    
    StudentInfo *retVal = [[StudentInfo alloc] init];
    [retVal setStudentId:(NSNumber *)[input objectForKey:STUDENT_ID_KEY]];
     
    // combine names for simplicity, we can separate them later
    NSString* first_name = (NSString *)[input objectForKey:FIRST_NAME_KEY];
    NSString* last_name = (NSString *)[input objectForKey:LAST_NAME_KEY];
    [retVal setName:[NSString stringWithFormat:@"%@ %@", first_name, last_name]];
     
    [retVal setContactsArray:[ContactInfo createContactListFromArray:[input objectForKey:CONTACTS_KEY]]];
    return retVal;
}

+ (NSArray *) createStudentListWithJsonString:(NSString *) input{
    NSDictionary *responseDict = [input objectFromJSONString];
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for(NSDictionary *student in [responseDict objectForKey:RESULTS_KEY]){ 
        [retVal addObject:[StudentInfo createFromDict:student]];
    }
    return retVal;
}
@end
