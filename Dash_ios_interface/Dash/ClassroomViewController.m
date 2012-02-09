//
//  FirstViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassroomViewController.h"

@implementation ClassroomViewController
@synthesize searchBar, classroomTableView, headerView, classInfoArray;
@synthesize otherController;

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
    
    //first, read classInfoArray from local copy before internet sync
    
    classInfoArray = [self loadClassArrayLocal];
    
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
    }
    
    classInfoSearchSubArray = [[NSMutableArray alloc]init ];
    
    
    //search bar
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30,0,260, 40)];
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
   // searchBar.tintColor = [UIColor grayColor];
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.translucent = YES;
    [self.view addSubview:searchBar];
    
    
    
    
    UIView* underPadView = [[UIView alloc]initWithFrame:CGRectMake(20, 60, 280, 340)];
    underPadView.backgroundColor=[UIColor blackColor];
    underPadView.layer.shadowColor = [UIColor blackColor].CGColor;
    underPadView.layer.shadowOpacity = 1.0;
    underPadView.layer.shadowRadius = 5.0;
    underPadView.layer.shadowOffset = CGSizeMake(5, 5);
    underPadView.clipsToBounds = NO; 
    [self.view addSubview:underPadView];
    
    
    //interface
     headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 60, 280, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];

    
    [self.view addSubview:headerView];
   /* UILabel *dashTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
    dashTitleLabel.textAlignment = UITextAlignmentCenter;
    dashTitleLabel.text = @"dash";
    dashTitleLabel.backgroundColor = [UIColor clearColor];    //[UIColor grayColor];
    dashTitleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:dashTitleLabel];
    */
    
    UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[DashConstants titleImage]];
    titleImageView.frame =CGRectMake(104, 5, 72, 30);
    [headerView addSubview:titleImageView];
    
    
    sortTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sortTableButton.frame = CGRectMake(200, 5, 50,30);
    sortTableButton.backgroundColor = [UIColor grayColor];
    [sortTableButton setTitle:@"sort" forState:UIControlStateNormal];
    sortTableButton.layer.cornerRadius=4;
    [headerView addSubview:sortTableButton];
    
    
    classroomTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, 280, 300)];
    classroomTableView.dataSource = self;
    classroomTableView.delegate = self;
    classroomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    classroomTableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:classroomTableView];
   
    
    
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
        for(StudentInfo* currInfo in classInfoArray){
        
            NSRange textRange =[[[currInfo name] lowercaseString] rangeOfString:[searchText lowercaseString]];
        
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
    //searching=YES;
     [classroomTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    printf("\nend editing");
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
	if(!searching)return [classInfoArray count];
    else return [classInfoSearchSubArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//printf("\ncalled !LISTwillDisplay");
	cell.backgroundColor = [UIColor whiteColor];//[MBConstants theRedColor];
   // cell.backgroundColor = [UIColor colorWithPatternImage:[DashConstants cellGradientImage]];
	
}

//TODO..what happens if save as other prset name? ahhh! treat as overwrite!

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
	StudentInfo* currStudentInfo;	
    if(!searching) currStudentInfo = [classInfoArray  objectAtIndex: [indexPath indexAtPosition:1]];
        else currStudentInfo = [classInfoSearchSubArray  objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currStudentInfo name];
        ClassroomTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
		if(cell==nil){
			cell = [[[ClassroomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] autorelease] ;
			
            
            [cell setStudentInfo:currStudentInfo];
            cell.parentVC=self;
			
		}
		return cell;
		
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
	
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
		int newIndex = [indexPath indexAtPosition:1];
        
    //StudentInfoViewController *nextController = [[StudentInfoViewController alloc] init];//
    StudentInfoViewController *nextController = [[StudentInfoViewController alloc] initWithStudentInfo:[classInfoArray objectAtIndex:newIndex]];//WithNibName:@"NextView" bundle:nil];
    [nextController setStudentInfo:[classInfoArray objectAtIndex:newIndex]];

    [self presentModalViewController:nextController animated:YES];
      
        
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