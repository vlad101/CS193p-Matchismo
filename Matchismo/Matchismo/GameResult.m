//
//  GameResult.m
//  Matchismo
//
//  Created by Vladimir Efros on 6/26/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResults_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

+ (NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for(id pList in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues])
    {
        GameResult *result = [[GameResult alloc] initFromPropertyList:pList];
        [allGameResults addObject:result];
    }
    
    return allGameResults;
}

// Convenience initializer.
-(id)initFromPropertyList:(id)pList
{
    self = [self init];
    
    if(self)
    {
        if([pList isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDictionary = (NSDictionary *)pList;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if(!_start || !_end)
                self = nil;
        }
    }
    
    return self;
}

- (id) init
{
    self = [super init];
    
    // Designated initializer.
    if(self)
    {
        // Return the time - now.
        _start = [NSDate date];
        
        // Always set the end.
        _end = _start;
    }
    
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

-(void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    // Turn the data into the property list.
    [self synchronize];
}

-(void)synchronize
{
    // Key - the start of the game.
    // Value - another dictionary to re-create the game results.
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    if(!mutableGameResultsFromUserDefaults)
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{ START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score) };
}

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult
{
    if(self.score > otherResult.score)
        return NSOrderedAscending;
    else if(self.score < otherResult.score)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult
{
    if(self.duration > otherResult.score)
        return NSOrderedAscending;
    else if(self.duration < otherResult.score)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

@end
