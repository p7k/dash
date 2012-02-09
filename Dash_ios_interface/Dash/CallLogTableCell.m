//
//  CallLogTableCell.m
//  Dash
//
//  Created by Daniel Iglesia on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallLogTableCell.h"

@implementation CallLogTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //height 60
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha=.5;
        self.backgroundView = imageView;
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
        dateLabel.font=[UIFont systemFontOfSize:14];
        dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dateLabel];
        
        reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 205, 20)];
        reportLabel.font=[UIFont systemFontOfSize:13];
        reportLabel.textColor = [UIColor grayColor];
        reportLabel.textAlignment = UITextAlignmentRight;
        reportLabel.backgroundColor = [UIColor clearColor];
        reportLabel.text=@"report info";
        [self addSubview:reportLabel];

        
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 20)];
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        
        phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 210, 20)];
        //phoneNumberLabel.textAlignment = UITextAlignmentRight;
        //phoneNumberLabel.textColor = [UIColor grayColor];
        phoneNumberLabel.font=[UIFont systemFontOfSize:14];
        phoneNumberLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:phoneNumberLabel];
        
        relationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 205, 20)];
        relationLabel.textAlignment = UITextAlignmentRight;
        relationLabel.textColor = [UIColor grayColor];
        relationLabel.font=[UIFont systemFontOfSize:13];
        relationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:relationLabel];
        
        contactTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 205, 20)];
        contactTypeLabel.textAlignment = UITextAlignmentRight;
        contactTypeLabel.textColor = [UIColor grayColor];
        contactTypeLabel.font=[UIFont systemFontOfSize:13];
        contactTypeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contactTypeLabel];
        
        iconImageView = [[UIImageView alloc]init];
        iconImageView.frame = CGRectMake(230, 10, 40, 40);
        [self addSubview:iconImageView];
        
        
        
        
    }
    return self;
}

-(void)setPhoneCall:(PhoneCall*)inCall{
    phoneCall=inCall;
    
    ContactInfo* contactInfo = [phoneCall contactInfo] ;
    
    nameLabel.text=[contactInfo name];
    phoneNumberLabel.text = [contactInfo phoneNumber];
    relationLabel.text = [contactInfo relation];
    contactTypeLabel.text = [contactInfo contactType];
    
    dateLabel.text = [[DashConstants dateFormatter] stringFromDate:[phoneCall callDate]];
    
    
    if( [[phoneCall callIntent] isEqualToNumber:[NSNumber numberWithInt:1]]){
        //self.backgroundColor = [DashConstants theHappyColor];
        iconImageView.image = [DashConstants happyHighlightImage];
    }
    else if([[phoneCall callIntent] isEqualToNumber:[NSNumber numberWithInt:0]]){
        iconImageView.image = [DashConstants sadHighlightImage];
        //self.backgroundColor = [DashConstants theSadColor];
    }else{// ==2 otherwise it's neutral happy
        iconImageView.image = [DashConstants happyImage];
    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end