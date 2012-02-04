//
//  FirstViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController
@synthesize searchBar, classroomTableView, headerView, classInfoArray;
@synthesize otherController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (id)init{//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

    self = [super init];//initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first.png"];
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
    
    // request data from the api
    NSError * error = nil;
    NSURL * url = [NSURL URLWithString:@"http://23.21.212.190:5000/api/v1/student"];
    NSString *studentJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];    
    
    classInfoArray = [StudentInfo createStudentListWithJsonString:studentJson];
            
            /*  still need to figure out how to do calls
            
            PhoneCall* phoneCall = [[PhoneCall alloc]init];
            [phoneCall setContactInfo:contactInfo];
            [phoneCall setCallDate:[NSDate date]];
            [[currInfo phoneCallArray] addObject:phoneCall];
             
             */
    
    //search bar
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30,0,260, 40)];
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
   // searchBar.tintColor = [UIColor grayColor];
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.translucent = YES;
    [self.view addSubview:searchBar];
    
    //interface
   // headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 60, 280, 40)];
    //headerView.backgroundColor = [UIColor grayColor];
    //[self.view addSubview:headerView];
    UILabel *dashTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 280, 40)];
    dashTitleLabel.textAlignment = UITextAlignmentCenter;
    dashTitleLabel.text = @"dash";
    dashTitleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    //[UIColor grayColor];
    [self.view addSubview:dashTitleLabel];
    dashTitleLabel.textColor = [UIColor whiteColor];
    //[headerView addSubview:dashTitleLabel];
    
   
    
    
    classroomTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, 280, 300)];
    classroomTableView.dataSource = self;
    classroomTableView.delegate = self;
    classroomTableView.layer.shadowColor = [UIColor blackColor].CGColor;
    classroomTableView.layer.shadowOpacity = 1.0;
    classroomTableView.layer.shadowRadius = 5.0;
    classroomTableView.layer.shadowOffset = CGSizeMake(5, 5);
    classroomTableView.clipsToBounds = NO;    
    [self.view addSubview:classroomTableView];
    
    
    
}

//search bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar*)inBar{
    [searchBar resignFirstResponder];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [classInfoArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//printf("\ncalled !LISTwillDisplay");
	//cell.backgroundColor = [UI//[MBConstants theRedColor];
	
}

//TODO..what happens if save as other prset name? ahhh! treat as overwrite!
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
		StudentInfo* currStudentInfo = [classInfoArray  objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currStudentInfo name];
        ClassroomTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
		if(cell==nil){
			cell = [[ClassroomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
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
	return 80;
	
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
		int newIndex = [indexPath indexAtPosition:1];
        
        StudentInfoViewController *nextController = [[StudentInfoViewController alloc] init];//WithNibName:@"NextView" bundle:nil];
    [nextController setStudentInfo:[classInfoArray objectAtIndex:newIndex]];  
    [self presentModalViewController:nextController animated:YES];
      
    
        
        
        
}


@end
