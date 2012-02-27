//
//  NewContactViewController.m
//  Dash
//
//  Created by Daniel Iglesia on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewContactViewController.h"

@implementation NewContactViewController
@synthesize delegate;
-(id)initWithStudentInfo:(StudentInfo*)inStudentInfo contactInfo:(ContactInfo*)inContactInfo{
    [super init];
    contactInfo = inContactInfo;
    studentInfo = inStudentInfo;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    
    
    
    //top header
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pad_Header.png"]];
    [self.view addSubview:headerView];
    
    
    UILabel* headerLabel = [[UILabel alloc]init ];//WithFrame:CGRectMake(0, 0, 320, 40)];
    headerLabel.frame = headerView.frame;
    headerLabel.text = @"New Contact";
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:headerLabel];
    
    
    
    cancelButton = [DashConstants gradientButton];
    
    cancelButton.frame = CGRectMake(20, 5, 60,25);
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius=4;
    [cancelButton addTarget:self action:@selector(cancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];
    
    doneButton = [DashConstants gradientButton];
    
    doneButton.frame = CGRectMake(250, 5, 60,25);
    doneButton.backgroundColor = [UIColor grayColor];
    [doneButton setTitle:@"done" forState:UIControlStateNormal];
    doneButton.layer.cornerRadius=4;
    [doneButton addTarget:self action:@selector(doneButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doneButton];
    
    NSString* textFieldNames[6] = {@"Relation", @"First Name", @"Last Name", @"Home Number", @"Mobile Number", @"Work Number"}; 
    for(int i=0;i<6;i++){
        textFields[i] = [[UITextField alloc]initWithFrame:CGRectMake( 10, 50+i*32, 300, 30 ) ];
        [ textFields[i] setAutocorrectionType:UITextAutocorrectionTypeNo];
        // textFields[i].layer.borderColor=[[MBConstants thePurpleColor] CGColor];
         textFields[i].layer.cornerRadius=10 ;
         //textFields[i].layer.borderWidth=2;
         textFields[i].delegate=self;
         textFields[i].textAlignment=UITextAlignmentCenter;
        [ textFields[i] setPlaceholder:textFieldNames[i]];
         textFields[i].font = [UIFont systemFontOfSize:24];
         textFields[i].backgroundColor=[UIColor whiteColor];
        if(i>2)[textFields[i] setKeyboardType:UIKeyboardTypeNumberPad];
        //[MBConstants theRedHighlightColor];
        // textFields[i].font=[MBConstants paramDigitFont];
        
                
        
        [self.view addSubview: textFields[i]];
    }
    
    //if contactInfo exists, fill in stuff
    if(contactInfo!=nil){
        if( [[contactInfo relation] length]>0) [textFields[0] setText:[contactInfo relation]];
        if( [[contactInfo firstName] length]>0) [textFields[1] setText:[contactInfo firstName]];
        if( [[contactInfo lastName] length]>0) [textFields[2] setText:[contactInfo lastName]];
        if( [[contactInfo homeNumber] length]>0) [textFields[3] setText:[contactInfo homeNumber]];
        if( [[contactInfo mobileNumber] length]>0) [textFields[4] setText:[contactInfo mobileNumber]];
        if( [[contactInfo workNumber] length]>0) [textFields[5] setText:[contactInfo workNumber]];
    }
        

    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    deleteButton.frame = CGRectMake(110, 242, 100,30);
    deleteButton.backgroundColor = [UIColor grayColor];
    [deleteButton setTitle:@"delete" forState:UIControlStateNormal];
    deleteButton.layer.cornerRadius=4;
    [deleteButton addTarget:self action:@selector(deleteButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];

    
    /*firstNameTextField = [[UITextField alloc]initWithFrame:CGRectMake( 10, 60, 300, 40 ) ];
	[firstNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	//firstNameTextField.layer.borderColor=[[MBConstants thePurpleColor] CGColor];
	firstNameTextField.layer.cornerRadius=10 ;
	firstNameTextField.layer.borderWidth=2;
	firstNameTextField.delegate=self;
	firstNameTextField.textAlignment=UITextAlignmentCenter;
    [firstNameTextField setPlaceholder:@"First Name"];
    firstNameTextField.font = [UIFont systemFontOfSize:24];
	firstNameTextField.backgroundColor=[UIColor whiteColor];//[MBConstants theRedHighlightColor];
	//firstNameTextField.font=[MBConstants paramDigitFont];
	[self.view addSubview:firstNameTextField];
    
    lastNameTextField = [[UITextField alloc]initWithFrame:CGRectMake( 10, 100, 300, 40 ) ];
	[lastNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	//lastNameTextField.layer.borderColor=[[MBConstants thePurpleColor] CGColor];
	lastNameTextField.layer.cornerRadius=10 ;
	lastNameTextField.layer.borderWidth=2;
	lastNameTextField.delegate=self;
	lastNameTextField.textAlignment=UITextAlignmentCenter;
    [lastNameTextField setPlaceholder:@"Last Name"];
    lastNameTextField.font = [UIFont systemFontOfSize:24];
	lastNameTextField.backgroundColor=[UIColor whiteColor];//[MBConstants theRedHighlightColor];
	//lastNameTextField.font=[MBConstants paramDigitFont];
	[self.view addSubview:lastNameTextField];
    
    homeNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake( 10, 140, 300, 40 ) ];
	[homeNumberTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [homeNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
	//homeNumberTextField.layer.borderColor=[[MBConstants thePurpleColor] CGColor];
	homeNumberTextField.layer.cornerRadius=10 ;
	homeNumberTextField.layer.borderWidth=2;
	homeNumberTextField.delegate=self;
	homeNumberTextField.textAlignment=UITextAlignmentCenter;
    [homeNumberTextField setPlaceholder:@"Home Number"];
    homeNumberTextField.font = [UIFont systemFontOfSize:24];
	homeNumberTextField.backgroundColor=[UIColor whiteColor];//[MBConstants theRedHighlightColor];
	//lastNameTextField.font=[MBConstants paramDigitFont];
	[self.view addSubview:homeNumberTextField];*/
    
    
   
    
    return self;
}

-(void)doneButtonHit{
    BOOL isNewSoAdd=NO;
    if(contactInfo==nil){
        isNewSoAdd=YES;
        contactInfo = [[ContactInfo alloc]init];
    }
    [contactInfo setRelation: [textFields[0] text] ];
    [contactInfo setFirstName:[ textFields[1] text]];
    [contactInfo setLastName:[ textFields[2] text]];
    [contactInfo setHomeNumber:[ textFields[3] text]];
    [contactInfo setMobileNumber: [textFields[4] text] ];
    [contactInfo setWorkNumber: [textFields[5] text] ];
    
     if([[contactInfo firstName] length]>0 || [[contactInfo   lastName] length]>0 ){
        if(isNewSoAdd)[[ studentInfo contactsArray] addObject:contactInfo];
         printf("\n studentInfo now has %d contacts", [[studentInfo contactsArray] count] );
        [[delegate contactTableView] reloadData];
    }
    [self dismissModalViewControllerAnimated:YES];
}
-(void)cancelButtonHit{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)deleteButtonHit{
    if(contactInfo!=nil){//exists in studentinfo contact array, so remove
        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"Delete Contact" message:@"delete this contact?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        [av show];
    }
    else [self dismissModalViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [[studentInfo contactsArray] removeObject:contactInfo];
        [[delegate contactTableView] reloadData];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//printf("\nshoudl return!");
	
   /* if(textField==firstNameTextField) firstNameString = [textField text];//[studentInfo setFirstName:[textField text]];
    else if(textField==lastNameTextField) lastNameString = [textField text];//[studentInfo setLastName:[textField text]];
	else if(textField==homeNumberTextField) homeNumberString = [textField text];//[studentInfo setLastName:[textField text]];
	*/
    [textField resignFirstResponder];
    
    
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
