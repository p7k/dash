//
//  ClassroomTableCell.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassroomTableCell.h"

@implementation ClassroomTableCell

@synthesize studentNameLabel;
@synthesize firstContactNameLabel, firstContactRelationLabel;
@synthesize happyButton;
@synthesize sadButton;
@synthesize callButton;
@synthesize myStudentInfo;
@synthesize parentVC;
@synthesize successView;
@synthesize controlHub;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //assume 40 high, 300 wide
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha=.5;
        self.backgroundView = imageView;
        
        successView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10,40)];
        [self addSubview:successView]; 
        
        callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton.frame = CGRectMake(10, 0, 40, 40);
        [callButton setTitle:@"call now" forState:UIControlStateNormal];
        callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        callButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        callButton.contentMode = UIViewContentModeScaleToFill;
        //callButton.backgroundColor=[DashConstants theCallNowColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
        //[callButton setBackgroundColor:[DashConstants theCallNowColor];// forState:UIControlStateSelected];
        [callButton setImage:[DashConstants phoneImage] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(callNowDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callButton];

        
        studentNameLabel = [[UILabel alloc]init ];
        studentNameLabel.frame = CGRectMake(55, 3, 165, 20);
        studentNameLabel.font=[UIFont boldSystemFontOfSize:14];
        studentNameLabel.textAlignment = UITextAlignmentLeft;
       
        studentNameLabel.backgroundColor = [UIColor clearColor];//[ UIColor    lightGrayColor];
        [self addSubview:studentNameLabel];
        
               
        firstContactRelationLabel = [[UILabel alloc]init ];
        firstContactRelationLabel.frame =  CGRectMake(55, 20, 165, 20);
        //firstContactRelationLabel.textAlignment = UITextAlignmentLeft;
        firstContactRelationLabel.textColor = [UIColor grayColor];
        firstContactRelationLabel.font=[UIFont boldSystemFontOfSize:13];
        firstContactRelationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstContactRelationLabel];
        
        firstContactNameLabel = [[UILabel alloc]init ];
        //firstContactNameLabel.frame =  CGRectMake(55, 20, 165, 20);//defined by text
        //firstContactNameLabel.textAlignment = UITextAlignmentRight;
        firstContactNameLabel.textColor = [UIColor grayColor];
        firstContactNameLabel.font=[UIFont systemFontOfSize:13];
        firstContactNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstContactNameLabel];


       
        
        sadButton= [UIButton buttonWithType:UIButtonTypeCustom];
        sadButton.frame = CGRectMake(220, 0, 40, 40);
        sadButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        sadButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        sadButton.contentMode = UIViewContentModeScaleToFill;
       // sadButton.backgroundColor=[DashConstants theSadColor];// forState:UIControlStateNormal];
      //  [sadButton setBackgroundColor:[DashConstants theSadHighlightedColor] forState:UIControlStateSelected];
        [sadButton setImage:[DashConstants sadImage] forState:UIControlStateNormal];
       // [sadButton setImage:[DashConstants sadHighlightImage] forState:UIControlStateSelected];
        
        [sadButton addTarget:self action:@selector(sadButtonDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sadButton];

        
        happyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        happyButton.frame = CGRectMake(220+40, 0, 40, 40);
        // happyButton.layer.borderColor = [[UIColor blackColor] CGColor];
        happyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        happyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        happyButton.contentMode = UIViewContentModeScaleToFill;
        //happyButton.backgroundColor=[DashConstants theHappyColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
      //  [happyButton setBackgroundColor:[DashConstants theHappyHighlightedColor] forState:UIControlStateSelected];
        [happyButton setImage:[DashConstants happyImage] forState:UIControlStateNormal];
        //[happyButton setImage:[DashConstants happyHighlightImage] forState:UIControlStateSelected];
        
        [happyButton addTarget:self action:@selector(happyButtonDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:happyButton];
        
       
        
        
        
    }

    
    return self;
}

-(void)callNowDown{//:(ContactInfo*)inContactInfo{
    
    // Hacky, we should set this as an instance var
    ContactInfo * inContactInfo = [[myStudentInfo contactsArray] objectAtIndex:0];
    

    NSString *phoneLinkString = [NSString stringWithFormat:@"tel://%@", [inContactInfo bestPhoneNumber]];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    [pcvc setStudentInfo:myStudentInfo];
    [pcvc setContactInfo:inContactInfo];
    [pcvc setParentVC:nil];
    //[pcvc setCallIntent:????
    [parentVC presentModalViewController:pcvc animated:YES];
       
        
    

    
}

