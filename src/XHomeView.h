#import "Constants.h"
#import "XCoordinatorDelegate.h"
#import "XIconCellView.h"

@interface XHomeView: UIView<UIGestureRecognizerDelegate>
@property (strong, nonatomic) UICollectionView* appsCollectionView;
-(XHomeView*)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id <XCoordinatorDelegate> coordinatorDelegate;
@end