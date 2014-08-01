//
//  APLViewController.m
//  APLExpandableCollectionViewDemo
//
//  Created by Michael Kamphausen on 01.08.14.
//  Copyright (c) 2014 apploft GmbH. All rights reserved.
//

#import "APLViewController.h"
#import "APLCollectionViewCell.h"

@interface APLViewController ()

@end

@implementation APLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isiPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    CGFloat sectionInsetX = isiPad ? 14. : 8.;
    CGFloat sectionInsetTop = 8.;
    CGFloat collectionViewInsetX = isiPad ? 14. : 0.;
    CGFloat collectionViewInsetY = isiPad ? 8. : 0.;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        collectionViewInsetY += 20.;
    }
    
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(304., 44.);
    layout.minimumLineSpacing = 4.;
    layout.sectionInset = UIEdgeInsetsMake(sectionInsetTop, sectionInsetX, 0., sectionInsetX);
    
    self.collectionView.contentInset = UIEdgeInsetsMake(collectionViewInsetY, collectionViewInsetX, collectionViewInsetY + sectionInsetTop, collectionViewInsetX);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    APLCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"APLCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.label.text = [NSString stringWithFormat:@"Section %i", indexPath.section + 1];
        cell.backgroundColor = [UIColor colorWithRed:58./255. green:165./255. blue:192./255. alpha:1.];
        cell.indentView.hidden = YES;
    } else {
        cell.label.text = [NSString stringWithFormat:@"Item %i", indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:58./255. green:165./255. blue:192./255. alpha:.5];
        cell.indentView.hidden = NO;
    }
    
    return cell;
}

@end
