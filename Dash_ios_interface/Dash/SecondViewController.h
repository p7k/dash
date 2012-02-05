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

@interface SecondViewController : UIViewController

@property (retain) NSMutableArray* callQueue;
@property (retain) UITableView* tableView;
@end
