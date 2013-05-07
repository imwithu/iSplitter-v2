//
//  WUGuestRoundPickerTableViewCell.m
//  iSplitter
//
//  Created by James Yu on 5/5/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUGuestRoundPickerTableViewCell.h"

@implementation WUGuestRoundPickerTableViewCell


@synthesize guests, rounding, delegate;

__strong NSArray *guestNumbers = nil;
__strong NSArray *roundingValues = nil;

+(void)initialize
{
    guestNumbers = [NSArray arrayWithObjects:@"Guests",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                    @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",nil];
    roundingValues = [NSArray arrayWithObjects:@"  Round of", @"1", @"25", @"50", @"100", @"500", @"1000", nil];
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

- (void)setGuests:(NSString *)gs
{
    guests = gs;
    if ([guests isEqualToString:[guestNumbers objectAtIndex:0]]) {
        guests = [guestNumbers objectAtIndex:1];
    }
    [self.picker selectRow:[guestNumbers indexOfObject:guests] inComponent:0 animated:YES];
}

- (void)setRounding:(NSString *)rd
{
    rounding = rd;
    if ([rounding isEqualToString:[roundingValues objectAtIndex:0]]) {
        rounding = [roundingValues objectAtIndex:1];
    }
    [self.picker selectRow:[roundingValues indexOfObject:rounding] inComponent:1 animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [guestNumbers count];
    } else if (component == 1) {
        return [roundingValues count];
    }
	return 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0 ) {
        if (row == 0) {
            return [guestNumbers objectAtIndex:row];
        } else {
            return [NSString stringWithFormat:@"% 7d",[[guestNumbers objectAtIndex:row] intValue]];
        }
    } else if (component == 1) {
        if (row == 0) {
            return [roundingValues objectAtIndex:row];
        } else if (row == 1){
            return @"   None";
        } else {
            int r = [[roundingValues objectAtIndex:row] intValue];
            return [NSString stringWithFormat:@"   $%2d.%02d",r/100, r%100];
        }
    }
	return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    } if (component == 1) {
        return 150;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.guests = [guestNumbers objectAtIndex:row];
    } else if (component == 1) {
        self.rounding = [roundingValues objectAtIndex:row];
    } else {
        return ;
    }
    
	if (delegate && [delegate respondsToSelector:@selector(guestRoundCell:didEndEditingWithGuests:Rounding:)]) {
		[delegate guestRoundCell:self didEndEditingWithGuests:self.guests Rounding:self.rounding];
	}
}

@end
