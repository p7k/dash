//
//  StudentInfoViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudentInfoViewController.h"

@implementation StudentInfoViewController
@synthesize studentInfo;
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

-(id)initWithStudentInfo:(StudentInfo *)inInfo allGroupNamesArray:(NSMutableArray*)inAllGroupNamesArray{
    self = [super init];
    printf("\ncreate studentVC");
    allGroupNamesArray = inAllGroupNamesArray;
    studentInfo = inInfo;
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    UIView* underNotesView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40+90)];
    underNotesView.backgroundColor=[UIColor blackColor];
    underNotesView.layer.shadowColor = [UIColor blackColor].CGColor;
    underNotesView.layer.shadowOpacity = 1.0;
    underNotesView.layer.shadowRadius = 1.0;
    underNotesView.layer.shadowOffset = CGSizeMake(0, 1);
    underNotesView.clipsToBounds = NO; 
    [self.view addSubview:underNotesView];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    [self.view addSubview:headerView];
    
    //spinner
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame = CGRectMake(40 , 0, 40, 40);
    [spinner setHidesWhenStopped:NO];
    [headerView addSubview:spinner];
    
    //UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
	UIButton *backButton  = [DashConstants gradientButton];
    backButton.frame = CGRectMake(10, 5, 50, 25);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    backButton.backgroundColor = [UIColor grayColor ];
    backButton.layer.cornerRadius=4;
    [headerView addSubview:backButton];
    
   topLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 180, 30)];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = UITextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:topLabel];
    
   
    notesView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
     notesView.frame =CGRectMake(20, 60, 280, 90);
    notesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    notesView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:notesView];
    
    //INFO
    lastContactLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 240, 20)];
    lastContactLabel.backgroundColor=[UIColor clearColor];
    [notesView addSubview:lastContactLabel];
    numberOfCallsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 240, 20)];
    numberOfCallsLabel.backgroundColor=[UIColor clearColor];
    [notesView addSubview:numberOfCallsLabel];
    positivityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, 240, 20)];
    positivityLabel.backgroundColor=[UIColor clearColor];
    [notesView addSubview:positivityLabel];
    
    
    NSArray* segItems = [NSArray arrayWithObjects:@"Contacts",@"Call Log",@"Groups", nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segItems];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame=CGRectMake(20,170, 280, 40);
    [segmentedControl addTarget:self action:@selector(segDown) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    UIView* underPadView = [[UIView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];
    underPadView.backgroundColor=[UIColor blackColor];
    underPadView.layer.shadowColor = [UIColor blackColor].CGColor;
    underPadView.layer.shadowOpacity = 1.0;
    underPadView.layer.shadowRadius = 1.0;
    underPadView.layer.shadowOffset = CGSizeMake(0, 1);
    underPadView.clipsToBounds = NO; 
    [self.view addSubview:underPadView];
    
    contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];// style:<#(UITableViewStyle)#>
    contactTableView.dataSource=self;
    contactTableView.delegate = self;
    contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contactTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];
    [self.view addSubview:contactTableView];
    
    callLogTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];// style:<#(UITableViewStyle)#>
    callLogTableView.dataSource=self;
    callLogTableView.delegate = self;
    callLogTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    callLogTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];
    [self.view addSubview:callLogTableView];
    callLogTableView.hidden=YES;
    
    groupMemberTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];// style:<#(UITableViewStyle)#>
    groupMemberTableView.dataSource=self;
    groupMemberTableView.delegate = self;
    groupMemberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    groupMemberTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];
    [self.view addSubview:groupMemberTableView];
     groupMemberTableView.hidden=YES;
    
    newContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    newContactButton.frame = CGRectMake(110, 425, 100,25);
    newContactButton.backgroundColor = [UIColor grayColor];
    [newContactButton setTitle:@"new contact" forState:UIControlStateNormal];
    newContactButton.layer.cornerRadius=4;
    [newContactButton addTarget:self action:@selector(newContactButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newContactButton];
    
    
    
    //this was in "setStudentInfo", moved here
    topLabel.text = [inInfo fullName];
    
    printf("\nstudentinfoview : set student info %s, %d contacts, %d calls", [[studentInfo fullName] cString], [[studentInfo contactsArray] count], [studentInfo callCount] );
    
    [self updateCallInfoElements];
    
   //====
    return self;
}

