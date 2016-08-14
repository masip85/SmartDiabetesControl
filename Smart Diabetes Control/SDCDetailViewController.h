//
//  SDCDetailViewController.h
//  Smart Diabetes Control
//
//  Created by ladmin on 01/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCEllipse.h"
#import "SDCPointView.h"
@class SDCGlucoseView;
@class SDCGlucoseScroll;

@interface SDCDetailViewController : UIViewController<UIScrollViewDelegate>{

    __weak IBOutlet UIView *detailCloudViewToScrollFrame;
    __weak IBOutlet UILabel *detailTitleLabel;
    __weak IBOutlet UIView *detailPercentRectView;
    __weak IBOutlet UILabel *detailMeasureLabel;
    __weak IBOutlet UILabel *detailMeasureValueLabel;
    __weak IBOutlet UILabel *detailMaxLabel;
    __weak IBOutlet UILabel *detailMaxValueLabel;
    __weak IBOutlet UILabel *detailVarLabel;
    __weak IBOutlet UILabel *detailVarValueLabel;
    __weak IBOutlet UILabel *detailMinLabel;
    __weak IBOutlet UILabel *detailMinValueLabel;
    __weak IBOutlet UILabel *detailMeanLabel;
    __weak IBOutlet UILabel *detailMeanValueLabel;
    
   

}

// Valores estadisticos de lo que estoy representando
@property(nonatomic)float varValue;
@property(nonatomic)float minValue;
@property(nonatomic)float maxValue;
@property(nonatomic)float meanValue;
@property(nonatomic)float hyperPercent;
@property(nonatomic)float normoPercent;
@property(nonatomic)float hypoPercent;

@property (nonatomic,strong) SDCEllipse *ellipse; // Me dirá con que elipse está trabajando DetailViewController
@property(nonatomic,strong)SDCPointView *point;
@property(nonatomic)SDCGlucoseView *glucoseView;
@property (weak, nonatomic) IBOutlet UILabel *detailPeriodLabel;
@property(strong,nonatomic)NSDate *untilDate;
@property(strong,nonatomic)NSDate *sinceDate;
@property(strong,nonatomic)NSString *stringDate;
@property(nonatomic)BOOL am,pm;
@property(strong,nonatomic) SDCGlucoseScroll *glucoseScroll;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

- (IBAction)oneDayTouched:(id)sender;
- (IBAction)oneWeekTouched:(id)sender;
- (IBAction)oneMonthTouched:(id)sender;
- (IBAction)calendarTouched:(id)sender;
- (IBAction)threeDaysTouched:(id)sender;
-(void)setStatisticsFromDrawedPoints;

@end
