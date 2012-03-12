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
@property (assign) CallListViewController* callListViewController;
@end
