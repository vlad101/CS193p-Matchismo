//
//  PlayingCard.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "PlayingCard.h"

// A PlayingCard has a contents of "??" until someone sets its rank and suit.
@implementation PlayingCard

// Use @"synthesize" if both setter and getter are implemented.
@synthesize suit = _suit;

// PlayingCards should match if the suit and/or rank is the same
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Match a single other card.
    if(otherCards.count == 1)
    {
        // Get the card in the array.
        PlayingCard *otherCard = [otherCards lastObject];
        
        // Give 4 times as many points for matching the rank than matching the suit.
        if([otherCard.suit isEqualToString:self.suit])
            score = 1;
        else
            if(otherCard.rank == self.rank)
                score = 4;
    }
    else if(otherCards.count == 2)
    {
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        
        if ([firstCard.suit isEqualToString:self.suit] && [secondCard.suit isEqualToString:self.suit])
            score = 4;
        else if ((firstCard.rank == self.rank) && (secondCard.rank == self.rank))
            score = 16;
    }
    
    // if zero - no match, one - match.
    return score;
}

// Getter implementation of the card contents - combine suit and rank.
- (NSString *)contents
{
    // A playing card with a rank of zero will show up as "?".
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

// Static methods for rank and value.
+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if(!validSuits)
        validSuits = @[@"♥", @"♦", @"♠", @"♣"];
    return validSuits;
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if(!rankStrings)
        rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return rankStrings;
}

// Make sure that the suit and rank are valid.
- (void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (void)setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank])
        _rank = rank;
}

// A playing card with a suit of zero will show up as "?".
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

@end
