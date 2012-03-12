//
//  GroupStudentsTableCell.h
//  Dash
//
//  Created by Daniel Iglesia on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StudentInfo.h"
#import "DashConstants.h"

@interface GroupStudentsTableCell : UITableViewCell{
    UIButton* toggleButton;
    UILabel* studentNameLabel;
    BOOL toggle;
}
@property (retain) NSString* groupNameString;
@property (assign) StudentInfo* studentInfo;
@end
