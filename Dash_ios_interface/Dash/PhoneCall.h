//
//  PhoneCall.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactInfo.h"
//#import "StudentInfo.h"
#import "JSONKit.h"

@class StudentInfo;
@interface PhoneCall : NSObject


@property (retain) NSDate* callDate;
@property (retain) NSString* callReport;
@property BOOL wasCompleted;
@property (retain) ContactInfo* contactInfo;
@property (retain) StudentInfo* studentInfo;
@property (retain) NSNumber* callIntent;
@property (retain) NSString* callNotesString;

-(NSData *)toJson;
-(NSDictionary*)toDict;
+ (NSMutableArray *) createCallListFromJson:(NSString *) input withStudentInfo:(StudentInfo*)student;
@end
