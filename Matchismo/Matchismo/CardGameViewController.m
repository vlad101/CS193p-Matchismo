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
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) NSInteger selectedSegment;
@property (weak, nonatomic) IBOutlet UISlider *slider;

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
    // If the value of the slider is not minimum, make it transparent.
    self.resultLabel.alpha = ([_slider value] == [_slider minimumValue]) ? 1.0 : 0.5;
    
    [_slider setValue:[_slider minimumValue] animated:NO];
        
    // add the result to the history array.
    if(self.game.result)
        [historyFlip insertObject:[NSString stringWithFormat:@"%@", self.game.result] atIndex:0];
    
    // Check the array historyFlip contents and count.
    NSLog(@"A history array %@ count: %d", historyFlip, historyFlip.count);
    
    for(UIButton *cardButton in self.cardButtons)
    {
        // Set the background color of the window.
        //[self.view setBackgroundColor:[UIColor greenColor]];
        
        self.resultLabel.alpha = ([_slider value] == [_slider minimumValue]) ? 1.0 : 0.5;
        
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        // Add a border to the cardButton.
        CALayer * layerCardButton = [cardButton layer];
        [layerCardButton setMasksToBounds:YES];
        [layerCardButton setCornerRadius:5.0]; //when radius is 0, the border is a rectangle
        [layerCardButton setBorderWidth:1.0];
        [layerCardButton setBorderColor:[[UIColor blueColor] CGColor]];
        
        // Add a border to the dealButton.
        CALayer * layerDealButton = [_dealButton layer];
        [layerDealButton setMasksToBounds:YES];
        [layerDealButton setCornerRadius:3.0]; //when radius is 0, the border is a rectangle
        [layerDealButton setBorderWidth:1.0];
        [layerDealButton setBorderColor:[[UIColor blackColor] CGColor]];
        
        // Set the back card image.
        UIImage *backImage = [UIImage imageNamed:@"card_back.jpg"];
        [cardButton setBackgroundImage:backImage forState:UIControlStateNormal];
        
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
        
        if(self.game.result)
        {
            if(historyFlip)
                self.resultLabel.text = [NSString stringWithFormat:@"%@", [historyFlip firstObject]];
        }
            
        // Update the score label.
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        // Remove the card image when the button is selected.
        if(cardButton.isSelected)
            [cardButton setBackgroundImage:nil forState:UIControlStateNormal];
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
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] selectedMode:_selectedSegment];
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

- (void)viewDidLoad
{
    // An array holds the history of the game.
    historyFlip = [[NSMutableArray alloc] init];
    
    self.resultLabel.text = [NSString stringWithFormat:@"2-Card-Mode Game"];
    
    // add the result to the history array.
    [historyFlip insertObject:[NSString stringWithFormat:@"2-Card-Mode Game"] atIndex:0];
    
    [self updateUI];
    
    // This makes the slider call the -valueChanged: method when the user interacts with it.
    [_slider addTarget:self
                action:@selector(sliderValueChanged:)
      forControlEvents:UIControlEventValueChanged];
    
    self.resultLabel.alpha = ([_slider value] == [_slider minimumValue]) ? 1.0 : 0.5;
    
    //[_slider setValue:[_slider minimumValue] animated:NO];
    
    [super viewDidLoad];
}

- (IBAction)changeMode:(id)sender
{
    self.segmentedControl = (UISegmentedControl *) sender;
    _selectedSegment = [self.segmentedControl selectedSegmentIndex];
    
    if (_selectedSegment == 0)
    {
        _game = nil;
        self.flipCount = 0;
        self.game.result = @"2-Card-Match Mode!";
        [self updateUI];
    }
    else
    {
        _game = nil;
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
        _game = nil;
        self.flipCount = 0;
        self.game.result = @"New Game!";
        [self updateUI];
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    // Update the slider information.
    _slider.continuous = YES;
    [_slider setMinimumValue:0];
    [_slider setMaximumValue:((float)[historyFlip count] - 1)];
    
    // Round the number.
    NSUInteger index = (NSUInteger)(_slider.value + 0.5);
    
    //[_slider setValue:index animated:NO];
    NSLog(@"index: %i", index);
    
    NSString *flip = [historyFlip objectAtIndex:index];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%@", flip];
    
    self.resultLabel.alpha = ([_slider value] == [_slider minimumValue]) ? 1.0 : 0.5;
}

@end
