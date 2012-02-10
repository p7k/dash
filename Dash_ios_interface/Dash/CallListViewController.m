//
//  SecondViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallListViewController.h"

@implementation CallListViewController
@synthesize tableView, callQueue, otherController, editing;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}*/

- (id)init{//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

    self = [super init ];
    if (self) {
        self.title = NSLocalizedString(@"Playlist", @"Playlist");
        self.tabBarItem.image = [UIImage imageNamed:@"Playlist_Icon.png"];
         self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
        printf("\nview did load");
        
        //data
        callQueue = [[NSMutableArray alloc]init ];
        
        
        
        //dummy
      /*  NSString* dummyNames[] = {@"dan", @"dhrev", @"pavel"};
        for( int i=0;i<3;i++){
            NSString* currName = dummyNames[i];
            StudentInfo* currInfo = [[StudentInfo alloc]init ];
            ContactInfo* firstContactInfo = [[ContactInfo alloc] init];
            [firstContactInfo setName:@"Mrs. SoandSo, mother!"];
            [firstContactInfo setPhoneNumber:@"555-555-5555"];
            currInfo.firstContactInfo = firstContactInfo;
            [currInfo setName:currName];
            [classInfoArray addObject:currInfo];
        }*/
        
        UIView* underPadView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 350)];
        underPadView.backgroundColor=[UIColor blackColor];
        underPadView.layer.shadowColor = [UIColor blackColor].CGColor;
        underPadView.layer.shadowOpacity = 1.0;
        underPadView.layer.shadowRadius = 5.0;
        underPadView.layer.shadowOffset = CGSizeMake(5, 5);
        underPadView.clipsToBounds = NO; 
        [self.view addSubview:underPadView];

        
        //interface
        /*UILabel *dashTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
        dashTitleLabel.textAlignment = UITextAlignmentCenter;
        dashTitleLabel.text = @"dash";
        dashTitleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];

        //[UIColor grayColor];
        
        [self.view addSubview:dashTitleLabel];
        dashTitleLabel.textColor = [UIColor whiteColor];
        */
        
       UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
        headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
        [self.view addSubview:headerView];
        
        
        UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[DashConstants titleImage]];
        titleImageView.frame =CGRectMake(104, 5, 72, 30);
        [headerView addSubview:titleImageView];
        
        //editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton  = [DashConstants gradientButton];
        editButton.frame = CGRectMake(200, 5, 50,25);
        editButton.backgroundColor = [UIColor grayColor];
        [editButton setTitle:@"edit" forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        editButton.layer.cornerRadius=5;
        [editButton addTarget:self action:@selector(editTable:) forControlEvents:UIControlEventTouchDown];
        [headerView addSubview:editButton];
      
        
        
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 60, 280, 310)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboard.jpg"]];//[UIColor clearColor];
        
        [self.view addSubview:tableView];
        
        
    }
    return self;
}

-(void)addInfo:(StudentInfo*)inInfo{
    printf("\nadd info:%s happy? %d", [[inInfo name] cString], [inInfo isHappy] );
    [callQueue addObject:inInfo];
    [tableView reloadData];
}
/*-(void)addHappy:(StudentInfo*)inInfo{
    printf("\nadd happy:%s", [[inInfo name] cString]);
   // CallIntent* newIntent = [[CallIntent alloc]init ];
   // newIntent.studentInfo = inInfo;
   // newIntent.isHappy = YES;
    [callQueue addObject:inInfo];
    [tableView reloadData];

}

-(void)addSad:(StudentInfo*)inInfo{
    printf("\nadd sad:%s", [[inInfo name] cString]);
    //CallIntent* newIntent = [[CallIntent alloc]init ];
    //newIntent.studentInfo = inInfo;
    //newIntent.isHappy = NO;
    [callQueue addObject:inInfo];
    [tableView reloadData];
    
}*/

