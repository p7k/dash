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
#import "NewStudentViewController.h"
#import "ControlHub.h"
#import "GroupViewController.h"

@class CallListViewController;

@interface ClassroomViewController : UIViewController{
    UIButton* sortTableButton, *groupsTableButton, *addStudentButton, *sideMenuButton;
    NSMutableArray* classInfoSearchSubArray;
    NSMutableArray* classInfoInGroupArray;//only students in selected group - this is always what is shown in table (including group "all"
    //NSMutableArray* groupStringArray;//array of possible groups
    NSString* currentGroupString;
    UIView* headerView, *searchHeaderView, *roundedContentView, *sortOptionsView;
    UIButton* sortOptionButton[7];
    BOOL searching;
    UILabel *groupNameLabel;
    
    UIView* groupsView, *addGroupView, *addStudentView;
    
   
    UITextField* addGroupTextField, *addStudentLastNameTextField, *addStudentFirstNameTextField;
    UIButton* addGroupOkButton, *addGroupCancelButton, *addStudentOkButton, *addStudentCancelButton;
    
    //UIAlertView* addGroupAlert;
    //UITextView* addGroupAlertTextField;
    
}

@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain) UITableView* mainTableView;
@property (retain) UITableView* groupsTableView;
//@property (retain, nonatomic) UIView*  groupHeaderView;
//@property (assign) CallListViewController* otherController;
@property (retain) UIActivityIndicatorView* spinner;
@property (assign) ControlHub* controlHub;
@end
