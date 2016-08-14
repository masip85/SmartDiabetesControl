//
//  SDCSetGlucoseVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import <UIKit/UIKit.h>

@interface SDCSetGlucoseVC : UIViewController <UITextFieldDelegate>{
    
    __weak IBOutlet UILabel *glucoseGlucoseLabel;
    __weak IBOutlet UILabel *glucoseDateLabel;
    __weak IBOutlet UILabel *glucoseUnitsLabel;
    __weak IBOutlet UITextField *glucoseMeasureEdit;
    __weak IBOutlet UIDatePicker *glucoseDatePicker;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)backgroundTapped:(id)sender;
@property BOOL nextButton;
@end
