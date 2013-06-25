//
//  Deck.h
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
