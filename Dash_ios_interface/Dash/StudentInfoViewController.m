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

-(id)init{
    self = [super init];
    printf("\ncreate studentVC");
     [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
	[dateFormatter retain];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
	backButton.frame = CGRectMake(10, 10, 60, 40);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    backButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:backButton];
    //[self.navigationItem setLeftBarButtonItem:backButton];
    
   topLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 60)];
    topLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topLabel];
    
    //TODO INFO
    
    NSArray* segItems = [NSArray arrayWithObjects:@"Contact Info",@"Call Log", nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segItems];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame=CGRectMake(10,160, 300, 40);
    [segmentedControl addTarget:self action:@selector(segDown) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 200, 300, 200)];// style:<#(UITableViewStyle)#>
    contactTableView.dataSource=self;
    contactTableView.delegate = self;
    [self.view addSubview:contactTableView];
    
    callLogTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 200, 300, 200)];// style:<#(UITableViewStyle)#>
    callLogTableView.dataSource=self;
    callLogTableView.delegate = self;
    [self.view addSubview:callLogTableView];
    callLogTableView.hidden=YES;
   
    return self;
}

-(void)segDown{
    int index = [segmentedControl selectedSegmentIndex];
    if(index==1){
        callLogTableView.hidden=NO;
        contactTableView.hidden=YES;
    }
    else{
        callLogTableView.hidden=YES;
        contactTableView.hidden=NO;
    }
    
	//printf("newVoxCount=%d ", newVoxCount);
	//[parentVC setVoxCount:newVoxCount];   
}

-(void)setStudentInfo:(StudentInfo*) inInfo{
    printf("\nsetStudentInfo %s", [[inInfo name] cString ] );
    studentInfo = inInfo;
    topLabel.text = [inInfo name];
    
}


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
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//printf("\ncalled !LISTwillDisplay cell name %s", [[[[cell callIntent] studentInfo] name] cString]);
	//if([[cell callIntent] isHappy]) cell.backgroundColor = [DashConstants theHappyColor];
	//else cell.backgroundColor = [DashConstants theSadColor];
}

//TODO..what happens if save as other prset name? ahhh! treat as overwrite!
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==contactTableView){
    printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
    ContactInfo* currContactInfo = [[studentInfo contactsArray] objectAtIndex: [indexPath indexAtPosition:1]];
    NSString *CellPersIDString = [currContactInfo name];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
        [[cell textLabel] setNumberOfLines:3];
        [cell textLabel].text = [NSString stringWithFormat:@"%s \n %s ", [[currContactInfo name] cString], [[currContactInfo phoneNumber] cString] ];
        //=[currStudentInfo name];//[currCollection valueForProperty: MPMediaPlaylistPropertyName];
        //[cell textLabel].font=[MBConstants paramLabelFont];//[parentVC theButtonFont];
        //[cell textLabel].textColor = [MBConstants thePurpleColor];
        //cell.selectedBackgroundView=[[UIView alloc]initWithFrame:[cell frame]];
        //cell.selectedBackgroundView.backgroundColor=[MBConstants theRedHighlightColor];
        //cell.textLabel.highlightedTextColor = [MBConstants thePurpleColor];
        
        //[cell setCallIntent:currCallIntent];
        
        
    }
    return cell;
    }
    
    if(tableView == callLogTableView){
        printf("\ncell create index %d ", [indexPath indexAtPosition:1]);
        PhoneCall* currPhoneCall = [[studentInfo phoneCallArray] objectAtIndex: [indexPath indexAtPosition:1]];
        NSString *CellPersIDString = [dateFormatter stringFromDate:[currPhoneCall callDate]];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellPersIDString];
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPersIDString] ;
            [[cell textLabel] setNumberOfLines:3];
            [cell textLabel].text = [NSString stringWithFormat:@"%s \n %s", [[[currPhoneCall contactInfo] name] cString], [[dateFormatter stringFromDate:[currPhoneCall callDate]] cString] ];
            //=[currStudentInfo name];//[currCollection valueForProperty: MPMediaPlaylistPropertyName];
            //[cell textLabel].font=[MBConstants paramLabelFont];//[parentVC theButtonFont];
            //[cell textLabel].textColor = [MBConstants thePurpleColor];
            //cell.selectedBackgroundView=[[UIView alloc]initWithFrame:[cell frame]];
            //cell.selectedBackgroundView.backgroundColor=[MBConstants theRedHighlightColor];
            //cell.textLabel.highlightedTextColor = [MBConstants thePurpleColor];
            
            //[cell setCallIntent:currCallIntent];
            
            
        }
        return cell;
    }

    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//if(isPad) return 96;
	return 50;
	
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    if(tableView==contactTableView){
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
