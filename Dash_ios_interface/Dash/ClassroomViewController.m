//
//  FirstViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassroomViewController.h"

@implementation ClassroomViewController
@synthesize searchBar, mainTableView,  groupsTableView, spinner;
@synthesize controlHub ;

int myCornerRadius=10;



/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}*/

- (id)initWithHub:(ControlHub*)inControlHub{//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

    self = [super init];//initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        controlHub = inControlHub;
        self.title = NSLocalizedString(@"Roster", @"Roster");
        self.tabBarItem.image = [UIImage imageNamed:@"Roster_icon.png"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    }
    return self;
}

							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    printf("\nview did load");
    
    
   
    
    //@"name", @"recency most recent first", @"recency least recent first", 
    NSString* sortTitles[7] = {@"name", @"most recent", @"least recent", @"positive", @"negative", @"most calls", @"fewest calls" }; 
    
    
    classInfoSearchSubArray = [[NSMutableArray alloc]init ];
    classInfoInGroupArray = [[NSMutableArray alloc]init ];
    for(StudentInfo* studentInfo in [controlHub classInfoArray]){
        [classInfoInGroupArray addObject:studentInfo];
    }
    
    //interface====
    //top header
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
     [self.view addSubview:headerView];
    
    UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[DashConstants titleImage]];
    titleImageView.frame =CGRectMake(104+20, 5, 72, 30);
    [headerView addSubview:titleImageView];
    
    sideMenuButton = [DashConstants gradientButton];
    
    sideMenuButton.frame = CGRectMake(20, 5, 60,25);
    sideMenuButton.backgroundColor = [UIColor grayColor];
    [sideMenuButton setTitle:@"-" forState:UIControlStateNormal];
    sideMenuButton.layer.cornerRadius=4;
    [sideMenuButton addTarget:self action:@selector(sideMenuButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideMenuButton];

    addStudentButton = [DashConstants gradientButton];
    
    addStudentButton.frame = CGRectMake(250, 5, 60,25);
    addStudentButton.backgroundColor = [UIColor grayColor];
    [addStudentButton setTitle:@"+" forState:UIControlStateNormal];
    addStudentButton.layer.cornerRadius=4;
    [addStudentButton addTarget:self action:@selector(addStudentButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addStudentButton];
    
    
    //spinner
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame = CGRectMake(0 , 0, 40, 40);
    [spinner setHidesWhenStopped:NO];
    [headerView addSubview:spinner];
    
    //group header Label with image!
    /*groupHeaderView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 280, 80)];
    groupHeaderView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    [self.view addSubview:groupHeaderView];
    */
    
    roundedContentView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, 300, 340)];
    roundedContentView.clipsToBounds = YES;
    roundedContentView.layer.cornerRadius = myCornerRadius;
    [self.view addSubview:roundedContentView];
    
    groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,300,40)];//(20, 50, 280, 40)];
    groupNameLabel.textAlignment = UITextAlignmentCenter;
    groupNameLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    groupNameLabel.text = [[controlHub allGroupNamesArray] objectAtIndex:0];
    groupNameLabel.font=[UIFont systemFontOfSize:24];
    groupNameLabel.textColor = [UIColor whiteColor];
    [roundedContentView addSubview:groupNameLabel];

    
    groupsTableButton = [DashConstants gradientButton];
    
    groupsTableButton.frame = CGRectMake(20, 5, 30,25);
    groupsTableButton.backgroundColor = [UIColor grayColor];
    [groupsTableButton setTitle:@"g" forState:UIControlStateNormal];
    groupsTableButton.layer.cornerRadius=4;
    [groupsTableButton addTarget:self action:@selector(groupsTableButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [roundedContentView addSubview:groupsTableButton];
    
    searchHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 40,300,40)];//(20, 90, 280, 80)];
    searchHeaderView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bar_gradient_dark.png"]];
    [roundedContentView addSubview:searchHeaderView];
    
    //search bar under search header
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,230, 40)];
    searchBar.showsCancelButton = NO;//only show on edit
    searchBar.delegate = self;
   // searchBar.tintColor = [UIColor grayColor];
    //searchBar.barStyle = UIBarStyleBlack;
    searchBar.translucent = YES;
    [searchHeaderView addSubview:searchBar];
    
    sortTableButton = [DashConstants gradientButton];
    
    sortTableButton.frame = CGRectMake(240, 7, 50,25);
    sortTableButton.backgroundColor = [UIColor grayColor];
    [sortTableButton setTitle:@"sort" forState:UIControlStateNormal];
    sortTableButton.layer.cornerRadius=4;
    [sortTableButton addTarget:self action:@selector(sortTableButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [searchHeaderView addSubview:sortTableButton];
    
    
    
    
    UIView* underPadView = [[UIView alloc]init];
    underPadView.frame = roundedContentView.frame;
    underPadView.backgroundColor=[UIColor blackColor];
    underPadView.layer.shadowColor = [UIColor blackColor].CGColor;
    underPadView.layer.shadowOpacity = 1.0;
    underPadView.layer.shadowRadius = 1.0;
    underPadView.layer.cornerRadius = myCornerRadius;
    underPadView.layer.shadowOffset = CGSizeMake(0, 1);
    underPadView.clipsToBounds = NO; 
    [self.view addSubview:underPadView];
    [self.view sendSubviewToBack:underPadView];
    
   
    
       
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 300, 260)];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];
    //mainTableView.layer.cornerRadius = myCornerRadius;
    //mainTableView.clipsToBounds = YES;
    [roundedContentView addSubview:mainTableView];
   
    //Groups View
    
    groupsView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 280, 340)];
    groupsView.layer.cornerRadius=4;
    groupsView.hidden = YES;
    groupsView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:groupsView];
    
    groupsTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 260, 280)];
    groupsTableView.dataSource = self;
    groupsTableView.delegate = self;
    [groupsView addSubview:groupsTableView];
    
    UIButton* addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addGroupButton.backgroundColor = [UIColor lightGrayColor];
    addGroupButton.frame = CGRectMake(80, 300, 120, 30);
    addGroupButton.layer.cornerRadius=4;
    [addGroupButton setTitle:@"add group" forState:UIControlStateNormal];
    [addGroupButton addTarget:self action:@selector(addGroupButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [groupsView addSubview:addGroupButton];
    
    //sort options
    
    sortOptionsView = [[UIView alloc]initWithFrame:CGRectMake(200, 80+50, 120, 400)];
    sortOptionsView.hidden = YES;
    [self.view addSubview: sortOptionsView];
    
    for(int i=0;i<7;i++){
        sortOptionButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        sortOptionButton[i].backgroundColor = [UIColor grayColor];
        sortOptionButton[i].frame = CGRectMake(0, i*40, 120, 40);
        [sortOptionButton[i] setTitle:sortTitles[i] forState:UIControlStateNormal];
        [sortOptionButton[i] addTarget:self action:@selector(sortOptionButtonHit:) forControlEvents:UIControlEventTouchUpInside];
        [sortOptionsView addSubview:sortOptionButton[i]];
    }
    
    //add group alert
    /*addGroupAlert = [[UIAlertView alloc]initWithTitle:@"Create Group" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil ]; 
    
       
     addGroupAlertTextField = [[UITextField alloc] initWithFrame:CGRectMake(16,40,252,25)];
    addGroupAlertTextField.font = [UIFont systemFontOfSize:18];
    addGroupAlertTextField.backgroundColor = [UIColor whiteColor];
    addGroupAlertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    addGroupAlertTextField.delegate = self;
    [addGroupAlertTextField becomeFirstResponder];//here or on show?
    addGroupAlertTextField.layer.cornerRadius=4; 
    [addGroupAlertTextField setPlaceholder:@"New Group Name"];
    [addGroupAlert addSubview:addGroupAlertTextField];
    
    [addGroupAlert setTransform:CGAffineTransformMakeTranslation(0,30)];*/
  
    
    //====add group view
    
    addGroupView = [[UIView alloc]initWithFrame:CGRectMake(80, 100, 160, 200)];
    addGroupView.backgroundColor = [UIColor greenColor];
    addGroupView.layer.cornerRadius=4;
    addGroupView.hidden=YES;
    [self.view addSubview:addGroupView];
    
    UILabel* addGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 140, 30 )];
    addGroupLabel.textAlignment = UITextAlignmentCenter;
    addGroupLabel.text = @"Add Group";
    addGroupLabel.backgroundColor=[UIColor clearColor];
    [addGroupView addSubview:addGroupLabel];
    
    addGroupTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 60, 140, 20)];
    addGroupTextField.placeholder = @"group name";
    addGroupTextField.textAlignment=UITextAlignmentCenter;
    addGroupTextField.backgroundColor = [UIColor whiteColor];
    addGroupTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    addGroupTextField.delegate=self;
    [addGroupView addSubview:addGroupTextField];
    
    addGroupCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addGroupCancelButton.frame = CGRectMake(10, 100, 60, 30);
    [addGroupCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [addGroupCancelButton addTarget:self action:@selector(addGroupCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [addGroupView addSubview:addGroupCancelButton];
    
    addGroupOkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addGroupOkButton.frame = CGRectMake(90, 100, 60, 30);
    [addGroupOkButton setTitle:@"OK" forState:UIControlStateNormal];
     [addGroupOkButton addTarget:self action:@selector(addGroupOkButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [addGroupView addSubview:addGroupOkButton];
    
    //====add student view
    
    addStudentView = [[UIView alloc]initWithFrame:CGRectMake(80, 100, 160, 200)];
    addStudentView.backgroundColor = [UIColor greenColor];
    addStudentView.layer.cornerRadius=4;
    addStudentView.hidden=YES;
    [self.view addSubview:addStudentView];
    
    UILabel* addStudentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 140, 30 )];
    addStudentLabel.textAlignment = UITextAlignmentCenter;
    addStudentLabel.text = @"Add Student";
    addStudentLabel.backgroundColor=[UIColor clearColor];
    [addStudentView addSubview:addStudentLabel];
    
    addStudentFirstNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 40, 140, 20)];
    addStudentFirstNameTextField.placeholder = @"first name";
    addStudentFirstNameTextField.textAlignment=UITextAlignmentCenter;
    addStudentFirstNameTextField.backgroundColor = [UIColor whiteColor];
    addStudentFirstNameTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    addStudentFirstNameTextField.delegate=self;
    [addStudentView addSubview:addStudentFirstNameTextField];
    
    addStudentLastNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, 140, 20)];
    addStudentLastNameTextField.placeholder = @"last name";
    addStudentLastNameTextField.textAlignment=UITextAlignmentCenter;
    addStudentLastNameTextField.backgroundColor = [UIColor whiteColor];
    addStudentLastNameTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    addStudentLastNameTextField.delegate=self;
    [addStudentView addSubview:addStudentLastNameTextField];
    
    addStudentCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addStudentCancelButton.frame = CGRectMake(10, 100, 60, 30);
    [addStudentCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [addStudentCancelButton addTarget:self action:@selector(addStudentCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [addStudentView addSubview:addStudentCancelButton];
    
    addStudentOkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addStudentOkButton.frame = CGRectMake(90, 100, 60, 30);
    [addStudentOkButton setTitle:@"OK" forState:UIControlStateNormal];
    [addStudentOkButton addTarget:self action:@selector(addStudentOkButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [addStudentView addSubview:addStudentOkButton];
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField==addGroupTextField)[self addGroupOkButtonHit];
    if(textField==addStudentFirstNameTextField)[addStudentLastNameTextField becomeFirstResponder];
    if(textField==addStudentLastNameTextField)[self addStudentOkButtonHit];
    
    
}


-(void)syncFinishedWithSuccess:(NSNumber*)inSuccessBoolNumber{
    printf("\nsync finished with success %d",  [inSuccessBoolNumber boolValue]);
     [spinner stopAnimating];
    if([inSuccessBoolNumber boolValue]==YES){
        spinner.hidden=YES; 
        
        //copy into group - but what happens if user has already selected a group!?!?!? ARGH TODO
        [classInfoInGroupArray removeAllObjects];
        for(StudentInfo* studentInfo in [controlHub classInfoArray]){
            [classInfoInGroupArray addObject:studentInfo];
        }
             
      
            
    }
    else spinner.backgroundColor=[UIColor redColor];

}

/*-(void)updateGroupsListing{
    printf("\n====update groups");
    
    [classInfoInGroupArray removeAllObjects];
    for(StudentInfo* studentInfo in classInfoArray){
       // printf("*");
        [classInfoInGroupArray addObject:studentInfo];
        
        //also compile allGroupNamesArray
        for(NSString* groupString in [studentInfo groupStringArray]){
            //printf("-");
            //printf("\nlook for %s in allGroupNamesArray count %d", [groupString cString], [allGroupNamesArray count]);
            BOOL found=NO;
            for(int i=0;i<[allGroupNamesArray count]; i++){
                //printf("\n  compare %s %s %d", [groupString cString],[[allGroupNamesArray objectAtIndex:i] cString],[groupString compare:[allGroupNamesArray objectAtIndex:i]]  );
                if ([groupString compare:[allGroupNamesArray objectAtIndex:i]] == NSOrderedSame){
                    //printf(" FOUND");
                    found=YES;
                    break;//move to next group string in student
                }
            }
            if(!found){
                [allGroupNamesArray addObject:groupString];
                //printf("\n found new group: %s", [groupString cString]);
                
            }
        }
    }
    [groupsTableView reloadData];

    
}*/

/*-(void)addStudentInfo:(StudentInfo*)inInfo{
    printf("\nadd %s", [[inInfo fullName] cString]);
    [[controlHub classInfoArray] addObject:inInfo];
    //[self updateGroupsListing];
    [mainTableView reloadData];
}*/

//add student view

-(void)addStudentButtonHit{
    //NewStudentViewController *nextController = [[NewStudentViewController alloc] initWithDelegate:self controlHub:controlHub];
    //[self presentModalViewController:nextController animated:YES];
    addStudentView.hidden=NO;
    [addStudentFirstNameTextField becomeFirstResponder];
}

-(void)addStudentCancelButtonHit{
    [addStudentFirstNameTextField resignFirstResponder];
    [addStudentLastNameTextField resignFirstResponder];
    
    addStudentFirstNameTextField.text=nil;
    addStudentLastNameTextField.text = nil;
    
    addStudentView.hidden=YES;
}

-(void)addStudentOkButtonHit{
    StudentInfo* newStudentInfo = [[StudentInfo alloc]init];
    [newStudentInfo setFirstName:[addStudentFirstNameTextField.text copy]];
    [newStudentInfo setLastName:[addStudentLastNameTextField.text copy]];
    //printf("\nadded %s, %s %s", [[newStudentInfo fullName] cString], [[newStudentInfo firstName] cString], [[newStudentInfo lastName] cString]);
    
    [[controlHub classInfoArray] addObject:newStudentInfo ];
    [mainTableView reloadData];
    
    [addStudentFirstNameTextField resignFirstResponder];
    [addStudentLastNameTextField resignFirstResponder];
    addStudentView.hidden=YES;
    
    //launch controller
    StudentInfoViewController *nextController = [[StudentInfoViewController alloc] initWithStudentInfo:newStudentInfo controlHub:controlHub];//WithNibName:@"NextView" bundle:nil];
    nextController.delegate=self;//for reloading table
    [self presentModalViewController:nextController animated:YES];
    
    
}

//add group view

-(void)addGroupButtonHit{
    
    //addGroupAlertTextField.text=nil;
    //[addGroupAlert show];
    addGroupView.hidden=NO;
    [addGroupTextField becomeFirstResponder];
}

-(void)addGroupCancelButtonHit{
    [addGroupTextField resignFirstResponder];
    addGroupTextField.text = nil;
    addGroupView.hidden=YES;
}

-(void)addGroupOkButtonHit{
    NSString* name = [[addGroupTextField text] copy];
    [[controlHub allGroupNamesArray] addObject:name ];
    [groupsTableView reloadData];

    [addGroupTextField resignFirstResponder];
    addGroupView.hidden=YES;
    
    //launch controller
    GroupViewController *nextController = [[GroupViewController alloc] initWithGroupName:name delegate:self controlHub:controlHub];
    nextController.delegate=self;//to relod table on delete
    [self presentModalViewController:nextController animated:YES];
    
}


     


/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [[controlHub allGroupNamesArray] addObject:[addGroupAlertTextField text]];
        [groupsTableView reloadData];
    }
}*/

-(void)editGroupButton:(UIButton*)sender{
    NSString* name = [[sender superview] reuseIdentifier];
    GroupViewController *nextController = [[GroupViewController alloc] initWithGroupName:name delegate:self controlHub:controlHub];
    nextController.delegate=self;//to relod table on delete
    [self presentModalViewController:nextController animated:YES];
}

-(void)sideMenuButtonHit{
    
    CGRect destination = self.parentViewController.view.frame;
    //printf("*%d", destination.origin.x);
    if (destination.origin.x > 0) {
        destination.origin.x = 0;
    } else {
        destination.origin.x += 254.5;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.parentViewController.view.frame = destination;        
        
    } completion:^(BOOL finished) {
        
        //self.view.userInteractionEnabled = !(destination.origin.x > 0);
        
    }];
}

