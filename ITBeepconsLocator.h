//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*!
 *       @header             ITBeepconsLocator.h
 *       @discussion         Header containing ITBeepconsLocator Class Interface and ITBeepconsLocatorDelegate Protocol
 *                           THIS SOFTWARE CAN BE USED ONLY UNDER NDA DISCLOSURE AGREEMENT
 *                           THIS CLASS ENCAPSULATES ALL THE FUNCTIONS THAT CAN BE PERFORMED WITH A BEEPCON ACROSS THE CORELOCATION FRAMEWORK
 *                           SOME KNOWLEDGE OF THE IOS CORELOCATION FRAMEWORK IS RECOMMENDED
 *       @copyright          Ilunion Tecnología y Accesibilidad
 *       @author             Andrés Ursueguía
 *
 *       @updated            2016-09-23
 *
 */
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>


@class ITBeepconsLocator;


//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*! @protocol       ITBeepconsLocatorDelegate
 *
 *  @brief          Protocol to be implemented by the ITBeepconsLocator owner class to receive events via the delegate pattern
 *
 *  @discussion     The class that instantiates a ITBeepconsLocator object needs to implement this delegate
 *                  to receive all the required answers fired by ITBeepconsLocator. At the moment of this release
 *                  all the delegate methods are declared as Required.
 *
 *  @updated        2016-09-23
 *
 */
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
@protocol ITBeepconsLocatorDelegate <NSObject>

