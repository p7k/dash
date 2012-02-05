//
//  CallTableCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfo.h"
//#import "CallIntent.h"
#import "DashConstants.h"
@class SecondViewController;
@interface CallTableCell : UITableViewCell

@property(retain) UILabel* studentNameLabel;
@property(retain) UILabel* firstContactNameLabel;
@property(retain) UIButton* callButton;

@property BOOL isHappy;
@property (retain) UIImageView* iconView;
@property (assign) StudentInfo* studentInfo;
@property (assign) SecondViewController* parentVC;
@end