-(void)sortOptionButtonHit:(UIButton*) sender{
    for(int i=0;i<7;i++){
        if (sender == sortOptionButton[i]){
            
            //name
            if(i==0){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    NSString *first = [a lastName];
                    NSString *second = [b lastName];
                    return [first compare:second];
                }];
                [mainTableView reloadData];
            }
            
            //most recent
            if(i==1){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    NSDate *first = [a lastContactDate];
                    NSDate *second = [b lastContactDate];
                    return [second compare:first];
                }];
                [mainTableView reloadData];
            }
            
            //least recent
            if(i==2){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    NSDate *first = [a lastContactDate];
                    NSDate *second = [b lastContactDate];
                    return [first compare:second];
                }];
                [mainTableView reloadData];
            }
            
            //positive
            if(i==3){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    int first = [a positiveCallCount];
                    int second = [b positiveCallCount];
                    //return [second compare:first];
                    if(first<second)return NSOrderedAscending;
                    else if (first>second) return NSOrderedDescending;
                    else return NSOrderedSame;
                }];
                [mainTableView reloadData];
            }
            
            //negative
            if(i==4){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    int first = [a positiveCallCount];
                    int second = [b positiveCallCount];
                    //return [second compare:first];
                    if(first<second)return NSOrderedDescending;
                    else if (first>second) return NSOrderedAscending;
                    else return NSOrderedSame;
                }];
                [mainTableView reloadData];
            }

            //most calls
            if(i==5){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    int first = [a callCount];
                    int second = [b callCount];
                    //return [second compare:first];
                    if(first<second)return NSOrderedAscending;
                    else if (first>second) return NSOrderedDescending;
                    else return NSOrderedSame;
                }];
                [mainTableView reloadData];
            }
            
            //fewest calls
            if(i==6){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    int first = [a callCount];
                    int second = [b callCount];
                    //return [second compare:first];
                    if(first<second)return NSOrderedDescending;
                    else if (first>second) return NSOrderedAscending;
                    else return NSOrderedSame;
                }];
                [mainTableView reloadData];
            }
            
            
            sortOptionsView.hidden=YES;
        }
    }
    
}

