//
//  WUMainViewController.m
//  iSplitter
//
//  Created by James Yu on 5/2/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUMainViewController.h"

@interface WUMainViewController ()

@property (nonatomic) double subtotal;
@property (nonatomic) double beforeTax;
@property (nonatomic) BOOL isAfterTax;
@property (nonatomic) double taxRate;
@property (nonatomic) double tax;
@property (nonatomic) double tipRateMinimum;
@property (nonatomic) double tipRateMaximum;
@property (nonatomic) double tip;
@property (nonatomic) double total;
@property (nonatomic) int rounding;
@property (nonatomic) int guests;
@property (nonatomic) double average;

@property (nonatomic, strong) IBOutlet UISwitch *taxSwitch;
@property (nonatomic, strong) IBOutlet UIView *keyboard;

@property (nonatomic, strong) UIPickerView *taxPicker;
@property (nonatomic, strong) UIPickerView *tipPicker;
@property (nonatomic, strong) UIPickerView *guestPicker;

@end

@implementation WUMainViewController

@synthesize subtotal, beforeTax, isAfterTax, taxRate, tax, tipRateMinimum, tipRateMaximum, tip, total, rounding, guests, average, taxSwitch, keyboard;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // load defautl data
    subtotal = 123.45;
    isAfterTax = NO;
    taxRate = 0.0925;
    tipRateMinimum = 0.13;
    tipRateMaximum = 0.18;
    rounding = 100;
    guests = 4;
    taxSwitch.enabled = isAfterTax;
    keyboard = nil;
    [self updateNumbers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight = 45;
    if (indexPath.row == 0) {
        hight = 80;
    }
    if (indexPath.row == 3 && !isAfterTax) {
        hight = 0;
    }
    if (indexPath.row == 2 || indexPath.row == 7) {
        return 60;
    }
    return hight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UILabel *iSplitterTitle = [[UILabel alloc] init];
    UIFont *font = [UIFont fontWithName:@"GillSans" size:40];
    iSplitterTitle.font = font;
    iSplitterTitle.textAlignment = UITextAlignmentCenter;
    iSplitterTitle.text = @"iSplitter";
        
    return iSplitterTitle;
}

