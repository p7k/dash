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
@synthesize firstContactNameLabel;
@synthesize happyButton;
@synthesize sadButton;
@synthesize callButton;
@synthesize myStudentInfo;
@synthesize parentVC;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //assume 100 high
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        studentNameLabel = [[UILabel alloc]init ];
        studentNameLabel.frame = CGRectMake(20, 0, 320, 25);
        studentNameLabel.textAlignment = UITextAlignmentLeft;
       
        studentNameLabel.backgroundColor = [UIColor clearColor];//[ UIColor    lightGrayColor];
        [self addSubview:studentNameLabel];
        
         firstContactNameLabel = [[UILabel alloc]init ];
        firstContactNameLabel.frame =  CGRectMake(20, 25, 280, 25);
        firstContactNameLabel.textAlignment = UITextAlignmentRight;
         firstContactNameLabel.textColor = [UIColor grayColor];
        firstContactNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstContactNameLabel];
        
        
        sadButton= [UIButton buttonWithType:UIButtonTypeCustom];
        sadButton.frame = CGRectMake(0, 50, 100, 50);
        sadButton.backgroundColor=[DashConstants theSadColor];// forState:UIControlStateNormal];
      //  [sadButton setBackgroundColor:[DashConstants theSadHighlightedColor] forState:UIControlStateSelected];
        
        [sadButton addTarget:self action:@selector(sadButtonDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sadButton];

        
        happyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        happyButton.frame = CGRectMake(110, 50, 100, 50);
         happyButton.layer.borderColor = [[UIColor blackColor] CGColor];
        happyButton.backgroundColor=[DashConstants theHappyColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
      //  [happyButton setBackgroundColor:[DashConstants theHappyHighlightedColor] forState:UIControlStateSelected];
        [happyButton addTarget:self action:@selector(happyButtonDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:happyButton];
        
        callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton.frame = CGRectMake(220, 50, 100, 50);
        [callButton setTitle:@"call now" forState:UIControlStateNormal];
        callButton.backgroundColor=[DashConstants theCallNowColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
        //[callButton setBackgroundColor:[DashConstants theCallNowColor];// forState:UIControlStateSelected];
        [callButton addTarget:self action:@selector(callNowDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callButton];

        
        
        
    }

    
    return self;
}

-(void)callNowDown{//:(ContactInfo*)inContactInfo{
    
    
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", [[myStudentInfo firstContactInfo] phoneNumber]];
    printf("\n call %s", [phoneLinkString cString]);
    NSURL *phoneLinkURL = [NSURL URLWithString:phoneLinkString];
    //[[UIApplication sharedApplication] openURL:phoneLinkURL];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    [pcvc setStudentInfo:myStudentInfo];
    [parentVC presentModalViewController:pcvc animated:YES];
       
        
    

    
}

-(void)setStudentInfo:(StudentInfo*)inInfo{
    myStudentInfo = inInfo;
    [studentNameLabel setText:[myStudentInfo name]];
    [firstContactNameLabel setText:[[myStudentInfo firstContactInfo] name]];
}


-(void)happyButtonDown{
    printf("\nhappybutton down");
    happyButton.selected = !happyButton.selected;
    if(happyButton.selected==YES){//to list
        [[parentVC otherController] addHappy:myStudentInfo];
        happyButton.layer.borderWidth = 3;
       
    }
    else{//off list
        happyButton.layer.borderWidth = 0;
        [[parentVC otherController] removeInfo:myStudentInfo];
    }
}

-(void)sadButtonDown{
    printf("\nsadbutton down");
    sadButton.selected = !happyButton.selected;
    if(sadButton.selected==YES){//to list
        [[parentVC otherController] addSad:myStudentInfo];
        sadButton.layer.borderWidth = 3;
        
    }
    else{//off list
        sadButton.layer.borderWidth = 0;
         [[parentVC otherController] removeInfo:myStudentInfo];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
