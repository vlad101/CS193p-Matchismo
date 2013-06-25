//
//  Deck.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "Deck.h"

// Private properties.
@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

// Lazy instantiation - create an array on the fly - getter implementation.
- (NSMutableArray *)cards
{
    if(!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if(atTop)
        // Add card to the top.
        [self.cards insertObject:card atIndex:0];
    else
        // Add card at the end.
        [self.cards addObject:card];
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    // If deck has cards.
    if(self.cards.count)
    {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

@end
