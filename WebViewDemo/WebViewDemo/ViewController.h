#import <WebKit/WebKit.h>
#import <AdnuntiusSDK/AdnuntiusSDK-Swift.h>

@interface ViewController : UIViewController <AdLoadCompletionHandler>

@property (weak, nonatomic) IBOutlet AdnuntiusAdWebView *adView;

- (void)loadFromConfig;
- (void)promptToLoadAd;
@end
