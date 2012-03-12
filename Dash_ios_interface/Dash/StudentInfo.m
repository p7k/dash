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

@synthesize lastName, firstName;
@synthesize studentId;
@synthesize contactsArray, phoneCallArray, groupStringArray;
//@synthesize firstContactInfo;
//@synthesize isHappy;
@synthesize /*callIntent*/ mood;
@synthesize callCount, positiveCallCount, negativeCallCount, lastContactDate;

NSString * const STUDENT_ID_KEY = @"id";
NSString * const FIRST_NAME_KEY = @"first_name";
NSString * const LAST_NAME_KEY = @"last_name";
NSString * const RESULTS_KEY = @"results";
NSString * const CONTACTS_KEY = @"contacts";
NSString * const STATS_KEY = @"stats";
NSString * const CALL_COUNT_KEY = @"count";
NSString * const CHARGE_KEY = @"charge";

NSString * const POSITIVE_CALL_COUNT_KEY = @"p";
NSString * const NEGATIVE_CALL_COUNT_KEY = @"n";
NSString * const GROUPS_KEY = @"groups";
NSString * const LAST_CONTACT_KEY = @"last_contact";
NSString * const LAST_DATE_FORMAT =@"yyyy-MM-dd HH:mm:ss";


-(id)init{
   self= [super init];
    contactsArray = [[NSMutableArray alloc]init];
    phoneCallArray = [[NSMutableArray alloc]init];
    groupStringArray = [[NSMutableArray alloc]init];
    //callIntent = [NSNumber numberWithInt:2]; // initialize to be neutral. 0 = negative 1 = positive
    mood = 0; //-1 neg, 0 neut, 1 pos
    //init strings?
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:firstName forKey:@"firstName"];
    [coder encodeObject:lastName forKey:@"lastName"];
    [coder encodeObject:studentId forKey:@"studentID"];
    [coder encodeObject:contactsArray forKey:@"contactsArray"];
    [coder encodeObject:phoneCallArray forKey:@"phoneCallArray"];
    [coder encodeObject:groupStringArray forKey:@"groupStringArray"];
    [coder encodeObject:lastContactDate forKey:@"lastContactDate"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if(self=[super init]){
		firstName = [[coder decodeObjectForKey:@"firstName"] retain];
        lastName = [[coder decodeObjectForKey:@"lastName"] retain];
        studentId = [[coder decodeObjectForKey:@"studentId"] retain];
        contactsArray = [[coder decodeObjectForKey:@"contactsArray"] retain];
        phoneCallArray = [[coder decodeObjectForKey:@"phoneCallArray"] retain];
        groupStringArray = [[coder decodeObjectForKey:@"groupStringArray"] retain];
        lastContactDate = [[coder   decodeObjectForKey:@"lastContactDate"] retain];
       // if([contactsArray count ]>0)firstContactInfo= [contactsArray objectAtIndex:0];
    }
    return self;
}


+ (StudentInfo *)createFromDict:(NSDictionary*) input{
    
    StudentInfo *retVal = [[StudentInfo alloc] init];
    [retVal setStudentId:(NSNumber *)[input objectForKey:STUDENT_ID_KEY]];
     
  
    //NSString* first_name = (NSString *)[input objectForKey:FIRST_NAME_KEY];
    //NSString* last_name = (NSString *)[input objectForKey:LAST_NAME_KEY];
    [retVal setFirstName: (NSString *)[input objectForKey:FIRST_NAME_KEY]];
     [retVal setLastName: (NSString *)[input objectForKey:LAST_NAME_KEY]];
    
    //call info
    NSDictionary* statsDict = [input objectForKey:STATS_KEY];
    [retVal setCallCount:[[statsDict objectForKey:CALL_COUNT_KEY]intValue]];
    NSDictionary* chargeDict = [statsDict objectForKey:CHARGE_KEY];
     [retVal setPositiveCallCount:[[chargeDict objectForKey:POSITIVE_CALL_COUNT_KEY] intValue]];
      [retVal setNegativeCallCount:[[chargeDict objectForKey:NEGATIVE_CALL_COUNT_KEY] intValue]];
       
    //group
    [retVal setGroupStringArray:[NSMutableArray arrayWithArray:[input objectForKey:GROUPS_KEY] ] ];
      
    //lat contact
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:LAST_DATE_FORMAT];
    NSString *theDate = (NSString *)[input objectForKey:LAST_CONTACT_KEY];
    [retVal setLastContactDate:[formatter dateFromString:theDate]];
    
    //
    [retVal setContactsArray:[ContactInfo createContactListFromArray:[input objectForKey:CONTACTS_KEY]]];
    
    /*if([[retVal contactsArray] count] > 0){
        [retVal setFirstContactInfo:[retVal.contactsArray objectAtIndex:0]];
    }*/
    //printf("\n created %s %s ", [[retVal firstName] cString], [[retVal lastName] cString]);
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

- (ContactInfo *) findContactById:(NSNumber *) contactId{
    for(ContactInfo * curr in contactsArray){
        if(curr.contactId == contactId)
            return curr;
    }
    return nil;
}



-(NSString*)fullName{
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

@end
