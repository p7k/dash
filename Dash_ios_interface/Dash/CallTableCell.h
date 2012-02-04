//
//  CallTableCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfo.h"
#import "CallIntent.h"
#import "DashConstants.h"

@interface CallTableCell : UITableViewCell

@property(retain) UILabel* studentNameLabel;
@property(retain) UILabel* firstContactNameLabel;
@property(retain) UIButton* callButton;

@property (assign) CallIntent* callIntent;
@property (retain) UIImageView* iconView;
@end
