//
//  SDCRegisterDatesVC3.h
//  Smart Diabetes Control
//
//  Created by Mederi on 21/06/13.
//
//

#import <UIKit/UIKit.h>

@interface SDCRegisterDatesVC3 : UIViewController{
    
    __weak IBOutlet UIDatePicker *registerDatesStartPicker;
    __weak IBOutlet UIDatePicker *registerDatesEndPicker;
    __weak IBOutlet UILabel *registerDatesLabel;
    
    
}
@property(strong,nonatomic)NSDate *untilDate;
@property(strong,nonatomic)NSDate *sinceDate;


@end