@required

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that the ITBeepconsLocator started locating BEEPCONS
 *
 *  @discussion     Once the client app calls the StartLocatingBeepconsWithId:LowId:Identifier function, this function is called via delegate to confirm the client app
 *                  that the IOS system is now monitoring for BEEPCONS. Monitoring for BEEPCONS is not the same as scanning for BEEPCONS on ITBeepconsManager.
 *                  Monitoring is used to inform the app that the user has entered or exit a region with BEEPCONS and this work is automatically done by IOS.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started locating (Ex. "com.ilunion.MyGroupOfBeepconsOneForLocate"). This identifier is supplied
 *                                  by the client app when calling StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @see            StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidStartLocating:(id)thislocator withRegionIdentifier:(NSString *)identifier;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that the ITBeepconsLocator stopped locating BEEPCONS
 *
 *  @discussion     Once the client app calls the StopLocatingBeepconsWithRegionIdentifier: function, this function is called via delegate to confirm the client app
 *                  that the IOS system has stopped monitoring for this BEEPCONS. No more enter or exit region events will be reported to the client app.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started locating (Ex. "com.ilunion.MyGroupOfBeepconsOneForLocate"). This identifier is supplied
 *                                  by the client app when calling StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @see            StopLocatingBeepconsWithRegionIdentifier:
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidStopLocating:(id)thislocator withRegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that Locating BEEPCONS cannot be performed
 *
 *  @discussion     Depending of various factors, (such as Bluetooth status, app permissions etc..) locating can be not allowed. This method is called to
 *                  inform the client App of this situation.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started locating (Ex. "com.ilunion.MyGroupOfBeepconsOneForLocate"). This identifier is supplied
 *                                  by the client app when calling StartLocatingBeepconsWithHiId:LowId:Identifier:
 *  @param          error           the description of the error in the userinfo property of this NSError argument
 *
 *  @see            StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @warning        Most usual cases are bluetooth is disabled, or app permissions to use Locations are not allowed
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidFailedStartLocating:(id)thislocator withRegionIdentifier:(NSString *)identifier error:(NSError *)error;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that the ITBeepconsLocator started reporting BEEPCONS
 *
 *  @discussion     Once the client app calls the StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier: function, this function is called via delegate
 *                  to confirm the app that the IOS system is now reporting for BEEPCONS.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *
 *  @see            StartReportingBeepconsWithHiId:LowId:RegionIdentifier:
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidStartReporting:(id)thislocator withRegionIdentifier:(NSString *)identifier;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that the ITBeepconsLocator stoppped reporting BEEPCONS
 *
 *  @discussion     Once the client app calls the StopReportingBeepconsWithRegionIdentifier: function, this function is called via delegate to confirm the app
 *                  that the IOS system has stopped reporting for BEEPCONS.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *
 *  @see            StopReportingBeepconsWithRegionIdentifier:
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidStopReporting:(id)thislocator withRegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that Reporting BEEPCONS cannot be performed
 *
 *  @discussion     The Reporting cannot be performed
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *  @param          error           the description of the error in the userinfo property of this NSError argument
 *
 *  @see            StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidFailedStartReporting:(id)thislocator withRegionIdentifier:(NSString *)identifier error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report that a BEEPCON has been encountered under the iBeacon Format
 *
 *  @discussion     when the app request to IOS to report BEEPCONS (via StartReportingBeepconsWithId:LowId:Identifier) as soon as it encounters them ,
 *                  the SDK calls this delegate function to inform the client app that BEEPCON data compatible with the iBeacon Profile has been received.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconstartWithHiId:LowId:WithRegionIdentifier:
 *  @param          hiident        the High value of the identifier of this Beepcon (also known as Major in Apple Docs)
 *  @param          loident        the Low value of the identifier of this Beepcon (also known as Major in Apple Docs)
 *  @param          Accuracy        estimated accuracy
 *  @param          proximity       a estimad value indicating the proximity to the Beepcon
 *
 *  @warning        For a more explained description of this parameters please refer to the apple CoreLocation framework documentation. See the CLBeaconRegion Class.
 *
 *  @warning        This parameters are redirected from CoreLocatioin Framework to the client App with no more processing task inside this SDK.
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorReportingBeepconAsIbeacon:(id)thislocator withRegionIdentifier:(NSString *)identifier major:(unsigned int)hiident minor:(unsigned int)loident rssi:(int) rssi accuracy:(double) Accuracy proximity:(int) proximity;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that the user has entered in a region with BEEPCONS
 *
 *  @discussion     When IOS is monitoring for BEEPCONS, this function will be called to inform the client app that the user has entered a region
 *                  with BEEPCONS. You will get this calls also with your app in background if the app has been configured correctly to do it.
 *
 *  @param          thislocator     the instance of the class VLBEEPCONSLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *
 *
 *  @warning        Declare the key NSLocationAlwaysUsageDescription in your application info.plist file to allow
 *                  background use of this feature. Also you need to declare that you app uses Location Update in your client app
 *                  background capabilities.
 *
 *  @warning        When a user has entered a region with BEEPCONS is self performed by IOS and this SDK has no control of how and when this message will
 *                  be delivered.
 *
 *  @warning        Read the SDK USING GUIDE text file
 *
 *  @see            StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidEnterRegion:(id)thislocator withRegionIdentifier:(NSString *)identifier;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to indicate that the user has exit from a region with BEEPCONS
 *
 *  @discussion     When IOS is monitoring for BEEPCONS, this function will be called to inform the client app that the user has exit a region
 *                  with BEEPCONS. You will get this calls also with your app in background if the app has been configured correctly to do it.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *
 *
 *  @warning        Declare the key NSLocationAlwaysUsageDescription in your application info.plist file to allow
 *                  background use of this feature. Also you need to declare that you app uses Location Update in your client app
 *                  background capabilities.
 *
 *  @warning        When a user has exit a region with BEEPCONS is self performed by IOS and this SDK has no control of how and when this message will
 *                  be delivered.
 *
 *  @see            StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @warning        Read the SDK USING GUIDE text file
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidExitRegion:(id)thislocator withRegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Region Status information (Inside, Outside, Not Known)
 *
 *  @discussion     This is called as an answer to RefreshRegionStatusWithRegionIdentifier: call. The SDK informs the client app the actual Region Status.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *  @param          identifier      the identifier of the region that started reporting (Ex. "com.ilunion.MyGroupOfBeepconsOneForReporting"). This identifier is supplied
 *                                  by the client app when calling StartReportingBeepconsWithHiId:LowId:WithRegionIdentifier:
 *  @param          Status          0 - INSIDE REGION
 *                                  1 - OUTSIDE REGION
 *                                  2 - STATUS NOT KNOWN
 *
 *  @see            RefreshRegionStatusWithRegionIdentifier:
 *
 *  @warning        The time ellapsed between a RefreshRegionStatusWithRegionIdentifier: call and this answer is managed internally by IOS.
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidGetRegionStatusInformation:(id)thislocator withRegionIdentifier:(NSString *)identifier status:(int)Status;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Used to warn the client app that the authorization status has changed.
 *
 *  @discussion     The client app can get a more complete status info calling CheckLocationsAvailability: function.
 *                  This method will be called also when ITBeepconsLocator is instantiated.
 *
 *  @param          thislocator     the instance of the class ITBeepconsLocator answering via this protocol method
 *
 *  @see            CheckLocationsAvailability:
 *
 *  @warning        not all the changes are reported asynchronusly from IOS so the safest way to be sure that Locating is available
 *                  is to call CheckLocationsAvailability as many times as needed from the client application to get the more accurate info.
 *                  Also IOS does not take into account if Bluetooth is Powered ON or OFF to make Location of Bluetooth low Energy Devices.
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsLocatorDidAuthorizationChanged:(id)thislocator;

