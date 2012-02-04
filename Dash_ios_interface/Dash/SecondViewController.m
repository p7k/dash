//
//  SecondViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController
@synthesize tableView, callQueue;

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
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
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
        
        
        //interface
        UILabel *dashTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
        dashTitleLabel.textAlignment = UITextAlignmentCenter;
        dashTitleLabel.text = @"dash";
        dashTitleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];

        //[UIColor grayColor];
        
        [self.view addSubview:dashTitleLabel];
        dashTitleLabel.textColor = [UIColor whiteColor];
        
      
        
        
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 60, 280, 350)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        tableView.layer.shadowOpacity = 1.0;
        tableView.layer.shadowRadius = 5.0;
        tableView.layer.shadowOffset = CGSizeMake(5, 5);
        tableView.clipsToBounds = NO;  
        [self.view addSubview:tableView];
        
        
    }
    return self;
}


-(void)addHappy:(StudentInfo*)inInfo{
    printf("\nadd happy:%s", [[inInfo name] cString]);
    CallIntent* newIntent = [[CallIntent alloc]init ];
    newIntent.studentInfo = inInfo;
    newIntent.isHappy = YES;
    [callQueue addObject:newIntent];
    [tableView reloadData];

}

-(void)addSad:(StudentInfo*)inInfo{
    printf("\nadd sad:%s", [[inInfo name] cString]);
    CallIntent* newIntent = [[CallIntent alloc]init ];
    newIntent.studentInfo = inInfo;
    newIntent.isHappy = NO;
    [callQueue addObject:newIntent];
    [tableView reloadData];
    
}

-(void)removeInfo:(StudentInfo*)inInfo{
    printf("\nremove %s", [[inInfo name] cString])  ;
    CallIntent* foundIntent=nil;
    for(CallIntent* currIntent in callQueue){
        if([currIntent studentInfo]==inInfo){
            foundIntent = currIntent;
        }
    }
    if(foundIntent!=nil){
        [callQueue removeObject:foundIntent];
        [tableView reloadData];
    }
}

//==============table stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [callQueue count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	printf("\ncalled !LISTwillDisplay cell name %s", [[[[cell callIntent] studentInfo] name] cString]);
	if([[cell callIntent] isHappy]) cell.backgroundColor = [DashConstants theHappyColor];
	else cell.backgroundColor = [DashConstants theSadColor];
}

//TODO..what happens if save as other prset name? ahhh! treat as overwrite!
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
    CallIntent* currCallIntent = [callQueue  objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [[currCallIntent studentInfo] name];
    CallTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
    if(cell==nil){
        cell = [[CallTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
        //[cell textLabel].text=[currStudentInfo name];//[currCollection valueForProperty: MPMediaPlaylistPropertyName];
        //[cell textLabel].font=[MBConstants paramLabelFont];//[parentVC theButtonFont];
        //[cell textLabel].textColor = [MBConstants thePurpleColor];
        //cell.selectedBackgroundView=[[UIView alloc]initWithFrame:[cell frame]];
        //cell.selectedBackgroundView.backgroundColor=[MBConstants theRedHighlightColor];
        //cell.textLabel.highlightedTextColor = [MBConstants thePurpleColor];
        
        [cell setCallIntent:currCallIntent];
        
        
    }
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//if(isPad) return 96;
	return 50;
	
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    int newIndex = [indexPath indexAtPosition:1];
    
    StudentInfoViewController *nextController = [[StudentInfoViewController alloc] init];//WithNibName:@"NextView" bundle:nil];
    [self presentModalViewController:nextController animated:YES];
    [nextController setStudentInfo:[[callQueue objectAtIndex:newIndex] studentInfo]];
    
    
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
