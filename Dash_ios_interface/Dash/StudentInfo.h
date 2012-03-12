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

//@property (retain) NSString* name;
@property (retain) NSString* firstName;
@property (retain) NSString* lastName;

@property (retain) NSNumber *studentId;
@property (retain) NSMutableArray* groupStringArray;
@property (retain) NSMutableArray* contactsArray;
@property (retain) NSMutableArray* phoneCallArray;
//@property (assign) ContactInfo* firstContactInfo;//contacts array kept sorted, now this is function to return first
//@property (assign) NSNumber* callIntent;//necc?


@property (assign) NSDate* lastContactDate;
//@property (assign) int totalCallCount;//derived from JSON stats
@property int callCount;
@property int positiveCallCount;
@property int negativeCallCount;

//@property BOOL isHappy;
@property int mood;//don't store any info with this, just for temporary call queue

+ (NSArray *) createStudentListWithJsonString:(NSString *) input;
- (ContactInfo *) findContactById:(NSNumber *) contactId;
@end
