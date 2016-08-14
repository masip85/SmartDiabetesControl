//
//  ItemsViewController.h
//  Homepwner
//
//  Created by ladmin on 21/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportDetailVC.h"

@interface SportsVC : UITableViewController<UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
    IBOutlet UIView *headerView;
}
-(UIView *)headerView;
-(IBAction) addNewItem:(id)sender;
//-(IBAction)toggleEditingMode:(id)sender;
@end
