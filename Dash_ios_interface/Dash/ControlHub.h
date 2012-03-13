//
//  ControlHub.h
//  Dash
//
//  Created by Daniel Iglesia on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentInfo.h"

@class CallListViewController;
@interface ControlHub : NSObject{
    NSMutableDictionary* myDataDict;
}

@property (retain) NSMutableArray* allGroupNamesArray;
@property (retain) NSMutableArray* classInfoArray;
@property (retain) NSMutableArray* allTopLevelViewControllersArray;
@property (retain) NSMutableArray* callQueue;
@property (retain) NSMutableArray* classInfoInGroupArray;//only students in selected group - this is always what is shown in table (including group "all"
@property (retain) NSString* currentGroupString;
@property (assign) CallListViewController* callListViewController;
@end
