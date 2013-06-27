//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/26/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResult.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *window;
@property (nonatomic) SEL sortSelector;
@end

@implementation GameResultsViewController

- (void)updateUI
{
    NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    for(GameResult *result in ([GameResult allGameResults]))
    {
        displayText = [displayText  stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, [formatter stringFromDate:result.end], round(result.duration)];
        self.window.text = displayText;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)setup
{
    // initialization that can't wait until viewDidload
    // Get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // Give it a label
    [tbi setTitle:@"Scores"];
    
    // Put the image on the tab bar item
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"dist_opt.jpg"]withFinishedUnselectedImage:[UIImage imageNamed:@"dist_opt.jpg"]];
}

- (void)awakeFromNib
{
    [self setup];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    [self setup];
    
    return self;
}

@synthesize sortSelector = _sortSelector;

- (SEL)sortSelector
{
    if(!_sortSelector)
        _sortSelector = @selector(compareScoreToGameResult:);
    return _sortSelector;
}

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}


- (IBAction)sortByDate
{
    self.sortSelector = @selector(compareEndDateToGameResult:);
}

- (IBAction)sortByScore
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByTime
{
    self.sortSelector = @selector(compareDurationToGameResult:);
}

@end