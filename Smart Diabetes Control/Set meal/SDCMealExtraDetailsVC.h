//
//  SDCMealExtraDetailsVC.h
//  Smart Diabetes Control
//
//  Created by Mederi on 27/05/13.
//
//

#import <UIKit/UIKit.h>
#import "SDCMeal.h"

@interface SDCMealExtraDetailsVC : UIViewController

@property (nonatomic,strong) SDCMeal *meal;

-(void)setMeal:(SDCMeal *)i;


@end
