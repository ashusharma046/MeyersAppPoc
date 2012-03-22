#import <Foundation/Foundation.h>
#import "BSKmlResult.h"
#import "BSAddressComponent.h"
#import "BSForwardGeocoder.h"

@interface BSGoogleV3KmlParser : NSObject<NSXMLParserDelegate> {
	NSMutableString *contentsOfCurrentProperty;
	int statusCode;
	NSMutableArray *results;
	NSMutableArray *addressComponents;
	NSMutableArray *typesArray;
	BSKmlResult *currentResult;
	BSAddressComponent *currentAddressComponent;
	BOOL ignoreAddressComponents;
	BOOL isLocation;
	BOOL isViewPort;
	BOOL isBounds;
	BOOL isSouthWest;
}

@property (nonatomic, readonly) int statusCode;
@property (nonatomic, readonly) NSMutableArray *results;

- (BOOL)parseXMLData:(NSData *)URL 
			   parseError:(NSError **)error 
			   ignoreAddressComponents:(BOOL)ignore;


@end
