//
//  SDCPointView.m
//  Smart Diabetes Control
//
//  Created by ladmin on 31/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCPointView.h"
#import "SDCAppDelegate.h"
#import "SDCDetailViewController.h"


@implementation SDCPointView
@synthesize clusterIndex;
@synthesize angle;
@synthesize glucoseMeasure;
@synthesize plotInDetailVC;
@synthesize center;
@synthesize touchPoint;

- (id)initWithFrame:(CGRect)frame
{
    center=CGPointMake(frame.origin.x, frame.origin.y);
    CGRect newFrame=CGRectMake(frame.origin.x-(frame.size.width/2), frame.origin.y-(frame.size.height/2), frame.size.width, frame.size.height);
    self = [super initWithFrame:newFrame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];
        [self setTouchPoint:NO];

        
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self touchPoint]==TRUE) {
        
        if ([self plotInDetailVC]==NO ) { // Si estoy en registro & NO dentro de una elipse
            [self setBackgroundColor:[UIColor whiteColor]];
            SDCDetailViewController *dvc=[[SDCDetailViewController alloc]init];
            [dvc setEllipse:NULL]; // no quiero ver detalles elipse
            [dvc setPoint:self];
            SDCAppDelegate *del = (SDCAppDelegate *)[UIApplication sharedApplication].delegate;
            
            [dvc setUntilDate:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]untilDate]];
            [dvc setSinceDate:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]sinceDate]];
            [dvc setStringDate:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]stringDate]];
            [dvc setAm:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]am]];
            [dvc setPm:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]pm]];
            [[del glucoseRegisterNC]pushViewController:dvc animated:YES];
        }else{
            // Cuando un punto sea tocado dentro de la vista detalle, le lanzo al controlador de vista un evento, con la información de la medida para que él la represente
            [self setBackgroundColor:[UIColor darkGrayColor]]; // Color transición,para notar que se toca
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:[self glucoseMeasure] forKey:@"glucoseMeasure"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chageDetailMeasureLabel" object:nil userInfo:userInfo];
        }

    }else{
    // si no es tocable, hay que pasar el evento tocar a la elipse
        if ([self plotInDetailVC]==NO)
        {
                for (int i=0; i<[[[self superview]subviews]count]; i++) {
                    if ([[[[self superview]subviews]objectAtIndex:i]isKindOfClass:[SDCEllipse class]]) {// Busco en todas las elipses de glucose View
                        if ([[[[self superview]subviews]objectAtIndex:i]clusterIndex]==[self clusterIndex]) { // Si se trata de la misma elipse que yo
                            [[[[self superview]subviews]objectAtIndex:i]touchesBegan:touches withEvent:event];
                        }
                    }

                }
        }
        
    }
    
}


-(void)setTouchableAction{

    [self setTouchPoint:YES];
}

-(void)setTouchableActionToEllipse{
    [self setTouchPoint:NO];
    
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event{
    //Dejo de tocar,así que vuelvo al color que estaba
    switch ([self clusterIndex]) {
        case 0:
            [self setBackgroundColor:[UIColor blackColor]];
            break;
        case 1:
            [self setBackgroundColor:[UIColor brownColor]];
            break;
        case 2:
            [self setBackgroundColor:[UIColor cyanColor]];
            break;
        case 3:
            [self setBackgroundColor:[UIColor blueColor]];
            break;
        case 4:
            [self setBackgroundColor:[UIColor magentaColor]];
            break;
        case 5:
            [self setBackgroundColor:[UIColor greenColor]];
            break;
            
        default:
            break;
    }
    
}



    
    
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
