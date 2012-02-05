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
        //[self.view setBackgroundColor:[UIColor lightGrayColor]];
         self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
        UIView* underNotesView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
        underNotesView.backgroundColor=[UIColor blackColor];
        underNotesView.layer.shadowColor = [UIColor blackColor].CGColor;
        underNotesView.layer.shadowOpacity = 1.0;
        underNotesView.layer.shadowRadius = 5.0;
        underNotesView.layer.shadowOffset = CGSizeMake(5, 5);
        underNotesView.clipsToBounds = NO; 
        [self.view addSubview:underNotesView];
        
        headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
        headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
        [self.view addSubview:headerView];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        backButton.frame = CGRectMake(10, 5, 60, 30);
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
        backButton.backgroundColor = [UIColor grayColor ];
        backButton.layer.cornerRadius=4;
        [headerView addSubview:backButton];
               
       topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.textAlignment = UITextAlignmentCenter;
        topLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:topLabel];

        
        
        
       
        
        NSString* buttonStrings[4]={@"Completed Contact", @"Left Message", @"Kept Ringing", @"Disconnected"};
        for(int i=0;i<4;i++){
            viewButtons[i] = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
            viewButtons[i].frame=CGRectMake(20, 80+i*80, 280, 60);
            [viewButtons[i] setTitle:buttonStrings[i] forState:UIControlStateNormal];
            [viewButtons[i] addTarget:self action:@selector(postCallButtonDown:) forControlEvents:UIControlEventTouchDown];
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
    
    //if this call was triggered from the playlist view controller, remove call from that list
    //printf("\n parentVC exists? %d", [self parentViewController]);
    
    if( [[[self parentViewController] selectedViewController ]respondsToSelector:@selector(removeInfo:)] ){
    //if( [[self parentViewController] isClass:[SecondViewController class]] ){
        
        printf(" ..and responds!");
        [[[self parentViewController] selectedViewController] removeInfo:studentInfo];
    }
    
    
    PhoneCall *newCall = [[PhoneCall alloc] init];
    [newCall setCallDate:[NSDate date]];
    [newCall setCallReport:clickedButton.currentTitle];
    [newCall setStudentInfo:studentInfo];
    
    
    // send the just created call to the server
    
    
    NSString *urlEndpoint = [NSString stringWithFormat:@"http://23.21.212.190:5000/api/v1/clog/?student_id=%@", studentInfo.studentId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                    initWithURL:[NSURL URLWithString:urlEndpoint]];
    //[request setHTTPBody:[newCall toJson];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:[request autorelease] delegate:self];
    
    [self back];
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
