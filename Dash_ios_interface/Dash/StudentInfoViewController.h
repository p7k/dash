//
//  StudentInfoViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "DashConstants.h"
#import "ContactInfoCell.h"
#import "CallLogTableCell.h"
#import "GroupMemberTableCell.h"
#import "NewContactViewController.h"
#import "ControlHub.h"

@interface StudentInfoViewController : UIViewController{
    UILabel* topLabel;
    UISegmentedControl* segmentedControl;
    UITableView* contactTableView, *callLogTableView, *groupMemberTableView;
   
    UIImageView* headerView, *notesView;
    
    UILabel* lastContactLabel, *numberOfCallsLabel, *positivityLabel;
    UIActivityIndicatorView* spinner;
    UIButton* editContactsButton;
    ControlHub* controlHub;
    BOOL groupInfoChanged;
}

-(id)initWithStudentInfo:(StudentInfo*) inInfo;
@property (assign) StudentInfo* studentInfo;
@property (assign) UIViewController* delegate;
@end
