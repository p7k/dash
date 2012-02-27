//
//  FirstViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassroomViewController.h"

@implementation ClassroomViewController
@synthesize searchBar, classroomTableView, classInfoArray, groupsTableView, spinner;
@synthesize otherController, allGroupNamesArray;

int myCornerRadius=10;

NSString* _archiveLocation; 
+ (NSString*)archiveLocation{
	if (_archiveLocation == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		_archiveLocation = [[documentsDirectory stringByAppendingPathComponent:@"PresetsDict.ar"] retain];       
		//printf("\ntemp= %s ", [_archiveLocation cString]);
	}
	return _archiveLocation;
}


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}*/

- (id)init{//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

    self = [super init];//initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    allGroupNamesArray = [[NSMutableArray alloc]init ];
     [allGroupNamesArray addObject:@"Full Roster"];
   
    
    //@"name", @"recency most recent first", @"recency least recent first", 
    NSString* sortTitles[7] = {@"name", @"most recent", @"least recent", @"positive", @"negative", @"most calls", @"fewest calls" }; 
    
    
    classInfoSearchSubArray = [[NSMutableArray alloc]init ];
    classInfoInGroupArray = [[NSMutableArray alloc]init ];
    
    //interface====
    //top header
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
     [self.view addSubview:headerView];
    
    UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[DashConstants titleImage]];
    titleImageView.frame =CGRectMake(104+20, 5, 72, 30);
    [headerView addSubview:titleImageView];
    
    groupsTableButton = [DashConstants gradientButton];
    
    groupsTableButton.frame = CGRectMake(20, 5, 60,25);
    groupsTableButton.backgroundColor = [UIColor grayColor];
    [groupsTableButton setTitle:@"groups" forState:UIControlStateNormal];
    groupsTableButton.layer.cornerRadius=4;
    [groupsTableButton addTarget:self action:@selector(groupsTableButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:groupsTableButton];

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
    groupNameLabel.text = [allGroupNamesArray objectAtIndex:0];
    groupNameLabel.font=[UIFont systemFontOfSize:24];
    groupNameLabel.textColor = [UIColor whiteColor];
    [roundedContentView addSubview:groupNameLabel];

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
    
   
    
       
    classroomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 300, 260)];
    classroomTableView.dataSource = self;
    classroomTableView.delegate = self;
    classroomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    classroomTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];
    //classroomTableView.layer.cornerRadius = myCornerRadius;
    //classroomTableView.clipsToBounds = YES;
    [roundedContentView addSubview:classroomTableView];
   
    groupsTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 40, 140, 200)];
    groupsTableView.dataSource = self;
    groupsTableView.delegate = self;
    groupsTableView.hidden=YES;
    [self.view addSubview:groupsTableView];
    
    //
    
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
    
    
    //first, read classInfoArray from local copy before internet sync
    
    classInfoArray = [self loadClassArrayLocal];
    /*for(StudentInfo* studentInfo in classInfoArray){
        [classInfoInGroupArray addObject:studentInfo];
    }*/
     [self updateGroupsListing]; 
    [spinner startAnimating];
    [NSThread detachNewThreadSelector:@selector(sync) toTarget:self withObject:nil];
    
    // request data from the api
    /*NSError * error = nil;
     NSURL * url = [NSURL URLWithString:@"http://23.21.212.190:5000/api/v1/student"];
     NSString *studentJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];    
     // printf("\n========CLASSROOM\n%s", [studentJson cString]);
     */
    /*if (studentJson!=nil && [studentJson length]>0) {//check for sucess
        classInfoArray = [StudentInfo createStudentListWithJsonString:studentJson];
        printf("\ninternet success, class info array with %d records", [classInfoArray count]);
        
        //on successful pull, save to local
        [self saveClassArrayLocal];
    }*/

    
}
//pull from server
-(void)sync{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    
    // request data from the api
    NSError * error = nil;
    NSURL * url = [NSURL URLWithString:@"http://23.21.212.190:5000/api/v1/student"];
    NSString *studentJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];    
     printf("\n========CLASSROOM\n%s", [studentJson cString]);
    
    if (studentJson!=nil && [studentJson length]>0) {//check for sucess
        classInfoArray = [StudentInfo createStudentListWithJsonString:studentJson];
        printf("\ninternet success, class info array with %d records", [classInfoArray count]);
        
        //on successful pull, save to local
        [self saveClassArrayLocal];
         [self performSelectorOnMainThread:@selector(syncFinishedWithSuccess:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        
       
        
    }
    else  [self performSelectorOnMainThread:@selector(syncFinishedWithSuccess:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
   
    [pool release];
}

-(void)syncFinishedWithSuccess:(NSNumber*)inSuccessBoolNumber{
    printf("\nsync finished with success %d",  [inSuccessBoolNumber boolValue]);
     [spinner stopAnimating];
    if([inSuccessBoolNumber boolValue]==YES){
        spinner.hidden=YES; 
        
        //copy into group - but what happens if user has already selected a group!?!?!? ARGH TODO
        
        [self updateGroupsListing];       
      
            
    }
    else spinner.backgroundColor=[UIColor redColor];

}

-(void)updateGroupsListing{
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

    
}

-(void)addStudentInfo:(StudentInfo*)inInfo{
    printf("\nadd %s", [[inInfo fullName] cString]);
    [classInfoArray addObject:inInfo];
    [self updateGroupsListing];
    [classroomTableView reloadData];
}

-(void)addStudentButtonHit{
    NewStudentViewController *nextController = [[NewStudentViewController alloc] initWithDelegate:self];
    [self presentModalViewController:nextController animated:YES];
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
                [classroomTableView reloadData];
            }
            
            //most recent
            if(i==1){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    NSDate *first = [a lastContactDate];
                    NSDate *second = [b lastContactDate];
                    return [second compare:first];
                }];
                [classroomTableView reloadData];
            }
            
            //least recent
            if(i==2){
                [classInfoInGroupArray sortUsingComparator:^(StudentInfo* a, StudentInfo* b) {
                    NSDate *first = [a lastContactDate];
                    NSDate *second = [b lastContactDate];
                    return [first compare:second];
                }];
                [classroomTableView reloadData];
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
                [classroomTableView reloadData];
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
                [classroomTableView reloadData];
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
                [classroomTableView reloadData];
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
                [classroomTableView reloadData];
            }
            
            
            sortOptionsView.hidden=YES;
        }
    }
    
}

