//
//  WUTipPickerTableViewCell.h
//  iSplitter
//
//  Created by James Yu on 5/4/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUPickerTableViewCell.h"

@class WUTipPickerTableViewCell ;

@protocol WUTipPickerTableViewCellDelegate <NSObject>

- (void)tipCell:(WUTipPickerTableViewCell *)cell didEndEditingFromMinimum:(NSString*)tipRateMin toMaximum:(NSString *)tipRateMax;

@end

@interface WUTipPickerTableViewCell : WUPickerTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSString *tipRateMin;
    NSString *tipRateMax;
}

@property (nonatomic, strong) NSString *tipRateMin;
@property (nonatomic, strong) NSString *tipRateMax;
@property (nonatomic, weak) IBOutlet id <WUTipPickerTableViewCellDelegate> delegate;


@end
