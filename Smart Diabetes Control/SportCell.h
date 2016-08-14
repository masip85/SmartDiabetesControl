//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by ladmin on 29/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
- (IBAction)showImage:(id)sender;

@property(weak,nonatomic) id controller;
@property(weak,nonatomic) UITableView *tableView;

@end
