#import "ViewController.h"

@implementation ViewController

- (void)promptToLoadScript {
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
                               handler:^(UIAlertAction *action){NSLog(@"Ok button tapped"); [self loadFromScript];}];

    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
    
    // Declare Alert message this is just so we can attach the browser debugger
    // stupid apple, android studio has the ability to wait for the app to start before starting the debugger, pity
    // you can't do the same here apple!
    //[self promptToLoadScript];
    
    [self loadFromScript];
}
			
- (void)loadFromScript {
    //AdConfig *config = [[AdConfig alloc] init:@"0000000000067082"];
    //[config setWidth:@"300"];
    //[config setHeight:@"250"];
    //[self.adView loadFromConfig:config completionHandler:self];

    NSString* adId = @"000000000006f450";	
    
    NSString *adScript = @"""<html><script type=\"text/javascript\" src=\"https://cdn.adnuntius.com/adn.js\" async></script> \
    <body> \
    <div id=\"adn-%@\" style=\"display:none\"></div> \
    <script type=\"text/javascript\"> \
        window.adn = window.adn || {}; adn.calls = adn.calls || []; \
          adn.calls.push(function() { \
            adn.request({ adUnits: [ \
                {auId: '%@', auW: 320, auH: 320 } \
            ]}); \
        }); \
    </script> \
    </body> \
    </html>""";

    NSString *adScriptWithIds = [NSString stringWithFormat:adScript, adId, adId];
    
    [self.adView loadFromScript:adScriptWithIds completionHandler:self];
}

- (void)onComplete:(AdnuntiusAdWebView * _Nonnull)view :(NSInteger)adCount {
    NSLog(@"Complete: %1ld", adCount);
}

- (void)onFailure:(AdnuntiusAdWebView * _Nonnull)view :(NSString * _Nonnull)message {
    NSLog(@"Failure: %@", message);
}
@end