// Configure the cell...
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    switch (indexPath.row) {
        case 0:
        {
            // total section number
            WUNumberKeyboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            if (!cell) {
                cell = [[WUNumberKeyboardTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TotalCell"];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.text = @"Total:";
            cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:36];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", subtotal];
            cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans" size:36];
            cell.detailTextLabel.textColor = [UIColor redColor];
            
            return cell;
        }
            break;
            
        case 1:
        {
            // total section setting before tax or after tax
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        cell.indentationWidth = 10;
      //      cell.indentationLevel = 2;
            cell.textLabel.text = @"After tax";
            cell.detailTextLabel.text = @"";
            
            if (!taxSwitch) {
                CGRect rect = CGRectMake(230, 10, 0, 0);
                taxSwitch = [[UISwitch alloc] initWithFrame:rect];
                [taxSwitch addTarget:self action:@selector(taxSwitchChanged:) forControlEvents:UIControlEventAllTouchEvents];
                [cell addSubview:taxSwitch];
            }
            
            
            return cell;
        }
            break;
            
        case 2:
        {
            // Summary section title
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummarySectionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SummarySectionCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Summary";
            cell.detailTextLabel.text = @"";
            
            return cell;
        }
            break;
        case 3:
        {
            // before tax number
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BTCell"];
            }
           if (isAfterTax) {
                cell.hidden = NO;
 //               cell.indentationLevel = 2;
   //             cell.indentationWidth = 10;
                cell.textLabel.text = @"Before tax";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",beforeTax];
            } else {
                cell.hidden = YES;
            }
            
            return cell;
        }
            break;
        case 4:
        {
            // tax
            WUTaxPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxCell"];
            if (!cell) {
                cell = [[WUTaxPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TaxCell"];
                cell.delegate = self;
            }
            int tr = (int)(taxRate*10000);
            cell.integerPart = [NSString stringWithFormat:@"%d",tr/100];
            cell.decimalPart = [NSString stringWithFormat:@"%02d", tr%100];
  //          cell.indentationLevel = 2;
    //        cell.indentationWidth =10;
            cell.textLabel.text = [NSString stringWithFormat:@"Tax(%.2f%%)", taxRate*100];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", tax];
            
            return cell;
        }
            break;
            
        case 5:
        {
            // tip
            WUTipPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipCell"];
            if (!cell) {
                cell = [[WUTipPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TipCell"];
                cell.delegate = self;
            }
            cell.tipRateMin = [NSString stringWithFormat:@"%d", (int)(tipRateMinimum*100)];
            cell.tipRateMax = [NSString stringWithFormat:@"%d", (int)(tipRateMaximum*100)];
   //         cell.indentationLevel = 2;
     //       cell.indentationWidth =10;
            if (tip == 0 && tipRateMaximum > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Tip(%.2f%% - %.2f%%)", tipRateMinimum*100, tipRateMaximum*100];
            } else {
                double tipRate = 0;
                if ( beforeTax > 0 )
                    tipRate = tip/beforeTax;
                cell.textLabel.text = [NSString stringWithFormat:@"Tip(%.2f%%)", tipRate*100];
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",tip];
            
            return cell;
        }
            break;
        case 6:
        {
            // total
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TACell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TACell"];
            }
   //         cell.indentationLevel = 2;
     //       cell.indentationWidth =10;
            cell.textLabel.text = [NSString stringWithFormat:@"Total Amount"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", total];

            
            return cell;
        }
            break;
        case 7:
        {
            // split section title
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SplitSectionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SplitSectionCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Split";
            cell.detailTextLabel.text = @"";
            
            return cell;
        }
            break;
        case 8:
        {
            // Guest rounding cell
            WUGuestRoundPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell"];
            if (!cell) {
                cell = [[WUGuestRoundPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GuestCell"];
                cell.delegate = self;
            }
            cell.guests = [NSString stringWithFormat:@"%d", self.guests];
            cell.rounding = [NSString stringWithFormat:@"%d", self.rounding];
       //     cell.indentationLevel = 2;
         //   cell.indentationWidth =10;
            cell.textLabel.text = [NSString stringWithFormat:@"Guests(x%d)",guests];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", average];
            
            return cell;
       }
        default:
            break;
    }
    
    return nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
}


#pragma mark - Change settings

- (double)WURoundNumber:(double)number withRate:(double)rate
{
    double temp = number*rate;
    return round(temp*100)/100;
}

- (void)updateNumbers
{
    if (isAfterTax) {
        beforeTax = subtotal/(1+taxRate);
        tax = subtotal - beforeTax;
    } else {
        beforeTax = subtotal;
        tax = [self WURoundNumber:beforeTax withRate:taxRate];
    }
    
    double tipMin = [self WURoundNumber:beforeTax withRate:tipRateMinimum];
    double tipMax = [self WURoundNumber:beforeTax withRate:tipRateMaximum];
    
    tip = tipMin;
    
    for (int i=tipMin*100; i<tipMax*100; i++) {
        int tempTotal = beforeTax*100+tax*100+i;
        if ( tempTotal % (rounding*guests) == 0) {
            tip = ((double)i)/100;
            NSLog(@"tempTotal=%d tip=%f",tempTotal, tip);
            
            break;
        }
    }

    total = beforeTax+tax+tip;
    average = total / guests;
    
    NSLog(@"subtotal=[%f] before tax=[%f],tax=[%f], tip=[%f], total=[%f] guest=[%d] average=[%f]", subtotal, beforeTax, tax, tip,total, guests, average);
}

- (IBAction)taxSwitchChanged:(UISwitch *)sender
{
    NSLog(@"after tax changed");
    isAfterTax = [taxSwitch isOn];
    [self updateNumbers];
    [self.tableView reloadData];
}

- (void)taxCell:(WUTaxPickerTableViewCell *)cell didEndEditingWithInteger:(NSString *)integerPart decimal:(NSString *)decimalPart
{
    NSLog(@"taxCell: didEndEditing with %@.%@", integerPart, decimalPart);
    self.taxRate = ((double)[integerPart intValue])/100 + ((double)[decimalPart intValue])/10000;
    [self updateNumbers];
}

- (void)tipCell:(WUTipPickerTableViewCell *)cell didEndEditingFromMinimum:(NSString *)tipRateMin toMaximum:(NSString *)tipRateMax
{
    NSLog(@"tipCell: didEndEditing from %@ to %@", tipRateMin, tipRateMax);
    self.tipRateMinimum = ((double)[tipRateMin intValue])/100 ;
    self.tipRateMaximum = ((double)[tipRateMax intValue])/100 ;
    [self updateNumbers];
    
}

- (void)guestRoundCell:(WUGuestRoundPickerTableViewCell *)cell didEndEditingWithGuests:(NSString *)gs Rounding:(NSString *)rd
{
    NSLog(@"guestRoundCell: didEndEditing with guests[%@] rounding[%@]",gs, rd);
    self.guests = [gs intValue];
    self.rounding = [rd intValue];
    [self updateNumbers];
}

- (void)keyboardCell:(WUNumberKeyboardTableViewCell *)cell keyboardPressed:(NSString *)key
{
    if ([key isEqualToString:@"Clean"]) {
        subtotal = 0;
    } else if ([key isEqualToString:@"<"]) {
        subtotal /= 10;
        subtotal = [self WURoundNumber:subtotal withRate:1.0];
    } else if (subtotal < 10000) {
        subtotal *= 10;
        subtotal += ((double)[key intValue])/100;
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"To expensive!"
                                                     message:[NSString stringWithFormat:@"Are you crazy?  \"%.1f%@\" is big number...", subtotal*10,key]
                                                    delegate:nil
                                           cancelButtonTitle:@"I see."
                                           otherButtonTitles:nil, nil];
        [av show];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", subtotal ];
    [self updateNumbers];
}

@end
