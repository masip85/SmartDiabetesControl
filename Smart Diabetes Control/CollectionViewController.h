//
//  CollectionViewController.h
//  Collection View Example
//
//  Created by Mederi on 21/05/13.
//  Copyright (c) 2013 Mederi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@end
