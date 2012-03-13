//
//  GroupViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"

@implementation GroupViewController
@synthesize delegate, controlHub;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

-(id)initWithGroupName:(NSString*)inGroup delegate:(ClassroomViewController*)inParentVC controlHub:(ControlHub*)inControlHub{
    
    self = [super init];
    delegate = inParentVC;
    controlHub = inControlHub;
    groupName = inGroup;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    //top header
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    [self.view addSubview:headerView];
    
    
    UILabel* headerLabel = [[UILabel alloc]init ];//WithFrame:CGRectMake(0, 0, 320, 40)];
    headerLabel.frame = headerView.frame;
    headerLabel.text = groupName;
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:headerLabel];
    
    
       doneButton = [DashConstants gradientButton];
    
    doneButton.frame = CGRectMake(20, 5, 60,25);
    doneButton.backgroundColor = [UIColor grayColor];
    [doneButton setTitle:@"done" forState:UIControlStateNormal];
    doneButton.layer.cornerRadius=4;
    [doneButton addTarget:self action:@selector(doneButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doneButton];
    
     /* groupNameTextView = [[UITextField alloc]initWithFrame:CGRectMake( 10, 50, 300, 30 ) ];
        [ groupNameTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
       groupNameTextView.layer.cornerRadius=10 ;
       groupNameTextView.delegate=self;
       groupNameTextView.textAlignment=UITextAlignmentCenter;
       if(inGroup==nil) [ groupNameTextView setPlaceholder:@"New Group Name"];
       else [groupNameTextView setText:inGroup];
       groupNameTextView.font = [UIFont systemFontOfSize:24];
        groupNameTextView.backgroundColor=[UIColor whiteColor];
                
        
        [self.view addSubview: groupNameTextView];*/
    
    //delete
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    deleteButton.frame = CGRectMake(110, 420, 100,30);
    deleteButton.backgroundColor = [UIColor grayColor];
    [deleteButton setTitle:@"delete" forState:UIControlStateNormal];
    deleteButton.layer.cornerRadius=4;
    [deleteButton addTarget:self action:@selector(deleteButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];

    
    //table of students

    groupStudentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, 300, 350)];// style:<#(UITableViewStyle)#>
    groupStudentsTableView.dataSource=self;
    groupStudentsTableView.delegate = self;
    groupStudentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    groupStudentsTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];
    [self.view addSubview:groupStudentsTableView];
    
    
    return self;
}

-(void)doneButtonHit{
    
    
    [controlHub reloadClassInfoInGroups];
    [self dismissModalViewControllerAnimated:YES];

}
-(void)cancelButtonHit{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)deleteButtonHit{
    
    UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"Delete Group" message:[NSString stringWithFormat:@"delete %s?", [groupName cString]] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [av show];
    
     //[self dismissModalViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        //[[studentInfo contactsArray] removeObject:contactInfo];
        [[controlHub allGroupNamesArray] removeObject:groupName];//check if there? and leave in student info vs go through and delete? TODO
        [[delegate groupsTableView] reloadData];
        [self dismissModalViewControllerAnimated:YES];
    }
}



//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [ [controlHub classInfoArray] count] ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//cell.backgroundColor = [UIColor whiteColor];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
           //NSString* groupName = [[[self parentViewController] allGroupsNamesArray] objectAtIndex:[indexPath indexAtPosition:1]];
    StudentInfo* studentInfo = [[controlHub classInfoArray] objectAtIndex:[indexPath indexAtPosition:1] ];
        NSString* studentName = [studentInfo fullName];
        GroupStudentsTableCell* cell = [tableView dequeueReusableCellWithIdentifier:studentName];
        if(cell==nil){
            cell = [[GroupStudentsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentName] ;
            [cell setGroupNameString:groupName];
            [cell setStudentInfo:studentInfo];
        }
        return cell;
      
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	 return 40;
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    
        int newIndex = [indexPath indexAtPosition:1];
        
    
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
