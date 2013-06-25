//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Vladimir Efros on 6/21/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Match among a certain number of cards given a certain deck to choose from.
- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

// Flip a card.
- (void)flipCardAtIndex:(NSUInteger)index;

// Get a card.
- (Card *)cardAtIndex:(NSUInteger)index;

// Keep the score, no setter, only getter.
@property (nonatomic, readonly) int score;
@property (copy, nonatomic) NSString *result;

@end
