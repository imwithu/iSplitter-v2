//
//  WUTaxPickerTableViewCell.h
//  iSplitter
//
//  Created by James Yu on 5/4/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUPickerTableViewCell.h"

@class WUTaxPickerTableViewCell;

@protocol WUTaxPickerTableViewCellDelegate <NSObject>

-(void)taxCell:(WUTaxPickerTableViewCell *)cell didEndEditingWithInteger:(NSString*)integerPart decimal:(NSString *)decimalPart;

@end

@interface WUTaxPickerTableViewCell : WUPickerTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSString *integerPart;
    NSString *decimalPart;
}

@property (nonatomic, strong) NSString *integerPart;
@property (nonatomic, strong) NSString *decimalPart;
@property (nonatomic, weak) IBOutlet id <WUTaxPickerTableViewCellDelegate> delegate;

@end
