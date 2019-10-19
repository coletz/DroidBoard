#import "DroidBoard.h"

%hook SBHomeScreenViewController

// Static
static CGSize screen;

// Properties
UIView* xRootView;
XHomeView* xHomeView;
XDrawerView* xDrawerView;

// Hooked methods

-(void)viewDidAppear:(BOOL)arg1 {
    %orig(arg1);
    [self updateScreenSize];
    
    xRootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
    [self.view addSubview:xRootView];

    xHomeView = [[XHomeView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height - statusBarHeight)];
    [xHomeView setAppLaunchDelegate:self];
    [xHomeView setCoordinatorDelegate:self];
    [xRootView addSubview:xHomeView];

    xDrawerView = [[XDrawerView alloc]initWithFrame:CGRectMake(0, screen.height, screen.width, screen.height - statusBarHeight)];
    [xDrawerView setAppLaunchDelegate:self];
    [xRootView addSubview:xDrawerView];
}

%new
-(void)launch:(NSString*)bundleId {
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleId suspended:NO];
}

%new
-(void)updateScreenSize {
    CGRect scrBounds = [[UIScreen mainScreen] bounds];
    screen = scrBounds.size;
}

%new
-(void)showDrawer {
    [xDrawerView show];
}

%new
-(void)hideDrawer {
    [xDrawerView hide];
}




 //// DUNNO WHY THIS IS NOT WORKING
%new
-(void)setupHomeDoubleTap {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHomeDoubleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.delegate = self;
    [xHomeView addGestureRecognizer:recognizer];
}

%new
-(void)onHomeDoubleTap:(UIGestureRecognizer*)sender {
    struct GSEventRecord record;
    memset(&record, 0, sizeof(record));
    record.type = kGSEventLockButtonDown;
    record.timestamp = GSCurrentEventTimestamp();
    GSSendSystemEvent(&record);
    record.type = kGSEventLockButtonUp;
    GSSendSystemEvent(&record);
}

%end
