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
@interface StudentInfoViewController : UIViewController{
    UILabel* topLabel;
    UISegmentedControl* segmentedControl;
    UITableView* contactTableView, *callLogTableView;
    NSDateFormatter* dateFormatter;
    UIView* headerView, *notesView;
    
    UILabel* lastContactLabel, *numberOfCallsLabel, *positivityLabel;

}

-(id)initWithStudentInfo:(StudentInfo*) inInfo;
@property (assign) StudentInfo* studentInfo;
@end
