//
//  WUMainViewController.h
//  iSplitter
//
//  Created by James Yu on 5/2/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUTaxPickerTableViewCell.h"
#import "WUTipPickerTableViewCell.h"

@interface WUMainViewController : UITableViewController <WUTaxPickerTableViewCellDelegate, WUTipPickerTableViewCellDelegate>

@end
