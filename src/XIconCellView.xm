#import "XIconCellView.h"

@implementation XIconCellView
-(XIconCellView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    // - ICON
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
    // --- constraints 
    [_appIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_appIcon.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0].active = YES;
    [_appIcon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    //[_appIcon.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.75]:

    // - NAME LABEl
    _appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _appName.textColor = [UIColor blackColor];
    _appName.textAlignment = NSTextAlignmentCenter;
    _appName.font = [UIFont systemFontOfSize:12];
    [self addSubview:_appName];
    // --- constraints
    [_appName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_appName.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0].active = YES;
    [_appName.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0].active = YES;
    [_appName.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active = YES;

    return self;
}

@end