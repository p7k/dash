//
//  PostCallViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "StudentInfo.h " 

@class StudentInfo;
@interface PostCallViewController : UIViewController{
    UILabel* topLabel;
    UIButton* viewButtons[4];
}
@property(retain) StudentInfo* studentInfo;
@end
