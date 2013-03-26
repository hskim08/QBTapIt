//
//  QBTTrainingViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 3/26/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTrainingViewController.h"

#import "QBTUserData.h"

@interface QBTTrainingViewController () <UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSMutableArray* trainingArray;

@property (nonatomic) NSArray* durationArray;

- (void)showPickerView:(BOOL)show;

@end

@implementation QBTTrainingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.durationText.delegate = self;
    self.instrumentText.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.editing = YES;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    CGRect frame = self.pickerHolder.frame;
    frame.origin.y = self.view.frame.size.height+40;
    self.pickerHolder.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction)continuePushed:(UIBarButtonItem*)sender
{
    // render down to comma separated string
    NSMutableString* str = [NSMutableString stringWithCapacity:0];
    
    for (NSString* s in self.trainingArray) {
        [str appendString:s];
        
        if ([self.trainingArray indexOfObject:s] < (self.trainingArray.count-1)) {
            [str appendString:@", "];
        }
    }
    
    NSLog(@"train string: %@", str);

    // save to user data
    [QBTUserData sharedInstance].specificTraining = str;
    
    // move on
    [self performSegueWithIdentifier:@"TrainingToStart"
                              sender:self];
}

- (IBAction)addPushed:(UIButton*)sender
{
    NSUInteger dur = self.durationText.text.intValue;
    NSString* durStr = dur > 1 ? [NSString stringWithFormat:@"%@s", self.durationButton.titleLabel.text] : self.durationButton.titleLabel.text;
    
    NSString* str = [NSString stringWithFormat:@"%d %@ of %@", dur, durStr, self.instrumentText.text];
    NSLog(@"%@", str);
    
    // add to data source
    [self.trainingArray addObject:str];
    
    // refresh table
    [self.tableView reloadData];
}

- (IBAction)durationPushed:(UIButton*)sender
{
    // show picker
    [self showPickerView:YES];
}

- (IBAction) pickerDonePushed:(UIButton*)sender
{
    // hide picker
    [self showPickerView:NO];
}

#pragma mark - Private Implementation

@synthesize durationArray = _durationArray;
- (NSArray*) durationArray
{
    if (!_durationArray) {
        _durationArray = @[@"month", @"year"];
    }
    return _durationArray;
}

@synthesize trainingArray = _trainingArray;
- (NSMutableArray*) trainingArray {
    if (!_trainingArray) {
        _trainingArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _trainingArray;
}

- (void)showPickerView:(BOOL)show
{
    if (show) { // show
        NSUInteger idx = [self.durationArray indexOfObject:self.durationButton.titleLabel.text];
        if (idx == NSNotFound)
            idx = 0;
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:idx
                       inComponent:0
                          animated:NO];
        
        [UIView animateWithDuration:.33
                         animations:^{
                             CGRect frame = self.pickerHolder.frame;
                             frame.origin.y = self.view.frame.size.height-frame.size.height;
                             self.pickerHolder.frame = frame;
                         }];
    }
    else {
        
        [UIView animateWithDuration:.33
                         animations:^{
                             CGRect frame = self.pickerHolder.frame;
                             frame.origin.y = self.view.frame.size.height;
                             self.pickerHolder.frame = frame;
                         }
         ];
    }
}

#pragma mark - UITableViewDataSource Selectors

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Entries"; // TODO: find better expression
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trainingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TrainingCell"];
    cell.textLabel.text = [self.trainingArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"delete row: %d", indexPath.row);
    
    [self.trainingArray removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}

#pragma mark - UITextFieldDelegate Selectors

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.durationText) { // force integer
        self.durationText.text = [NSString stringWithFormat:@"%d", textField.text.intValue];
    }
    else if (textField == self.instrumentText) { // force lower case
        self.instrumentText.text = [self.instrumentText.text lowercaseString];
    }
    
    return NO;
}

#pragma mark - UIPickerViewDataSource Selectors

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.durationArray.count;
}

#pragma mark - UIPickerViewDelegate Selectors

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.durationArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // update component
    [self.durationButton setTitle:[self.durationArray objectAtIndex:row]
                          forState:UIControlStateNormal] ;
}


@end
