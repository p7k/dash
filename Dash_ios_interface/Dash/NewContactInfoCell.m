//
//  NewContactInfoCell.m
//  Dash
//
//  Created by Daniel Iglesia on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewContactInfoCell.h"

@implementation NewContactInfoCell

@synthesize contactInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //60 px high
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
        
        allNumbersLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 150, 60)];
        allNumbersLabel.numberOfLines=3;
       
         //allNumbersLabel.textAlignment = UITextAlignmentRight;
         allNumbersLabel.textColor = [UIColor grayColor];
         allNumbersLabel.font=[UIFont systemFontOfSize:13];
         allNumbersLabel.backgroundColor = [UIColor clearColor];
         [self addSubview:allNumbersLabel];
        
                
        
    }
    return self;
}


/*-(void)setStudentInfo:(StudentInfo *)inInfo{
    studentInfo = inInfo;
}*/

-(void)setContactInfo:(ContactInfo*)inInfo{
    printf("\nset contact info in cell");
    contactInfo = inInfo;
    nameLabel.text=[inInfo fullName];
    //phoneNumberLabel.text = [inInfo phoneNumber];
    relationLabel.text = [inInfo relation];
   
    NSString* numbers[3];
    
    numbers[0]=[contactInfo homeNumber];
    if(numbers[0]==nil)numbers[0] = @"(nil)";
    numbers[1]=[contactInfo mobileNumber];
    if(numbers[1]==nil)numbers[1] = @"(nil)";
    numbers[2]=[contactInfo workNumber];
    if(numbers[2]==nil)numbers[2] = @"(nil)";
    
    allNumbersLabel.text = [NSString stringWithFormat:@"home:%@\nmobile:%@\nwork:%@", numbers[0], numbers[1], numbers[2]];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
