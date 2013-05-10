//
//  WUMainViewController.h
//  iSplitter
//
//  Created by James Yu on 5/2/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUTableViewCell.h"
#import "WUNumberKeyboardTableViewCell.h"
#import "WUTaxPickerTableViewCell.h"
#import "WUTipPickerTableViewCell.h"
#import "WUGuestRoundPickerTableViewCell.h"
#import "WUUserGuideViewController.h"


@interface WUMainViewController : UITableViewController <WUNumberKeyboardTableViewCellDelegate, WUTaxPickerTableViewCellDelegate, WUTipPickerTableViewCellDelegate, WUGuestRoundPickerTableViewCellDelegate>


@end
