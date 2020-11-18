#import <UIKit/UIKit.h>
#import <AdnuntiusSDK/AdnuntiusSDK-Swift.h>

@interface ViewController : UIViewController <AdLoadCompletionHandler>

@property (weak, nonatomic) IBOutlet AdnuntiusAdWebView *adView;

- (void)loadFromScript;
- (void)promptToLoadScript;
@end
