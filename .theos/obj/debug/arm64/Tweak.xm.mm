#line 1 "Tweak.xm"
#import <AppList/AppList.h>
#import <GraphicsServices/GSEvent.h>


@interface UIApplication (Undocumented)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended; 
@end

@interface XIconCellView: UICollectionViewCell
@property (strong, nonatomic) UIImageView* appIcon;
@property (strong, nonatomic) UILabel* appName;
-(XIconCellView*)initWithFrame:(CGRect)frame;
@end


static CGSize screen;
static CGSize icon = CGSizeMake(ALApplicationIconSizeLarge, ALApplicationIconSizeLarge);
static int statusBarHeight = 20;


@implementation XIconCellView
-(XIconCellView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon.width, icon.height)];
    _appIcon.contentMode = UIViewContentModeScaleAspectFit;    

    int elevation = 2;
    _appIcon.layer.masksToBounds = NO;
    _appIcon.layer.shadowColor = [[UIColor blackColor] CGColor];
    _appIcon.layer.shadowOffset = CGSizeMake(0, elevation);
    _appIcon.layer.shadowOpacity = 0.24;
    _appIcon.layer.shadowRadius = elevation;

    _appIcon.layer.borderWidth = 1.0;
    _appIcon.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.35] CGColor];
    _appIcon.layer.cornerRadius = 12;
    _appIcon.layer.shouldRasterize = YES; 
    _appIcon.layer.rasterizationScale = [UIScreen mainScreen].scale; 
    [self addSubview:_appIcon];
    
    [_appIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_appIcon.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0].active = YES;
    [_appIcon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    

    
    _appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _appName.textColor = [UIColor blackColor];
    _appName.textAlignment = NSTextAlignmentCenter;
    _appName.font = [UIFont systemFontOfSize:12];
    [self addSubview:_appName];
    
    [_appName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_appName.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0].active = YES;
    [_appName.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0].active = YES;
    [_appName.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active = YES;

    return self;
}

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
static void (*_logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBHomeScreenViewController$loadApps(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$updateScreenSize(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$setupDrawerGrid(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$setupHomeSwipeUp(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$onHomeSwipeUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UIGestureRecognizer*); static void _logos_method$_ungrouped$SBHomeScreenViewController$setupDrawerSwipeDown(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$onDrawerSwipeDown$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UIGestureRecognizer*); static void _logos_method$_ungrouped$SBHomeScreenViewController$setupHomeDoubleTap(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBHomeScreenViewController$onHomeDoubleTap$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UIGestureRecognizer*); static NSInteger _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$numberOfItemsInSection$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UICollectionView *, NSInteger); static UICollectionViewCell* _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$cellForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UICollectionView *, NSIndexPath*); static CGSize _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$layout$sizeForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UICollectionView*, UICollectionViewLayout*, NSIndexPath*); static void _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$didSelectItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UICollectionView*, NSIndexPath*); static BOOL _logos_method$_ungrouped$SBHomeScreenViewController$gestureRecognizer$shouldRecognizeSimultaneouslyWithGestureRecognizer$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, UIGestureRecognizer*, UIGestureRecognizer*); 

#line 80 "Tweak.xm"



UIView* xRootView;
UIView* xHomeView;
UIView* xDrawerView;
UICollectionView* xCollectionView;

NSDictionary *applications;
NSArray *bundleIds;



static void _logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$(self, _cmd, arg1);
    [self loadApps];
    [self updateScreenSize];
    
    xRootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
    [self.view addSubview:xRootView];

    xHomeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height - statusBarHeight)];
    [xRootView addSubview:xHomeView];

    xDrawerView = [[UIView alloc]initWithFrame:CGRectMake(0, screen.height, screen.width, screen.height - statusBarHeight)];
    xDrawerView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    xDrawerView.alpha = 0;
    [xRootView addSubview:xDrawerView];

    [self setupDrawerGrid];

    [self setupHomeSwipeUp];
    [self setupDrawerSwipeDown];
    [self setupHomeDoubleTap];
}




