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

@property (nonatomic, strong) UIPickerView *taxPicker;
@property (nonatomic, strong) UIPickerView *tipPicker;
@property (nonatomic, strong) UIPickerView *guestPicker;

@property (nonatomic) BOOL isRetina4Inch;

@end

@implementation WUMainViewController

@synthesize subtotal, beforeTax, isAfterTax, taxRate, tax, tipRateMinimum, tipRateMaximum, tip, total, rounding, guests, average, taxSwitch, isRetina4Inch;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
   // self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"receipt.jpg"]];
    
    // load defautl data
    [self loadConfigureItems];
    subtotal = 0.0;
    isAfterTax = NO;
    taxSwitch.enabled = isAfterTax; // 这个地方不知道有没有什么风险，taxSwitch会不会还没有被初始化
    
    if ([[UIScreen mainScreen] bounds].size.height > 480)
        isRetina4Inch = YES;
    else
        isRetina4Inch = NO;
    
    [self updateNumbers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save and load data

- (void)loadConfigureItems
{
    NSDictionary *data = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"iSplitter-saved-data"] copy];
    if (data) {
        taxRate = [[data objectForKey:@"taxRate"] doubleValue];
        tipRateMinimum = [[data objectForKey:@"tipRateMinimum"] doubleValue];
        tipRateMaximum = [[data objectForKey:@"tipRateMaximum"] doubleValue];
        rounding = [[data objectForKey:@"rounding"] intValue];
        guests = [[data objectForKey:@"guests"] intValue];
    } else {
        taxRate = 0.0925;
        tipRateMinimum = 0.10;
        tipRateMaximum = 0.20;
        rounding = 100;
        guests = 2;
    }
 }

- (void)saveConfigureItems
{
    NSDictionary *data = @{@"taxRate":@(taxRate), @"tipRateMinimum":@(tipRateMinimum), @"tipRateMaximum":@(tipRateMaximum), @"rounding":@(rounding), @"guests":@(guests)};
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"iSplitter-saved-data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 4;
    } else return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 70.f;
    } else
        return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 50.f;
    }
    if (isRetina4Inch)
        return 45.f;
    else
        return 35.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionTitle = [[UILabel alloc] init];
    UIFont *font = nil;
    if (section == 0)
    {
        font = [UIFont fontWithName:@"GillSans" size:40];
        sectionTitle.text = @"iSplitter";
        // 加上帮助页面的按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        btn.frame = CGRectMake(280, 20, 20, 20);
        
        // 这里需要增加按钮的事件。及，使用segue进入到info页面。打开一系列使用帮助。
        
        [sectionTitle addSubview:btn];
    } else {
        font = [UIFont fontWithName:@"GillSans" size:24];
        if (section == 1) {
            sectionTitle.text = @"Detail";
        } else {
            sectionTitle.text = @"Summary";
        }
    }
    sectionTitle.font = font;
    sectionTitle.textAlignment = UITextAlignmentCenter;
        
    return sectionTitle;
}

- (void)setAttributedLable:(UILabel *)textLabel text:(NSString *)text rangeText:(NSString *)rangeText size:(float)size color:(UIColor *)color
{
    textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:12];
    textLabel.textColor = color;
    
    NSRange arange = [text rangeOfString:rangeText];
    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:@"GillSans-Light" size:size]};
    [richText setAttributes:attr range:arange];
    
    textLabel.attributedText = richText;
}

- (void)setAttributedLable:(UILabel *)textLabel text:(NSString *)text rangeText:(NSString *)rangeText
{
    [self setAttributedLable:textLabel text:text rangeText:rangeText size:18 color:[UIColor blackColor]];
}

- (void)setAttributedLable:(UILabel *)textLabel text:(NSString *)text size:(float)size color:(UIColor *)color
{
    [self setAttributedLable:textLabel text:text rangeText:text size:size color:color];
}

- (void)setAttributedLable:(UILabel *)textLabel text:(NSString *)text color:(UIColor *)color
{
    [self setAttributedLable:textLabel text:text size:18 color:color];
}

- (void)setAttributedLable:(UILabel *)textLabel text:(NSString *)text size:(float)size
{
    [self setAttributedLable:textLabel text:text size:size color:[UIColor blackColor]];
}

- (void)setAttributedLable:(UILabel *)textLabel text:(NSString *)text
{
    [self setAttributedLable:textLabel text:text size:18];
}


