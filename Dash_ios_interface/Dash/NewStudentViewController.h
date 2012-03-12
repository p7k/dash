//
//  NewStudentViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudentInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "DashConstants.h"
#import "NewContactInfoCell.h"
#import "CallLogTableCell.h"
#import "GroupMemberTableCell.h"
#import "NewContactViewController.h"
#import "ControlHub.h"

@class ClassroomViewController;

@interface NewStudentViewController : UIViewController{

    UILabel* headerLabel;
    UIView* headerView;
    UIButton* doneButton, *cancelButton;
    //UIImageView* headerView, *notesView;
    UISegmentedControl* segmentedControl;
    UITableView* contactTableView, *groupMemberTableView;
    UITextField* firstNameTextField, *lastNameTextField;
    UIButton* newContactButton;
    
   
}
@property (assign) ClassroomViewController* delegate;
@property (assign) StudentInfo* studentInfo;
@property (assign) ControlHub* controlHub;
@end
