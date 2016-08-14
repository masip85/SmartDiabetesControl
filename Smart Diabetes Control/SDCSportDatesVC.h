//
//  SDCSportDetailDatesVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 29/05/13.
//
//

#import <UIKit/UIKit.h>
@class SDCSportMeasure;

@interface SDCSportDatesVC : UIViewController{
    
    __weak IBOutlet UIDatePicker *sportDatesStartPicker;
    __weak IBOutlet UIDatePicker *sportDatesIntervalPicker;
    __weak IBOutlet UILabel *sportDatesStartLabel;
    __weak IBOutlet UILabel *sportDatesIntervalLabel;
    
}

@property (nonatomic, strong) SDCSportMeasure *sportMeasure;

@end