-(void)removeInfo:(StudentInfo*)inInfo{//from first view controller or modal postcall view. 
    printf("\nremove %s", [[inInfo name] cString])  ;
    StudentInfo* foundStudentInfo=nil;
    for(StudentInfo* currStudentInfo in callQueue){
        if(currStudentInfo==inInfo){
            foundStudentInfo = currStudentInfo;
        }
    }
    if(foundStudentInfo!=nil){
        [callQueue removeObject:foundStudentInfo];
        [tableView reloadData];
    }
    
    [otherController removeInfo:inInfo];
}

//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [callQueue count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	printf("\ncalled !LISTwillDisplay cell name %s", [[[cell  studentInfo] name] cString]);
	if([[cell studentInfo] isHappy])
        //cell.backgroundColor = [UIColor colorWithPatternImage:[DashConstants cellGradientHappyImage]];
         cell.backgroundColor = [DashConstants theHappyColor];
	else  //cell.backgroundColor = [UIColor colorWithPatternImage:[DashConstants cellGradientSadImage]];
	
        cell.backgroundColor = [DashConstants theSadColor];
}

//TODO..what happens if save as other prset name? ahhh! treat as overwrite!
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
    StudentInfo* currStudentInfo = [callQueue  objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currStudentInfo  name];
    CallTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
    if(cell==nil){
        cell = [[CallTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
        //[cell textLabel].text=[currStudentInfo name];//[currCollection valueForProperty: MPMediaPlaylistPropertyName];
        //[cell textLabel].font=[MBConstants paramLabelFont];//[parentVC theButtonFont];
        //[cell textLabel].textColor = [MBConstants thePurpleColor];
        //cell.selectedBackgroundView=[[UIView alloc]initWithFrame:[cell frame]];
        //cell.selectedBackgroundView.backgroundColor=[MBConstants theRedHighlightColor];
        //cell.textLabel.highlightedTextColor = [MBConstants thePurpleColor];
        
        [cell setStudentInfo:currStudentInfo];
         cell.parentVC=self;
        
    }
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//if(isPad) return 96;
	return 50;
	
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    int newIndex = [indexPath indexAtPosition:1];
    
    StudentInfoViewController *nextController = [[StudentInfoViewController alloc] initWithStudentInfo:[callQueue objectAtIndex:newIndex]];//WithNibName:@"NextView" bundle:nil];
    [self presentModalViewController:nextController animated:YES];
    //[nextController setStudentInfo:[callQueue objectAtIndex:newIndex] ];
    
    
}

//table editing

    
    
- (void) editTable:(id)sender{
    [self setEditing:!editing];
}

-(void)setEditing:(BOOL)inEditing{
    editing=inEditing;
	if(!editing)
	{
        [editButton setSelected:NO];
		//[super setEditing:NO animated:NO]; 
		[tableView setEditing:NO animated:NO];
		[tableView reloadData];
		//[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		//[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
         [editButton setSelected:YES];
		//[super setEditing:YES animated:YES]; 
		[tableView setEditing:YES animated:YES];
		[tableView reloadData];
		//[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		//[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.    
   
   	return UITableViewCellEditingStyleDelete;
	
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //turn off icons in classroom view
    StudentInfo* infoToRemove = [callQueue objectAtIndex:indexPath.row];
    [otherController removeInfo:infoToRemove];
       
    [callQueue removeObjectAtIndex:indexPath.row];
		[tableView reloadData];
    
    
    
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath {
	
   // NSString *item = [[arryData objectAtIndex:fromIndexPath.row] retain];
	StudentInfo* item = [[callQueue objectAtIndex:fromIndexPath.row] retain];
    [callQueue removeObject:item];
	[callQueue insertObject:item atIndex:toIndexPath.row];
	[item release];
}



//

							
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
}

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
    return (interfaceOrientation ==UIInterfaceOrientationPortrait);//!= UIInterfaceOrientationPortraitUpsideDown);
}

@end
