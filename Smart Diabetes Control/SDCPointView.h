//
//  SDCPointView.h
//  Smart Diabetes Control
//
//  Created by ladmin on 31/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "SDCGlucoseMeasure.h"

@interface SDCPointView : UIView
{
    
}
@property(nonatomic)BOOL plotInDetailVC;
@property (nonatomic)int clusterIndex;
@property(nonatomic)float angle; // ángulo no reloj,sino trigonometrico
@property(nonatomic,strong)SDCGlucoseMeasure *glucoseMeasure;
@property(nonatomic)BOOL touchPoint;
@property(nonatomic)CGPoint center;
-(void)setTouchableAction;
-(void)setTouchableActionToEllipse;
@end
