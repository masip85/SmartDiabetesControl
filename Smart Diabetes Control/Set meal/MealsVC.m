//
//  ItemsViewController.m
//  Homepwner
//
//  Created by ladmin on 21/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MealsVC.h"
#import "SDCMealStore.h"
#import "MealCell.h"

#import "SDCImageStore.h"
#import "SDCMealImageVC.h"



@implementation MealsVC

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES]; 
    imagePopover = nil;
}
-(void) showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{

    NSLog(@"Going to show the image for %@",ip);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    { // Get the item for the index path 
        SDCMeal *i = [[[SDCMealStore sharedStore] allMeals] objectAtIndex:[ip row]];
    
        NSString *imageKey = [i imageKey];
        // If there is no image, we don't need to display anything
        UIImage *img = [[SDCImageStore sharedStore] imageForKey:imageKey]; 
            if (!img)
                return;
        // Make a rectangle that the frame of the button relative to // our table view
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        // Create a new ImageViewController and set its image 
        SDCMealImageVC *ivc = [[SDCMealImageVC alloc] init]; 
        [ivc setImage:img];
        // Present a 600x600 popover from the rect 
        imagePopover = [[UIPopoverController alloc]initWithContentViewController:ivc]; 
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)]; 
        [imagePopover presentPopoverFromRect:rect                                                                                           inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny                                                                                           animated:YES];
}
}
-(void)viewDidLoad
{
    [super  viewDidLoad];
    //Load the NIb file
    UINib *nib=[UINib nibWithNibName:@"MealCell" bundle:nil];
    
    //Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"MealCell"];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Clear first Responder
    [[self tableView] reloadData];



}
-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailViewController *detailViewController=[[DetailViewController alloc] init];
    MealDetailVC *detailViewController=[[MealDetailVC alloc] initForNewMeal:NO];
    
    NSArray *meals = [[SDCMealStore sharedStore]allMeals];
    SDCMeal *selectedMeal=[meals objectAtIndex:[indexPath row]];

    //Give a detail view controller a pointer to the item object in row
    [detailViewController setMeal:selectedMeal];
    
    //Push in onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController animated:YES];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
}
-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[SDCMealStore sharedStore] moveMealAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}
-(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the table view is asking to commit a delete command
    if(editingStyle==UITableViewCellEditingStyleDelete){
        SDCMealStore *ps=[SDCMealStore sharedStore];
        NSArray *meals=[ps allMeals];
        SDCMeal *p=[meals objectAtIndex:[indexPath row]];
        [ps removeMeal:p];
        
        //We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(IBAction)addNewItem:(id)sender{
    
    //Create a new BNRItem and add it to the store
    SDCMeal *newMeal=[[SDCMealStore sharedStore] createMeal];
    
    MealDetailVC *detailViewController=[[MealDetailVC alloc] initForNewMeal:YES];
    
    [detailViewController setMeal:newMeal];
    
    //Block that reloads the ItemsViewController's table by 
    // dismissBlock of the DetailViewController Pag. 251
    //Es decir, cuando tengo que salir de detail, como es modal, itemcontroller no tiene
    //oportunidad de recargarse sin esto. Así que detail aguantará este bloque, y lo lanzará cuando 
    // detail es despedido. En ese momento, detailViewController pasará este bloque mediante 
    //dismissViewControllerAnimated:completion. 
    [detailViewController setDismissBlock:^{
     [[self tableView] reloadData];
    }];
    
    [[self navigationController]pushViewController:detailViewController animated:YES];
    
    
//    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:detailViewController];
//    
////    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
//    [navController setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [self setDefinesPresentationContext:YES];
//    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    
//    [self presentViewController:navController animated:YES completion:nil];
}

 
    
-(UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
//    return[self headerView];
    return NULL;
}
-(CGFloat) tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec
{
    //The height of the header view should be determined from the height of the 
    //view in the XIB file
    return[[self headerView] bounds].size.height;
}
-(UIView *) headerView
{
    //If we haven't loaded the headerView yet
    if(!headerView){
        //Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}
- (id)initWithStyle:(UITableViewStyle)style
{
       return [self init];
}

-(id)init
{
    //Call the superclass's designated initializar 
    self=[super initWithStyle:UITableViewStyleGrouped];
    if (self){
        
        UINavigationItem *n=[self navigationItem];
        [n setTitle:@"Mis alimentos"];
        
        //Create a new bar button item that will send
        //addNewItem: to Items View Controller
         
        UIBarButtonItem *bbr=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        NSArray* buttons = [NSArray arrayWithObjects:self.editButtonItem, bbr, nil];
        n.rightBarButtonItems = buttons;
        
        //Set tjis bar button item as the right item in the navigationItem
        
//        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
//        for(int i=0;i<5;i++){
//            [[BNRItemStore sharedStore] createItem];
//        }
    }
    return self;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[SDCMealStore sharedStore] allMeals] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    //Create a instance of UITableViewCell, with default appearance
//    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                 reuseIdentifier:@"UITableViewCell"];

//    //Check for a reusable cell first,use that if it exists
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    
//    //If there is no reusable cell of this type ,create a new one
//    if(!cell)
//    {
//        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//    }
//    
    
    //Set the text on the cell with the description of the item
    //that is at the nth index of items,where n = row this cell
    //will appear on the tableView
    
    SDCMeal *p=[[[SDCMealStore sharedStore] allMeals] objectAtIndex:[indexPath row]];
    
//    [[cell textLabel] setText:[p description]];
    //Get the new or recycled cell
    MealCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MealCell"];
    
    // Ojo queremos que HomepwnerItemCell apunte a ItemsViewController, sin perder de vista que HomepwnerItemCell apunta a la tabla a la que pertenece
    [cell setController:self];
    [cell setTableView:tableView];
    
    //Configure the cell with the BNRItem
    [[cell nameLabel] setText:[p mealName]];
    NSString *s=[NSString stringWithFormat:@"%d raciones de CHO/%d %@",[[p rationValue]intValue],[[p unitValue]intValue],[p unitKind]];
    [[cell valueLabel]setText:s];
     
    
    
    [[cell thumbnailView]setImage:[p thumbnail]];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
