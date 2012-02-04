//
//  DashConstants.h
//  Dash
//
//  Created by Daniel Iglesia on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static UIColor *theHappyHighlightColor, *theHappyColor, *theSadHighlightColor, *theSadColor, *theCallNowColor;
static UIImage* happyImage, *sadImage;
@interface DashConstants : NSObject{
    
}
+(UIColor*) theHappyColor;
+(UIColor*) theHappyHighlightColor;
+(UIColor*) theSadColor;
+(UIColor*) theSadHighlightColor;
+(UIColor*) theCallNowColor;
+(UIImage*) happyImage;
+(UIImage*) sadImage;

@end