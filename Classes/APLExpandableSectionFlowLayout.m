#import "APLExpandableSectionFlowLayout.h"

@interface APLExpandableSectionFlowLayout ()

@property (nonatomic, strong) NSArray* indexPathsBeforeUpdate;
@property (nonatomic, strong) NSArray* indexPathsAfterUpdate;

@end

@implementation APLExpandableSectionFlowLayout

#pragma mark - updates

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray* indexPathsBeforeUpdate = [NSMutableArray array];
    NSMutableArray* indexPathsAfterUpdate = [NSMutableArray array];
    for (UICollectionViewUpdateItem* updateItem in updateItems) {
        if (updateItem.indexPathBeforeUpdate) {
            [indexPathsBeforeUpdate addObject:updateItem.indexPathBeforeUpdate];
        }
        if (updateItem.indexPathAfterUpdate) {
            [indexPathsAfterUpdate addObject:updateItem.indexPathAfterUpdate];
        }
    }
    self.indexPathsBeforeUpdate = [indexPathsBeforeUpdate copy];
    self.indexPathsAfterUpdate = [indexPathsAfterUpdate copy];
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    
    self.indexPathsBeforeUpdate = nil;
    self.indexPathsAfterUpdate = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ((itemIndexPath.item != 0) && [self.indexPathsAfterUpdate containsObject:itemIndexPath]) {
        attributes = [self updateInitialLayoutAttributesForItemAtIndexPath:itemIndexPath];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ((itemIndexPath.item != 0) && [self.indexPathsBeforeUpdate containsObject:itemIndexPath]) {
        attributes = [self updateInitialLayoutAttributesForItemAtIndexPath:itemIndexPath];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes*)updateInitialLayoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    attributes.center = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]].center;
    attributes.size = CGSizeMake(attributes.size.width, 0.);
    return attributes;
}

@end
