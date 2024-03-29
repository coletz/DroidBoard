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

    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    xRootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
    [self setupBackground];
    [self.view addSubview:xRootView];

    xHomeView = [[XHomeView alloc]initWithFrame:CGRectMake(0, statusBarHeight, screen.width, screen.height - statusBarHeight)];
    [xHomeView setCoordinatorDelegate:self];
    [xRootView addSubview:xHomeView];

    xDrawerView = [[XDrawerView alloc]initWithFrame:CGRectMake(0, screen.height, screen.width, screen.height - statusBarHeight)];
    [xDrawerView setCoordinatorDelegate:self];
    [xRootView addSubview:xDrawerView];


    for (i = 65; i <= 90; i++){
        NSString *shortcutKey = [NSString stringWithFormat:@"%c", i];
        
        UIKeyCommand* cmd = [UIKeyCommand
                keyCommandWithInput:shortcutKey
                modifierFlags:0
                action:@selector(onUnassignedKeyPressed:)
                discoverabilityTitle:shortcutKey
        ];
        [self addKeyCommand:cmd];
    }
}

%new
-(void)onUnassignedKeyPressed:(UIKeyCommand*)sender {
    //TODO
}

%new
-(void)onAssignedKeyPressed:(UIKeyCommand*)sender {
    NSString* shortcutKey = sender.input;
    XIconCellView* cell = [[XIconCellView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    [cell setAppId:@"ph.telegra.Telegraph"];
    [cell launchApp];
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
    [xDrawerView hideProgrammatically];
}

%new
-(void)reloadHomeApps {
    [xHomeView loadApps];
}

%new
-(void)setupBackground {
    CAGradientLayer *gradient = [CAGradientLayer layer];

    gradient.frame = xRootView.bounds;
    gradient.colors = @[
        (id)[UIColor colorWithRed:18.0/255.0 green:66.0/255.0 blue:71.0/255.0 alpha:1].CGColor,
        (id)[UIColor colorWithRed:63.0/255.0 green:146.0/255.0 blue:126.0/255.0 alpha:1].CGColor,
        (id)[UIColor colorWithRed:199.0/255.0 green:200.0/255.0 blue:208.0/255.0 alpha:1].CGColor,
        (id)[UIColor colorWithRed:205.0/255.0 green:168.0/255.0 blue:126.0/255.0 alpha:1].CGColor
    ];

    [xRootView.layer insertSublayer:gradient atIndex:0];
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
