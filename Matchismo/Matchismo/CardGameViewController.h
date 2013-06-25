//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Vladimir Efros on 6/20/13.
//  Copyright (c) 2013 Vladimir Efros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGameViewController : UIViewController
<UIAlertViewDelegate>
{
    NSMutableArray *historyFlip;
}

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)dealCards:(id)sender;
- (IBAction)changeMode:(id)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
