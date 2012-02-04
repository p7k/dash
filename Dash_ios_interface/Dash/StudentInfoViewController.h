//
//  StudentInfoViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfo.h"

@interface StudentInfoViewController : UIViewController{
    UILabel* topLabel;
    UISegmentedControl* segmentedControl;
    UITableView* contactTableView, *callLogTableView;
    NSDateFormatter* dateFormatter;
}
@property (assign) StudentInfo* studentInfo;
@end
