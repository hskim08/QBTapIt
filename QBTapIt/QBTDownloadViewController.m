//
//  QBTDownloadViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTDownloadViewController.h"

#import "QBTSongListDownloader.h"
#import "QBTDownloadCell.h"

@interface QBTDownloadViewController ()<QBTSongListDownloaderDelegate>

@end

@implementation QBTDownloadViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [QBTSongListDownloader sharedInstance].delegate = self;
    
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem.title = [QBTSongListDownloader sharedInstance].isDownloading ? @"Cancel" : @"Download";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [QBTSongListDownloader sharedInstance].audioDownloaderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    NSUInteger idx = [indexPath indexAtPosition:1];
    
    // Configure the cell by setting audio downloader
    QBTDownloadCell* dlCell = (QBTDownloadCell*)cell;
    dlCell.downloader = [[QBTSongListDownloader sharedInstance].audioDownloaderArray objectAtIndex:idx];
    
    return cell;
}

#pragma mark - IBAction Selectors

- (IBAction)downloadClicked:(UIButton*)sender
{
    if ([QBTSongListDownloader sharedInstance].isDownloading) { // cancel
        
        [[QBTSongListDownloader sharedInstance] cancelDownload];
    }
    else { // download
    
        [[QBTSongListDownloader sharedInstance] downloadSongListFromServer];
        
        [self.tableView reloadData];
        
        self.navigationItem.rightBarButtonItem.title = @"Cancel";
    }
}

#pragma mark - QBTSongListDownloaderDelegate Selectors

- (void) downloadListChanged
{
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem.title = [QBTSongListDownloader sharedInstance].isDownloading ? @"Cancel" : @"Download";
}

@end
