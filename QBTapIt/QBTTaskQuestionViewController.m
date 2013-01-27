//
//  QBTTaskQuestionViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskQuestionViewController.h"

@interface QBTTaskQuestionViewController ()

@property (nonatomic) NSArray* withMusicArray;

- (NSUInteger) indexOfLabel:(UILabel*)label;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction) doneClicked:(UIButton*)sender
{
    [self.delegate handleFamiliarity:ceil(self.familiaritySlider.value*5)];
    
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 
                                 [self.delegate didFinishQuestionnaire];
                             }];
}

- (IBAction) labelTapped:(UITapGestureRecognizer*)sender
{
    self.answer1.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.answer2.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.answer3.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.answer4.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.answer5.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    sender.view.backgroundColor = [UIColor yellowColor];
}

#pragma mark - Private Implementation

@synthesize withMusicArray = _withMusicArray;
- (NSArray*) withMusicArray
{
    if (!_withMusicArray) {
        _withMusicArray = @[@"Yes - it helped me remember more details of the song",
        @"Yes - I thought the lyrics were from a different song, but now I know which song it is",
        @"Yes - I had no idea of the song from just the lyrics, but listening made me recognize it",
        @"No - I already knew the song really well",
        @"No - this song is totally unfamiliar, so hearing it once didn’t help"];
    }
    return _withMusicArray;
}

- (NSUInteger) indexOfLabel:(UILabel*)label
{
    if (label == self.answer1) return 0;
    else if (label == self.answer2) return 1;
    else if (label == self.answer3) return 2;
    else if (label == self.answer4) return 3;
    else if (label == self.answer5) return 4;
    return NSNotFound;
}

@end
