//
//  GroupStudentsTableCell.m
//  Dash
//
//  Created by Daniel Iglesia on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupStudentsTableCell.h"

@implementation GroupStudentsTableCell
@synthesize studentInfo, groupNameString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        toggle=NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[DashConstants cellGradientImage] ];
        imageView.contentMode = UIViewContentModeScaleToFill;
        //imageView.alpha=.5;
        self.backgroundView = imageView;
        
        studentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 250, 40)];
        studentNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:studentNameLabel];
        
        toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleButton.frame = CGRectMake(240, 5, 30, 30);
        toggleButton.layer.borderWidth=2;
        [toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toggleButton];                      
        
    }
    return self;
}

-(void) toggle{
    [self setToggle:!toggle];
}

-(void)setToggle:(BOOL)inToggle{//TODO REFRESH GROUP subarray on top level view
    toggle = inToggle;
    if(toggle){
        toggleButton.backgroundColor = [UIColor redColor];
        //add group string to student info
        [[studentInfo groupStringArray] addObject:groupNameString];
        
    }
    else{
        toggleButton.backgroundColor = [UIColor whiteColor];  
        //remove
        NSString* itemToRemove;
        for(NSString* myGroupName in [studentInfo groupStringArray]){
            if([myGroupName isEqualToString:groupNameString]){
                itemToRemove = myGroupName;
            }
        }
        [[studentInfo groupStringArray] removeObject:itemToRemove];
        
    }   
}

/*-(void)setGroupNameString:(NSString *)inGroupNameString{
    groupNameString = inGroupNameString;
    groupNameLabel.text = groupNameString;
}*/

-(void)setStudentInfo:(StudentInfo*)inStudentInfo {
    studentInfo = inStudentInfo;
    studentNameLabel.text = [studentInfo fullName];
    for(NSString* myGroupName in [inStudentInfo groupStringArray]){
        if([myGroupName isEqualToString:groupNameString]){
            //[self setToggle:YES];no, this adds removes objects!
            toggle=YES;
            toggleButton.backgroundColor = [UIColor redColor];
            
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end