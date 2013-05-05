//
//  WUMainViewController.m
//  iSplitter
//
//  Created by James Yu on 5/2/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUMainViewController.h"
#import "WUTaxPickerTableViewCell.h"
#import "WUTipPickerTableViewCell.h"

@interface WUMainViewController ()

@property (nonatomic) int subtotal;
@property (nonatomic) int beforeTax;
@property (nonatomic) BOOL isAfterTax;
@property (nonatomic) int taxRate;
@property (nonatomic) int tax;
@property (nonatomic) int tipRateMinimum;
@property (nonatomic) int tipRateMaximum;
@property (nonatomic) int tip;
@property (nonatomic) int total;
@property (nonatomic) int rounding;
@property (nonatomic) int guests;
@property (nonatomic) int average;

@property (nonatomic, strong) IBOutlet UISwitch *taxSwitch;
@property (nonatomic, strong) IBOutlet UIView *keyboard;
@property (nonatomic, strong) IBOutlet UIButton *cleanButton;

@property (nonatomic) CGRect keyboardHidden;
@property (nonatomic) CGRect keyboardShowen;
@property (nonatomic) BOOL isKeyboardActive;


@property (nonatomic, strong) UIPickerView *taxPicker;
@property (nonatomic, strong) UIPickerView *tipPicker;
@property (nonatomic, strong) UIPickerView *guestPicker;

@end

@implementation WUMainViewController

@synthesize subtotal, beforeTax, isAfterTax, taxRate, tax, tipRateMinimum, tipRateMaximum, tip, total, rounding, guests, average, taxSwitch, keyboard, cleanButton, keyboardHidden, keyboardShowen, isKeyboardActive;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ( frame.size.height > 480) {
        keyboardHidden = CGRectMake(0, 548, 320, 200);
        keyboardShowen = CGRectMake(0, 348, 320, 200);
    } else {
        keyboardHidden = CGRectMake(0, 460, 320, 200);
        keyboardShowen = CGRectMake(0, 260, 320, 200);
    }
    
    
    // load defautl data
    subtotal = 123456;
    isAfterTax = NO;
    taxRate = 925;
    tipRateMinimum = 1300;
    tipRateMaximum = 1800;
    rounding = 100;
    guests = 4;
    taxSwitch.enabled = isAfterTax;
    keyboard = nil;
    isKeyboardActive = NO;
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
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight = 45;
    if (indexPath.row == 1) {
        hight = 80;
    }
    if (indexPath.row == 4 && !isAfterTax) {
        hight = 0;
    }
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 8) {
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
            // total section title
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalSectionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TotalSectionCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = @"";
            
            return cell;
        }
            break;
            
        case 1:
        {
            // total section number
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TotalCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%d.%02d", subtotal/100, subtotal%100];
            cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans" size:38];
            cell.detailTextLabel.textColor = [UIColor redColor];
            if (!cleanButton) {
                cleanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                cleanButton.frame = CGRectMake(25, 20, 50, 40);
                [cleanButton setTitle:@"Clean" forState:UIControlStateNormal];
                [cleanButton addTarget:self action:@selector(zeroSubtitle:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:cleanButton];
            }
            
            return cell;
        }
            break;
            
        case 2:
        {
            // total section setting before tax or after tax
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indentationWidth = 10;
            cell.indentationLevel = 2;
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
            
        case 3:
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
        case 4:
        {
            // before tax number
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BTCell"];
            }
           if (isAfterTax) {
                cell.hidden = NO;
                cell.indentationLevel = 2;
                cell.indentationWidth = 10;
                cell.textLabel.text = @"Before tax";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"$%d.%02d",beforeTax/100, beforeTax%100];
            } else {
                cell.hidden = YES;
            }
            
            return cell;
        }
            break;
        case 5:
        {
            // tax
            WUTaxPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxCell"];
            if (!cell) {
                cell = [[WUTaxPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TaxCell"];
                cell.delegate = self;
            }
            cell.integerPart = [NSString stringWithFormat:@"%d",self.taxRate/100];
            cell.decimalPart = [NSString stringWithFormat:@"%02d", self.taxRate%100];
            cell.indentationLevel = 2;
            cell.indentationWidth =10;
            cell.textLabel.text = [NSString stringWithFormat:@"Tax(%d.%02d%%)",self.taxRate/100, self.taxRate%100];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%d.%02d", self.tax/100, self.tax%100];
            
            return cell;
        }
            break;
            
        case 6:
        {
            // tip
            WUTipPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipCell"];
            if (!cell) {
                cell = [[WUTipPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TipCell"];
                cell.delegate = self;
            }
            cell.tipRateMin = [NSString stringWithFormat:@"%d", self.tipRateMinimum/100];
            cell.tipRateMax = [NSString stringWithFormat:@"%d", self.tipRateMaximum/100];
            cell.indentationLevel = 2;
            cell.indentationWidth =10;
            if (tip == 0 && tipRateMaximum > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Tip(%d.%02d%% - %d.%02d%%)", tipRateMinimum/100, tipRateMinimum%100, tipRateMaximum/100, tipRateMaximum%100];
            } else {
                int tipRate = 0;
                if ( beforeTax > 0 )
                    tipRate = tip*10000/beforeTax;
                cell.textLabel.text = [NSString stringWithFormat:@"Tip(%d.%02d%%)", tipRate/100, tipRate%100];
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%d.%02d",tip/100, tip%100];
            
            return cell;
        }
            break;
        case 7:
        {
            // total
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TACell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TACell"];
            }
            cell.indentationLevel = 2;
            cell.indentationWidth =10;
            cell.textLabel.text = [NSString stringWithFormat:@"Total Amount"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];

            
            return cell;
        }
            break;
        case 8:
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
        case 9:
        {
            // split number
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GuestCell"];
            }
            cell.indentationLevel = 2;
            cell.indentationWidth =10;
            cell.textLabel.text = [NSString stringWithFormat:@"Guests(x%d)",guests];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%d.%02d", average/100, average%100];
            
            return cell;
       }
        default:
            break;
    }
    
    return nil;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self keyboardShowAnimation:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self keyboardShowAnimation:NO];
    [tableView reloadData];
}


