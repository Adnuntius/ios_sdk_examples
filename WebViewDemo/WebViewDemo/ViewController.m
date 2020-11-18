#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
                {auId: '%@', auW: 320, auH: 320, kv: [{'version':'X'}] } \
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
