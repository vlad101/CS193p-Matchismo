//
//  Card.h
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
{}

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end