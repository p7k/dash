//
//  CallTableCell.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallTableCell.h"
#import "PostCallViewController.h"

@implementation CallTableCell
@synthesize callIntent;
@synthesize studentNameLabel;
@synthesize firstContactNameLabel, iconView, callButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //assume 40 high
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        studentNameLabel = [[UILabel alloc]init ];
        studentNameLabel.frame = CGRectMake(50, 0, 280, 25);
        studentNameLabel.textAlignment = UITextAlignmentLeft;
        
        studentNameLabel.backgroundColor = [UIColor clearColor];//[ UIColor    lightGrayColor];
        [self addSubview:studentNameLabel];
        
        firstContactNameLabel = [[UILabel alloc]init ];
        firstContactNameLabel.frame =  CGRectMake(50, 25, 280, 25);
        firstContactNameLabel.textAlignment = UITextAlignmentLeft;
        firstContactNameLabel.textColor = [UIColor grayColor];
        firstContactNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstContactNameLabel];
        
        
        iconView = [[UIImageView alloc]init];// ;WithImage:[UIImage imageNamed:@"
        iconView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:iconView];
        
        callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton.frame = CGRectMake(220, 0, 100, 50);
        [callButton setTitle:@"call" forState:UIControlStateNormal];
        callButton.backgroundColor=[DashConstants theCallNowColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
        //[callButton setBackgroundColor:[DashConstants theCallNowColor];// forState:UIControlStateSelected];
        [callButton addTarget:self action:@selector(callNowDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callButton];
        
        
        
        
    }
    
    
    return self;
}

-(void)callNowDown{//:(ContactInfo*)inContactInfo{
    
    
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", [[[callIntent studentInfo] firstContactInfo] phoneNumber]];
    printf("\n call test %s", [phoneLinkString cString]);
    NSURL *phoneLinkURL = [NSURL URLWithString:phoneLinkString];
    
    // a somewhat hack to let us regain control of the app after a phonecall
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    //[pcvc setStudentInfo:myStudentInfo];
    //[parentVC presentModalViewController:pcvc animated:YES];
    //[[UIApplication sharedApplication] openURL:phoneLinkURL];
    
}

-(void)setCallIntent:(CallIntent*)inIntent{
    callIntent=inIntent;
    if([inIntent isHappy]){
        //self.backgroundColor = [DashConstants theHappyColor];
        iconView.image = [DashConstants happyImage];
    }
    else{
        iconView.image = [DashConstants sadImage];
        //self.backgroundColor = [DashConstants theSadColor];
    }
        
    StudentInfo* myStudentInfo = [inIntent studentInfo];
    [studentNameLabel setText:[myStudentInfo name]];
    [firstContactNameLabel setText:[[myStudentInfo firstContactInfo] name]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
