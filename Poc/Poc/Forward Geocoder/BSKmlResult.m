
/**
 
 Object for storing placemark results from Googles geocoding API
 
 **/

#import "BSKmlResult.h"


@implementation BSKmlResult

@synthesize address = _address;
@synthesize accuracy = _accuracy;
@synthesize countryNameCode = _countryNameCode;
@synthesize countryName = _countryName;
@synthesize subAdministrativeAreaName = _subAdministrativeAreaName;
@synthesize localityName = _localityName;
@synthesize addressComponents = _addressComponents;
@synthesize viewportSouthWestLat = _viewportSouthWestLat;
@synthesize viewportSouthWestLon = _viewportSouthWestLon;
@synthesize viewportNorthEastLat = _viewportNorthEastLat;
@synthesize viewportNorthEastLon = _viewportNorthEastLon;
@synthesize boundsSouthWestLat = _boundsSouthWestLat;
@synthesize boundsSouthWestLon = _boundsSouthWestLon; 
@synthesize boundsNorthEastLat = _boundsNorthEastLat; 
@synthesize boundsNorthEastLon = boundsNorthEastLon; 
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


- (CLLocationCoordinate2D)coordinate 
{
	CLLocationCoordinate2D coordinate = {self.latitude, self.longitude};
	return coordinate;
}

- (MKCoordinateSpan)coordinateSpan
{
	// Calculate the difference between north and south to create a span.
	float latitudeDelta = fabs(fabs(self.viewportNorthEastLat) - fabs(self.viewportSouthWestLat));
	float longitudeDelta = fabs(fabs(self.viewportNorthEastLon) - fabs(self.viewportSouthWestLon));
	
	MKCoordinateSpan spn = {latitudeDelta, longitudeDelta};
	
	return spn;
}

- (MKCoordinateRegion)coordinateRegion
{
	MKCoordinateRegion region;
	region.center = self.coordinate;
	region.span = self.coordinateSpan;
	
	return region;
}

- (NSArray*)findAddressComponent:(NSString*)typeName
{
	NSMutableArray *matchingComponents = [[NSMutableArray alloc] init];
	
	for (int i = 0, components = [self.addressComponents count]; i < components; i++) {
		BSAddressComponent *component = [self.addressComponents objectAtIndex:i];
		if (component.types != nil) {
			for(int j = 0, typesCount = [component.types count]; j < typesCount; j++) {
				NSString * type = [component.types objectAtIndex:j];
				if ([type isEqualToString:typeName]) {
					[matchingComponents addObject:component];
					break;
				}
			}
		}
		
	}
	
	return matchingComponents ;
}

@end