static void _logos_method$_ungrouped$SBHomeScreenViewController$loadApps(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSArray *outIds;
	
	
	applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:nil onlyVisible:YES titleSortedIdentifiers:&outIds];
	bundleIds = outIds;
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$updateScreenSize(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    CGRect scrBounds = [[UIScreen mainScreen] bounds];
    screen = scrBounds.size;
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$setupDrawerGrid(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    xCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, xDrawerView.frame.size.width, xDrawerView.frame.size.height) collectionViewLayout:layout];
    [xCollectionView setContentInset:UIEdgeInsetsMake(32, 16, 0, 16)];
    [xCollectionView setDataSource:self];
    [xCollectionView setDelegate:self];

    [xCollectionView registerClass:[XIconCellView class] forCellWithReuseIdentifier:@"cellIdentifier"];
    xCollectionView.backgroundColor = nil;

    [xDrawerView addSubview:xCollectionView];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$setupHomeSwipeUp(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onHomeSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [xHomeView addGestureRecognizer:recognizer];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$onHomeSwipeUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIGestureRecognizer* sender) {
    if([sender locationInView:self.view].y > screen.height - 90) {
        return;
    }

    [UIView animateWithDuration:0.3
        delay:0
        options: UIViewAnimationCurveEaseIn
        animations:^ {
             CGRect frame = xDrawerView.frame;
             frame.origin.y = statusBarHeight;
             xDrawerView.frame = frame;
             xDrawerView.alpha = 1;
         }
         completion:nil];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$setupDrawerSwipeDown(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onDrawerSwipeDown:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [xDrawerView addGestureRecognizer:recognizer];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$onDrawerSwipeDown$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIGestureRecognizer* sender) {
    if (xCollectionView.contentOffset.y > 10) {
        return;
    }
    [UIView animateWithDuration:0.3
        delay:0
        options: UIViewAnimationCurveEaseOut
        animations:^ {
            CGRect frame = xDrawerView.frame;
            frame.origin.y = screen.height;
            xDrawerView.frame = frame;
            xDrawerView.alpha = 0;
         }
         completion:nil];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$setupHomeDoubleTap(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHomeDoubleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.delegate = self;
    [xHomeView addGestureRecognizer:recognizer];
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$onHomeDoubleTap$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIGestureRecognizer* sender) {
    struct GSEventRecord record;
    memset(&record, 0, sizeof(record));
    record.type = kGSEventLockButtonDown;
    record.timestamp = GSCurrentEventTimestamp();
    GSSendSystemEvent(&record);
    record.type = kGSEventLockButtonUp;
    GSSendSystemEvent(&record);
}



static NSInteger _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$numberOfItemsInSection$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView * collectionView, NSInteger section) {
    return applications.count;
}


static UICollectionViewCell* _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$cellForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView * collectionView, NSIndexPath* indexPath) {
    XIconCellView* cell = (XIconCellView*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [[cell appIcon] setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:bundleIds[indexPath.row]]];
    [[cell appName] setText:applications[bundleIds[indexPath.row]]];
    return cell;
}


static CGSize _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$layout$sizeForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView* collectionView, UICollectionViewLayout* collectionViewLayout, NSIndexPath* indexPath) {
    return CGSizeMake(icon.width, icon.height + 20);
}


static void _logos_method$_ungrouped$SBHomeScreenViewController$collectionView$didSelectItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UICollectionView* collectionView, NSIndexPath* indexPath)  {
    [self onDrawerSwipeDown:nil];

    [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIds[indexPath.row] suspended:NO];
}


static BOOL _logos_method$_ungrouped$SBHomeScreenViewController$gestureRecognizer$shouldRecognizeSimultaneouslyWithGestureRecognizer$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIGestureRecognizer* gestureRecognizer, UIGestureRecognizer* otherGestureRecognizer) {
    return YES;
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBHomeScreenViewController = objc_getClass("SBHomeScreenViewController"); MSHookMessageEx(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(loadApps), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$loadApps, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(updateScreenSize), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$updateScreenSize, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(setupDrawerGrid), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$setupDrawerGrid, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(setupHomeSwipeUp), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$setupHomeSwipeUp, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(onHomeSwipeUp:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$onHomeSwipeUp$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(setupDrawerSwipeDown), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$setupDrawerSwipeDown, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(onDrawerSwipeDown:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$onDrawerSwipeDown$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(setupHomeDoubleTap), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$setupHomeDoubleTap, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(onHomeDoubleTap:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$onHomeDoubleTap$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView *), strlen(@encode(UICollectionView *))); i += strlen(@encode(UICollectionView *)); memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(collectionView:numberOfItemsInSection:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$collectionView$numberOfItemsInSection$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UICollectionViewCell*), strlen(@encode(UICollectionViewCell*))); i += strlen(@encode(UICollectionViewCell*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView *), strlen(@encode(UICollectionView *))); i += strlen(@encode(UICollectionView *)); memcpy(_typeEncoding + i, @encode(NSIndexPath*), strlen(@encode(NSIndexPath*))); i += strlen(@encode(NSIndexPath*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(collectionView:cellForItemAtIndexPath:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$collectionView$cellForItemAtIndexPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(CGSize), strlen(@encode(CGSize))); i += strlen(@encode(CGSize)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView*), strlen(@encode(UICollectionView*))); i += strlen(@encode(UICollectionView*)); memcpy(_typeEncoding + i, @encode(UICollectionViewLayout*), strlen(@encode(UICollectionViewLayout*))); i += strlen(@encode(UICollectionViewLayout*)); memcpy(_typeEncoding + i, @encode(NSIndexPath*), strlen(@encode(NSIndexPath*))); i += strlen(@encode(NSIndexPath*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(collectionView:layout:sizeForItemAtIndexPath:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$collectionView$layout$sizeForItemAtIndexPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UICollectionView*), strlen(@encode(UICollectionView*))); i += strlen(@encode(UICollectionView*)); memcpy(_typeEncoding + i, @encode(NSIndexPath*), strlen(@encode(NSIndexPath*))); i += strlen(@encode(NSIndexPath*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(collectionView:didSelectItemAtIndexPath:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$collectionView$didSelectItemAtIndexPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$gestureRecognizer$shouldRecognizeSimultaneouslyWithGestureRecognizer$, _typeEncoding); }} }
#line 251 "Tweak.xm"