#pragma mark - Change settings

-(IBAction)zeroSubtitle:(id)sender
{
    subtotal = 0;
    [self updateNumbers];
    [self.tableView reloadData];
}

- (int)getRoundNumber:(int)number rate:(int)rate
{
    int rnumber = number*rate / 10000;
    if ((number*rate)%10000>=5000) {
        rnumber ++;
    }
    return rnumber;
}

- (void)updateNumbers
{
    if (isAfterTax) {
        beforeTax = (subtotal*10000)/(10000+taxRate);
        tax = subtotal - beforeTax;
    } else {
        beforeTax = subtotal;
        tax = [self getRoundNumber:beforeTax rate:taxRate];
    }
    
    tip = [self getRoundNumber:beforeTax rate:tipRateMinimum];

    for (int i=tip; i<[self getRoundNumber:beforeTax rate:tipRateMaximum]; i++) {
        int temp = beforeTax+tax+i;
        if (temp % (rounding * guests) == 0) {
            tip = i;
            break;
        }
    }

    total = beforeTax+tax+tip;
    average = total / guests;
  //  NSLog(@"subtotal=[%d] before tax=[%d],tax=[%d], tip=[%d], total=[%d] guest=[%d] average=[%d]", subtotal, beforeTax, tax, tip,total, guests, average);
}

#pragma mark - keyboard

-(UIButton *)drawButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    UIFont *font = [UIFont fontWithName:@"GillSans" size:20];
    btn.titleLabel.font = font;
    btn.imageView.image = image;
    
    [btn addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    return btn;
}

- (void)drawKeyboard
{
    keyboard = [[UIView alloc] initWithFrame:CGRectZero];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(    0,   0, 107, 50) title:@"7" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  107,   0, 106, 50) title:@"8" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  213,   0, 107, 50) title:@"9" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(    0,  50, 107, 50) title:@"4" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  107,  50, 106, 50) title:@"5" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  213,  50, 107, 50) title:@"6" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(    0, 100, 107, 50) title:@"1" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  107, 100, 106, 50) title:@"2" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  213, 100, 107, 50) title:@"3" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(    0, 150, 107, 50) title:@"Done" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  107, 150, 106, 50) title:@"0" image:nil]];
    [keyboard addSubview:[self drawButtonWithFrame:CGRectMake(  213, 150, 107, 50) title:@"<" image:nil]];
    [self.view addSubview:keyboard];

}


-(void)keyboardShowAnimation:(BOOL)show
{
    if (show) {
        if (!isKeyboardActive) {
            if (!keyboard) {
                [self drawKeyboard];
            }
            [keyboard setFrame:keyboardHidden];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [keyboard setFrame:keyboardShowen];
            [UIView commitAnimations];
            isKeyboardActive = YES;
        }
    } else {
        if (isKeyboardActive) {
            [keyboard setFrame:keyboardShowen];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [keyboard setFrame:keyboardHidden];
            [UIView commitAnimations];
            isKeyboardActive = NO;
            [keyboard removeFromSuperview];
            keyboard = nil;
        }
    }
}

- (IBAction)taxSwitchChanged:(UISwitch *)sender
{
    NSLog(@"after tax changed");
    isAfterTax = [taxSwitch isOn];
    [self keyboardShowAnimation:NO];
    [self updateNumbers];
    [self.tableView reloadData];
}

- (IBAction)keyboardButtonPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Done"]) {
        [self keyboardShowAnimation:NO];
    } else if ([sender.titleLabel.text isEqualToString:@"<"]) {
        subtotal /= 10;
    } else if (subtotal < 999999) {
        subtotal *= 10;
        subtotal += [sender.titleLabel.text intValue];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"To expensive!" message:@"The number you input is too large." delegate:nil cancelButtonTitle:@"I see." otherButtonTitles:nil, nil];
        [av show];
    }
    [self updateNumbers];
    [self.tableView reloadData];
}

- (void)taxCell:(WUTaxPickerTableViewCell *)cell didEndEditingWithInteger:(NSString *)integerPart decimal:(NSString *)decimalPart
{
    NSLog(@"taxCell: didEndEditing with %@.%@", integerPart, decimalPart);
    self.taxRate = [integerPart intValue]*100 + [decimalPart intValue];
    [self updateNumbers];
}

- (void)tipCell:(WUTipPickerTableViewCell *)cell didEndEditingFromMinimum:(NSString *)tipRateMin toMaximum:(NSString *)tipRateMax
{
    NSLog(@"tipCell: didEndEditing from %@ to %@", tipRateMin, tipRateMax);
    self.tipRateMinimum = [tipRateMin intValue]*100 ;
    self.tipRateMaximum = [tipRateMax intValue]*100 ;
    [self updateNumbers];
    
}

@end