// Configure the cell...
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // total section number
            WUNumberKeyboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            if (!cell) {
                cell = [[WUNumberKeyboardTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TotalCell"];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:24];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans-Light" size:36];
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                cell.textLabel.text = @"Subtotal:";
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", subtotal];
            
            return cell;
        } else {
            // total section setting before tax or after tax
            WUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATCell"];
            if (!cell) {
                cell = [[WUTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (isRetina4Inch) 
                    taxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 9, 0, 0)];
                else
                    taxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 4, 0, 0)];
                    
                [taxSwitch addTarget:self action:@selector(taxSwitchChanged:) forControlEvents:UIControlEventAllTouchEvents];
                [cell addSubview:taxSwitch];
            }
            text = [NSString stringWithFormat:@"After tax (%@)", [taxSwitch isOn]?@"Yes":@"No"];
            [self setAttributedLable:cell.textLabel text:text rangeText:@"After tax"];
           
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            WUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTCell"];
            if (!cell) {
                cell = [[WUTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BTCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self setAttributedLable:cell.textLabel text:@"Before tax"];
            }
            text = [NSString stringWithFormat:@"$%.2f",beforeTax];
            [self setAttributedLable:cell.detailTextLabel text:text];
            
            return cell;
        } else if (indexPath.row  == 1) {
            WUTaxPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxCell"];
            if (!cell) {
                cell = [[WUTaxPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TaxCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.delegate = self;
            }
            [self updateTaxCell:cell];
            
            return cell;
            
        } else if ( indexPath.row == 2) {
            WUTipPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipCell"];
            if (!cell) {
                cell = [[WUTipPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TipCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.delegate = self;
            }
            
            [self updateTipCell:cell];
            
            return cell;

        } else {
            WUGuestRoundPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell"];
            if (!cell) {
                cell = [[WUGuestRoundPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GuestCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.delegate = self;
            }
            [self updateGuestRoundCell:cell];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            // total
            WUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TACell"];
            if (!cell) {
                cell = [[WUTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TACell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self setAttributedLable:cell.textLabel text:@"Total Amount"];
            }
            text = [NSString stringWithFormat:@"$%.2f", total];
            [self setAttributedLable:cell.detailTextLabel text:text];
            
            return cell;
        } else if(indexPath.row == 1) {
            WUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CACell"];
            if (!cell) {
                cell = [[WUTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CACell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self setAttributedLable:cell.textLabel text:@"Collect Amount"];
            }
            text = [NSString stringWithFormat:@"$%.2f", average * guests];
            [self setAttributedLable:cell.detailTextLabel text:text];
            
            return cell;
        } else {
            WUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiffCell"];
            if (!cell) {
                cell = [[WUTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DiffCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self setAttributedLable:cell.textLabel text:@"Balance"];
            }
            double diff = total - average * guests ;
            diff = [self WURoundNumber:diff withRate:1.0];
            if (diff > 0) {
             //   NSLog(@"diff is > 0(%f)",diff);
                text = [NSString stringWithFormat:@"-$%.2f", diff];
                [self setAttributedLable:cell.detailTextLabel text:text color:[UIColor orangeColor]];
            } else {
             //   NSLog(@"diff is <= 0(%f)",diff);
                diff = 0-diff;
                text = [NSString stringWithFormat:@"$%.2f", diff];
                [self setAttributedLable:cell.detailTextLabel text:text];
            }
            
            return cell;           
        }
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
        beforeTax = [self WURoundNumber:(subtotal/(1+taxRate)) withRate:1.0];
        tax = [self WURoundNumber:(subtotal-beforeTax) withRate:1.0];
    } else {
        beforeTax = [self WURoundNumber:subtotal withRate:1.0];
        tax = [self WURoundNumber:beforeTax withRate:taxRate];
    }
    
    double tipMin = [self WURoundNumber:beforeTax withRate:tipRateMinimum];
    double tipMax = [self WURoundNumber:beforeTax withRate:tipRateMaximum];
    
    tip = tipMin;

    int intbt = (int)round(beforeTax*100);
    int inttax = (int)round(tax*100);

    for (int inttip=(int)round(tipMin*100); ; inttip++) {
        int tempTotal = intbt+inttax+inttip;
        if ( tempTotal % (rounding*guests) == 0) {
            tip = ((double)inttip)/100;
            break;
        }
    }
    total = beforeTax+tax+tip;
    average = [self WURoundNumber:(total/guests) withRate:1.0];
    
    if ([self WURoundNumber:tip withRate:1.0] > tipMax) {
        tip = tipMin;
    }
    total = beforeTax+tax+tip;
    
  //  NSLog(@"subtotal=[%f] before tax=[%f],tax=[%f], tip=[%f], total=[%f] guest=[%d] round=[%d] average=[%f]", subtotal, beforeTax, tax, tip,total, guests, rounding, average);
}

- (IBAction)taxSwitchChanged:(UISwitch *)sender
{
    isAfterTax = [taxSwitch isOn];
    [self updateNumbers];
    [self.tableView reloadData];
}

- (void)updateTaxCell:(WUTaxPickerTableViewCell *)cell
{
    int tr = (int)(taxRate*10000);
    cell.integerPart = [NSString stringWithFormat:@"%d",tr/100];
    cell.decimalPart = [NSString stringWithFormat:@"%02d", tr%100];
    NSString *text = [NSString stringWithFormat:@"Tax (%.2f%%)", taxRate*100];
    [self setAttributedLable:cell.textLabel text:text rangeText:@"Tax"];
    text = [NSString stringWithFormat:@"$%.2f", tax];
    [self setAttributedLable:cell.detailTextLabel text:text];
}

- (void)taxCell:(WUTaxPickerTableViewCell *)cell didEndEditingWithInteger:(NSString *)integerPart decimal:(NSString *)decimalPart
{
    self.taxRate = [integerPart doubleValue]/100 + [decimalPart doubleValue]/10000;
    [self saveConfigureItems];
    [self updateNumbers];
    [self updateTaxCell:cell];
}

- (void)updateTipCell:(WUTipPickerTableViewCell *)cell
{
    cell.tipRateMin = [NSString stringWithFormat:@"%d", (int)(tipRateMinimum*100)];
    cell.tipRateMax = [NSString stringWithFormat:@"%d", (int)(tipRateMaximum*100)];
    
    NSString *text = nil;
    if (tipRateMinimum == tipRateMaximum) {
        text = [NSString stringWithFormat:@"Tip (%.0f%%)", tipRateMaximum*100];
    } else if (beforeTax > 0)
        text = [NSString stringWithFormat:@"Tip (%.2f%% of %.0f%%-%.0f%%)",(tip/beforeTax)*100, tipRateMinimum*100, tipRateMaximum*100];
    else
        text = [NSString stringWithFormat:@"Tip (%.0f%%-%.0f%%)",tipRateMinimum*100, tipRateMaximum*100];
    [self setAttributedLable:cell.textLabel text:text rangeText:@"Tip"];
    text = [NSString stringWithFormat:@"$%.2f", tip];
    [self setAttributedLable:cell.detailTextLabel text:text];
}

- (void)tipCell:(WUTipPickerTableViewCell *)cell didEndEditingFromMinimum:(NSString *)tipRateMin toMaximum:(NSString *)tipRateMax
{
    self.tipRateMinimum = [tipRateMin doubleValue]/100 ;
    self.tipRateMaximum = [tipRateMax doubleValue]/100 ;
    [self saveConfigureItems];
    [self updateNumbers];
    [self updateTipCell:cell];
}

- (void)updateGuestRoundCell:(WUGuestRoundPickerTableViewCell *)cell
{
    cell.guests = [NSString stringWithFormat:@"%d", self.guests];
    cell.rounding = [NSString stringWithFormat:@"%d", self.rounding];
    NSString *text = [NSString stringWithFormat:@"Split (x%d)",guests];
    [self setAttributedLable:cell.textLabel text:text rangeText:@"Split"];
    text = [NSString stringWithFormat:@"$%.2f", average];
    [self setAttributedLable:cell.detailTextLabel text:text];

}

- (void)guestRoundCell:(WUGuestRoundPickerTableViewCell *)cell didEndEditingWithGuests:(NSString *)gs Rounding:(NSString *)rd
{
    self.guests = [gs intValue];
    self.rounding = [rd intValue];
    [self saveConfigureItems];
    [self updateNumbers];
    
    [self updateGuestRoundCell:cell];
}

- (void)keyboardCell:(WUNumberKeyboardTableViewCell *)cell keyboardPressed:(NSString *)key
{
    if ([key isEqualToString:@"AC"]) {
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
    [self updateNumbers];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", subtotal];
}

@end
