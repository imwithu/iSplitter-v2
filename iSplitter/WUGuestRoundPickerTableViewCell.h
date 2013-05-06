//
//  WUGuestRoundPickerTableViewCell.h
//  iSplitter
//
//  Created by James Yu on 5/5/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUPickerTableViewCell.h"

@class WUGuestRoundPickerTableViewCell;

@protocol WUGuestRoundPickerTableViewCellDelegate <NSObject>

- (void)guestRoundCell:(WUGuestRoundPickerTableViewCell *)cell didEndEditingWithGuests:(NSString *)gs Rounding:(NSString *)rd;

@end

@interface WUGuestRoundPickerTableViewCell : WUPickerTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSString *guests;
    NSString *rounding;
}

@property (nonatomic, strong) NSString *guests;
@property (nonatomic, strong) NSString *rounding;

@property (nonatomic, weak) id <WUGuestRoundPickerTableViewCellDelegate> delegate;

@end
