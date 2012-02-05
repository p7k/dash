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
    
    

                                    
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
	[dateFormatter retain];
    
    UIView* underNotesView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40+90)];
    underNotesView.backgroundColor=[UIColor blackColor];
    underNotesView.layer.shadowColor = [UIColor blackColor].CGColor;
    underNotesView.layer.shadowOpacity = 1.0;
    underNotesView.layer.shadowRadius = 5.0;
    underNotesView.layer.shadowOffset = CGSizeMake(5, 5);
    underNotesView.clipsToBounds = NO; 
    [self.view addSubview:underNotesView];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    [self.view addSubview:headerView];
    
   
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
	backButton.frame = CGRectMake(10, 5, 60, 30);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    backButton.backgroundColor = [UIColor grayColor ];
    backButton.layer.cornerRadius=4;
    [headerView addSubview:backButton];
    
   topLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 180, 30)];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = UITextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:topLabel];
    
   
    notesView = [[UIView alloc]initWithFrame:CGRectMake(20, 60, 280, 90)];
    notesView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:notesView];
    
    //INFO
    lastContactLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 240, 20)];
    [notesView addSubview:lastContactLabel];
    numberOfCallsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 240, 20)];
    [notesView addSubview:numberOfCallsLabel];
    positivityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 240, 20)];
    [notesView addSubview:positivityLabel];
    
    
    NSArray* segItems = [NSArray arrayWithObjects:@"Contact Info",@"Call Log", nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segItems];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame=CGRectMake(20,170, 280, 40);
    [segmentedControl addTarget:self action:@selector(segDown) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    UIView* underPadView = [[UIView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];
    underPadView.backgroundColor=[UIColor blackColor];
    underPadView.layer.shadowColor = [UIColor blackColor].CGColor;
    underPadView.layer.shadowOpacity = 1.0;
    underPadView.layer.shadowRadius = 5.0;
    underPadView.layer.shadowOffset = CGSizeMake(5, 5);
    underPadView.clipsToBounds = NO; 
    [self.view addSubview:underPadView];
    
    contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];// style:<#(UITableViewStyle)#>
    contactTableView.dataSource=self;
    contactTableView.delegate = self;
    [self.view addSubview:contactTableView];
    
    callLogTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 220, 280, 200)];// style:<#(UITableViewStyle)#>
    callLogTableView.dataSource=self;
    callLogTableView.delegate = self;
    [self.view addSubview:callLogTableView];
    callLogTableView.hidden=YES;
   
    return self;
}
-(id)initWithStudentInfo:(StudentInfo*) inInfo{
    studentInfo = inInfo;
    return [self init];
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
    
    NSDate* lastContactDate = [[[studentInfo phoneCallArray] lastObject] callDate];
    if(lastContactDate==nil) lastContactLabel.text=@"Last Contact: --";
    else lastContactLabel.text = [NSString stringWithFormat:@"Last Contact: %@", [dateFormatter stringFromDate:lastContactDate]];
                            
    numberOfCallsLabel.text = [NSString stringWithFormat:@"Number of Calls: %d", [[studentInfo phoneCallArray] count] ];
    
    int positivitySum =0;
    for(PhoneCall* currCall in [studentInfo phoneCallArray]) positivitySum+=[[currCall intent] intValue];
    int percent;
    if([[studentInfo phoneCallArray]count]==0) percent=0;
    else percent= (positivitySum*100)/[[studentInfo phoneCallArray] count];
    positivityLabel.text = [NSString stringWithFormat:@"Positivity: %d%%", percent];

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
    //cell.backgroundColor = [UIColor colorWithPatternImage:[DashConstants cellGradientImage]];
	
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
        
        /*UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha=.5;
        cell.backgroundView = imageView;
        [imageView retain];*/
        
        
        
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
            
            /*UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.alpha=.5;
            cell.backgroundView = imageView;*/
            
            UIImageView* iconView = [[UIImageView alloc]init];// ;WithImage:[UIImage imageNamed:@"
            iconView.frame = CGRectMake(0, 0, 50, 50);
            [self addSubview:iconView];
            
            if( [currPhoneCall callIntent]==1){
                //self.backgroundColor = [DashConstants theHappyColor];
                iconView.image = [DashConstants happyImage];
            }
            else{
                iconView.image = [DashConstants sadImage];
                //self.backgroundColor = [DashConstants theSadColor];
            }
            
            cell.accessoryView = iconView;
            
            
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // we may not need to do this if there's already some call logs. Let's deal with that case later
    NSError *error = nil;
    NSString *urlEndpoint = [NSString stringWithFormat:@"http://23.21.212.190:5000/api/v1/clog?student_id=%@", studentInfo.studentId];
    NSURL *url = [NSURL URLWithString:urlEndpoint];
    NSString *callsJson = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    [studentInfo setPhoneCallArray:[PhoneCall createCallListFromJson:callsJson withStudentInfo:studentInfo]];
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
