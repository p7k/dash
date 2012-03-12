//
//  GroupViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DashConstants.h"
#import "ControlHub.h"
#import "GroupStudentsTableCell.h"

@class ClassroomViewController;

@interface GroupViewController : UIViewController{
    NSString* groupName;
    
    UIButton *doneButton, *deleteButton;
    UIView *headerView;
    UITableView* groupStudentsTableView;
}

@property(assign) ClassroomViewController* delegate;
@property(assign) ControlHub* controlHub; 
@end
