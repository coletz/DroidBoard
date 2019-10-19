#import "Constants.h"
#import <AppList/AppList.h>
#import <GraphicsServices/GSEvent.h>

#import "XIconCellView.h"

#import "XHomeView.h"
#import "XDrawerView.h"

#import "XAppLaunchDelegate.h"
#import "XCoordinatorDelegate.h"

@interface UIApplication (Undocumented)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended; 
@end

@interface SBHomeScreenViewController: UIViewController<UIGestureRecognizerDelegate, XAppLaunchDelegate, XCoordinatorDelegate>
-(void)updateScreenSize;

-(void)setupHomeDoubleTap;
-(void)onHomeDoubleTap:(UIGestureRecognizer*)sender;
@end