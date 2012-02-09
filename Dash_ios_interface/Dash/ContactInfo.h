//
//  ContactInfo.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject

@property (retain) NSString* name;
@property (retain) NSString* phoneNumber;
@property (retain) NSString* relation;
@property (retain) NSString* contactType;//work/cell/etc
@property (retain) NSNumber *contactId;

+ (NSArray *) createContactListFromArray:(NSArray *) input;
@end
