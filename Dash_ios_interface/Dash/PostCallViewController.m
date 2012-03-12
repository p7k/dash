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
@synthesize studentInfo, parentVC, contactInfo, callIntent;

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
        
        //UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        UIButton *backButton = [DashConstants gradientButton];
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
            viewButtons[i].frame=CGRectMake(20, 80+i*70, 280, 55);
            [viewButtons[i] setTitle:buttonStrings[i] forState:UIControlStateNormal];
            [viewButtons[i] addTarget:self action:@selector(postCallButtonDown:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:viewButtons[i]];
        }
            
        
        NSString* callIntentStrings[3]={@"hap",@"neut",@"bad"};
        for(int i=0;i<3;i++){
            intentButtons[i] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            intentButtons[i].frame = CGRectMake(20+i*95, 360, 85, 55);
            [intentButtons[i] setTitle:callIntentStrings[i] forState:UIControlStateNormal];
            [intentButtons[i] setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
            [intentButtons[i] addTarget:self action:@selector(intentButtonDown:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:intentButtons[i]];
        }

    }
    return self;
}


-(void)intentButtonDown:(UIButton*)inButton{
    for(int i=0;i<3;i++){
        if(inButton==intentButtons[i]){
            [self setIntent:i];//sets my variable and updates buttons
        }
    }
}

-(void)setIntent:(int)inIntent{
    intent=inIntent;
    [self setIntentButtonState:inIntent];
}

-(void)setIntentButtonState:(int)inStatus{//this doesn't affect the call status, assign that separately
    for(int i=0;i<3;i++){
        intentButtons[i].selected=NO;
    }
    intentButtons[inStatus].selected=YES;
}

-(void)setStudentInfo:(StudentInfo*)inInfo{
    printf("\nsetStudentInfo %s", [[inInfo fullName] cString ] );
    studentInfo = inInfo;
    topLabel.text = [inInfo fullName];   
}

-(void)back{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)postCallButtonDown:(id)sender{
    UIButton *clickedButton = (UIButton *) sender;
    
    //if this call was triggered from the playlist view controller, remove call from that list
    //printf("\n parentVC exists? %d", [self parentViewController]);
    //printf("\nselected VC index %d", [[self parentViewController] selectedIndex ] );
    
    //if( [[self parentViewController] selectedIndex ]==1) {//espondsToSelector:@selector(removeInfo:)] ){
    //if( [[self parentViewController] isClass:[SecondViewController class]] ){
        
        //printf(" ..and responds!");
      if(parentVC!=nil)  [parentVC removeInfo:studentInfo];
    //}
    
    
    PhoneCall *newCall = [[PhoneCall alloc] init];
    [newCall setCallDate:[NSDate date]];
    [newCall setCallReport:clickedButton.currentTitle];
    [newCall setStudentInfo:studentInfo];
    [newCall setContactInfo:contactInfo];
   // [newCall setCallIntent:????
    //[newCall setCallStatus:????
    
    // send the just created call to the server
    
    
    NSString *urlEndpoint = [NSString stringWithFormat:@"http://23.21.212.190:5000/api/v1/clog_entry", studentInfo.studentId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                    initWithURL:[NSURL URLWithString:urlEndpoint]];
    [request setHTTPBody:[newCall toJson]];
    [request setHTTPMethod:@"POST"];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection connectionWithRequest:[request autorelease] delegate:self];
    
    // also add it to the current StudentInfo
    
    [[studentInfo phoneCallArray] addObject:newCall];
    
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


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

// delegate methods for NSURLConnection

// required methods: connection:didReceiveResponse:, connection:didReceiveData:, connection:didFailWithError: and connectionDidFinishLoading:.

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    //[connection release];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // release the connection, and the data object
    //[connection release];
 }
@end
