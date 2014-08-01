#import "APLSectionTopToBottomFlowLayout.h"

@interface APLSectionTopToBottomFlowLayout ()

@property (nonatomic) NSInteger sectionCount;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger maxRowCount;
@property (nonatomic) CGFloat remainingSpaceBetweenColumns;
@property (nonatomic) CGSize contentSize;
@property (nonatomic, strong) NSArray* points;

@end

@implementation APLSectionTopToBottomFlowLayout

#pragma mark - layout flow

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    self.sectionCount = [self.collectionView numberOfSections];
    
    CGFloat columnWidth = self.itemSize.width + self.sectionInset.left + self.sectionInset.right;
    self.columnCount = MAX((NSInteger)floor(collectionViewWidth / columnWidth), 1);
    
    self.maxRowCount = (NSInteger)ceil((double)self.sectionCount / (double)self.columnCount);
    
    self.remainingSpaceBetweenColumns = collectionViewWidth - self.columnCount * columnWidth;
    self.remainingSpaceBetweenColumns /= (double)MAX(self.columnCount - 1, 1);
    
    CGSize contentSize = CGSizeMake(collectionViewWidth, 0.);
    NSMutableArray *sections = [NSMutableArray array];
    for (NSInteger section = 0, maxSection = [self.collectionView numberOfSections]; section < maxSection; section++) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger item = 0, maxItem = [self.collectionView numberOfItemsInSection:section]; item < maxItem; item++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGPoint point = [self pointForIndexPath:indexPath];
            [items addObject:[NSValue valueWithCGPoint:point]];
            contentSize.height = MAX(point.y, contentSize.height);
        }
        [sections addObject:items];
    }
    contentSize.height += self.itemSize.height * 0.5 + self.sectionInset.bottom;
    self.contentSize = contentSize;
    self.points = [sections copy];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    rect = CGRectInset(rect, -0.5 * self.itemSize.width, -0.5 * self.itemSize.height);
    NSMutableArray* allAttributesInRect = [NSMutableArray array];
    for (NSInteger section = 0, maxSection = [self.points count]; section < maxSection; section++) {
        for (NSInteger item = 0, maxItem = [self.points[section] count]; item < maxItem; item++) {
            CGPoint point = [self.points[section][item] CGPointValue];
            if (CGRectContainsPoint(rect, point)) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes* cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                [self applySectionTopToBottomLayoutAttributes:cellAttributes];
                [allAttributesInRect addObject:cellAttributes];
            }
        }
    }
    
    return allAttributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applySectionTopToBottomLayoutAttributes:attributes];
    return attributes;
}

#pragma mark - own methods

- (void)applySectionTopToBottomLayoutAttributes:(UICollectionViewLayoutAttributes*)attributes {
    NSInteger item = attributes.indexPath.item;
    NSArray* itemPoints = self.points[attributes.indexPath.section];
    attributes.alpha = 1.0;
    attributes.center = [itemPoints[(item < [itemPoints count]) ? item : 0] CGPointValue];
    attributes.size = self.itemSize;
    attributes.zIndex = -attributes.indexPath.item;
}

- (CGPoint)pointForIndexPath:(NSIndexPath*)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.item;
    
    NSInteger column = (NSInteger)floor((double)section / (double)self.maxRowCount);
    NSInteger firstSectionInColumn = (NSInteger)ceil((double)self.sectionCount / (double)self.columnCount) * column;
    // when there is only one section per column left…
    if ((self.columnCount <= self.sectionCount) && (self.sectionCount - section < self.columnCount - column)) {
        column = self.columnCount - self.sectionCount + section;
        firstSectionInColumn = section;
    }
    for (NSUInteger i = firstSectionInColumn; i < section; i++) {
        row += [self.collectionView numberOfItemsInSection:i];
    }
    NSInteger previousSectionsInColumnCount = section - firstSectionInColumn;
    CGFloat x = (column + 0.5) * (self.itemSize.width + self.sectionInset.left + self.sectionInset.right) + column * self.remainingSpaceBetweenColumns;
    CGFloat y = (row + 0.5) * self.itemSize.height + self.sectionInset.top + previousSectionsInColumnCount * (self.sectionInset.top + self.sectionInset.bottom) + (row - previousSectionsInColumnCount) * self.minimumLineSpacing;
    return CGPointMake(x, y);
}

@end
