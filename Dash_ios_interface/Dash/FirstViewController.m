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
    
    //data
    classInfoArray = [[NSMutableArray alloc]init ];
    
    
    
    //dummy
    NSString* dummyNames[] = {@"dan", @"dhrev", @"pavel"};
    NSString* dummyContactNames[] = {@"mrs. bla", @"mr bloo", @"baby daddy"};
    
    
    for( int i=0;i<3;i++){
        NSString* currName = dummyNames[i];
        StudentInfo* currInfo = [[StudentInfo alloc]init ];
        [currInfo setName:currName];
        
        for(int j=0;j<3;j++){
            ContactInfo* contactInfo = [[ContactInfo alloc]init];
            [contactInfo setName:dummyContactNames[j] ];
            [contactInfo setPhoneNumber:@"555-555-5555"];
            [[currInfo contactsArray] addObject:contactInfo];
            
            PhoneCall* phoneCall = [[PhoneCall alloc]init];
            [phoneCall setContactInfo:contactInfo];
            [phoneCall setCallDate:[NSDate date]];
            [[currInfo phoneCallArray] addObject:phoneCall];
            
        }

        
        currInfo.firstContactInfo = [[currInfo contactsArray] objectAtIndex:0 ];
        printf("\nsetfirstcontact:%s", [[[[currInfo contactsArray] objectAtIndex:0 ] name ]cString] );
        
        [classInfoArray addObject:currInfo];
    }
    
    
    //interface
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:headerView];
    UILabel *dashTitleLabel = [[UILabel alloc]initWithFrame:headerView.frame];
    dashTitleLabel.textAlignment = UITextAlignmentCenter;
    dashTitleLabel.text = @"dash";
    dashTitleLabel.backgroundColor = [UIColor clearColor];
    dashTitleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:dashTitleLabel];
    
    //search bar
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,40,320, 40)];
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    
    classroomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 320, 340)];
    classroomTableView.dataSource = self;
    classroomTableView.delegate = self;
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
	//if(isPad) return 96;
	return 100;
	
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
		int newIndex = [indexPath indexAtPosition:1];
        
        StudentInfoViewController *nextController = [[StudentInfoViewController alloc] init];//WithNibName:@"NextView" bundle:nil];
    [nextController setStudentInfo:[classInfoArray objectAtIndex:newIndex]];  
    [self presentModalViewController:nextController animated:YES];
      
    
        
        
        
}


@end