-(void) updateCallInfoElements{//called both from init and from end of sync
    
    NSDate* lastContactDate=nil;
    if([[studentInfo phoneCallArray] count]>0) lastContactDate= [[[studentInfo phoneCallArray] objectAtIndex:0] callDate];
    
    if(lastContactDate==nil) lastContactLabel.text=@"Last Contact: --";
    else lastContactLabel.text = [NSString stringWithFormat:@"Last Contact: %@", [[DashConstants dateFormatter] stringFromDate:lastContactDate]];
    
    numberOfCallsLabel.text = [NSString stringWithFormat:@"Number of Calls: %d", [[studentInfo phoneCallArray] count] ];
    
    int positivitySum =0;
    for(PhoneCall* currCall in [studentInfo phoneCallArray]){
        if([[currCall callIntent] intValue] == 1){
            positivitySum++;
        }
        
    }
    int percent;
    if([[studentInfo phoneCallArray]count]==0) percent=0;
    else percent= (positivitySum*100)/[[studentInfo phoneCallArray] count];
    positivityLabel.text = [NSString stringWithFormat:@"Positivity: %d%%", percent];
    
    [callLogTableView reloadData];

}

-(UITableView*)contactTableView{
    return contactTableView;
}

-(void)newContactButtonHit{
    NewContactViewController* ncvc = [[NewContactViewController alloc]initWithStudentInfo:studentInfo contactInfo:nil];
    ncvc.delegate=self;//for updating table on dismissal
    [self presentModalViewController:ncvc animated:YES];

    
}

-(void)segDown{
    int index = [segmentedControl selectedSegmentIndex];
    if(index==1){
        contactTableView.hidden=YES;
        callLogTableView.hidden=NO;
        groupMemberTableView.hidden=YES;
    }
    else if (index==0){
       
        contactTableView.hidden=NO;
         callLogTableView.hidden=YES;
        groupMemberTableView.hidden=YES;
    }
    else if (index==2){
        
        contactTableView.hidden=YES;
        callLogTableView.hidden=YES;
        groupMemberTableView.hidden=NO;
    }
    
	//printf("newVoxCount=%d ", newVoxCount);
	//[parentVC setVoxCount:newVoxCount];   
}

/*-(void)setStudentInfo:(StudentInfo*) inInfo{
    
    studentInfo = inInfo;
    topLabel.text = [inInfo name];
    
     printf("\nstudentinfoview : set student info %s, %d contacts, %d calls", [[studentInfo name] cString], [[studentInfo contactsArray] count], [[studentInfo phoneCallArray] count] );
       
    NSDate* lastContactDate=nil;
    if([[studentInfo phoneCallArray] count]>0) lastContactDate= [[[studentInfo phoneCallArray] objectAtIndex:0] callDate];
    
    if(lastContactDate==nil) lastContactLabel.text=@"Last Contact: --";
    else lastContactLabel.text = [NSString stringWithFormat:@"Last Contact: %@", [[DashConstants dateFormatter] stringFromDate:lastContactDate]];
                            
    numberOfCallsLabel.text = [NSString stringWithFormat:@"Number of Calls: %d", [[studentInfo phoneCallArray] count] ];
    
    int positivitySum =0;
    for(PhoneCall* currCall in [studentInfo phoneCallArray]){
        if([[currCall callIntent] intValue] == 1){
            positivitySum++;
        }
       
    }
    int percent;
    if([[studentInfo phoneCallArray]count]==0) percent=0;
    else percent= (positivitySum*100)/[[studentInfo phoneCallArray] count];
    positivityLabel.text = [NSString stringWithFormat:@"Positivity: %d%%", percent];

    [callLogTableView reloadData];
    [contactTableView reloadData];

}*/


-(void)back{
    [self dismissModalViewControllerAnimated:YES];
}
    


