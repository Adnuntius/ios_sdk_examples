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
    [self promptToLoadAd];
    
    //[self loadFromConfig];
}
			
- (void)loadFromConfig {
    AdRequest *adRequest = [[AdRequest alloc] init:@"000000000006f450"];
    [adRequest height:@"480"];
    [adRequest useCookies:true];
    [adRequest consentString:@"some consent string"];
    [adRequest keyValue:@"version" :@"X"];
    [self.adView loadAd:adRequest :self delayViewEvents:NO];
}

- (void)onFailure:(AdnuntiusAdWebView * _Nonnull)view :(NSString * _Nonnull)message {
    NSLog(@"Failure: %@", message);
    self.adView.hidden = true;
}

- (void)onAdResponse:(AdnuntiusAdWebView * _Nonnull)view :(AdResponseInfo * _Nonnull)response {
    NSLog(@"ad found, height: %1ld, width: %1ld", response.definedHeight, response.definedWidth);
    
    if (response.definedHeight > 0) {
        CGRect frame = view.frame;
        frame.size.height = response.definedHeight;
        view.frame = frame;
    }
}

@end
