#import "Constants.h"
#import "XAppLaunchDelegate.h"
#import "XCoordinatorDelegate.h"
#import "XIconCellView.h"

@interface XHomeView: UIView<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UICollectionView* appsCollectionView;
-(XHomeView*)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id <XAppLaunchDelegate> appLaunchDelegate;
@property (nonatomic, weak) id <XCoordinatorDelegate> coordinatorDelegate;
@end