@optional

@end

//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*!
 *  @class           ITBeepconsLocator
 *  @discussion      Class that wraps all the functions that can be performed with a BEEPCON Device using the
 *                   CoreLocation Framework. This class declares the protocol ITBeepconsLocatorDelegate
 *  @warning         Declare the key NSLocationAlwaysUsageDescription in your application info.plist file to allow
 *                   background use of this class. Also you need to declare that you app uses Location Update in your
 *                   background capabilities
 *
 *  @see             ITBeepconsLocatorDelegate
 *
 *  @warning         Read the SDK USING GUIDE text file
 *
 *  @updated         2016-09-23
 *
*/
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
@interface ITBeepconsLocator : NSObject <CLLocationManagerDelegate>


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Initialization Routine to instantiate and object of the ITBeepconsLocator class prior to use it.
 *
 *  @param          thisDelegate   The Delegate receiving the protocol methods calls.
 *
 *  @see            ITBeepconsLocatorDelegate
 *
 *  @warning        Read the SDK USING GUIDE text file
 *
 *  @return         id             The instantiated object of ITBeepconsLocator Class
 *
 *  @updated        2016-09-23
 *
 *  @code           LocatorExample = [[ITBeepconsLocator alloc] initWithDelegate:self];
 *  @codeend
 *
 */
//*****************************************************************************************************************************************************************
- (id) initWithDelegate:(id <ITBeepconsLocatorDelegate>)thisDelegate;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          UUID under the iBeacon format that the ITBeepconsLocator will search for.
 *
 *  @discussion     call this function tho change the UUID that the SDK will locate/report for. The SDK only will locate those BEEPCONS
 *                  that have the same UUID that you have set. When the class is created a default UUID is set F9403000-F5F8-466E-AFF9-25556B57FE6D
 *                  This is the same UUID that BEEPCONS are set by default on factory settings
 *
 *  @param          UUID   The UUID to Locate
 *
 *  @see            StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @warning        The UUID (a propietary one) or the default one (F9403000-F5F8-466E-AFF9-25556B57FE6D)
 *                  depends on your final use case. It´better to contact Ilunion Tecnología y Accesibilidad
 *                  to know the best choice that better fits your requirements, as the default UUID is used for a particular application and use case.
 *
 *  @updated        2016-09-23
 *
 *  @code           [LocatorExample setUUIDToLocate:[[NSUUID alloc] initWithUUIDString:@"F9403000-F5F8-466E-AFF9-25556B57AA55"]];
 *  @codeend
 *
 */
//*****************************************************************************************************************************************************************
- (void)setUUIDToLocate:(NSUUID *)UUID;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to tell IOS to start locating de defined Group of BEEPCONS
 *
 *  @discussion     When the start is performed normally, the delegate function ITBeepconsLocatorDidStartLocating:withRegionIdentifier:
 *                  The Group of BEEPCONS to Locate are defined by its UUID, its Major and Minor Values, with different degree´s of filtering. (See params)
 *
 *  @param          hiid       A 4 byte Number with the also known Major Value.
 *                             Null to disable filtering by Major
 *  @param          loid       A 4 byte Number with the also known Minor Value.
 *                             Null to disable filtering by Minor
 *  @param          identifier a string to identifiy the Group of BEEPCONS being located that will be refered in other functions (Needs to be Unique. Ex :
 *                             @"com.ilunion.GroupOfBeepconsOneLocated")
 *
 *  @see            setUUIDToLocate:
 *  @see            ITBeepconsLocatorDidStartLocating:withRegionIdentifier:
 *  @see            ITBeepconsLocatorDidEnterRegion:withRegionIdentifier:
 *  @see            ITBeepconsLocatorDidExitRegion:withRegionIdentifier:
 *
 *  @warning        If loid is supplied (not null), the hiid cannot be null or the Locating Action will be refused
 *  @warning        The UUID to locate for will be the last you have set via setUUIDToLocate:
 *
 *  @updated        2016-09-23
 *
 *  @code           // Code shows a call to start locating any BEEPCON broadcasting the actual UUID set by setUUIDToLocate:
 *                  [LocatorExample setUUIDToLocate:[[NSUUID alloc] initWithUUIDString:@"F9403000-F5F8-466E-AFF9-25556B57AA55"]];
 *                  [LocatorExample StartLocatingBeepconsWithHiId:nil LowId:nil Identifier:@"com.mycompanyname.mycomapyapp.mytargetbeepconstolocate"]
 *  @codeend
 */
