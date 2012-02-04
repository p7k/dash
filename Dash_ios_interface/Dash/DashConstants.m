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
		theHappyColor=[UIColor colorWithRed:.1922 green:.8 blue:0 alpha:1];
		[theHappyColor retain];
	}
	return theHappyColor;
}

+(UIColor*)theHappyHighlightColor{
	if(!theHappyHighlightColor){
		theHappyHighlightColor=[UIColor colorWithRed:.8 green:.196 blue:.3 alpha:1];//puple+.3 was too gray
		[theHappyHighlightColor retain];
	}
	return theHappyHighlightColor;
}

+(UIColor*)theSadColor{
	if(!theSadColor){
		theSadColor=[UIColor colorWithRed:.8 green:.8 blue:.1569 alpha:1];
		[theSadColor retain];
	}
	return theSadColor;
}

+(UIColor*)theSadHighlightColor{
	if(!theSadHighlightColor){
		theSadHighlightColor=[UIColor colorWithRed:.5 green:.4 blue:0 alpha:1];//puple+.3 was too gray
		[theSadHighlightColor retain];
	}
	return theSadHighlightColor;
}

+(UIColor*)theCallNowColor{
	if(!theCallNowColor){
		theCallNowColor=[UIColor colorWithRed:0 green:.6 blue:.4 alpha:1];
		[theCallNowColor retain];
	}
	return theCallNowColor;
}

+(UIImage*)happyImage{
    if(!happyImage){
		happyImage=[UIImage imageNamed:@"happyIcon.png"];
		[happyImage retain];
	}
	return happyImage;
}

+(UIImage*)sadImage{
    if(!sadImage){
		sadImage=[UIImage imageNamed:@"happyIcon.png"];
		[sadImage retain];
	}
	return sadImage;
}



@end
