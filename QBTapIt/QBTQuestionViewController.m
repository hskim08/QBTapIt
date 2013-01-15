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
    PT_GENDER = 1,
    PT_HANDEDNESS = 2,
    PT_TONE_DEAF = 3,
    PT_ARRHYTHMIC = 4,
    PT_LANGUAGE = 5
};

@interface QBTQuestionViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    // Move these arrays into their own class
    NSArray* genderArray;
    NSArray* handArray;
    NSArray* ynArray;
    NSArray* langArray;
}

@property int pickerType;

- (void) initArrays;
- (NSArray*) currentArray;
- (UIButton*) currentButton;


- (void)showPickerView:(BOOL)show;

@end

@implementation QBTQuestionViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initArrays];
    
    self.ageText.delegate = self;
    
    self.pickerType = PT_GENDER;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
//    self.pickerView.hidden = YES;
    CGRect frame = self.pickerView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.pickerView.frame = frame;
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
    
    userData.age = [self.ageText.text integerValue];
    userData.gender = self.genderButton.titleLabel.text;
    userData.nativeLanguage = self.languageButton.titleLabel.text;
    
    SInt8 val;
    val = [handArray indexOfObject:self.handedButton.titleLabel.text];
    userData.handedness = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    val = [ynArray indexOfObject:self.toneButton.titleLabel.text];
    userData.toneDeaf = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    val = [ynArray indexOfObject:self.arrhythmicButton.titleLabel.text];
    userData.arrythmic = val > 1 ? -1 : val; // see user data format in QBTUserData.h
    
    // send to server
    [userData sendToServer];
    
    // open next page
    [self performSegueWithIdentifier:@"QuestionToStart"
                              sender:self];
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


#pragma mark - UITextFieldDelegate Selectors

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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
    [self showPickerView:NO];
}

#pragma mark - Private Selectors

- (void) initArrays
{
    genderArray = @[@"Male", @"Female"];
    handArray = @[@"Left", @"Right", @"Both"];
    ynArray = @[@"Yes", @"No", @"N/A"];
    langArray = @[@"Acholi", @"Afrikaans", @"Akan", @"Albanian", @"Amharic", @"Arabic", @"Armenian", @"Assyrian", @"Azerbaijani", @"Azeri",
    @"Bajuni", @"Bambara", @"Basque", @"Behdini", @"Belorussian", @"Bengali", @"Berber", @"Bosnian", @"Bravanese", @"Bulgarian", @"Burmese",
    @"Cantonese", @"Catalan", @"Chaldean", @"Chaochow", @"Chamorro", @"Chavacano", @"Cherokee", @"Chuukese", @"Croatian", @"Czech",
    @"Dakota", @"Danish", @"Dari", @"Dinka", @"Diula", @"Dutch",
    @"English", @"Ewe",
    @"Farsi", @"Fijian ", @"Hindi", @"Finnish", @"Flemish", @"French", @"Fukienese", @"Fula", @"Fulani", @"Fuzhou",
    @"Gaddang", @"Georgian", @"German", @"Gorani", @"Greek", @"Gujarati",
    @"Haitian Creole", @"Hakka", @"Hausa", @"Hebrew", @"Hindi", @"Hmong", @"Hunanese", @"Hungarian",
    @"Ibanag", @"Ibo/Igbo", @"Icelandic", @"Ilocano", @"Indonesian", @"Italian",
    @"Jakartanese", @"Japanese", @"Javanese",
    @"Karen", @"Kashmiri", @"Kazakh", @"Khmer (Cambodian)", @"Kinyarwanda", @"Kirghiz", @"Kirundi", @"Korean", @"Kosovan", @"Krio", @"Kurdish", @"Kurmanji",
    @"Lakota", @"Laotian", @"Latvian", @"Lingala", @"Lithuanian", @"Luganda", @"Luxembourgeois",
    @"Maay", @"Macedonian", @"Malagasy", @"Malay", @"Malayalam", @"Maltese", @"Mandarin", @"Mandingo", @"Mandinka", @"Maninka", @"Mankon", @"Marathi", @"Marshallese", @"Mien", @"Mina", @"Mirpuri", @"Mixteco", @"Moldavan", @"Mongolian", @"Montenegrin",
    @"Navajo", @"Neapolitan", @"Nepali", @"Norwegian", @"Nuer",
    @"Oromo",
    @"Pahari", @"Pampangan", @"Pamgasinan", @"Pashto", @"Patois", @"Polish", @"Portuguese", @"Portuguese", @"Punjabi",
    @"Romanian", @"Russian", @"Samoan", @"Serbian", @"Shanghainese", @"Shona", @"Sicilian", @"Sinhalese", @"Sindhi", @"Slovak", @"Slovenian", @"Somali", @"Sorani", @"Spanish", @"Swahili", @"Swedish", @"Sylhetti",
    @"Tagalog", @"Taiwanese", @"Tajik", @"Tamil", @"Telugu", @"Thai", @"Tibetan", @"Tigre", @"Tigrinya", @"Toishanese", @"Tongan", @"Tshiluba", @"Turkish", @"Twi",
    @"Ukrainian", @"Urdu", @"Uzbek",
    @"Vietnamese", @"Visayan",
    @"Welsh", @"Wolof",
    @"Yiddish", @"Yoruba", @"Yupik"];
}

- (NSArray*) currentArray
{
    if(self.pickerType == PT_GENDER) return genderArray;
    else if(self.pickerType == PT_HANDEDNESS) return handArray;
    else if(self.pickerType == PT_LANGUAGE) return langArray;
    else return ynArray;
}

- (UIButton*) currentButton
{
    if(self.pickerType == PT_GENDER) return self.genderButton;
    else if(self.pickerType == PT_HANDEDNESS) return self.handedButton;
    else if(self.pickerType == PT_TONE_DEAF) return self.toneButton;
    else if(self.pickerType == PT_ARRHYTHMIC) return self.arrhythmicButton;
    else if(self.pickerType == PT_LANGUAGE) return self.languageButton;
    else return nil;
}

- (void)showPickerView:(BOOL)show
{
    if (show) {
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:[[self currentArray] indexOfObject:[self currentButton].titleLabel.text]
                       inComponent:0
                          animated:NO];
        
        [UIView animateWithDuration:.33
                         animations:^{
                             CGRect frame = self.pickerView.frame;
                             frame.origin.y = self.view.frame.size.height-frame.size.height;
                             self.pickerView.frame = frame;
                         }];
    }
    else {
        [UIView animateWithDuration:.33
                         animations:^{
                             CGRect frame = self.pickerView.frame;
                             frame.origin.y = self.view.frame.size.height;
                             self.pickerView.frame = frame;
                         }
         ];
    }
}


@end
