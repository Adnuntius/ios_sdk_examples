#import <WebKit/WebKit.h>
#import <AdnuntiusSDK/AdnuntiusSDK-Swift.h>

@interface ViewController : UIViewController <AdLoadCompletionHandler, AdnSdkHandler>

@property (weak, nonatomic) IBOutlet AdnuntiusAdWebView *adView;

- (void)loadFromConfig;
- (void)promptToLoadAd;
@end
