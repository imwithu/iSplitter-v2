//
//  WUTaxRatePickerTableViewCell.h
//  iSplitter
//
//  Created by James Yu on 5/3/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUTableViewCell.h"

@class WUPickerTableViewCell;

@interface WUPickerTableViewCell : WUTableViewCell {
    UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) UIPickerView *picker;

@end
