//
//  WUTipPickerTableViewCell.m
//  iSplitter
//
//  Created by James Yu on 5/4/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUTipPickerTableViewCell.h"

@implementation WUTipPickerTableViewCell

@synthesize tipRateMin, tipRateMax, delegate;

__strong NSArray *pickerValues = nil;

+(void)initialize
{
    pickerValues = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                    @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                    @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",nil];
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


- (void)setTipRateMin:(NSString *)trMin
{
    tipRateMin = trMin;
    if ([tipRateMin intValue] > [tipRateMax intValue]) {
        self.tipRateMax = trMin;
    }
    [self.picker selectRow:[pickerValues indexOfObject:tipRateMin] inComponent:1 animated:YES];
}

- (void)setTipRateMax:(NSString *)trMax
{
    tipRateMax = trMax;
    if ([tipRateMax intValue] < [tipRateMin intValue]) {
        self.tipRateMin = trMax;
    }
    [self.picker selectRow:[pickerValues indexOfObject:tipRateMax] inComponent:3 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1 || component == 3) {
        return [pickerValues count];
    } 
	return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 1 || component == 3) {
        return [NSString stringWithFormat:@"%@%%", [pickerValues objectAtIndex:row]];
    } else if (component == 2) {
        return @"-";
    }
	return @"Tip=";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 1 || component == 3) {
        return 60.f;
    } else if ( component == 2) {
        return 30.f;
    }
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        self.tipRateMin = [pickerValues objectAtIndex:row];
    } else if (component == 3) {
        self.tipRateMax = [pickerValues objectAtIndex:row];
    } else {
        return ;
    }
    
	if (delegate && [delegate respondsToSelector:@selector(tipCell:didEndEditingFromMinimum:toMaximum:)]) {
		[delegate tipCell:self didEndEditingFromMinimum:tipRateMin toMaximum:tipRateMax];
	}
}

@end
