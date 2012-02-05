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
@property (retain) NSNumber *studentId;
@property (retain) NSMutableArray* contactsArray;
@property (retain) NSMutableArray* phoneCallArray;
@property (assign) ContactInfo* firstContactInfo;

@property BOOL isHappy;//don't store any info with this, just for temporary call queue

+ (NSArray *) createStudentListWithJsonString:(NSString *) input;
@end
