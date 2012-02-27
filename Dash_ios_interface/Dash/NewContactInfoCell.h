//
//  NewContactInfoCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactInfo.h"
#import "DashConstants.h"

@interface NewContactInfoCell : UITableViewCell{
    UILabel* nameLabel, *relationLabel, *allNumbersLabel;
    
}
//@property (assign) StudentInfoViewController* parentVC;
//@property (assign) StudentInfo* studentInfo;
@property (assign) ContactInfo* contactInfo;


@end
