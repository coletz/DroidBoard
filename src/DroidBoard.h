#import "Constants.h"
#import <AppList/AppList.h>
#import <GraphicsServices/GSEvent.h>
#import "XIconCellView.h"

@interface UIApplication (Undocumented)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended; 
@end

@interface SBHomeScreenViewController: UIViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(void)loadApps;
-(void)updateScreenSize;

-(void)setupHomeSwipeUp;
-(void)onHomeSwipeUp:(UIGestureRecognizer*)sender;

-(void)setupDrawerSwipeDown;
-(void)onDrawerSwipeDown:(UIGestureRecognizer*)sender;

-(void)setupHomeDoubleTap;
-(void)onHomeDoubleTap:(UIGestureRecognizer*)sender;

-(void)setupDrawerGrid;
@end