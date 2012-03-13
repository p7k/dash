//
//  StudentInfoViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewStudentViewController.h"

@implementation NewStudentViewController
@synthesize studentInfo, delegate, controlHub;
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }*/

-(id)initWithDelegate:(ClassroomViewController*)parentVC controlHub:(ControlHub*)inControlHub{
    self = [super init];
    printf("\ncreate new student");
    
    delegate = parentVC;
    controlHub = inControlHub;
    studentInfo = [[StudentInfo alloc]init ];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
   
    
    
    //top header
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    [self.view addSubview:headerView];
    
    headerLabel = [[UILabel alloc]init ];//WithFrame:CGRectMake(0, 0, 320, 40)];
    headerLabel.frame = headerView.frame;
    headerLabel.text = @"New Student";
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:headerLabel];
    
   
    
    cancelButton = [DashConstants gradientButton];
    
    cancelButton.frame = CGRectMake(20, 5, 60,25);
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius=4;
    [cancelButton addTarget:self action:@selector(cancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];
    
    doneButton = [DashConstants gradientButton];
    
    doneButton.frame = CGRectMake(250, 5, 60,25);
    doneButton.backgroundColor = [UIColor grayColor];
    [doneButton setTitle:@"done" forState:UIControlStateNormal];
    doneButton.layer.cornerRadius=4;
    [doneButton addTarget:self action:@selector(doneButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doneButton];
    
    
    
    /*UIView* underNotesView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 280, 40+90)];
    underNotesView.backgroundColor=[UIColor blackColor];
    underNotesView.layer.shadowColor = [UIColor blackColor].CGColor;
    underNotesView.layer.shadowOpacity = 1.0;
    underNotesView.layer.shadowRadius = 5.0;
    underNotesView.layer.shadowOffset = CGSizeMake(5, 5);
    underNotesView.clipsToBounds = NO; 
    [self.view addSubview:underNotesView];*/
    
    firstNameTextField = [[UITextField alloc]initWithFrame:CGRectMake( 10, 60, 300, 40 ) ];
	[firstNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	//firstNameTextField.layer.borderColor=[[MBConstants thePurpleColor] CGColor];
	firstNameTextField.layer.cornerRadius=10 ;
	//firstNameTextField.layer.borderWidth=2;
	firstNameTextField.delegate=self;
	firstNameTextField.textAlignment=UITextAlignmentCenter;
    [firstNameTextField setPlaceholder:@"First Name"];
    firstNameTextField.font = [UIFont systemFontOfSize:24];
	firstNameTextField.backgroundColor=[UIColor whiteColor];//[MBConstants theRedHighlightColor];
	//firstNameTextField.font=[MBConstants paramDigitFont];
	[self.view addSubview:firstNameTextField];
    
    lastNameTextField = [[UITextField alloc]initWithFrame:CGRectMake( 10, 105, 300, 40 ) ];
	[lastNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	//lastNameTextField.layer.borderColor=[[MBConstants thePurpleColor] CGColor];
	lastNameTextField.layer.cornerRadius=10 ;
	//lastNameTextField.layer.borderWidth=2;
	lastNameTextField.delegate=self;
	lastNameTextField.textAlignment=UITextAlignmentCenter;
    [lastNameTextField setPlaceholder:@"Last Name"];
    lastNameTextField.font = [UIFont systemFontOfSize:24];
	lastNameTextField.backgroundColor=[UIColor whiteColor];//[MBConstants theRedHighlightColor];
	//lastNameTextField.font=[MBConstants paramDigitFont];
	[self.view addSubview:lastNameTextField];

  
    
    NSArray* segItems = [NSArray arrayWithObjects:@"Contact Info",@"Groupings", nil];
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

   
    return self;
}



-(void)segDown{
    int index = [segmentedControl selectedSegmentIndex];
    if(index==1){
        contactTableView.hidden=YES;
        groupMemberTableView.hidden=NO;
    }
    else if (index==0){
        
        contactTableView.hidden=NO;
        groupMemberTableView.hidden=YES;
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


-(void)cancelButtonHit{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)doneButtonHit{
    [studentInfo setFirstName:[firstNameTextField text]];
     [studentInfo setLastName:[lastNameTextField text]];
    [[controlHub classInfoArray] addObject:studentInfo];
//    [[delegate mainTableView] reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

-(UITableView*)contactTableview{
    return contactTableView;
    
}

-(UITableView*)contactTableView{
    return contactTableView;
}

-(void)newContactButtonHit{
    NewContactViewController* ncvc = [[NewContactViewController alloc]initWithStudentInfo:studentInfo contactInfo:nil];
    ncvc.delegate=self;//for updating table on dismissal
    [self presentModalViewController:ncvc animated:YES];
} 

//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView==contactTableView) return [[studentInfo contactsArray ]count];
    if(tableView==groupMemberTableView) return [[controlHub allGroupNamesArray ]count]-1;
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
        printf("\ncell create index %d -", [indexPath indexAtPosition:1]);
        ContactInfo* currContactInfo = [[studentInfo contactsArray] objectAtIndex: [indexPath indexAtPosition:1]];
        NSString *CellPersIDString = [currContactInfo fullName];
        printf(" %s", [[currContactInfo fullName] cString]);
        NewContactInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
        if(cell==nil){
            cell = [[NewContactInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
            
            //[cell setStudentInfo:studentInfo];
            //[cell setParentVC:self];
        }
        [cell setContactInfo:currContactInfo];//put it outside of just on new cells!
        return cell;
    }
    
       
    else if(tableView == groupMemberTableView){
        //NSString* groupName = [[[self parentViewController] allGroupsNamesArray] objectAtIndex:[indexPath indexAtPosition:1]];
        NSString* groupName = [ [controlHub allGroupNamesArray] objectAtIndex:[indexPath indexAtPosition:1]+1];
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
	if(tableView==contactTableView) return 60;
	else return 40;
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    if(tableView==contactTableView){
        int newIndex = [indexPath indexAtPosition:1];
        NewContactViewController* ncvc = [[NewContactViewController alloc]initWithStudentInfo:studentInfo contactInfo:[[studentInfo contactsArray] objectAtIndex:newIndex] ];
        ncvc.delegate=self;//for updating table on dismissal
        [self presentModalViewController:ncvc animated:YES];
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//printf("\nshoudl return!");
	
    /*if(textField==firstNameTextField) [studentInfo setFirstName:[textField text]];
    if(textField==lastNameTextField) [studentInfo setLastName:[textField text]];*/
	[textField resignFirstResponder];
    

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

@end