-(void)setStudentInfo:(StudentInfo*)inInfo{//todo restructure this...big check for contact, then do all strings
    myStudentInfo = inInfo;
    [studentNameLabel setText:[myStudentInfo fullName]];
    NSString* cookedRelation;
    //NSString* rawRelation = [[[myStudentInfo contactsArray] objectAtIndex:0] relation];
    if([/*rawRelation!=nil*/[myStudentInfo contactsArray] count]>0)   cookedRelation = [NSString stringWithFormat:@"%@, ", [[[myStudentInfo contactsArray] objectAtIndex:0] relation] ];//add comma
    else cookedRelation=@"";
       [firstContactRelationLabel setText: cookedRelation];
    
       CGSize stringSize = [cookedRelation sizeWithFont:[firstContactRelationLabel font] ];
    firstContactNameLabel.frame =  CGRectMake(55+stringSize.width, 20, 165-stringSize.width, 20);//defined by text, width to make it truncate rather than overlap buttons
   
    if([[myStudentInfo contactsArray] count]>0) [firstContactNameLabel setText:[[[myStudentInfo contactsArray] objectAtIndex:0] fullName]];
    
    
    //float successRatio = (float)(rand()%10)/10;/// [myStudentInfo contactSuccessRatio];
   // printf("\nsuccessratio %.2f", successRatio);
    printf("\nclassroomtable cell: set student info %s, %d calls", [[myStudentInfo fullName] cString], [myStudentInfo callCount] );
    float positivePercent = 0;
    if([myStudentInfo callCount ]==0) positivePercent = .5;
    else {
        positivePercent = (float)[myStudentInfo positiveCallCount] / ([myStudentInfo positiveCallCount]+[myStudentInfo negativeCallCount]);
    }
    printf("\nsuccess %.2f", positivePercent);
    successView.backgroundColor = [UIColor colorWithRed:1-positivePercent green:positivePercent blue:.3 alpha:.8];
    
    //turn off phone enabled  if no valid contact
    if([[inInfo contactsArray] count]==0 || [[[inInfo contactsArray] objectAtIndex:0] bestPhoneNumber]==nil)
        callButton.enabled=NO;
    else callButton.enabled=YES;
    
}

-(void)updateMoodButtons{//via selected status, not mood
    if(happyButton.selected)
        [happyButton setImage:[DashConstants happyHighlightImage] forState:UIControlStateNormal];
    else [happyButton setImage:[DashConstants happyImage] forState:UIControlStateNormal];
   
    if(sadButton.selected)
        [sadButton setImage:[DashConstants sadHighlightImage] forState:UIControlStateNormal];
    else [sadButton setImage:[DashConstants sadImage] forState:UIControlStateNormal];
    

}

-(void)happyButtonDown{
   // printf("\nhappybutton down");
    happyButton.selected = !happyButton.selected;
    //printf("..selected? %d ", happyButton.selected);
    myStudentInfo.mood = (int)happyButton.selected; //happy = mood 1, neutral = 0
    //printf("..info mood? %d ", myStudentInfo.mood);
    
    
    
    if(happyButton.selected==YES){//to list
        if(sadButton.selected==YES)sadButton.selected=NO;
        if(![[controlHub callQueue] containsObject:myStudentInfo])//if it _isn't on callQueue, add it (other wise just refresh the mood)
            [[controlHub callQueue] addObject:myStudentInfo];
        [[[controlHub callListViewController] mainTableView] reloadData];
        
    }
    else{//off list
        [[controlHub callQueue] removeObject:myStudentInfo];
        [[[controlHub callListViewController] mainTableView] reloadData];
        
    }
    
    [self updateMoodButtons];
    
}

-(void)sadButtonDown{
    //printf("\nsadbutton down");
    sadButton.selected = !sadButton.selected;
    myStudentInfo.mood = (int)-sadButton.selected; //happy = mood 1, neutral = 0
   
    
    if(sadButton.selected==YES){//to list
        if(happyButton.selected==YES)happyButton.selected=NO;
        if(![[controlHub callQueue] containsObject:myStudentInfo])
            [[controlHub callQueue] addObject:myStudentInfo];
        [[[controlHub callListViewController] mainTableView] reloadData];
        
    }
    else{//off list
        [[controlHub callQueue] removeObject:myStudentInfo];
        [[[controlHub callListViewController] mainTableView] reloadData];
        
    }
     [self updateMoodButtons];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    printf("\nclassrromtablecell dealloc");
    
}

@end