//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView==contactTableView) return [[studentInfo contactsArray ]count];
    if(tableView==callLogTableView) return [[studentInfo phoneCallArray ]count];
    if(tableView==groupMemberTableView) return [ allGroupNamesArray count] -1;//ignore first element
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//printf("\ncalled !LISTwillDisplay cell name %s", [[[[cell callIntent] studentInfo] name] cString]);
	//if([[cell callIntent] isHappy]) cell.backgroundColor = [DashConstants theHappyColor];
	//else cell.backgroundColor = [DashConstants theSadColor];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[DashConstants cellGradientImage]];
	cell.backgroundColor = [UIColor whiteColor];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==contactTableView){
    printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
    ContactInfo* currContactInfo = [[studentInfo contactsArray] objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currContactInfo fullName];
    ContactInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
    if(cell==nil){
        cell = [[ContactInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
        [cell setContactInfo:currContactInfo];
        [cell setStudentInfo:studentInfo];
        [cell setParentVC:self];
    }
    return cell;
    }
    
    else if(tableView == callLogTableView){
        printf("\ncell phone create index %d ", [indexPath indexAtPosition:1]);
        PhoneCall* currPhoneCall = [[studentInfo phoneCallArray] objectAtIndex: [indexPath indexAtPosition:1]];
        NSString *CellPersIDString = [[DashConstants dateFormatter] stringFromDate:[currPhoneCall callDate]];
        CallLogTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
        if(cell==nil){
            cell = [[CallLogTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
            //[[cell textLabel] setNumberOfLines:3];
            //[cell textLabel].text = [NSString stringWithFormat:@"%s \n %s", [[[currPhoneCall contactInfo] name] cString], [[dateFormatter stringFromDate:[currPhoneCall callDate]] cString] ];
                        
            [cell setPhoneCall:currPhoneCall];
            
            
        }
        return cell;
    }
    
    else if(tableView == groupMemberTableView){
        //NSString* groupName = [[[self parentViewController] allGroupsNamesArray] objectAtIndex:[indexPath indexAtPosition:1]];
        NSString* groupName = [ allGroupNamesArray objectAtIndex:[indexPath indexAtPosition:1]+1];
        GroupMemberTableCell* cell = [tableView dequeueReusableCellWithIdentifier:groupName];
        if(cell==nil){
            cell = [[GroupMemberTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupName] ;
            [cell setGroupNameString:groupName];
            [cell setStudentInfo:studentInfo];
        }
        return cell;
        
    }

    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView==contactTableView) return 40;
    else if(tableView==callLogTableView) return 40;
	else if (tableView == groupMemberTableView) return 40;
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    if(tableView==contactTableView){
        int newIndex = [indexPath indexAtPosition:1];
        NewContactViewController* ncvc = [[NewContactViewController alloc]initWithStudentInfo:studentInfo contactInfo:[[studentInfo contactsArray] objectAtIndex:newIndex] ];
        ncvc.delegate=self;//for updating table on dismissal
        [self presentModalViewController:ncvc animated:YES];
        
    }
    
    if(tableView==groupMemberTableView){
        int newIndex = [indexPath indexAtPosition:1];
        
    }
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
    [spinner startAnimating];
    [NSThread detachNewThreadSelector:@selector(sync) toTarget:self withObject:nil];
   
}

-(void)sync{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    // we may not need to do this if there's already some call logs. Let's deal with that case later
    NSError *error = nil;
    NSString *urlEndpoint = [NSString stringWithFormat:@"http://23.21.212.190:5000/api/v1/clog?student_id=%@", studentInfo.studentId];
    NSURL *url = [NSURL URLWithString:urlEndpoint];
    NSString *callsJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    //printf("\n========CALLS\n %s", [callsJson cString]);
    
    printf("\n %s", [callsJson cString]);
    if (callsJson!=nil && [callsJson length]>0) {
        
        [studentInfo setPhoneCallArray:[PhoneCall createCallListFromJson:callsJson withStudentInfo:studentInfo]];
        [self performSelectorOnMainThread:@selector(syncFinishedWithSuccess:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        
    }
        
     else  [self performSelectorOnMainThread:@selector(syncFinishedWithSuccess:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];

     [pool release];
}

-(void)syncFinishedWithSuccess:(NSNumber*)inSuccessBoolNumber{
    printf("\ncalls sync finished with success %d, count %d",  [inSuccessBoolNumber boolValue], [[studentInfo phoneCallArray] count]);
    [spinner stopAnimating];
    if([inSuccessBoolNumber boolValue]==YES){
        spinner.hidden=YES; 
        [self updateCallInfoElements];
    }
    else spinner.backgroundColor=[UIColor redColor];
    
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

@end
