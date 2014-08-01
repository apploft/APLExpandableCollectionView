#import "APLExpandableCollectionView.h"

@interface APLExpandableCollectionView () <UIGestureRecognizerDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray* expandedSections;
@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;
@property (nonatomic, weak) id<UICollectionViewDataSource> myDataSource;

@end

@implementation APLExpandableCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (id<UICollectionViewDataSource>)dataSource {
    return [super dataSource];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    _myDataSource = dataSource;
    [super setDataSource:self];
}

- (NSMutableArray *)expandedSections {
    if (!_expandedSections) {
        _expandedSections = [NSMutableArray array];
        NSInteger maxI = [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)] ? [self.dataSource numberOfSectionsInCollectionView:self] : 0;
        for (NSInteger i = 0; i < maxI; i++) {
            [_expandedSections addObject:@NO];
        }
    }
    return _expandedSections;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

- (BOOL)isExpandedSection:(NSInteger)section {
    return [self.expandedSections[section] boolValue];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self];
        NSIndexPath* tappedCellPath = [self indexPathForItemAtPoint:point];
        
        if (tappedCellPath && (tappedCellPath.item == 0)) {
            NSInteger tappedSection = tappedCellPath.section;
            BOOL willOpen = ![self.expandedSections[tappedSection] boolValue];
            NSMutableArray* indexPaths = [NSMutableArray array];
            for (NSInteger i = 1, maxI = [self.myDataSource collectionView:self numberOfItemsInSection:tappedSection]; i < maxI; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:tappedSection]];
            }
            [self performBatchUpdates:^{
                if (willOpen) {
                    [self insertItemsAtIndexPaths:indexPaths];
                } else {
                    [self deleteItemsAtIndexPaths:indexPaths];
                }
                self.expandedSections[tappedSection] = @(willOpen);
            } completion:nil];
            
            if (willOpen) {
                NSIndexPath* lastItemIndexPath = [NSIndexPath indexPathForItem:[self numberOfItemsInSection:tappedCellPath.section] - 1 inSection:tappedCellPath.section];
                UICollectionViewCell* firstItem = [self cellForItemAtIndexPath:tappedCellPath];
                UICollectionViewCell* lastItem = [self cellForItemAtIndexPath:lastItemIndexPath];
                CGFloat firstItemTop = firstItem.frame.origin.y;
                CGFloat lastItemBottom = lastItem.frame.origin.y + lastItem.frame.size.height;
                CGFloat height = self.bounds.size.height;
                
                if (lastItemBottom - self.contentOffset.y > height) {
                    if (lastItemBottom - firstItemTop > height) {
                        // using setContentOffset:animated: here because scrollToItemAtIndexPath:atScrollPosition:animated: is broken on iOS 6
                        [self setContentOffset:CGPointMake(0., firstItemTop) animated:YES];
                    } else {
                        [self setContentOffset:CGPointMake(0., lastItemBottom - height) animated:YES];
                    }
                }
                if ([self.delegate respondsToSelector:@selector(collectionView:didExpandItemAtIndexPath:)]) {
                    [self.delegate collectionView:self didExpandItemAtIndexPath:tappedCellPath];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(collectionView:didCollapseItemAtIndexPath:)]) {
                    [self.delegate collectionView:self didCollapseItemAtIndexPath:tappedCellPath];
                }
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            CGPoint point = [touch locationInView:self];
            NSIndexPath* tappedCellPath = [self indexPathForItemAtPoint:point];
            return tappedCellPath && (tappedCellPath.item == 0);
        }
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.myDataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)] ? [self.myDataSource numberOfSectionsInCollectionView:self] : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = [self.myDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)] ? [self.myDataSource collectionView:self numberOfItemsInSection:section] : 0;
    return [self isExpandedSection:section] ? numberOfItemsInSection : MIN(1, numberOfItemsInSection);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.myDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)] ? [self.myDataSource collectionView:self cellForItemAtIndexPath:indexPath] : [UICollectionViewCell new];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.myDataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)] ? [self.myDataSource collectionView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath] : nil;
}

@end
