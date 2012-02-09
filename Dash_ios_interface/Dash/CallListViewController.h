//
//  SecondViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfo.h"
#import "ContactInfo.h"
#import "CallTableCell.h"
//#import "CallIntent.h"
#import "StudentInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
@class ClassroomViewController;

@interface CallListViewController : UIViewController

-(void)removeInfo:(StudentInfo*)inInfo;

@property (retain) NSMutableArray* callQueue;
@property (retain) UITableView* tableView;
@property (assign) ClassroomViewController* otherController;
@end
