//
//  AppDelegate.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
//@synthesize viewController1, viewController2;
@synthesize controlHub;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
   
    controlHub = [[ControlHub alloc] init ];//model contains student lists, group lists, etc
    
    viewController1 = [[ClassroomViewController alloc] initWithHub:controlHub];
    [[controlHub allTopLevelViewControllersArray] addObject:viewController1];
    
    viewController2 = [[CallListViewController alloc] initWithHub:controlHub];
    [[controlHub allTopLevelViewControllersArray] addObject:viewController2];
    
    controlHub.callListViewController=viewController2;
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    self.tabBarController.delegate=self;
    [self.window makeKeyAndVisible];
    
    //[NSThread detachNewThreadSelector:@selector(sync) toTarget:controlHub withObject:nil];
    
    //edit
    //viewController1.otherController = viewController2;
    //viewController2.otherController = viewController1;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [controlHub saveLocalInfoDict];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
       /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}





// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController==viewController1){//switched to classroom view, turn off editing of table in call list
        if([viewController2 editing]) [viewController2 setEditing:NO];
    }
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
