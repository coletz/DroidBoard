#import "Constants.h"
#import <AppList/AppList.h>
#import <GraphicsServices/GSEvent.h>

#import "XIconCellView.h"

#import "XHomeView.h"
#import "XDrawerView.h"

#import "XCoordinatorDelegate.h"

@interface SBHomeScreenViewController: UIViewController<UIGestureRecognizerDelegate, XCoordinatorDelegate>
-(void)updateScreenSize;
-(void)setupBackground;

-(void)setupHomeDoubleTap;
-(void)onHomeDoubleTap:(UIGestureRecognizer*)sender;

-(void)onUnassignedKeyPressed:(UIKeyCommand*)sender;
-(void)onAssignedKeyPressed:(UIKeyCommand*)sender;
@end