//doesn't actually remove, just resets mood, called from othercontroller. really hack-y!
-(void)removeInfo:(StudentInfo*)inInfo{//from first view controller or modal postcall view. 
   // printf("\nremove %s", [[inInfo name] cString])  ;
    //StudentInfo* foundStudentInfo=nil;
   // for(StudentInfo* currStudentInfo in classInfoArray){
    int foundStudentIndex=-1;
    for(int i=0;i<[classInfoArray count];i++){  
        StudentInfo* currStudentInfo = [classInfoArray objectAtIndex:i];
        if(currStudentInfo==inInfo){
            foundStudentIndex = i;
        }
    }
    if(foundStudentIndex!=-1){
       // printf("found %d ", foundStudentIndex);
        int pathArray[2]={0,foundStudentIndex};
        NSIndexPath* path = [NSIndexPath indexPathWithIndexes:pathArray length:2];
        //NSString *CellPersIDString = [foundStudentInfo name];
        //ClassroomTableCell* cell = [classroomTableView dequeueReusableCellWithIdentifier:CellPersIDString];
        UITableViewCell* cell = [classroomTableView cellForRowAtIndexPath:path];
       // printf(" cell? %d", cell);
        [cell resetMood];
    }
    
} 

//sorting
-(void)sortTableButtonHit{
     [sortOptionsView setHidden:!sortOptionsView.hidden];
    
}

-(void)groupsTableButtonHit{
    [groupsTableView setHidden:!groupsTableView.hidden];
}

//search bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar*)inBar{
    [searchBar resignFirstResponder];
    searching=NO;
    searchBar.text=@"";
     [classroomTableView reloadData];
}

- (void)searchBar:(UISearchBar *)inBar textDidChange:(NSString *)searchText{
    printf("\ntext:%s", [searchText cString]);
   
    [classInfoSearchSubArray removeAllObjects];
    
    if([searchText length] > 0) {
        searching = YES;
        for(StudentInfo* currInfo in classInfoInGroupArray){
        
            NSRange textRange =[[[currInfo fullName] lowercaseString] rangeOfString:[searchText lowercaseString]];
        
            if(textRange.location != NSNotFound){
                printf("*");
                [classInfoSearchSubArray addObject:currInfo];
            }
        }
    }
    
    else searching=NO;
    
    [classroomTableView reloadData];
    
}

