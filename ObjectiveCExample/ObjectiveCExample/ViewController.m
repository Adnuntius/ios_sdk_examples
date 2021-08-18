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

- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
    
    // Declare Alert message this is just so we can attach the browser debugger
    //[self promptToLoadAd];
    
    [self loadFromConfig];
}
			
- (void)loadFromConfig {
    NSString* adId = @"000000000006f450";
    
    NSDictionary* config = @{
        @"adUnits" : @[
                @{
                    @"auId":adId, @"auH":@200, @"kv": @[@{@"version" : @"X"}]
                }
        ],
        @"useCookies": @false
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
