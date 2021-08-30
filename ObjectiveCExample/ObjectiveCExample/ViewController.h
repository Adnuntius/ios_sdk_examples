//
//  ViewController.h
//  ObjectiveCExample
//
//  Created by Jason Pell on 30/8/21.
//

#import <WebKit/WebKit.h>
#import <AdnuntiusSDK/AdnuntiusSDK-Swift.h>

@interface ViewController : UIViewController <AdLoadCompletionHandler, AdnSdkHandler>

@property (strong, nonatomic) AdnuntiusAdWebView *adView;

- (void)loadFromConfig;
- (void)promptToLoadAd;
@end
