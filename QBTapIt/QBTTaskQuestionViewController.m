//
//  QBTTaskQuestionViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskQuestionViewController.h"

@interface QBTTaskQuestionViewController ()

@property UInt8 labelSelected;

- (NSUInteger) indexOfLabel:(UILabel*)label;
- (NSUInteger) indexOfCheckBox:(UILabel*)label;

- (void) updateSelection;

@end

@implementation QBTTaskQuestionViewController

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
    
    [self updateSelection];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.doneButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction) doneClicked:(UIButton*)sender
{
    [self.delegate handleHelpful:self.labelSelected];
    
    [self.delegate willCloseQuestionnaire];
    
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 [self.delegate didCloseQuestionnaire];
                             }];
}

- (IBAction) labelTapped:(UITapGestureRecognizer*)sender
{
    self.labelSelected = [self indexOfLabel:(UILabel*)sender.view];
    
    [self updateSelection];
}

- (IBAction) checkBoxTapped:(UITapGestureRecognizer*)sender
{
    self.labelSelected = [self indexOfCheckBox:(UILabel*)sender.view];
    
    [self updateSelection];
}

#pragma mark - Private Implementation

- (NSUInteger) indexOfLabel:(UILabel*)label
{
    if (label == self.answer1) return 1;
    else if (label == self.answer2) return 2;
    else if (label == self.answer3) return 3;
    else if (label == self.answer4) return 4;
    else if (label == self.answer5) return 5;
    else if (label == self.answer6) return 6;
    return 0;
}

- (NSUInteger) indexOfCheckBox:(UILabel*)label
{
    if (label == self.checkBox1) return 1;
    else if (label == self.checkBox2) return 2;
    else if (label == self.checkBox3) return 3;
    else if (label == self.checkBox4) return 4;
    else if (label == self.checkBox5) return 5;
    else if (label == self.checkBox6) return 6;
    return 0;
}

- (void) updateSelection
{
    self.doneButton.enabled = YES;
    
    UIColor* unselected = [UIColor whiteColor];
    UIColor* selected = [UIColor yellowColor];
    
    // TODO: systematically add buttons
    self.answer1.backgroundColor = self.labelSelected == 1 ? selected : unselected;
    self.answer2.backgroundColor = self.labelSelected == 2 ? selected : unselected;
    self.answer3.backgroundColor = self.labelSelected == 3 ? selected : unselected;
    self.answer4.backgroundColor = self.labelSelected == 4 ? selected : unselected;
    self.answer5.backgroundColor = self.labelSelected == 5 ? selected : unselected;
    self.answer6.backgroundColor = self.labelSelected == 6 ? selected : unselected;
    
    self.checkBox1.text = self.labelSelected == 1 ? @"▣" : @"□";
    self.checkBox2.text = self.labelSelected == 2 ? @"▣" : @"□";
    self.checkBox3.text = self.labelSelected == 3 ? @"▣" : @"□";
    self.checkBox4.text = self.labelSelected == 4 ? @"▣" : @"□";
    self.checkBox5.text = self.labelSelected == 5 ? @"▣" : @"□";
    self.checkBox6.text = self.labelSelected == 6 ? @"▣" : @"□";
    
    self.checkBox1.backgroundColor = self.labelSelected == 1 ? selected : unselected;
    self.checkBox2.backgroundColor = self.labelSelected == 2 ? selected : unselected;
    self.checkBox3.backgroundColor = self.labelSelected == 3 ? selected : unselected;
    self.checkBox4.backgroundColor = self.labelSelected == 4 ? selected : unselected;
    self.checkBox5.backgroundColor = self.labelSelected == 5 ? selected : unselected;
    self.checkBox6.backgroundColor = self.labelSelected == 6 ? selected : unselected;
}

@end
