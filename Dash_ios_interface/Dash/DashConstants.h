//
//  DashConstants.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static UIColor *theHappyHighlightColor, *theHappyColor, *theSadHighlightColor, *theSadColor, *theCallNowColor;
static UIImage* happyImage, *sadImage, *happyHighlightImage,*sadHighlightImage, *cellBackgroundImage, *phoneImage, *titleImage, *cellGradientImage, *cellGradientHappyImage, *cellGradientSadImage;

@interface DashConstants : NSObject{
    
}
+(UIColor*) theHappyColor;
//+(UIColor*) theHappyHighlightColor;
+(UIColor*) theSadColor;
//+(UIColor*) theSadHighlightColor;
+(UIColor*) theCallNowColor;
+(UIImage*) happyImage;
+(UIImage*) sadImage;
+(UIImage*) happyHighlightImage;
+(UIImage*) sadHighlightImage;
+(UIImage*) cellBackgroundImage;
+(UIImage*) titleImage;

+(UIImage*) cellGradientImage;
+(UIImage*) cellGradientHappyImage;
+(UIImage*) cellGradientSadImage;


@end
