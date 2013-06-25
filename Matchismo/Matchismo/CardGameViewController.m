//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) NSInteger selectedSegment;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if(!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        // Set the card in the selected state to be the card's contents.
        // If the contents have not changed, it will do nothing.
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        
        // Set the title when the button is both Selected and Disabled to also be the card's contents.
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        // Select the card only if it's faceUp.
        cardButton.selected = card.faceUp;
        
        // Make the card untappable if isUnplayable.
        cardButton.enabled = !card.isUnplayable;
        
        // Make the disabled buttons "semi-transparent."
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        // Update the result label.
        if(self.game.result)
            self.resultLabel.text = [NSString stringWithFormat:@"%@", self.game.result];
        
        // Update the score label.
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (void)setFlipCount:(int)flipCount
{
    // Only setters and getters should access the instance variable directly.
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", flipCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    // Let the CardMatchingGame to flip the card.
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)dealCards:(id)sender
{
    // Ask the user if he or she is sure before aborting the game in process to re-deal.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really reset?"
                                                     message:@"Do you really want to reset this game?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"reset", nil];
    
    [alert show];
}


- (IBAction)changeMode:(id)sender
{
    self.segmentedControl = (UISegmentedControl *) sender;
    _selectedSegment = [self.segmentedControl selectedSegmentIndex];
    
    if (_selectedSegment == 0)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
        self.flipCount = 0;
        self.game.result = @"2-Card-Match Mode!";
        [self updateUI];
    }
    else
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
        self.flipCount = 0;
        self.game.result = @"3-Card-Match Mode!";
        [self updateUI];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Cancel alert.
    if (buttonIndex == 0)
        [self updateUI];
    // Reset the game by creating a new game instance, set flipCount and score to zero.
    else if (buttonIndex == 1)
    {
        if(_selectedSegment == 0)
        {
            _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
            self.flipCount = 0;
            self.game.result = @"New Game!";
            [self updateUI];
            NSLog(@"No Hello");
        }
        if(self.selectedSegment == 1)
            NSLog(@"Hello");
        start setting the different LogicalAddress
    }
}

@end