//
//  StudentInfo.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudentInfo.h"

@implementation StudentInfo

@synthesize  name;
@synthesize  contactsArray, phoneCallArray;
@synthesize firstContactInfo;

-(id)init{
   self= [super init];
    contactsArray = [[NSMutableArray alloc]init];
    phoneCallArray = [[NSMutableArray alloc]init];
    return self;
}
@end
