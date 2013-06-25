//
//  Card.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize contents, faceUp, unplayable;

- (int)match:(NSArray *)otherCards selectedMode:(int)mode
{
    int score = 0;

    // Compare the cards.
    for(Card *card in otherCards)
    {
        if([card.contents isEqualToString:self.contents])
            score = 1;
    }
    
    // If zero - no match, one - match.
    return score;
}

@end