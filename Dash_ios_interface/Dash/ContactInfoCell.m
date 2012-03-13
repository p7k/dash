//
//  ContactInfoCell.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactInfoCell.h"

@implementation ContactInfoCell
@synthesize parentVC, studentInfo, contactInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //40 px high
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha=.5;
        self.backgroundView = imageView;
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
    
       /* phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 20)];
        phoneNumberLabel.font=[UIFont systemFontOfSize:14];
        phoneNumberLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:phoneNumberLabel];*/
        
        relationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 20)];
       // relationLabel.textAlignment = UITextAlignmentRight;
        relationLabel.textColor = [UIColor grayColor];
        relationLabel.font=[UIFont systemFontOfSize:13];
        relationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:relationLabel];
        
        /*contactTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 205, 20)];
        contactTypeLabel.textAlignment = UITextAlignmentRight;
        contactTypeLabel.textColor = [UIColor grayColor];
        contactTypeLabel.font=[UIFont systemFontOfSize:13];
        contactTypeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contactTypeLabel];*/
        
        for(int i=0;i<3;i++){
            callButtons[i] = [UIButton buttonWithType:UIButtonTypeCustom];
            callButtons[i].frame = CGRectMake(130+i*55, 0, 40, 40);
            callButtons[i].contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            callButtons[i].contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            callButtons[i].contentMode = UIViewContentModeScaleToFill;
            [callButtons[i] setImage:[DashConstants phoneImage] forState:UIControlStateNormal];
            [callButtons[i] addTarget:self action:@selector(callNowDown:) forControlEvents:UIControlEventTouchDown];
            callButtons[i].enabled=NO;
            [self addSubview:callButtons[i]];
        }

        
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    printf("\ntransition to editing %d", editing);
    if(editing) {
       nameLabel.frame = CGRectMake(60, 0, 200, 20);
        relationLabel.frame = CGRectMake(60, 20, 200, 20);
        for(int i=0;i<3;i++) callButtons[i].hidden=YES;
    }
    else{
        nameLabel.frame = CGRectMake(10, 0, 200, 20);//matches init
         relationLabel.frame = CGRectMake(10, 20, 200, 20);
         for(int i=0;i<3;i++) callButtons[i].hidden=NO;
    }
}


-(void)callNowDown:(UIButton*)sender{//:(ContactInfo*)inContactInfo{
    
    // Hacky, we should set this as an instance var
    //ContactInfo * inContactInfo = [studentInfo firstContactInfo];
     //NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", [contactInfo phoneNumber]];
    
    NSString *phoneLinkString; 
    if(sender==callButtons[0]) phoneLinkString = [NSString stringWithFormat:@"tel:%@", [contactInfo homeNumber]];
    if(sender==callButtons[1]) phoneLinkString = [NSString stringWithFormat:@"tel:%@", [contactInfo mobileNumber]];
    if(sender==callButtons[2]) phoneLinkString = [NSString stringWithFormat:@"tel:%@", [contactInfo workNumber]];
    
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    [pcvc setStudentInfo:studentInfo];
    [pcvc setContactInfo:contactInfo];
    [pcvc setParentVC:parentVC];
    //[pcvc setIntent:???
    [parentVC presentModalViewController:pcvc animated:YES];
    
    
}

-(void)setText:(NSString *)text{
    nameLabel.text = text;
}

-(void)setStudentInfo:(StudentInfo *)inInfo{
    studentInfo = inInfo;
}

-(void)setContactInfo:(ContactInfo*)inInfo{
    contactInfo = inInfo;
    nameLabel.text=[inInfo fullName];
    //phoneNumberLabel.text = [inInfo phoneNumber];
    relationLabel.text = [inInfo relation];
    //contactTypeLabel.text = [inInfo contactType];
    if([contactInfo homeNumber]!=nil)callButtons[0].enabled=YES;
    if([contactInfo mobileNumber]!=nil)callButtons[1].enabled=YES;
    if([contactInfo workNumber]!=nil)callButtons[2].enabled=YES;
       
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
