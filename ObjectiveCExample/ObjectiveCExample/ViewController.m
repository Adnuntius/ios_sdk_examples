#import "ViewController.h"

@implementation ViewController

- (void)promptToLoadAd {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirm"
                               message:@"Do you want to release the Ads?"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action){NSLog(@"Cancel button tapped");}];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){NSLog(@"Ok button tapped"); [self loadFromConfig];}];

    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *labelAbove = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.adView=[[AdnuntiusAdWebView alloc] initWithFrame:CGRectMake(0, 100, 320, 275)];
    UILabel *labelBelow = [[UILabel alloc]initWithFrame:CGRectMake(0, 375, 320, 125)];
    
    labelAbove.textAlignment = NSTextAlignmentCenter;
    labelAbove.backgroundColor = [UIColor brownColor];
    labelAbove.textColor = [UIColor whiteColor];
    labelAbove.text = @"Im above";
    
    labelBelow.textAlignment = NSTextAlignmentCenter;
    labelBelow.backgroundColor = [UIColor greenColor];
    labelBelow.textColor = [UIColor whiteColor];
    labelBelow.text = @"Im below";
    
    self.adView.backgroundColor = [UIColor orangeColor];
    
    self.view.backgroundColor = [UIColor blueColor];
    [self.adView setOpaque:FALSE];
    self.adView.scrollView.backgroundColor = [UIColor purpleColor];
    [self.adView.scrollView setOpaque:FALSE];
    
    [self.view setNeedsLayout];
    
    [self.view addSubview:labelAbove];
    [self.view addSubview:self.adView];
    [self.view addSubview:labelBelow];

    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"", @"globalUserId",
                                     nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    NSString* globalUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"globalUserId"];
    if ([globalUserId length] == 0) {
        NSLog(@"No global user id found, generating");
        NSString *userId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject: userId forKey:@"globalUserId"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];

    // Declare Alert message this is just so we can attach the browser debugger
    [self promptToLoadAd];
    
    //[self loadFromConfig];
}
            
- (void)loadFromConfig {
    NSString* globalUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"globalUserId"];
    NSLog(@"global user is %@", globalUserId);
    
    [self.adView enableDebug:YES];
    NSString *sessionId = [[NSUUID UUID] UUIDString];
    
    NSString* adId = @"000000000006f450";
    
    NSDictionary* config = @{
        @"adUnits" : @[
                @{
                    @"auId":adId, @"auH":@200, @"kv": @{@"version" : @[@"6s"]}
                }
        ],
        @"useCookies": @false,
        @"userId": globalUserId,
        @"sessionId": sessionId,
        @"consentString": @"some consent string"
    };

    bool configResult = [self.adView loadAd:config completionHandler:self adnSdkHandler:nil];
    if (!configResult) {
        NSLog(@"Something is wrong with the config, check the logs");
    }
}

- (void)onNoAdResponse:(AdnuntiusAdWebView * _Nonnull)view {
    NSLog(@"No ad found");
    self.adView.hidden = true;
}

- (void)onFailure:(AdnuntiusAdWebView * _Nonnull)view :(NSString * _Nonnull)message {
    NSLog(@"Failure: %@", message);
    self.adView.hidden = true;
}

- (void)onAdResponse:(AdnuntiusAdWebView * _Nonnull)view :(NSInteger)width :(NSInteger)height {
    NSLog(@"ad found, height: %1ld, width: %1ld", height, width);
    
    if (height > 0) {
        CGRect frame = self.adView.frame;
        frame.size.height = height;
        self.adView.frame = frame;
    }
}

- (void)onClose:(AdnuntiusAdWebView * _Nonnull)view {
    NSLog(@"No on close implemented");
}

@end

