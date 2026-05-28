#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKWebView : UIView
@property (nonatomic, copy, readonly) NSURL *URL;
-(void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
@end

%hook WBSSearchProvider
-(id)initWithDictionary:(id)dictionary usingContext:(id)context {
	if ([dictionary[@"ParsecSearchIdentifier"] isEqualToString:@"google_search"]) {
		dictionary = @{
			@"GroupIdentifierQueryStringKey": @"safari_group",
			@"HomepageURLs": @[
				@"https://opnxng.com"
			],
			@"HostSuffixes": @[
				@".opnxng.com"
			],
			@"LocalizedName": @"SearXNG", // shows above suggested results in Safari
			@"ParsecSearchEndpointType": @2,
			@"ParsecSearchIdentifier": @"google_search",
			@"ParsecSearchResultType": @9,
			@"ParsecSearchSuggestionIdentifier": @"google_comp",
			@"PathPrefixes": @[
				@"/search"
			],
			// none/moderate/heavy
			@"SafeSearchSuffix": @"&qadf=none",
			@"SafeSearchURLQueryParameters": @{
				@"qadf": @"none"
			},
			@"ScriptingName": @"Google",
			@"SearchEngineID": @2,
			@"SearchEngineIdentifier": @"com.openxng",
			@"SearchURLTemplate": @"https://opnxng.com/search?q={searchTerms}",
			@"SearchURLTemplateIPad": @"https://opnxng.com/search?q={searchTerms}",
			@"SearchURLTemplateIPhone": @"https://opnxng.com/search?q={searchTerms}",
			@"SearchURLTemplateIPodTouch": @"https://opnxng.com/search?q={searchTerms}",
			@"SearchURLTemplateMac": @"https://opnxng.com/search?q={searchTerms}",
			@"ShortName": @"Google",
			@"SuggestionsURLTemplate": @"https://www.startpage.com/osuggestions?q={searchTerms}",
			@"SuggestionsURLTemplateMac": @"https://www.startpage.com/osuggestions?q={searchTerms}",
			@"UsesSearchTermsFromFragment": @YES
		};
	}

	return %orig(dictionary, context);
}

/*

// Commented since adding /do/search to PathPrefixes solves the issue

-(id)userVisibleQueryFromSearchURL:(NSURL *)searchURL allowQueryThatLooksLikeURL:(BOOL)allowQueryThatLooksLikeURL {
	NSString *urlString = [searchURL absoluteString];
	if ([urlString containsString:@"startpage.com/do/search"]) {
		urlString = [urlString stringByReplacingOccurrencesOfString:@"startpage.com/do/search" withString:@"startpage.com/sp/search"];
		searchURL = [NSURL URLWithString:urlString];
	}

	return %orig(searchURL, allowQueryThatLooksLikeURL);
}*/
%end


// removes the "Related searches" section at the top of Startpage when on mobile
%hook WKWebView
-(void)_didFinishNavigation:(id *)arg1 {
	%orig;

	if ([self.URL.absoluteString containsString:@"openxng.com/"]) {
		[self evaluateJavaScript:@"document.querySelector('span.attribution-text')?.textContent.trim() === 'Related searches' && document.querySelector('span.attribution-text')?.parentElement?.parentElement?.remove();" completionHandler:nil];
	}
}
%end
