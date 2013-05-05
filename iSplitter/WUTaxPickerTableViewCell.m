//
//  WUTaxPickerTableViewCell.m
//  iSplitter
//
//  Created by James Yu on 5/4/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUTaxPickerTableViewCell.h"


@implementation WUTaxPickerTableViewCell

@synthesize integerPart, decimalPart, delegate;

__strong NSArray *integerValues = nil;
__strong NSArray *decimalValues = nil;

+(void)initialize
{
    integerValues = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",nil];
    decimalValues = [NSArray arrayWithObjects:@"00", @"25", @"50",@"75",nil];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.picker.delegate = self;
        self.picker.dataSource = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.picker.delegate = self;
        self.picker.dataSource = self;
    }
    return self;
}

- (void)setIntegerPart:(NSString *)ip
{
    integerPart = ip;
    [self.picker selectRow:[integerValues indexOfObject:ip] inComponent:1 animated:YES];
}

- (void)setDecimalPart:(NSString *)dp
{
    decimalPart = dp;
    [self.picker selectRow:[decimalValues indexOfObject:dp] inComponent:2 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1) {
        return [integerValues count];
    } else if (component == 2) {
        return [decimalValues count];
    }
	return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 1) {
        return [integerValues objectAtIndex:row];
    } else if (component == 2) {
        return [NSString stringWithFormat:@".%@ %%", [decimalValues objectAtIndex:row]];
    }
	return @"Tax=";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 1 ) {
        return 40.f;
    } else if ( component == 2) {
        return 80.f;
    }
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        self.integerPart = [integerValues objectAtIndex:row];
    } else if (component == 2) {
        self.decimalPart = [decimalValues objectAtIndex:row];
    } else
        return;

	if (delegate && [delegate respondsToSelector:@selector(taxCell:didEndEditingWithInteger:decimal:)]) {
		[delegate taxCell:self didEndEditingWithInteger:self.integerPart decimal:self.decimalPart];
	}

}


@end
