//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/21/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@end


@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if(self)
    {
        // Loop through the specified count of cards.
        for(int i = 0; i < count; i++)
        {
            // Draw a random card from the specified deck.
            Card *card = [deck drawRandomCard];
            
            // Protect from insufficient decks.
            if(!card)
                self = nil;
            else
                // Add a card to an NSMutableArray.
                self.cards[i] = card;
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

// Charge a cost to flip.
#define FLIP_COST 1;

// If match, scale the scoring.
#define MATCH_BONUS 4

// If no match, assess a penalty
#define MISMATCH_PENALTY 2;

- (void)flipCardAtIndex:(NSUInteger)index
           selectedMode:(int)mode;
{
    // Get the card.
    Card *card = [self cardAtIndex:index];
    
    NSMutableArray *testCards = [[NSMutableArray alloc] init];
    
    // Flip the card if it is playable.
    if(!card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            // Is flipping the card creates a match?
            for(Card *otherCard in self.cards)
            {
                // Look through the other cards looking for another face up, playable one.
                if(mode == 0 && otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    // If the card is found check to see if it there is a match.
                    // Since it's a 2-card matching game, create an array with one card.
                    int matchScore = [card match:@[otherCard] selectedMode:mode];
                    
                    // If it's a match and both cards become unplayable, up the score.
                    if(matchScore)
                    {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.result = [NSString stringWithFormat:@"Match! %@ %@ [%d pts]!", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.result = [NSString stringWithFormat:@"No Match! %@ %@ [-2 pts]", card.contents, otherCard.contents];
                    }
                    break;
                }
                
                // Look through the other cards looking for another face up, playable one.
                if(mode == 1 && otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [testCards addObject:otherCard];
                }
                
                if(mode == 1 && testCards.count == 2 && otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    Card *card1 = testCards[0];
                    Card *card2 = testCards[1];
                    
                    // If the card is found check to see if it there is a match.
                    // Since it's a 2-card matching game, create an array with one card.
                    int matchScore = [card match:testCards selectedMode:mode];
                    
                    // If it's a match and both cards become unplayable, up the score.
                    if(matchScore)
                    {
                        for(Card *testCard in testCards)
                            testCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.result = [NSString stringWithFormat:@"Match! %@ %@ %@ [%d pts!]", card.contents, card1.contents, card2.contents, matchScore * MATCH_BONUS];
                    }
                    else
                    {
                        for(Card *testCard in testCards)
                            testCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.result = [NSString stringWithFormat:@"No match! %@ %@ %@ [-2 pts!]", card.contents, card1.contents, card2.contents];
                    }
                    break;
                }
                
                self.result = [NSString stringWithFormat:@"Flipped up %@!", card.contents];
            }
            
            self.score -= FLIP_COST;
        }
        
        card.faceUp = !card.faceUp;
    }
}

@end
