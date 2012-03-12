//
//  AppDelegate.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassroomViewController.h"

#import "CallListViewController.h"
#import "ControlHub.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    ClassroomViewController *viewController1;
   CallListViewController *viewController2;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain) ControlHub* controlHub;
@property (strong, nonatomic) UITabBarController *tabBarController;

//@property (retain) ClassroomViewController *viewController1;
//@property (retain) CallListViewController *viewController2;

@end
