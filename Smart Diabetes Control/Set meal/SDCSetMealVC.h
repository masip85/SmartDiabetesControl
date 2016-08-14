//
//  SDCSetMealVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import <UIKit/UIKit.h>

@interface SDCSetMealVC : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UIView *mealViewToCollectionPlace;
    __weak IBOutlet UITextField *mealRationTextEdit;
    __weak IBOutlet UITextField *mealNameTextEdit;
    __weak IBOutlet UILabel *mealUnitLabel;
    __weak IBOutlet UIDatePicker *mealDatePicker;
    __weak IBOutlet UISegmentedControl *mealSegments;
    __weak IBOutlet UILabel *mealDateLabel;
    
//    NSMutableArray *mealNames;
//    NSMutableArray *mealAutoComplete;
// UITableView *autoCompleteTableView;
    
    
}
@property (nonatomic, retain) NSMutableArray *mealNames;
@property (nonatomic, retain) NSMutableArray *mealAutoComplete;
@property (nonatomic, retain) UITableView *autoCompleteTableView;
@property (nonatomic) BOOL nextButton;


-(BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)mealGoToList:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;


@end