//redo
//doesn't actually remove, just resets mood, called from othercontroller. really hack-y!
/*-(void)removeInfo:(StudentInfo*)inInfo{//from first view controller or modal postcall view. 
   // printf("\nremove %s", [[inInfo name] cString])  ;
    //StudentInfo* foundStudentInfo=nil;
   // for(StudentInfo* currStudentInfo in classInfoArray){
    int foundStudentIndex=-1;
    for(int i=0;i<[[controlHub classInfoArray] count];i++){  
        StudentInfo* currStudentInfo = [[controlHub classInfoArray] objectAtIndex:i];
        if(currStudentInfo==inInfo){
            foundStudentIndex = i;
        }
    }
    if(foundStudentIndex!=-1){
       // printf("found %d ", foundStudentIndex);
        int pathArray[2]={0,foundStudentIndex};
        NSIndexPath* path = [NSIndexPath indexPathWithIndexes:pathArray length:2];
        //NSString *CellPersIDString = [foundStudentInfo name];
        //ClassroomTableCell* cell = [mainTableView dequeueReusableCellWithIdentifier:CellPersIDString];
        UITableViewCell* cell = [mainTableView cellForRowAtIndexPath:path];
       // printf(" cell? %d", cell);
        [cell resetMood];
    }
    
} */

