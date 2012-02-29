//
//  ClassroomTableCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashConstants.h"
#import "StudentInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "PostCallViewController.h"

@class ClassroomViewController;
@interface ClassroomTableCell : UITableViewCell



@property(retain) UILabel* studentNameLabel;
@property(retain) UILabel* firstContactNameLabel;
@property(retain) UILabel* firstContactRelationLabel;

@property(retain) UIButton* happyButton;
@property(retain) UIButton* sadButton;
@property(retain) UIButton* callButton;
@property (assign) StudentInfo* myStudentInfo;
@property (assign) ClassroomViewController* parentVC;
@property (retain) UIView* successView;
@end
