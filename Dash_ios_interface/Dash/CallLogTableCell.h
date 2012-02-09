//
//  CallLogTableCell.h
//  Dash
//
//  Created by Daniel Iglesia on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneCall.h"
#import "ContactInfo.h"
#import "DashConstants.h"    

@interface CallLogTableCell : UITableViewCell{
    UILabel* nameLabel, *phoneNumberLabel, *relationLabel, *contactTypeLabel, *dateLabel, *reportLabel;
    UIImageView* iconImageView;
    PhoneCall* phoneCall;//since I have a written setter, it doesn't want to synthesize
}
//@property (assign) PhoneCall* phoneCall;
@end
