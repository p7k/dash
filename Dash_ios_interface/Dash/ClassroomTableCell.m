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
@synthesize successView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier //assume 40 high, 280 wide
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha=.5;
        self.backgroundView = imageView;
        
        studentNameLabel = [[UILabel alloc]init ];
        studentNameLabel.frame = CGRectMake(20, 3, 130, 20);
        studentNameLabel.font=[UIFont systemFontOfSize:14];
        studentNameLabel.textAlignment = UITextAlignmentLeft;
       
        studentNameLabel.backgroundColor = [UIColor clearColor];//[ UIColor    lightGrayColor];
        [self addSubview:studentNameLabel];
        
         firstContactNameLabel = [[UILabel alloc]init ];
        firstContactNameLabel.frame =  CGRectMake(20, 20, 140, 20);
        firstContactNameLabel.textAlignment = UITextAlignmentRight;
         firstContactNameLabel.textColor = [UIColor grayColor];
        firstContactNameLabel.font=[UIFont systemFontOfSize:13];
        firstContactNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstContactNameLabel];
        
        successView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10,80)];
        [self addSubview:successView]; 
        
        sadButton= [UIButton buttonWithType:UIButtonTypeCustom];
        sadButton.frame = CGRectMake(160, 0, 40, 40);
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
        happyButton.frame = CGRectMake(160+40, 0, 40, 40);
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
        
        callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton.frame = CGRectMake(160+80, 0, 40, 40);
        [callButton setTitle:@"call now" forState:UIControlStateNormal];
        callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        callButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        callButton.contentMode = UIViewContentModeScaleToFill;
        //callButton.backgroundColor=[DashConstants theCallNowColor];//[DashConstants theHappyColor]];// forState:UIControlStateNormal];
        //[callButton setBackgroundColor:[DashConstants theCallNowColor];// forState:UIControlStateSelected];
        [callButton setImage:[DashConstants phoneImage] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(callNowDown) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callButton];

        
        
        
    }

    
    return self;
}

-(void)callNowDown{//:(ContactInfo*)inContactInfo{
    
    // Hacky, we should set this as an instance var
    ContactInfo * inContactInfo = [myStudentInfo firstContactInfo];
    
    

    NSString *phoneLinkString = [NSString stringWithFormat:@"tel://%@", [inContactInfo phoneNumber]];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:phoneLinkString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    PostCallViewController *pcvc = [[PostCallViewController alloc]init ];
    [pcvc setStudentInfo:myStudentInfo];
    [pcvc setContactInfo:inContactInfo];
    [pcvc setParentVC:nil];
    [parentVC presentModalViewController:pcvc animated:YES];
       
        
    

    
}

-(void)setStudentInfo:(StudentInfo*)inInfo{
    myStudentInfo = inInfo;
    [studentNameLabel setText:[myStudentInfo name]];
    [firstContactNameLabel setText:[[myStudentInfo firstContactInfo] name]];
    
    float successRatio = (float)(rand()%10)/10;/// [myStudentInfo contactSuccessRatio];
   // printf("\nsuccessratio %.2f", successRatio);
    
    
    successView.backgroundColor = [UIColor colorWithRed:1-successRatio green:successRatio blue:.3 alpha:.8];
    
}


-(void)happyButtonDown{
    printf("\nhappybutton down");
    happyButton.selected = !happyButton.selected;
    if(happyButton.selected==YES){//to list
        if(sadButton.selected){
            [[parentVC otherController] removeInfo:myStudentInfo];
            [sadButton setSelected:NO];
            [sadButton setImage:[DashConstants sadImage] forState:UIControlStateNormal];
        }
        
        myStudentInfo.isHappy=YES;
        myStudentInfo.callIntent = [NSNumber numberWithInt:1]; // set call intent to happy
        [[parentVC otherController] addInfo:myStudentInfo];
        //happyButton.layer.borderWidth = 3;
       [happyButton setImage:[DashConstants happyHighlightImage] forState:UIControlStateNormal];
        
       
    }
    else{//off list
        //happyButton.layer.borderWidth = 0;
        myStudentInfo.isHappy=NO;
        myStudentInfo.callIntent = [NSNumber numberWithInt:2];  // back to neutral 
        [[parentVC otherController] removeInfo:myStudentInfo];
        [happyButton setImage:[DashConstants happyImage] forState:UIControlStateNormal];
        
    }
}

-(void)sadButtonDown{
    printf("\nsadbutton down");
    [sadButton setSelected: !sadButton.selected];
   
    printf("\nsadbutton state is selected:%d", [sadButton state]==UIControlStateSelected );
    if(sadButton.selected==YES){//to list
        if(happyButton.selected){
             [[parentVC otherController] removeInfo:myStudentInfo];
            [happyButton setSelected:NO];
            [happyButton setImage:[DashConstants happyImage] forState:UIControlStateNormal];

        }
        
        myStudentInfo.isHappy=NO;
        myStudentInfo.callIntent = [NSNumber numberWithInt:0];
        [[parentVC otherController] addInfo:myStudentInfo];
        //sadButton.layer.borderWidth = 3;
        [sadButton setImage:[DashConstants sadHighlightImage] forState:UIControlStateNormal];
        
    }
    else{//off list
        //sadButton.layer.borderWidth = 0;
         myStudentInfo.callIntent = [NSNumber numberWithInt:2]; //back to neutral
         [[parentVC otherController] removeInfo:myStudentInfo];
        [sadButton setImage:[DashConstants sadImage] forState:UIControlStateNormal];
    }
}

-(void)resetMood{
     [sadButton setImage:[DashConstants sadImage] forState:UIControlStateNormal];
    [happyButton setImage:[DashConstants happyImage] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