/*- (void)searchBarSearchButtonClicked:(UISearchBar *)inBar{
    [searchBar resignFirstResponder];
}*/ //if we resign, we leave the text in the space and the clear button 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
     printf("\nbegin editing");
    searchBar.showsCancelButton = YES;
    //searching=YES;
     [classroomTableView reloadData];
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
	if(tableView==groupsTableView){
        return [allGroupNamesArray count];
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
	if(tableView==classroomTableView){
    StudentInfo* currStudentInfo;	
    if(!searching) currStudentInfo = [classInfoInGroupArray  objectAtIndex: [indexPath indexAtPosition:1]];
        else currStudentInfo = [classInfoSearchSubArray  objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currStudentInfo fullName] ;
        ClassroomTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
		if(cell==nil){
			cell = [[[ClassroomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] autorelease] ;
			
            
            [cell setStudentInfo:currStudentInfo];
            cell.parentVC=self;
			
		}
		return cell;
    }
    
    else if (tableView==groupsTableView){
        
        NSString* groupName = [allGroupNamesArray objectAtIndex:[indexPath indexAtPosition:1]];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:groupName];
        if(cell==nil){
			cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupName] autorelease] ;
            cell.textLabel.text=groupName;
        }
        
        return cell;
    }
		
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView == classroomTableView) return 40;
	else if (tableView== groupsTableView) return 40;
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
		
    if(tableView == classroomTableView){
        
    int newIndex = [indexPath indexAtPosition:1];
        
    //StudentInfoViewController *nextController = [[StudentInfoViewController alloc] init];//
    StudentInfo* selectedStudentInfo;
    if(searching)selectedStudentInfo = [classInfoSearchSubArray objectAtIndex:newIndex];
    else selectedStudentInfo = [classInfoInGroupArray objectAtIndex:newIndex];
        StudentInfoViewController *nextController = [[StudentInfoViewController alloc] initWithStudentInfo:selectedStudentInfo allGroupNamesArray:allGroupNamesArray];//WithNibName:@"NextView" bundle:nil];
    //[nextController setStudentInfo:[classInfoArray objectAtIndex:newIndex]];

    [self presentModalViewController:nextController animated:YES];
    
    }
    
    else if (tableView==groupsTableView) {
        [classInfoInGroupArray removeAllObjects];
        
        if([indexPath indexAtPosition:1]==0){//"all"
            for(StudentInfo* studentInfo in classInfoArray){
                 [classInfoInGroupArray addObject:studentInfo];
            }
           
        }
        else{
            
            currentGroupString = [allGroupNamesArray objectAtIndex: [indexPath indexAtPosition:1]];
            for(StudentInfo* studentInfo in classInfoArray){
                for (NSString* groupString in [studentInfo groupStringArray]){
                    if([groupString compare:currentGroupString]==NSOrderedSame){
                        [classInfoInGroupArray addObject:studentInfo];
                        break;//stop looking at this student, move to next
                    }
                }
            }
        }
        [classroomTableView reloadData];
        groupNameLabel.text = [allGroupNamesArray objectAtIndex:[indexPath indexAtPosition:1]];
        [groupsTableView setHidden:YES];
        
    }
      
        
}


-(NSMutableArray*) loadClassArrayLocal{
    NSMutableArray* tempArray;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[ClassroomViewController archiveLocation]]) {
		tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[ClassroomViewController archiveLocation]];
		printf("\nlocal array file exists, has %d records ", [tempArray count]);
		//printf("\ninit dictionary:%s", [[trackInfoDict description]cString]);
	}
    else{ 
        tempArray=[[NSMutableArray alloc]init ];
    }
    [tempArray retain];
    return tempArray;
}

-(void) saveClassArrayLocal{
	printf("\ncalled save");
	printf("contents:");
	/*for(int i=0;i<[classInfoArray count];i++){
		printf("\n-%s -- %d", [[[stateInfoArray objectAtIndex:i] presetName] cString], [[stateInfoArray objectAtIndex:i] osc1Cent] );
	}*/
	BOOL result = [NSKeyedArchiver archiveRootObject:classInfoArray toFile:[ClassroomViewController archiveLocation]];	
	if(result)printf(" --save successful");
	else printf("\nsave UNsuccessful!");
}


@end
