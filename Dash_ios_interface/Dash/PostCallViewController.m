//
//  PostCallViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostCallViewController.h"
#import "StudentInfo.h"
@implementation PostCallViewController
@synthesize studentInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        backButton.frame = CGRectMake(10, 10, 60, 40);
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
        backButton.backgroundColor = [UIColor blueColor];
        [self.view addSubview:backButton];
        //[self.navigationItem setLeftBarButtonItem:backButton];
        
        topLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 60)];
        topLabel.backgroundColor = [UIColor grayColor];
        [self.view addSubview:topLabel];
        
        NSString* buttonStrings[4]={@"Completed Contact", @"Left Message", @"Kept Ringing", @"Disconnected"};
        for(int i=0;i<4;i++){
            viewButtons[i] = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
            viewButtons[i].frame=CGRectMake(20, 80+i*80, 280, 60);
            [viewButtons[i] setTitle:buttonStrings[i] forState:UIControlStateNormal];
            [viewButtons[i] addTarget:self action:@selector(postCallButtonDown:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:viewButtons[i]];
        }
            
        

    }
    return self;
}




-(void)setStudentInfo:(StudentInfo*)inInfo{
    printf("\nsetStudentInfo %s", [[inInfo name] cString ] );
    studentInfo = inInfo;
    topLabel.text = [inInfo name];   
}

-(void)back{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)postCallButtonDown:(id)sender{
    UIButton *clickedButton = (UIButton *) sender;
    
    PhoneCall *newCall = [[PhoneCall alloc] init];
    [newCall setCallDate:[NSDate date]];
    [newCall setCallReport:clickedButton.currentTitle];
    
    // send the just created call to the server
    
    
    NSString *urlEndpoint = [NSString stringWithFormat:@"http://23.21.212.190:5000/api/v1/clog/?student_id=%@", studentInfo.studentId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                    initWithURL:[NSURL URLWithString:urlEndpoint]];
    //[request setHTTPBody:[newCall toJson];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:[request autorelease] delegate:self];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
