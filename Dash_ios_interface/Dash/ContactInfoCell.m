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
    
        phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 20)];
        //phoneNumberLabel.textAlignment = UITextAlignmentRight;
        //phoneNumberLabel.textColor = [UIColor grayColor];
        phoneNumberLabel.font=[UIFont systemFontOfSize:14];
        phoneNumberLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:phoneNumberLabel];
        
        relationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 205, 20)];
        relationLabel.textAlignment = UITextAlignmentRight;
        relationLabel.textColor = [UIColor grayColor];
        relationLabel.font=[UIFont systemFontOfSize:13];
        relationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:relationLabel];
        
        contactTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 205, 20)];
        contactTypeLabel.textAlignment = UITextAlignmentRight;
        contactTypeLabel.textColor = [UIColor grayColor];
        contactTypeLabel.font=[UIFont systemFontOfSize:13];
        contactTypeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contactTypeLabel];
        
        UIButton* callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton.frame = CGRectMake(230, 0, 40, 40);
        //[callButton setTitle:@"call" forState:UIControlStateNormal];
        
        callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        callButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        callButton.contentMode = UIViewContentModeScaleToFill;
        [callButton setImage:[DashConstants phoneImage] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(callNowDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callButton];

        
    }
    return self;
}

-(void)callNowDown{//:(ContactInfo*)inContactInfo{
    
    // Hacky, we should set this as an instance var
    //ContactInfo * inContactInfo = [studentInfo firstContactInfo];
    
    
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", [contactInfo phoneNumber]];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    [pcvc setStudentInfo:studentInfo];
    [pcvc setContactInfo:contactInfo];
    [pcvc setParentVC:parentVC];
    [parentVC presentModalViewController:pcvc animated:YES];
    
    
}

-(void)setStudentInfo:(StudentInfo *)inInfo{
    studentInfo = inInfo;
}

-(void)setContactInfo:(ContactInfo*)inInfo{
    contactInfo = inInfo;
    nameLabel.text=[inInfo name];
    phoneNumberLabel.text = [inInfo phoneNumber];
    relationLabel.text = [inInfo relation];
    contactTypeLabel.text = [inInfo contactType];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
