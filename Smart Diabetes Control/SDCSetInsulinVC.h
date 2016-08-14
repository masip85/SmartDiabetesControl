//
//  SDCSetInsulineVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import <UIKit/UIKit.h>

@interface SDCSetInsulinVC : UIViewController<UITextFieldDelegate>
{
        __weak IBOutlet UILabel *insulinBasalKindLabel;
        __weak IBOutlet UILabel *insulinBolusKindLabel;
        __weak IBOutlet UITextField *insulinBasalEdit;
        __weak IBOutlet UITextField *insulinBolusEdit;
        __weak IBOutlet UILabel *insulinDateLabel;
        __weak IBOutlet UIDatePicker *insulinDatePicker;
    }
@property(nonatomic) BOOL nextButton;

    -(BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (IBAction)backgroundTapped:(id)sender;

@end
