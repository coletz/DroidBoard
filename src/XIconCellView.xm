#import "XIconCellView.h"

@implementation XIconCellView

-(void)prepareForReuse {
    [super prepareForReuse];
    [self.appIcon setImage:nil];
    [self.appName setText:nil];
}

-(XIconCellView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    // - ICON
    UIImageView* appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon.width, icon.height)];
    appIcon.contentMode = UIViewContentModeScaleAspectFit;    

    int elevation = 2;
    appIcon.layer.masksToBounds = NO;
    appIcon.layer.shadowColor = [[UIColor blackColor] CGColor];
    appIcon.layer.shadowOffset = CGSizeMake(0, elevation);
    appIcon.layer.shadowOpacity = 0.24;
    appIcon.layer.shadowRadius = elevation;

    appIcon.layer.borderWidth = 1.0;
    appIcon.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.35] CGColor];
    appIcon.layer.cornerRadius = 12;
    appIcon.layer.shouldRasterize = YES; 
    appIcon.layer.rasterizationScale = [UIScreen mainScreen].scale; 
    [self addSubview:appIcon];
    // --- constraints 
    [appIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [appIcon.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0].active = YES;
    [appIcon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;

    // - NAME LABEl
    UILabel* appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    appName.textColor = [UIColor blackColor];
    appName.textAlignment = NSTextAlignmentCenter;
    appName.font = [UIFont systemFontOfSize:12];
    [self addSubview:appName];
    // --- constraints
    [appName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [appName.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0].active = YES;
    [appName.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0].active = YES;
    [appName.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active = YES;


    self.appIcon = appIcon;
    self.appName = appName;
    return self;
}

-(void)setAppId:(NSString*)appId {
    self.bundleId = appId;
    NSDictionary* apps = [[ALApplicationList sharedApplicationList] applications];
    [self.appName setText:apps[appId]];
    [self.appIcon setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:appId]];
}

-(void)launchApp {
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:_bundleId suspended:NO];
}

@end