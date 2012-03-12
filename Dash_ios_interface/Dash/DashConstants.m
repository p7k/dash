//
//  DashConstants.m
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DashConstants.h"

@implementation DashConstants

+(UIColor*)theHappyColor{
	if(!theHappyColor){
		theHappyColor=[UIColor colorWithRed:.5 green:.9 blue:.5 alpha:1];
		[theHappyColor retain];
	}
	return theHappyColor;
}

/*+(UIColor*)theHappyHighlightColor{
	if(!theHappyHighlightColor){
		theHappyHighlightColor=[UIColor colorWithRed:.8 green:.196 blue:.3 alpha:1];//puple+.3 was too gray
		[theHappyHighlightColor retain];
	}
	return theHappyHighlightColor;
}*/

+(UIColor*)theSadColor{
	if(!theSadColor){
		theSadColor=[UIColor colorWithRed:.9 green:.5 blue:.5 alpha:1];
		[theSadColor retain];
	}
	return theSadColor;
}

+(UIColor*)theNeutralColor{
	if(!theNeutralColor){
		theNeutralColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1];
		[theNeutralColor retain];
	}
	return theNeutralColor;
}

/*+(UIColor*)theSadHighlightColor{
	if(!theSadHighlightColor){
		theSadHighlightColor=[UIColor colorWithRed:.5 green:.4 blue:0 alpha:1];//puple+.3 was too gray
		[theSadHighlightColor retain];
	}
	return theSadHighlightColor;
}*/

+(UIColor*)theCallNowColor{
	if(!theCallNowColor){
		theCallNowColor=[UIColor colorWithRed:0 green:.6 blue:.4 alpha:1];
		[theCallNowColor retain];
	}
	return theCallNowColor;
}

+(UIImage*)happyImage{
    if(!happyImage){
		happyImage=[UIImage imageNamed:@"Happy_Face_icon.png"];
		[happyImage retain];
	}
	return happyImage;
}

+(UIImage*)happyHighlightImage{
    if(!happyHighlightImage){
		happyHighlightImage=[UIImage imageNamed:@"Happy_Face_Activated_Icon.png"];
		[happyHighlightImage retain];
	}
	return happyHighlightImage;
}

+(UIImage*)sadImage{
    if(!sadImage){
		sadImage=[UIImage imageNamed:@"Sad_Face_icon.png"];
		[sadImage retain];
	}
	return sadImage;
}

+(UIImage*)sadHighlightImage{
    if(!sadHighlightImage){
		sadHighlightImage=[UIImage imageNamed:@"Sad_Face_Icon_Activated.png"];
		[sadHighlightImage retain];
	}
	return sadHighlightImage;
}

+(UIImage*)phoneImage{
    if(!phoneImage){
		phoneImage=[UIImage imageNamed:@"Call_Button.png"];
		[phoneImage retain];
	}
	return phoneImage;
}


+(UIImage*)cellBackgroundImage{
    if(!cellBackgroundImage){
		cellBackgroundImage=[UIImage imageNamed:@"cellBackground.png"];
		[cellBackgroundImage retain];
	}
	return cellBackgroundImage;
}

+(UIImage*)titleImage{
    if(!titleImage){
		titleImage=[UIImage imageNamed:@"Light_Logo_small.png"];
		[titleImage retain];
	}
	return titleImage;
}

+(UIImage*)cellGradientImage{
    if(!cellGradientImage){
		cellGradientImage=[UIImage imageNamed:@"ItemBarGradient_slice.png"];
		[cellGradientImage retain];
	}
	return cellGradientImage;
}
+(UIImage*)cellGradientHappyImage{
    if(!cellGradientHappyImage){
		cellGradientHappyImage=[UIImage imageNamed:@"CellBGHAppy.png"];
		[cellGradientHappyImage retain];
	}
	return cellGradientHappyImage;
}
+(UIImage*)cellGradientSadImage{
    if(!cellGradientSadImage){
		cellGradientSadImage=[UIImage imageNamed:@"CellBGSad.png"];
		[cellGradientSadImage retain];
	}
	return cellGradientSadImage;
}

+(NSDateFormatter*)dateFormatter{
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM d, h:mm a"];
        [dateFormatter retain];
    }
    return dateFormatter;
}

+(UIButton*)gradientButton{//assume 50x25
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60,25);
// Create a gradient for the background.
CAGradientLayer* shineLayer = [CAGradientLayer layer] ;
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects: //was alpha .4 .2 .2 .2 .4
                         (id)[UIColor colorWithWhite:.2f alpha:1].CGColor,
                         (id)[UIColor colorWithWhite:.5f alpha:1].CGColor,
                         (id)[UIColor colorWithWhite:0.5f alpha:1].CGColor,
                         (id)[UIColor colorWithWhite:0.2f alpha:1].CGColor,
                         (id)[UIColor colorWithWhite:.5f alpha:1].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
       [button.layer addSublayer:shineLayer];
    button.clipsToBounds=YES;

    
    return button;
}
 @end
