#line 1 "Tweak.x"
#import <AppList/AppList.h>

@interface SBHomeScreenViewController: UIViewController<UIGestureRecognizerDelegate>
-(void)log;
-(void)updateScreenSize;
-(void)setupSwipe;
-(void)onSwipeUp:(UIGestureRecognizer*)sender;
-(void)setupApp:(id)app atPosition:(int)index;
-(void)loadApps;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBHomeScreenViewController; 
static void (*_logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBHomeScreenViewController$loadApps(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$updateScreenSize(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$setupSwipe(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$onSwipeUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UIGestureRecognizer*); static void _logos_method$_ungrouped$SBHomeScreenViewController$setupApp$atPosition$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, id, int); static void _logos_method$_ungrouped$SBHomeScreenViewController$log(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); 

#line 12 "Tweak.x"


static CGSize screen;


UIView* xRootView;

NSDictionary *applications;
NSArray *bundleIds;

static void _logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$(self, _cmd, arg1);
    [self loadApps];
    [self updateScreenSize];
    xRootView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, screen.width, screen.height - 20)];
    xRootView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:xRootView];
    [self setupSwipe];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$loadApps(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSArray *outIds;
	NSPredicate *filter = [NSPredicate predicateWithFormat:@"isSystemApplication = FALSE"];
	applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:filter onlyVisible:YES titleSortedIdentifiers:&outIds];
	bundleIds = outIds;
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$updateScreenSize(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    CGRect scrBounds = [[UIScreen mainScreen] bounds];
    screen = scrBounds.size;
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$setupSwipe(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp:)];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    upRecognizer.numberOfTouchesRequired = 1;
    upRecognizer.delegate = self;
    [xRootView addGestureRecognizer:upRecognizer];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$onSwipeUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIGestureRecognizer* sender) {
	int index = 0;
	for(NSString* bundleId in bundleIds) { 
		[self setupApp:applications[bundleId] atPosition:index];
		index++;
	}
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$setupApp$atPosition$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id app, int index) {
	int yPos = 10 + (index+1) * 40;

	NSString *appName = app;

	UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 250, yPos)];
	[label setText:appName];
	[label setTextColor:[UIColor blackColor]];
	[label setNumberOfLines:1];
	[label.layer setBorderColor:[UIColor blackColor].CGColor];
	[xRootView addSubview:label];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$log(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UIAlertController* alert = [UIAlertController
        alertControllerWithTitle:@"Log"
        message:@"NSLog_v2"
        preferredStyle:UIAlertControllerStyleAlert
    ];
    UIAlertAction* defaultAction = [UIAlertAction
        actionWithTitle:@"OK"
        style:UIAlertActionStyleDefault
        handler:nil
    ];
    [alert addAction:defaultAction];
    [[[UIApplication sharedApplication] keyWindow].rootViewController
        presentViewController:alert
        animated:YES
        completion:nil
    ];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBHomeScreenViewController = objc_getClass("SBHomeScreenViewController"); MSHookMessageEx(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(loadApps), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$loadApps, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(updateScreenSize), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$updateScreenSize, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(setupSwipe), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$setupSwipe, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(onSwipeUp:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$onSwipeUp$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(setupApp:atPosition:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$setupApp$atPosition$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(log), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$log, _typeEncoding); }} }
#line 99 "Tweak.x"