//*****************************************************************************************************************************************************************
- (void) StartLocatingBeepconsWithHiId:(NSNumber *)hiid LowId:(NSNumber *)loid Identifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          stops the reporting of the Group of BEEPCONS corresponding to identifier
 *
 *  @discussion     When the stop is performed the delegate function ITBeepconsLocatorDidStopLocating:withRegionIdentifier: will be called
 *
 *  @param          identifier the unique string that refers to this Group of BEEPCONS being located, or NIL to STOP ALL LOCATED GROUPS OF BEEPCONS
 *
 *  @see            ITBeepconsLocatorDidStopLocating:withRegionIdentifier:
 *
 *  @updated        2016-09-23
 *
 *  @warning        When a Region Identifier is supplied, it must be equal than one of the region identifiers supplied to
 *                  StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *
 *  @code           // Stop Locating all BEEPCONS with any identifier
 *                  [LocatorExample StopLocatingBeepconsWithRegionIdentifier:nil];
 *                  // Stop locating a Region Identifier Group of BEEPCONS
 *                  [LocatorExample StopLocatingBeepconsWithRegionIdentifier:@"com.mycompanyname.mycomapyapp.mytargetbeepconstolocate"];
 *
 *  @codeend
 */
//*****************************************************************************************************************************************************************
- (void) StopLocatingBeepconsWithRegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          call this function to get the BEEPCONS data reported as soon as IOS encounters the defined Group of BEEPCONS.
 *
 *  @discussion     When this function is called, all BEEPCONS encountered that match the Group will be reported via the
 *                  ITBeepconsLocatorReportingBeeconAsIbeacon:WithRegionIdentifier:Major:Minor:Rssi:Accuracy:
 *
 *  @param          hiid       A 4 byte Number with the also known Major Value.
 *                             Null to report any Major.
 *  @param          loid       A 4 byte Number with the also known Minor Value.
 *                             Null to report any Minor
 *  @param          identifier a string to identifiy the Group of BEEPCONS being reported that will be refered in other functions (Needs to be Unique. Ex :
 *                             @"com.ilunion.GroupOfBeepconsOneLocated")
 *
 *  @see            setUUIDToLocate:
 *  @see            ITBeepconsLocatorDidStartReporting:withRegionIdentifier:
 *  @see            ITBeepconsLocatorReportingBeepconAsIbeacon:withRegionIdentifier:major:minor:rssi:accuracy:proximity:
 *
 *  @warning        If loid is supplied (not null), the hiid cannot be null or the Reporting Action will be refused
 *  @warning        The UUID to locate for will be the last you have set via setUUIDToLocate:
 *  @warning        Apple recommends to use this function in Foreground.
 *  @warning        The rate that reports are sended to the client App are controlled internally by IOS.
 *
 *
 *  @updated        2016-09-23
 *
 *  @code           // Code shows a call to start reporting any Beepcon broadcasting the actual UUID set by setUUIDToLocate:
 *                  [LocatorExample setUUIDToLocate:[[NSUUID alloc] initWithUUIDString:@"F9403000-F5F8-466E-AFF9-25556B57AA55"]];
 *                  [LocatorExample StartReportingBeepconsWithHiId:nil LowId:nil Identifier:@"com.mycompanyname.mycomapyapp.mytargetbeepconstoreport"]
 *  @codeend
 */