//sorting
-(void)sortTableButtonHit{
     [sortOptionsView setHidden:!sortOptionsView.hidden];
    
}

-(void)groupsTableButtonHit{
    
    [groupsView setHidden:NO];
}

//search bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar*)inBar{
    [searchBar resignFirstResponder];
    searching=NO;
    searchBar.text=@"";
     [mainTableView reloadData];
}

- (void)searchBar:(UISearchBar *)inBar textDidChange:(NSString *)searchText{
    printf("\ntext:%s", [searchText cString]);
   
    [classInfoSearchSubArray removeAllObjects];
    
    if([searchText length] > 0) {
        searching = YES;
        for(StudentInfo* currInfo in [controlHub classInfoArray]){
        
            NSRange textRange =[[[currInfo fullName] lowercaseString] rangeOfString:[searchText lowercaseString]];
        
            if(textRange.location != NSNotFound){
                printf("*");
                [classInfoSearchSubArray addObject:currInfo];
            }
        }
    }
    
    else searching=NO;
    
    [mainTableView reloadData];
    
}

/*- (void)searchBarSearchButtonClicked:(UISearchBar *)inBar{
    [searchBar resignFirstResponder];
}*/ //if we resign, we leave the text in the space and the clear button 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
     printf("\nbegin editing");
    searchBar.showsCancelButton = YES;
    //searching=YES;
     [mainTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    printf("\nend editing");
    searchBar.showsCancelButton=NO;
    //searching=NO; - this is called on "search" button hit, so only turn off searching on cancel
}

