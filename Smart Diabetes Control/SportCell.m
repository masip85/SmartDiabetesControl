//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by ladmin on 29/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SportCell.h"

@implementation SportCell
@synthesize thumbnailView;
@synthesize nameLabel;
@synthesize serialNumberLabel;
@synthesize valueLabel;
@synthesize controller,tableView;

-(IBAction)showImage:(id)sender
{
//    NSIndexPath *indexPath=[[self tableView] indexPathForCell:self];
//    
//    //No puedo importar itemViewController.h,la reciprocidad causa dependencia, y la celda no pdoria ser instanciada por otra clase
//    [[self controller] showImage:sender atIndexPath:indexPath];
    
    //Así que se procede así:
    
    //Get this name of this method, "showImage:"
    NSString *selector=NSStringFromSelector(_cmd);
    //selector is now "showImage:atIndexPath:"
    selector=[selector stringByAppendingString:@"atIndexPath:"];
    
    //Prepare a selector from this string
    SEL newSelectorSport=NSSelectorFromString(selector);
    
    NSIndexPath *indexPath=[[self tableView] indexPathForCell:self];
    if(indexPath){
        if([[self controller] respondsToSelector:newSelectorSport]){
            
            [[self controller] performSelector:newSelectorSport withObject:sender withObject:indexPath];
            
           }
    }
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
