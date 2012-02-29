//
//  ContactInfoCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashConstants.h"
#import "ContactInfo.h"
#import "StudentInfo.h"
#import "PostCallViewController.h"

@class StudentInfoViewController;

@interface ContactInfoCell : UITableViewCell{
    UILabel* nameLabel, *relationLabel, *contactTypeLabel;
    UIButton* callButtons[3];
    
}
@property (assign) StudentInfoViewController* parentVC;
@property (assign) StudentInfo* studentInfo;
@property (assign) ContactInfo* contactInfo;
@end
