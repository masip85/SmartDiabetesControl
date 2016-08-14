//
//  SDCSecondViewController.h
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCGlucoseView.h"

@interface SDCGlucoseRegisterVC : UIViewController
{
    __weak IBOutlet UIView *viewToGlucoseRect;
//    __strong IBOutlet SDCGlucoseView *glucoseView;
}
@property(strong,nonatomic)IBOutlet UILabel *periodLabel;
@property(strong,nonatomic)SDCGlucoseView *glucoseView;
@property(strong,nonatomic)NSDate *untilDate;
@property(strong,nonatomic)NSDate *sinceDate;
@property(strong,nonatomic)NSString *stringDate;
@property(readwrite)BOOL am,pm;

- (IBAction)oneDayTouched:(id)sender;
- (IBAction)oneWeekTouched:(id)sender;
- (IBAction)oneMonthTouched:(id)sender;
- (IBAction)calendarTouched:(id)sender;
- (IBAction)amTouched:(id)sender;
- (IBAction)pmTouched:(id)sender;
- (IBAction)threeDaysTouched:(id)sender;
- (IBAction)allDayTouched:(id)sender;
@end
