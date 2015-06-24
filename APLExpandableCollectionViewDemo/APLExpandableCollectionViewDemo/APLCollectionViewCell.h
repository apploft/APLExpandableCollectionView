//
//  APLCollectionViewCell.h
//  APLExpandableCollectionViewDemo
//
//  Created by Michael Kamphausen on 01.08.14.
//  Copyright (c) 2014 apploft GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APLCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *indentView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