//====
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // printf("\nhere: %d %d ", );
	if(tableView==groupsTableView){
        return [[controlHub allGroupNamesArray] count];
    }
    else{   //classroom
        if(!searching)return [classInfoInGroupArray count];
        else return [classInfoSearchSubArray count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//printf("\ncalled !LISTwillDisplay");
	cell.backgroundColor = [UIColor whiteColor];//[MBConstants theRedColor];
   // cell.backgroundColor = [UIColor colorWithPatternImage:[DashConstants cellGradientImage]];
	
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView==mainTableView){
    StudentInfo* currStudentInfo;	
    if(!searching) currStudentInfo = [classInfoInGroupArray  objectAtIndex: [indexPath indexAtPosition:1]];
        else currStudentInfo = [classInfoSearchSubArray  objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currStudentInfo fullName] ;
        ClassroomTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
		if(cell==nil){
			cell = [[[ClassroomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] autorelease] ;
			
            
            
            [cell setControlHub:controlHub];//for access to calllistviewcontroller
            cell.parentVC=self;
			
		}
        //do this all the time...ok? - this will update the contact info, success color, name, etc
        [cell setStudentInfo:currStudentInfo];
        
		return cell;
    }
    
    else if (tableView==groupsTableView){//260 wide
        
        NSString* groupName = [[controlHub allGroupNamesArray] objectAtIndex:[indexPath indexAtPosition:1]];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:groupName];
        if(cell==nil){
			cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupName] autorelease] ;
            cell.textLabel.text=groupName;
            cell.textLabel.frame=CGRectMake(0, 0, 220, 40);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if([indexPath indexAtPosition:1]>0){//don't edit full roster
                UIButton* editGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
                editGroupButton.backgroundColor = [UIColor greenColor];
                editGroupButton.frame = CGRectMake(220, 5, 30, 30);
                [editGroupButton addTarget:self action:@selector(editGroupButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:editGroupButton];
            }
        }
        
        return cell;
    }
		
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView == mainTableView) return 40;
	else if (tableView== groupsTableView) return 40;
	
}
-(void)test{
    printf("\nHI!");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
		
    if(tableView == mainTableView){
        
    int newIndex = [indexPath indexAtPosition:1];
        
    //StudentInfoViewController *nextController = [[StudentInfoViewController alloc] init];//
    StudentInfo* selectedStudentInfo;
    if(searching)selectedStudentInfo = [classInfoSearchSubArray objectAtIndex:newIndex];
    else selectedStudentInfo = [classInfoInGroupArray objectAtIndex:newIndex];
        
        StudentInfoViewController *nextController = [[StudentInfoViewController alloc] initWithStudentInfo:selectedStudentInfo controlHub:controlHub];//WithNibName:@"NextView" bundle:nil];
    //[nextController setStudentInfo:[classInfoArray objectAtIndex:newIndex]];
        nextController.delegate=self;//for reload table
    [self presentModalViewController:nextController animated:YES];
    
    }
    
    else if (tableView==groupsTableView) {
        [classInfoInGroupArray removeAllObjects];
        
        if([indexPath indexAtPosition:1]==0){//"all"
            for(StudentInfo* studentInfo in [controlHub classInfoArray]){
                 [classInfoInGroupArray addObject:studentInfo];
            }
           
        }
        else{
            
            currentGroupString = [[controlHub allGroupNamesArray] objectAtIndex: [indexPath indexAtPosition:1]];
            for(StudentInfo* studentInfo in [controlHub classInfoArray]){
                for (NSString* groupString in [studentInfo groupStringArray]){
                    if([groupString compare:currentGroupString]==NSOrderedSame){
                        [classInfoInGroupArray addObject:studentInfo];
                        break;//stop looking at this student, move to next
                    }
                }
            }
        }
        [mainTableView reloadData];
        groupNameLabel.text = [[controlHub allGroupNamesArray] objectAtIndex:[indexPath indexAtPosition:1]];
        [groupsView setHidden:YES];
        
    }
      
        
}




@end
