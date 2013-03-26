//
//  QBTSelectViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 3/25/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSelectViewController.h"

#import "QBTUserData.h"

@interface QBTSelectViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSArray* ageArray;
@property (nonatomic) NSArray* genderArray;
@property (nonatomic) NSArray* handArray;
@property (nonatomic) NSArray* ynArray;
@property (nonatomic) NSArray* langArray;

- (NSArray*) currentArray;
- (void) saveSelection:(NSString*)selection;

@end

@implementation QBTSelectViewController

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
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController setToolbarHidden:YES
                                       animated:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction)donePushed:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Implementation

@synthesize ageArray = _ageArray;
- (NSArray*) ageArray
{
    if (!_ageArray) {
        NSMutableArray* ar = [NSMutableArray arrayWithCapacity:100];
        
        for (int i = 1; i < 101; i++) {
            [ar addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        _ageArray = [NSArray arrayWithArray:ar];
    }
    return _ageArray;
}

@synthesize genderArray = _genderArray;
- (NSArray*) genderArray
{
    if (!_genderArray) {
        _genderArray = @[@"Male", @"Female"];
    }
    return _genderArray;
}

@synthesize handArray = _handArray;
- (NSArray*) handArray
{
    if (!_handArray) {
        _handArray = @[@"Left", @"Right", @"Both"];
    }
    return _handArray;
}

@synthesize ynArray = _ynArray;
- (NSArray*) ynArray
{
    if (!_ynArray) {
        _ynArray = @[@"No", @"Yes", @"Don't know"];
    }
    return _ynArray;
}

@synthesize langArray = _langArray;
- (NSArray*) langArray
{
    if (!_langArray) {
        _langArray = @[@"Arabic",@"Bengali",@"Cantonese",@"English",@"French",@"German",@"Hindi",@"Italian",@"Japanese",@"Javanese",@"Korean",@"Malay/Indonesian",@"Mandarin",@"Persian",@"Polish",@"Portuguese",@"Punjabi",@"Russian",@"Spanish",@"Tamil",@"Thai",@"Turkish",@"Vietnamese",@"Other"];
    }
    return _langArray;
}

- (NSArray*) currentArray
{
    if (!self.titleString)  return self.ynArray;

    if ([self.titleString isEqualToString:@"Age"]) return self.ageArray;
    else if ([self.titleString isEqualToString:@"Gender"]) return self.genderArray;
    else if ([self.titleString isEqualToString:@"Native Language"]) return self.langArray;
    else if ([self.titleString isEqualToString:@"Handedness"]) return self.handArray;
    else return self.ynArray;
}

- (void) saveSelection:(NSString*)selection
{
    QBTUserData* userData = [QBTUserData sharedInstance];
    
    if ([self.titleString isEqualToString:@"Age"]) {
        userData.age = selection.intValue;
        NSLog(@"Age: %d", userData.age);
    }
    else if ([self.titleString isEqualToString:@"Gender"]) {
        userData.gender = selection;
    }
    else if ([self.titleString isEqualToString:@"Native Language"]) {
        userData.nativeLanguage = selection;
    }
    else if ([self.titleString isEqualToString:@"Handedness"]) {
        SInt8 val = [self.handArray indexOfObject:selection];
        userData.handedness = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    }
    else if ([self.titleString isEqualToString:@"Tone Deaf"]) {
        SInt8 val = [self.ynArray indexOfObject:selection];
        userData.toneDeaf = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    }
    else if ([self.titleString isEqualToString:@"Arrhythmic"]) {
        SInt8 val = [self.ynArray indexOfObject:selection];
        userData.arrhythmic = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    }
    else {
    
    }
}

#pragma mark - UITableViewDataSource Selectors

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
    
    if (cell) {
        cell.textLabel.text = self.titleString;
        cell.detailTextLabel.text = self.detailString;
    }
    
    return cell;
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
    return [self currentArray].count;
}

#pragma mark - UIPickerViewDelegate Selectors

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self currentArray] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.detailString = [[self currentArray] objectAtIndex:row];
    
    [self saveSelection:self.detailString];
    
    [self.tableView reloadData];
}

@end
