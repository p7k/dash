//
//  NewContactViewController.h
//  Dash
//
//  Created by Daniel Iglesia on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StudentInfo.h"
#import "DashConstants.h"
#import "ContactInfo.h"
@class NewStudentViewController;//delegate

@interface NewContactViewController : UIViewController{
    StudentInfo* studentInfo;
    ContactInfo* contactInfo;
     UIButton* cancelButton, *doneButton, *deleteButton;
     //UITextField* relationTextField,*firstNameTextField, *lastNameTextField, *homeNumberTextField, *mobileNumberTextField, *workNumberTextField;
    UITextField* textFields[6];
    UIView *headerView;
    
    //temp values, put into object on "done"
    NSString* firstNameString, *lastNameString, *homeNumberString;
    
}

@property (assign) NewStudentViewController* delegate;
@end
