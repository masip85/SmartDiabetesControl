//
//  SDCSetsportVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import <UIKit/UIKit.h>

@interface SDCSetSportVC : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UIView *sportViewToCollectionPlace;
    __weak IBOutlet UITextField *sportNameTextEdit;
    __weak IBOutlet UILabel *sportNameLabel;
    
    __weak IBOutlet UIButton *sportFinishDateButton;
    __weak IBOutlet UIScrollView *sportScrollView;
    __weak IBOutlet UILabel *sportIntensityLabel;
    __weak IBOutlet UISlider *sportIntensitySlider;
    __weak IBOutlet UIButton *sportStartDateButton;
//    NSMutableArray *sportNames;
//    NSMutableArray *sportAutoComplete;
// UITableView *autoCompleteTableView;
    
    
}
@property (nonatomic, retain) NSMutableArray *sportNames;
@property (nonatomic, retain) NSMutableArray *sportAutoComplete;
@property (nonatomic, retain) UITableView *autoCompleteTableView;
@property (nonatomic,strong) NSMutableArray *track;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;

- (IBAction)sportGoToList:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)goToDate1:(id)sender;
- (IBAction)gotoDate2:(id)sender;
- (IBAction)goToDate3:(id)sender;
- (IBAction)goToDate4:(id)sender;

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
-(NSInteger *)getSportIndex:(NSString *) substring;
- (IBAction)intensityValueChanged:(id)sender;

@end
