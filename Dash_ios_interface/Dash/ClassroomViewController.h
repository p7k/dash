//
//  FirstViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfo.h"
#import "ContactInfo.h"
#import "ClassroomTableCell.h"
#import "StudentInfoViewController.h"

@class CallListViewController;

@interface ClassroomViewController : UIViewController{
    UIButton* sortTableButton;
    NSMutableArray* classInfoSearchSubArray;
    BOOL searching;
}

@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) UITableView* classroomTableView;
@property (retain, nonatomic) UIView*  headerView;
@property (retain, nonatomic) NSMutableArray* classInfoArray;
@property (assign) CallListViewController* otherController;

@end
