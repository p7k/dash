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
//@synthesize isHappy;
@synthesize studentNameLabel;
@synthesize firstContactNameLabel, iconView, callButton;
@synthesize studentInfo;
@synthesize parentVC;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha=.5;
        self.backgroundView = imageView;
        
        
        studentNameLabel = [[UILabel alloc]init ];
        studentNameLabel.frame = CGRectMake(50, 0, 150, 25);
        studentNameLabel.textAlignment = UITextAlignmentLeft;
        
        studentNameLabel.backgroundColor = [UIColor clearColor];//[ UIColor    lightGrayColor];
        [self addSubview:studentNameLabel];
        
        firstContactNameLabel = [[UILabel alloc]init ];
        firstContactNameLabel.frame =  CGRectMake(50, 25, 150, 25);
        firstContactNameLabel.textAlignment = UITextAlignmentRight;
        firstContactNameLabel.textColor = [UIColor grayColor];
        firstContactNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstContactNameLabel];
        
        
        iconView = [[UIImageView alloc]init];// ;WithImage:[UIImage imageNamed:@"
        iconView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:iconView];
        
        callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton.frame = CGRectMake(220, 5, 40, 40);
        //[callButton setTitle:@"call" forState:UIControlStateNormal];
        
        callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        callButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        callButton.contentMode = UIViewContentModeScaleToFill;
        [callButton setImage:[DashConstants phoneImage] forState:UIControlStateNormal];
       // callButton.backgroundColor=[DashConstants theCallNowColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
        //[callButton setBackgroundColor:[DashConstants theCallNowColor];// forState:UIControlStateSelected];
        [callButton addTarget:self action:@selector(callNowDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callButton];
        
        /*deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(5, 5, 30, 30);
        deleteButton.layer.cornerRadius=5;
        deleteButton.backgroundColor=[UIColor redColor];
        deleteButton.hidden=YES;
        [self addSubview:deleteButton];*/
        
    }
    
    
    return self;
}

-(void)callNowDown{//:(ContactInfo*)inContactInfo{
    
    // Hacky, we should set this as an instance var
    ContactInfo * inContactInfo = [studentInfo firstContactInfo];
    
    
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", [inContactInfo bestPhoneNumber]];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    [pcvc setStudentInfo:studentInfo];
    [pcvc setContactInfo:inContactInfo];
    [pcvc setParentVC:parentVC];
    //[pcvc setIntent:
    [parentVC presentModalViewController:pcvc animated:YES];
    
    
}


/*-(void)didTransitionToState:(UITableViewCellStateMask)state{
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    printf("\ntransition to editing %d", editing);
    if(editing) {
        iconView.hidden=YES;
        callButton.hidden=YES;
    }
    else{
        iconView.hidden=NO;
        callButton.hidden=NO;
    }
}

/*-(void)setIsHappy:(BOOL)inIsHappy{
    isHappy = inIsHappy;
    
    if( isHappy){
        //self.backgroundColor = [DashConstants theHappyColor];
        iconView.image = [DashConstants happyImage];
    }
    else{
        iconView.image = [DashConstants sadImage];
        //self.backgroundColor = [DashConstants theSadColor];
    }
        
   
}*/

-(void)setStudentInfo:(StudentInfo*)inInfo{
    studentInfo = inInfo;
    [studentNameLabel setText:[studentInfo fullName]];
    if([[studentInfo contactsArray] count]>0)[firstContactNameLabel setText:[[[studentInfo contactsArray] objectAtIndex:0] fullName]];
    
    if( [studentInfo mood]==1){
        //self.backgroundColor = [DashConstants theHappyColor];
        iconView.image = [DashConstants happyImage];
    }
    else if([studentInfo mood]==-1){
        iconView.image = [DashConstants sadImage];
        //self.backgroundColor = [DashConstants theSadColor];
    }
    
    //un-enable call button if no contact info
    if([[inInfo contactsArray] count]==0 || [[[inInfo contactsArray] objectAtIndex:0] bestPhoneNumber]==nil)
        callButton.enabled=NO;
    else callButton.enabled=YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
