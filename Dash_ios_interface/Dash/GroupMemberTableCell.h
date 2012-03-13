//
//  GroupMemberTableCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StudentInfo.h"
#import "DashConstants.h"
#import "ControlHub.h"

@interface GroupMemberTableCell : UITableViewCell{
    UIButton* toggleButton;
    UILabel* groupNameLabel;
    BOOL toggle;

}
@property (retain) NSString* groupNameString;
@property (assign) StudentInfo* studentInfo;
@property (assign) ControlHub* controlHub;
@end
