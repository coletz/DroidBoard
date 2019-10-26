#import "Constants.h"
#import "XCoordinatorDelegate.h"
#import "XIconCellView.h"

@interface XHomeView: UIView<UIGestureRecognizerDelegate>
@property (nonatomic, weak) id <XCoordinatorDelegate> coordinatorDelegate;

@property (strong, nonatomic) UICollectionView* appsCollectionView;
-(XHomeView*)initWithFrame:(CGRect)frame;
-(void)loadApps;
@end