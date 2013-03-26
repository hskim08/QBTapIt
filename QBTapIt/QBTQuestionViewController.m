//
//  QBTQuestionViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTQuestionViewController.h"

#import "QBTUserData.h"

enum PickerType {
    PT_AGE = 0,
    PT_GENDER = 1,
    PT_HANDEDNESS = 2,
    PT_TONE_DEAF = 3,
    PT_ARRHYTHMIC = 4,
    PT_LANGUAGE = 5
};

@interface QBTQuestionViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSArray* ageArray;
@property (nonatomic) NSArray* genderArray;
@property (nonatomic) NSArray* handArray;
@property (nonatomic) NSArray* ynArray;
@property (nonatomic) NSArray* langArray;

@property int pickerType;

- (void)showPickerView:(BOOL)show;

- (NSArray*) currentArray;
- (UIButton*) currentButton;

@end

@implementation QBTQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 470);
    
    self.pickerType = PT_GENDER;
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

- (IBAction) continuePushed:(UIButton*)sender
{
    // save results
    QBTUserData* userData = [QBTUserData sharedInstance];
    [userData initData];
    
    userData.age = [self.ageButton.titleLabel.text integerValue];
    userData.gender = self.genderButton.titleLabel.text;
    userData.nativeLanguage = self.languageButton.titleLabel.text;
    
    SInt8 val;
    val = [self.handArray indexOfObject:self.handedButton.titleLabel.text];
    userData.handedness = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    val = [self.ynArray indexOfObject:self.toneButton.titleLabel.text];
    userData.toneDeaf = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    val = [self.ynArray indexOfObject:self.arrhythmicButton.titleLabel.text];
    userData.arrhythmic = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    
    userData.instrumentTraining = self.instrumentSlider.value*5;
    userData.theoryTraining = self.theorySlider.value*5;
    userData.listeningHabits = self.habitSlider.value*5;
    
    // open next page
    [self performSegueWithIdentifier:@"QuestionToTraining"
                              sender:self];
}

- (IBAction) agePushed:(UIButton*)sender
{
    // set data source array
    self.pickerType = PT_AGE;
    
    // show picker
    [self showPickerView:YES];
}

- (IBAction) genderPushed:(UIButton*)sender
{
    // set data source array
    self.pickerType = PT_GENDER;
    
    // show picker
    [self showPickerView:YES];
}

- (IBAction) languagePushed:(UIButton*)sender
{
    // set data source array
    self.pickerType = PT_LANGUAGE;
    
    // show picker
    [self showPickerView:YES];
}

- (IBAction) handPushed:(UIButton*)sender
{
    // set data source array
    self.pickerType = PT_HANDEDNESS;
    
    // show picker
    [self showPickerView:YES];
}

- (IBAction) tonePushed:(UIButton*)sender
{
    // set data source array
    self.pickerType = PT_TONE_DEAF;
    
    // show picker
    [self showPickerView:YES];
}

- (IBAction) arrhythmicPushed:(UIButton*)sender
{
    // set data source array
    self.pickerType = PT_ARRHYTHMIC;
    
    // show picker
    [self showPickerView:YES];
}

- (IBAction) pickerDonePushed:(UIButton*)sender
{
    [self showPickerView:NO];
}

#pragma mark - UIPickerViewDataSource Selectors

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{// returns the number of 'columns' to display.
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{// returns the # of rows in each component..
    return [self currentArray].count;
}

#pragma mark - UIPickerViewDelegate Selectors

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self currentArray] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // update component
    [[self currentButton] setTitle:[[self currentArray] objectAtIndex:row]
                          forState:UIControlStateNormal] ;
    
    // hide picker
    if ( !(self.pickerType == PT_LANGUAGE || self.pickerType == PT_AGE) )
        [self showPickerView:NO];
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
    if(self.pickerType == PT_AGE) return self.ageArray;
    else if(self.pickerType == PT_GENDER) return self.genderArray;
    else if(self.pickerType == PT_HANDEDNESS) return self.handArray;
    else if(self.pickerType == PT_LANGUAGE) return self.langArray;
    else return self.ynArray;
}

- (UIButton*) currentButton
{
    if(self.pickerType == PT_AGE) return self.ageButton;
    else if(self.pickerType == PT_GENDER) return self.genderButton;
    else if(self.pickerType == PT_HANDEDNESS) return self.handedButton;
    else if(self.pickerType == PT_TONE_DEAF) return self.toneButton;
    else if(self.pickerType == PT_ARRHYTHMIC) return self.arrhythmicButton;
    else if(self.pickerType == PT_LANGUAGE) return self.languageButton;
    else return nil;
}

- (void)showPickerView:(BOOL)show
{
    if (show) { // show
        NSUInteger idx = [[self currentArray] indexOfObject:[self currentButton].titleLabel.text];
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


@end