//*****************************************************************************************************************************************************************
- (void) StartReportingBeepconsWithHiId:(NSNumber *)hiid LowId:(NSNumber *)loid RegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          stops the reporting of the Group of BEEPCONS corresponding to identifier
 *
 *  @discussion     When the stop is performed the delegate function ITBeepconsLocatorDidStopReporting:withRegionIdentifier: will be called
 *
 *  @param          identifier the unique string that refers to this Group of BEEPCONS being reported, or NIL to STOP ALL REPORTED GROUPS OF BEEPCONS
 *
 *  @see            ITBeepconsLocatorDidStopReporting:withRegionIdentifier:
 *
 *  @updated        2016-09-23
 *
 *  @code           // Stop Reporting all BEEPCONS with any identifier
 *                  [LocatorExample StopReportingBeepconsWithRegionIdentifier:nil];
 *                  // Stop locating a Region Identifier Group of BEEPCONS
 *                  [LocatorExample StopReporingBeepconsWithRegionIdentifier:@"com.mycompanyname.mycomapyapp.mytargetbeepconstoreport"];
 *  @codeend
 */
//*****************************************************************************************************************************************************************
- (void) StopReportingBeepconsWithRegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          call this function to know the actual status of a BEEPCONS Region.
 *
 *  @discussion     The SDK will answer via the ITBeepconsLocatorRegionStatusInformation: delegate function as soon IOS answers.
 *
 *  @param          identifier the unique string that refers to the Group of BEEPCONS for wich status is inquired.
 *
 *  @see            ITBeepconsLocatorDidGetRegionStatusInformation:withRegionIdentifier:status:
 *
 *
 *  @warning        The time ellapsed between the call and the answer depends of IOS.
 *
 *  @updated        2016-09-23
 *
 *  @code           [LocatorExample RefreshRegionStatusWithRegionIdentifier:@"com.mycompanyname.mycomapyapp.mytargetbeepconstolocate"];
 *  @codeend
 *
 */
//*****************************************************************************************************************************************************************
- (void) RefreshRegionStatusWithRegionIdentifier:(NSString *)identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call to know if IOS is actually locating for a Group of BEEPCONS corresponding to this identifier
 *
 *  @discussion     At any moment your App can inquiry if some group of BEEPCONS, identified by its identifier are in locating status by IOS.
 *
 *  @param          identifier the unique string that refers to the Group of BEEPCONS for wich status is inquired.
 *
 *  @return         TRUE if this group of BEEPCONS are in locating status by IOS
 *
 *  @updated        2016-09-23
 *
 *  @code           if ([LocatorExample IsBeepconsLocatingActiveOnIOSWithRegionIdentifier:@"com.mycompanyname.mycomapyapp.mytargetbeepconstolocate"]){
 *                      // Do Something
 *                  }
 *  @codeend
 */
//*****************************************************************************************************************************************************************
- (BOOL) IsBeepconsLocatingActiveOnIOSWithRegionIdentifier:(NSString *)identifier;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call to get a NSArray with the NSStrings of all the Identifiers that are actually registered to be Located.
 *
 *  @discussion     The identifiers are those that were registered with success via StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @see            StartLocatingBeepconsWithHiId:LowId:Identifier:
 *
 *  @return         A NSArray with all the NSStrings of identifiers being located at the moment of the call
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (NSArray *) GetIdentifiersOfLocatingBeepcons;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call to get a NSArray with the NSStrings of all the Identifiers that are actually registered to be Reported.
 *
 *  @discussion     The identifiers are those that were registered with success via StartReportingBeepconsWithHiId:LowId:Identifier:
 *
 *  @see            StartReportingBeepconsWithHiId:LowId:Identifier:
 *
 *  @return         A NSArray with all the NSStrings of identifiers being reported at the moment of the call
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
- (NSArray *) GetIdentifiersOfReportingBeepcons;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Check with this function if your actual device can locate regions of BEEPCONS.
 *
 *  @param          reason NSError reference to get the reason of the error if any exists.
 *
 *  @return         TRUE if all is set OK to locate BEEPCONS, FALSE if not.
 *
 *  @updated        2016-09-23
 */
//*****************************************************************************************************************************************************************
+ (BOOL) CheckLocationsAvailability: (NSError **) reason;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will set ON or OFF the console DEBUG Messages from the SDK
 *
 *  @param          debugmessages   TRUE will send debug messages to the XCODE console. FALSE will silence this messages.
 *
 *  @updated        2016-09-27
 */
//*****************************************************************************************************************************************************************
- (void) SetDebugMessagesForDevelopment:(BOOL)debugmessages;


@end
