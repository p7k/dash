//
//  PostCallViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "StudentInfo.h "
#import <QuartzCore/QuartzCore.h>
#import "CallListViewController.h"
@class StudentInfo;

@interface PostCallViewController : UIViewController{
    UILabel* topLabel;
    UIView* headerView;
    UIButton* viewButtons[4], *intentButtons[3];
    int intent;
}
@property(retain) StudentInfo* studentInfo;
@property(retain) ContactInfo* contactInfo;
@property(retain) NSNumber* callIntent;
@property (assign) UIViewController* parentVC;//something when presented from call list, nil from roster. STUPID HACK 
@end
