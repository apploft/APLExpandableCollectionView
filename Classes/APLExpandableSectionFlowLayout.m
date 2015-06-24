#import "APLExpandableSectionFlowLayout.h"

@interface APLExpandableSectionFlowLayout ()

@property (nonatomic, strong) NSArray* indexPathsBeforeUpdate;
@property (nonatomic, strong) NSArray* indexPathsAfterUpdate;
@property (nonatomic, strong) NSArray* previousLayoutAttributes;

@end

@implementation APLExpandableSectionFlowLayout

#pragma mark - updates

-(void)prepareLayout {
    [super prepareLayout];
    [self updatePreviousLayoutAttributes];
}

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

- (void)updatePreviousLayoutAttributes {
    NSMutableArray* layoutAttribues = [NSMutableArray array];
    for (NSInteger i = 0, maxI = self.collectionView.numberOfSections; i < maxI; i++) {
        [layoutAttribues addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]]];
    }
    self.previousLayoutAttributes = [layoutAttribues copy];
}

- (UICollectionViewLayoutAttributes*)previousLayoutAttributesForSection:(NSInteger)section {
    if (section < self.previousLayoutAttributes.count) {
        return self.previousLayoutAttributes[section];
    }
    return [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ((itemIndexPath.item != 0) && [self.indexPathsAfterUpdate containsObject:itemIndexPath]) {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.center = [self previousLayoutAttributesForSection:itemIndexPath.section].center;
        attributes.size = CGSizeMake(attributes.size.width, 0.);
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ((itemIndexPath.item != 0) && [self.indexPathsBeforeUpdate containsObject:itemIndexPath]) {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.center = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:itemIndexPath.section]].center;
        attributes.size = CGSizeMake(attributes.size.width, 0.);
    }
    return attributes;
}

@end
