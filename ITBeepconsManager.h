//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
 /*!
 *       @header             ITBeepconsManager.h
 *       @discussion         Header containing ITBeepconsManager Class Interface and ITBeepconsManagerDelegate Protocol
 *                           THIS SOFTWARE CAN BE USED ONLY UNDER NDA DISCLOSURE AGREEMENT
 *                           THIS CLASS ENCAPSULATES ALL THE FUNCTIONS THAT CAN BE PERFORMED WITH A BEEPCON ACROSS THE COREBLUETOOTH FRAMEWORK
 *                           SOME KNOWLEDGE OF THE IOS COREBLUETOOTH FRAMEWORK IS RECOMMENDED
 *       @copyright          Ilunion Tecnología y Accesibilidad
 *       @author             Andrés Ursueguía
 *
 *       @updated            2016-09-26
 *
 */
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ITFoundedBeepcon.h"


@class ITBeepconsManager;

//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*! @protocol       ITBeepcopnsManagerDelegate
 *
 *  @brief          Protocol to be implemented by the ITBeepconsManager owner class to receive events via the delegate pattern
 *
 *  @discussion     The class that instantiates a ITBeepconsManager object needs to implement this delegate
 *                  to receive all the required answers fired by ITBeeconsManager. At the moment of this release
 *                  all the delegate methods are declared as Optional.
 *
 *  @updated        2016-02-29
 *
 */
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
@protocol ITBeepconsManagerDelegate <NSObject>

@optional

//*****************************************************************************************************************************************************************
// SCANNING PROCESS RELATED PROTOCOL METHODS
//*****************************************************************************************************************************************************************

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to confirm that a Scanning has been started.
 *
 *  @discussion     Once the client App calls the StartScanningForPeripheralsWithReport: method, this delegate method is called to indicate that the scanning
 *                  process has started. During the scanning process the ITBeepconsManager class stores internally all BEEPCONS in Range and its non connected
 *                  associated data. The ITBeepconsManager class provides methods to retrieve this information once the scan process has finished, or get this
 *                  information as it appears "in live", to be inmediately processed by the client App.
 *
 *  @param          thismanager     The object of ITBeepconsManager class that is calling the delegate
 *
 *  @see            StartScanningForPeripheralsWithReport:
 *
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidStartScanning:(id)thismanager;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to confirm that a Scanning has been stopped.
 *
 *  @discussion     Once the client App calls the StopScanningForPeripherals method, this delegate method is called to indicate that the scanning
 *                  process has stopped.
 *
 *  @param          thismanager     The object of ITBeepconsManager class that is calling the delegate
 *
 *  @see            StopScanningForPeripherals
 *
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidStopScanning:(id)thismanager;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report each BEEPCON broadcast founded when StartScanningForPeripheralsWithReport is called with Report BOOL Parameter True
 *                  (StartScanningForPeripheralsWithReport:TRUE)
 *
 *  @discussion     This function allows the client application to process some BEEPCON Data as soon it is encountered by IOS without
 *                  the need of waiting to Stop the Scanning. This can give the client application more flexibility to manage the information received
 *                  as soon as it is available, without having to wait to Stop the scan and then retrieve the BEEPCONS Founded.
 *
 *
 *  @param          thismanager          The object of ITBeepconsManager class that is calling the delegate
 *  @param          identifier           A unique number asigned by IOS to this BEEPCON that can be used to refer to this peripheral.
 *                                       This is not the BEEPCON hiid/loid number nor the BEEPCON Mac. It´s a ramdom number assigned by IOS that can change in time
 *                                       for the same BEEPCON.
 *  @param          name                 The BEEPCON friendly name. (Ex. "Main floor Lift")
 *  @param          rssi                 The radio signal strength that is received on the iPhone in db. (Ex. -78)
 *  @param          txpower              The TxPower that the BEEPCON declares it Transmits at 1m of distance. (Ex. -59)
 *  @param          hiid                 The high part of the BEEPCON Serial Number (can be nil if is not received)
 *  @param          loid                 The low part of the BEEPCON Serial Number (can be nil if is not received)
 *  @param          meanrssi             The computed MeanRssi of all received packets from the scanning start
 *                                       (It´s the mean value of all rssi values received, excluding not valid values)
 *                                       Actually not valid values are considered those outside of +10 to -120 dBms
 *  @param          numberofbroadcasts   The total number of packets recieved from the scanning start for this BEEPCON
 *  @param          Mac                  DEPRECATED always "00:00:00:00:00:00"
 *
 *
 *  @see            StartScanningForPeripheralsWithReport:
 *
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerReportingBeepcon:(id)thismanager
                                  withId:(NSUUID *)identifier
                                    name:(NSString *)name
                                    rssi:(NSNumber *)rssi
                                 txPower:(NSNumber *)txpower
                                    hiId:(NSNumber *) hiid
                                   lowId:(NSNumber *)loid
                                meanRSSI:(NSNumber *)meanrssi
                      numberOfBroadcasts:(NSNumber *)numberofbroadcasts
                                     mac:(NSString *)Mac;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Reports internally computed data for the BEEPCON.
 *
 *  @discussion     This event is fired when you have started the scanning process via a call to  
 *                  StartScanningForPeripheralsWithReport:WithMeanReportsEach:RemoveOutliners:pseudodistancePropagationPathLossExponent:
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *  @param          identifier                A unique number asigned by IOS to this BEEPCON that can be used to refer to this peripheral.
 *                                            This is not the BEEPCON hiid/loid number nor the BEEPCON Mac. It´s a ramdom number assigned by IOS that can change in time
 *                                            for the same BEEPCON.
 *  @param          media                     The media of the RSSI samples used to compute this slot of time (dBm) (Arithmetic media)
 *  @param          numofsamples              The number of samples used to compute all the data
 *  @param          sigma                     The standard deviation in dBm of the computed samples
 *  @param          maxrssi                   The max RSSI received on this samples
 *  @param          minrssi                   The min RSSI received on this samples
 *  @param          pseudodistance            The meters from the BEEPCON...PSEUDO MEANS THAT YOU CAN NOT EXPECT ACCURACY, AND SOMETIMES YOU WILL GET STRANGE RESULTS
 *                                            If you receive a -1, means that no Pseudodistance was computed this time.
 *  @param          pseudodistancedeverror    This is a PSEUDOERROR expected on PseudoDistance, based on the sigma desviation
 *  @param          numoutliners              If you enabled the ouliners remove engine, this will indicate how many samples where removed from the
 *                                            initial raw list of RSSI
 *
 *  @see            StartScanningForPeripheralsWithReport:WithMeanReportsEach:RemoveOutliners:pseudodistancePropagationPathLossExponent:
 *  @see            COMPUTING MEDIAS TXT FILE
 *
 *
 *  @warning        PSEUDODISTANCE is exactly what it means, and cannot be used to estimate with accuracy the real distante to de BEEPCON.
 *                  Please read carefully the COMPUTING MEDIAS DOC to have more details.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerReportingComputedMediaForBeepcon:(id)thismanager
                                                  withId:(NSUUID *)identifier
                                               withMedia:(NSInteger)media
                                     withNumberofSamples:(NSUInteger)numofsamples
                                          withDesviation:(double)sigma
                                             withMaxRssi:(NSInteger)maxrssi
                                             withMinRssi:(NSInteger)minrssi
                               withPseudoDistanceAtMedia:(double)pseudodistance
                              withPseudoDistanceDevError:(double)pseudodistancedeverror
                                        outlinersRemoved:(NSInteger)numoutliners;



//********************************************************************
// CONNECTING AND INFO MESSAGES
//********************************************************************

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to confirm that the connection has been stablished with the BEEPCON once ConnectToBeepcon:withPassword: has been called.
 *
 *  @discussion     This event is raised when the ITBeepconsManager succesfully established the connection with the BEEPCON. Some actions that can be taken
 *                  with BEEPCONS, need a connection prior to perform the action itself. This event is raised always that a connection is requested, with or 
 *                  without password validation.
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @see            ConnectToBeepcon:withPassword:
 *  @see            ITBeepconsManagerDidValidatedPassword:isValidated:withError:
 *
 *  @warning        You need to wait to this event to raise prior to ake any more action with the BEEPCONS that need a connection. Some actions need also that
 *                  the password (when supplied) is validated. 
 *                  In this case you need to wait also to the ITBeepconsManagerDidValidatedPassword:isValidated:withError: to proceed with the action.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidEstablishedTheConnection:(id)thismanager;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This function is called when the connection has been terminated  by any reason (expected or unexpected).
 *
 *  @discussion     The more frecuent (and controlled) reason is the call to DisconnectFromBeepcon:WithThisFoundedBeepcon from the
 *                  client application.
 *                  Also it can be called by any other reason that causes a dsconnection from the BEEPCON.
 *                  (ex. the BEPPCON has gone out of range while connected).
 *                  It can be called also because an unexpected error of connection happened (not expected disconnection).
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @see            DisconnectFromBeepcon:
 *
 *  @see            ITBeepconsManagerDidFailTheProcess:withBeepcon:
 *
 *  @warning        Normally, when a unexpected (error) disconnection occurs you will also have a call to ITBeepconsManagerDidFailTheProcess:withBeepcon:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidTerminatedTheConnection:(id)thismanager;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This function is called when the required process (connect, write or read command etc..) requested to the BEEPCON has been failed by any reason.
 *
 *  @discussion     Normally this function is called when some unexpected error happened, included these errors that have been also reported in the action 
 *                  answer calls that report an NSERROR. (Like for example ITBeepconsManagerDidBuzz:withError:)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          thisFoundedPeripheral     A ITFoundedBeepcon object that describes the error in its public property NSString *ErrorDesc
 *
 *  @warning        This is useful to debug trace your client application and get control of what can be happening when things are not as expected.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidFailTheProcess:(id)thismanager withBeepcon:(ITFoundedBeepcon *) thisFoundedPeripheral;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          This function is called to report in a friendly readable string of the progress of different processes
 *                  being executed with the BEEPCON, such as "Connecting, Connected..etc"
 *
 *  @discussion     Usefull mainly for development stage / Debug purposes.
 *
 *  @param          ProgressMessage      The Status Message in a friendly readable string
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerReportingProgressMessage:(id)thismanager withMessage:(NSString *) ProgressMessage;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to confirm that the password validation has been performed.
 *
 *  @discussion     When a password is provided in the ConnectToBeepcon:withPassword: call, you will get first an answer via
 *                  ITBeepconsManagerDidEstablishedTheConnection:
 *                  Then the BEEPCON will start the process of validating the password, and when done will call this method.
 *
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          PasswordOk                TRUE if password is validated.
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ConnectToBeepcon:withPassword:
 *
 *  @warning        The client App needs to wait to this call prior to execute any action that is password protected.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidValidatedPassword:(id)thismanager isValidated:(BOOL)PasswordOk withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called when the device authorization for permorming Bluetooth operations has changed.(Ex.The user turns OFF the bluetooth).
 *
 *  @discussion     The SDK will call also this function when the ITBeepconsManager class is instantiated.
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          status                    TRUE can perform Bluetooth operations
 *                                            FALSE cannot perform Bluetooth operations
 *
 *  @param          statusdescription         a friendly description of the new status
 *
 *  @see            statusAllowsScanning
 *
 *  @see            CentralStatus
 *
 *  @warning        this info is also exposed as public properties (statusAllowsScanning an CentralStatus) but this protocol function will keep the client app
 *                  informed asynchronously.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerHasChangedAuthorizationStatus:(id)thismanager withStatus:(BOOL)status statusDescription:(NSString *)statusdescription;

//********************************************************************
// ANSWER TO COMMAND MESSAGES
//********************************************************************

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to answer the ReadBeepconBattery: command
 *
 *  @discussion     You can get the actual value of the BEEPCON Battery. Standard value is 3V when battery is full. Values under 2.3V are low battery status.
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          batteryvoltage            The BEEPCON battery voltage in Volts.
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadBeepconBattery:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadBattery:(id)thismanager withVoltage:(float)batteryvoltage error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to answer the BuzzBeepcon:WithSoundType: command
 *
 *  @discussion     A call to this method indicates that the buzz action has been performed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            BuzzBeepcon:WithSoundType:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidBuzz:(id)thismanager withError:(NSError *)error;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to answer the LightLed:DuringSeconds: command
 *
 *  @discussion     A call to this method indicates that the LED action has been performed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            LightLed:DuringSeconds:
 *
 *  @warning        Not all BEEPCONS models have the led feature.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidLightLed:(id)thismanager withError:(NSError *)error;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to answer the ReadBeepconTextInfo: command
 *
 *  @discussion     A call to this method indicates that the Internal Text/Url Read action has been performed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          InfoText                  The text info stored into the BEEPCON
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadBeepconTextInfo:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadTextInfo:(id)thismanager withText:(NSString *)InfoText url:(NSString *)Url error:(NSError *)error;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the ReadBeepconIdMajorAndMinor: command.
 *
 *  @discussion     A call to this method indicates that the Internal Identifiers and the BEEPCON Mac has been readed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          Major                     The High Identifier, also known as Major (2 bytes)
 *
 *  @param          Minor                     The Low Identifier, also known as Minor (2 bytes)
 *
 *  @param          Mac                       The BEEPCONS Mac, (6 bytes)
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadBeepconIdMajorAndMinor:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadBeepconIdentifiers:(id)thismanager withIdMajor:(int)Major idMinor:(int)Minor mac:(unsigned char[6]) Mac error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the ReadVersionNumber: command.
 *
 *  @discussion     A call to this method indicates that the different codes of version numbers have been readed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          hversion                  1 byte hardware version, 4 high bits are version, 4 low bits are Revision (Ex 0x10 = Version 1.0)
 *
 *  @param          fversion                  1 byte firmware version, 4 high bits are version, 4 low bits are Revision (Ex 0x05 = Version 0.5)
 *
 *  @param          StackVersion              The complete version descriptor of the internal Bluetooth Stack
 *
 *  @param          modelcode                 1 byte model code
 *
 *  @param          otafilecheck              a NSString with the ota file of the BEEPCON like "VC_M001H0300S0104010128F0007"
 *
 *  @param          quietmode                 TRUE if Quiet Mode is Set on this BEECON
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadBeepconIdMajorAndMinor:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadBeepconVersion:(id)thismanager
                              withHardVersion:(int)hversion
                                  firmVersion:(int)fversion
                                 stackVersion:(NSString *)StackVersion
                                    modelCode:(int)modelcode
                                 otaFileCheck:(NSString *)otafilecheck
                                    quietMode:(BOOL)quietmode
                                        error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the ReadTxPowerMode: command.
 *
 *  @discussion     A call to this method indicates that the transmit power values of the BEEPCON have been readed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          txpower                   The TxPower index value (Normally 0 for min power ..MaxValueForTxPower for Max Power)
 *
 *  @param          dbAtOneMeter              The Power that the BEEPCON declares to transmit at 1 meter measured in dBm (Ex. -58 dBm)
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadTxPowerMode:
 *
 *  @see            MaxValueForTxPower
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadBeepconPower:(id)thismanager withTxPower:(int)txpower dbAtOneMeterCalibrated:(signed char)dbAtOneMeter error:(NSError *)error;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the ReadTxRateMode: command.
 *
 *  @discussion     A call to this method indicates that the transmit rate value of the BEEPCON have been readed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          txrate                    The txrate index value (Normally 0 for min rate ..MaxValueForTxRate for Max Rate)
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadTxRateMode:
 *
 *  @see            MaxValueForTxRate
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadRate:(id)thismanager withTxRate:(int)txrate error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the ReadTxPattern: command.
 *
 *  @discussion     A call to this method indicates that the transmit pattern values of the BEEPCON have been readed (with or without error)
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          ibeacontime               seconds transmitting iBeacon pattern
 *
 *  @param          beepcontime               seconds transmitting BEEPCON pattern
 *
 *  @param          eddystoneuidtime          seconds transmitting Eddystone UID pattern
 *
 *  @param          eddystoneurltime          seconds transmitting Eddystone URL pattern
 *
 *  @param          eddystonetlmtime          seconds transmitting Eddystone TLM pattern
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ReadTxPattern:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidReadTxPattern:(id)thismanager
                                            withIbeaconTime:(unsigned char)ibeacontime
                                            beepconTime:(unsigned char)beepcontime
                                            eddystoneUIDTime:(unsigned char)eddystoneuidtime
                                            eddystoneURLTime:(unsigned char)eddystoneurltime
                                            eddystoneTLMTime:(unsigned char)eddystonetlmtime
                                            configTime:(unsigned char)configtime
                                            error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndResetDefaultFactoryCalibrationData: command.
 *
 *  @discussion     A call to this method indicates that the BEEPCON has reset its TxPower calibration data to its factory settings for the actual TxPower Value
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndResetDefaultFactoryCalibrationData:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconDefaultFactoryCalibrationData:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewTxDbCalibrationData: command.
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its TxPower calibration data via the WriteToBeepconAndReset:NewTxDbCalibrationData: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewTxDbCalibrationData:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewTxDbCalibrationData:(id)thismanager withError:(NSError *)error;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewPassword: command.
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new password via the WriteToBeepconAndReset:NewPassword: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewPassword:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewPassword:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewName:NewDescription:NewUrl:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new information via the WriteToBeepconAndReset:NewName:NewDescription:NewUrl: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewName:NewDescription:NewUrl:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewTextInfo:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewIdHigh:NewIdLow:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new High and Low Ids via the WriteToBeepconAndReset:NewIdHigh:NewIdLow: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewIdHigh:NewIdLow:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewIdentifiers:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewTxRate:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new Tx Rate via the WriteToBeepconAndReset:NewTxRate: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewTxRate:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewTxRate:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewTxPower:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new Tx Power via the WriteToBeepconAndReset:NewTxPower: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewTxPower:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewTxPower:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewUUID:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new UUID via the WriteToBeepconAndReset:NewUUID: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewUUID:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteNewUUIDToBeepcon:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the              
 *                  WriteToBeepconAndReset:NewiBeaconTime:NewBeepconTime:NewEddystoneUIDTime:NewEddystoneURLTime:NewEddystoneTLMTime:NewConfigTime:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set its new broadcast pattern via the
 *                  WriteToBeepconAndReset:NewiBeaconTime:NewBeepconTime:NewEddystoneUIDTime:NewEddystoneURLTime:NewEddystoneTLMTime:NewConfigTime:
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewiBeaconTime:NewBeepconTime:NewEddystoneUIDTime:NewEddystoneURLTime:NewEddystoneTLMTime:NewConfigTime:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteNewTxPattern:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:NewFirmwareWithData:FirmwareName:
 *
 *  @discussion     A call to this method indicates the progress of the WriteToBeepconAndReset:NewFirmwareWithData:FirmwareName:
 *                  Due that a Firmare update command it´s a long time consuming command, the SDK periodically calls this function to allow the client App
 *                  to know exactly the actual status of the update.
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          PercentCompleted          A value 0..100 indicating the percent of the command completed
 *
 *  @param          completed                 TRUE when process has been completed.
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:NewFirmwareWithData:FirmwareName:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerReportsFirmwareUdateProgress:(id)thismanager withProgress:(unsigned char)PercentCompleted completed:(BOOL)completed error:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the WriteToBeepconAndReset:QuietMode:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has set o reset the quiet mode via WriteToBeepconAndReset:QuietMode: command
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            WriteToBeepconAndReset:QuietMode:
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidWriteToBeepconNewQuietMode:(id)thismanager withError:(NSError *)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Called to report the result of the ResetPasswordToFactorySettings:
 *
 *  @discussion     A call to this method indicates that the BEEPCON has reset the password via the ResetPasswordToFactorySettings:
 *
 *  @param          thismanager               The object of ITBeepconsManager class that is calling the delegate
 *
 *  @param          error                     NIL if no error. If not nil an error description is provided in this class.
 *
 *  @see            ResetPasswordToFactorySettings: 
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ITBeepconsManagerDidResetPasswordToFactory:(id)thismanager withError:(NSError *)error;

@end




//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*!
 *  @class           ITBeepconsManager
 *  @discussion      Class that wraps all the functions that can be performed with a BEEPCON Device using the
 *                   CoreBluetooth Framework. This class declares the protocol ITBeepconsManagerDelegate
 *  @see             ITBeepconsManagerDelegate
 *  @see             SDK USING GUIDE text file
 *
 *  @updated        2016-02-29
 *
 */
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
@interface ITBeepconsManager : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

/********************************************************************************************************************
  PUBLIC PROPERTIES
********************************************************************************************************************/

//*****************************************************************************************************************************************************************
/*!
 *  @brief          returns the actual SDK version number
 */
//*****************************************************************************************************************************************************************
@property (readonly) NSString *SDKVersion;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool that describes if the CentralManager (IOS) can be used. 
 *                  TRUE all is prepared to use the ITBeepconsManager scanning and connecting command.
 *                  FALSE, the bluetooh LowEnergy is not prepared to be used. (Ex. Buetooth not powered ON on the IOS device...etc)
 *                  See CentralStatus for a friendly decription of the actual status
 *
 *  @warning        Due that this property is updated when CoreBluetooth informs the SDK about the actual state, it´s value is not updated
 *                  inmediately once this class is instantiated. This means for example, that if you instatiate the class and inmediately check
 *                  this status(For example to start a Scan), you can get a FALSE value. You can use the ITBeepconsManagerHasChangedAuthorizationStatus:
 *                  to wait until iOS updates the value, with some extra own logic to perform this kind of tasks...
 */
//*****************************************************************************************************************************************************************
@property BOOL statusAllowsScanning;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          String describing the CentralManager (IOS) status reported by IOS
 */
//*****************************************************************************************************************************************************************
@property (readonly) NSString *CentralStatus;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate that an action is in progress with a BEEPCON (trying to connect, connected, executind an action ...)
 *                  Used to avoid new connection requests while one is active, because an Object of ITBeepconsManager only manages 1 action/beepcon at the same time
 *                  If the client App tries to perform a new action before the executing one is finished, the SDK will report an error.
 */
//*****************************************************************************************************************************************************************
@property (readonly) BOOL IsBeepconInProcess;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Max len that the BEEPCON Name can have in bytes
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MaxLenForName;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Max value for Tx rate (0..MaxValueForTxRate)
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MaxValueForTxRate;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Max value for Tx Power (0..MaxValueForTxPower)
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MaxValueForTxPower;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Max len that the BEEPCON Password can have in bytes
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MaxLenForPassword;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Min len that the BEEPCON Password can have in bytes
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MinLenForPassword;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Max time for any of the TxPatterns (ibeacon,Beepcon,EddystoneUid,EddystoneUrl,EddystoneTLM)
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MaxTimeForTxPattern;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Minimun Configuration Time
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MinConfigTime;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Maximun Configuration Time
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) unsigned char MaxConfigTime;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Max Calibrated Power in dbm
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) signed char   MaxPowerDB1m;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Bool to indicate the Min Calibrated Power in dbm
 *                  Its values are only valid once the BEEPCON is connected and Password has been validated, otherwise are ZEROED
 *                  Once BEEPCON is disconnected, they are zeroed also.
 *                  Read its values when ITBeepconsManagerDidValidatedPassword: is called with Password Validation success.
 */
//*****************************************************************************************************************************************************************
@property (readonly) signed char   MinPowerDB1m;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          NSDate property that indicates "how old" is the actual data that can be retrieved from the SDK via GetFoundedPeripherals:
 */
//*****************************************************************************************************************************************************************
@property (readonly) NSDate   *ScanStoredDataDate;


/********************************************************************************************************************
 INITIALIZATION ROUTINES
 ********************************************************************************************************************/

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Initialization Routine to init the ITBeepconsManager class prior to use it.
 *
 *  @param          thisDelegate                 Delegate to receive the answers of the ITBeepconsManager class via the ITBeepconsManagerDelegate Protocol
 *
 *  @see            ITBeepconsManagerDelegate
 *
 *  @return         id                           The ITBeepconsManager object
 *
 *  @updated        2016-02-29
 *
 *  @code           ManagerExample = [[ITBeepconsManager alloc] initWithDelegate:self];
 */
//*****************************************************************************************************************************************************************
- (id) initWithDelegate:(id <ITBeepconsManagerDelegate>)thisDelegate;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          sets the Delegate for the ITBeepconsManager class
 *
 *  @discussion     it is recommended to set the delegate via the initWithDelegate function. In any case you can use
 *                  this setDelegate function to change the actual delegate of an existing instance of this class.
 *
 *  @param          thisDelegate                 Delegate to receive the answers of the ITBeepconsManger class via the ITBeepconsManagerDelegate Protocol
 *
 *  @see            ITBeepconsManagerDelegate
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample setDelegate:self];
 */
//*****************************************************************************************************************************************************************
- (void)setDelegate:(id <ITBeepconsManagerDelegate>)thisDelegate;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          call this function tho change the UUID that the SDK will scan for.
 *                  The SDK only will show those BEEPCONS that have the same UUID that you have set.
 *                  When the class is created a default UUID is set F9403000-F5F8-466E-AFF9-25556B57FE6D
 *
 *  @param          UUID   the UUID to set, or nil to set the default BEEPCON UUID F9403000-F5F8-466E-AFF9-25556B57FE6D
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample setUUIDToScan:[CBUUID UUIDWithString:@"F9403000-F5F8-466E-AFF9-25556B57A55"]]
 */
//*****************************************************************************************************************************************************************
- (void)setUUIDToScan:(CBUUID *)UUID;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to start scanning for peripherals.
 *
 *  @discussion     The scan will be performed coninuosly until
 *                  StopScanningForPeripherals is called. The class will store all the founded peripherals internally
 *                  while scanning. Once stopped, you can retrieve the BEEPCONS detected via the GetFoundedPeripherals:
 *                  function. Be sure no Device is in progress (connected etc..) before attempting to begin a Scan or Scan
 *                  will return FALSE and not begin.
 *
 *  @param          Report                If set to TRUE, the scanner will continuosly report all founded packets of the BEEPCONS in range as soon as they are received.
 *                                        This BEEPCONS are reported via delegate with the 
 *                                        ITBeepconsManagerReportingBeepcon:withId:name:rssi:txPower:hiId:lowId:meanRSSI:numberOfBroadcasts:mac: protocol function
 *
 *  @see            ITBeepconsManagerReportingBeepcon:withId:name:rssi:txPower:hiId:lowId:meanRSSI:numberOfBroadcasts:mac:
 *
 *  @see            ITBeepconsManagerDidStartScanning:
 *
 *  @return         Boolean TRUE if scan started
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample StartScanningForPeripheralsWithReport:FALSE]
 */
//*****************************************************************************************************************************************************************
- (BOOL) StartScanningForPeripheralsWithReport:(BOOL)Report;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Sets the time that samples the recioved packets of a Beepcon, compute its media, and store internally in the SDK Data.
 *
 *  @discussion     This allows not only to have the total Mean RSSI of the Scan. You can also have partial RSSI computations of RSSI during time, and time referenced.
 *                  By this way, you can retrieve FoundedBeepcons in las X seconds, and the RSSII you get willbe the computed in only this X seconds..
 *
 *  @param          durationinseconds     recomended to 2
 *
 *  @see            GetFoundedPeripheralsWithOnlyFullInfo:WithMaxAgeInSeconds:AndFlushOlders:
 *
 *  @return         Boolean TRUE if vaklue was setted (zero or negative values are not allowed)
 *
 *  @warning        If you are not sure what are the real meaning and how it affects other computations for the SDK, dont touch this value. Also it needs to be set to
 *                  the desired value, before the Scan starts.
 *
 *  @updated        2016-10-14
 *
 *  @code           [ManagerExample SetSamplingRateForInternalRSSITimeTracker:2]
 */
//*****************************************************************************************************************************************************************
- (BOOL) SetSamplingRateForInternalRSSITimeTracker:(int)durationinseconds;


//*****************************************************************************************************************************************************************
// ---
// See COMPUTING MEDIAS DOC
// ---
// !!!!!!! Do not change if you are not sure what you are doing, refer to COMPUTING MEDIAS DOC !!!!!!!!
//
//

#define RSSIRAWDATA_SAMPLES_LIMIT 50            // Num of samples max to maintain in memory to compute average each period
                                                // SDK performance is affected if you increase it (and samples arrive). Typ 50

#define N_SIGMA_OUTLIERS_THRESHOLD 2            // Typical value 2.0 Recommended range 1.0 to 2.0

//
//
//*****************************************************************************************************************************************************************


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to start scanning for peripherals with Media advanced computing.
 *
 *  @discussion     This function is equivalent to StartScanningForPeripheralsWithReport: but it also starts the media computing engine included into the SDK
 *
 *  @param          Report                If set to TRUE, the scanner will continuosly report all founded packets of the BEEPCONS in range as soon as they are received.
 *                                        This BEEPCONS are reported via delegate with the
 *                                        ITBeepconsManagerReportingBeepcon:withId:name:rssi:txPower:hiId:lowId:meanRSSI:numberOfBroadcasts:mac: protocol function
 *
 *  @param          DecOfSeconds          Time between computed media reports in dec of seconds (Ex. 30 = 3 seconds)
 *
 *  @param          remove                Remove Outliners from the computation data
 *
 *  @param          PathLossExponent      Path Loss Exponent used for the pseudodistance calculation. A Standard Value is 2,0
 *
 *  @see            ITBeepconsManagerReportingBeepcon:withId:name:rssi:txPower:hiId:lowId:meanRSSI:numberOfBroadcasts:mac:
 *
 *  @see            ITBeepconsManagerDidStartScanning:
 *
 *  @see            ITBeepconsManagerReportingComputedMediaForBeepcon:
 *                                                           withId:
 *                                                        withMedia:
 *                                              withNumberofSamples:
 *                                                   withDesviation:
 *                                                      withMaxRssi:
 *                                                      withMinRssi:
 *                                        withPseudoDistanceAtMedia:
 *                                       withPseudoDistanceDevError:
 *                                                 outlinersRemoved:
 *
 *  @see            COMPUTING MEDIAS DOC
 *
 *  @return         Boolean TRUE if scan started
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample StartScanningForPeripheralsWithReport:FALSE WithMeanReportsEach:30 RemoveOutliners:TRUE pseudodistancePropagationPathLossExponent:2.0]
 */
//*****************************************************************************************************************************************************************
- (BOOL) StartScanningForPeripheralsWithReport:(BOOL)Report
                           WithMeanReportsEach:(NSInteger)DecOfSeconds
                               RemoveOutliners:(BOOL)remove
     pseudodistancePropagationPathLossExponent:(double) PathLossExponent;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Calling this function will refresh the SCAN order to IOS.
 *
 *  @discussion     During very Long SCANS (more than for example 20 segs) it seems that IOS becomes LAZY giving
 *                  reports of new packets. Calling this function will refresh the SCAN order to IOS and avoids this slow down.
 *                  The delegate ITBeepconsManagerDidStartScanning: will be called.
 *                  This function will not reset the information stored for the Original Scan.
 *
 *  @see            ITBeepconsManagerDidStartScanning:
 *
 *  @return         Boolean TRUE if scan restarted
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample ReinitiateScanningForPeripherals]
 */
//*****************************************************************************************************************************************************************
- (BOOL) ReinitiateScanningForPeripherals;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to stop scanning for peripherals.
 *
 *  @discussion     The scan will be stopped and a call to ITBeepconsManagerDidStopScanning to confirm
 *
 *  @see            ITBeepconsManagerReportingBeepcon:withId:name:rssi:txPower:hiId:lowId:meanRSSI:numberOfBroadcasts:mac:
 *
 *  @see            ITBeepconsManagerDidStopScanning:
 *
 *  @return         Boolean TRUE if scan stopped
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample StopScanningForPeripherals]
 */
//*****************************************************************************************************************************************************************
- (BOOL) StopScanningForPeripherals;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to get all founded BEEPCONS during the scan period.
 *
 *  @discussion     You can call this method to retrieve all the BEEPCONS encountered in range during of after a Scan process.
 *
 *  @param          OnlyFullInfoReceived   Sometimes the radio packets are not fully received, and some info (name, txpower...)
 *                  can be lost. If you set this Param to TRUE, only 100% perfect received packets are reported. Setting it to FALSE
 *                  will report all BEEPCONS , those with some info lossed included.
 *
 *  @see            ITFoundedBeepcon.h
 *
 *  @return         A NSArray of ITFoundedBeepcons objects
 *
 *  @updated        2016-02-29
 *
 *  @warning        Remember that if the CLient APP wants to have full control of the received information at "real time" you can call the
 *                  StartScanningForPeripheralsWithReport:(BOOL)Report with Report = TRUE, (ex. [ManagerExample StartScanningForPeripheralsWithReport:TRUE];)
 *
 *  @code           [ManagerExample GetFoundedPeripheralsWithOnlyFullInfo:FALSE]
 */
//*****************************************************************************************************************************************************************
- (NSArray *) GetFoundedPeripheralsWithOnlyFullInfo:(BOOL) OnlyFullInfoReceived;

- (NSArray *) GetFoundedPeripheralsWithOnlyFullInfo:(BOOL) OnlyFullInfoReceived WithMaxAgeInSeconds:(float)ageinseconds AndFlushOlders:(BOOL) flush;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to start the connection process to a BEEPCON.
 *
 *  @discussion     When you have the list of ITFoundedBeepcons, you can launch the process of connecting to one of them. There are many reason you may want
 *                  to connect to a BEEPCON. Some information is provided just scanning then without connection (Name, Major, Minor, TxPower) because this
 *                  is self contained in the broadcast packets. Other info, and actions, need a connection to be performed.
 *
 *  @param          WithThisFoundedBeepcon  A ITFoundedBeepcon Object to connect to
 *
 *  @param          password                A Passsword to be validate once the connection is established.
 *                                          Nil if password validation is not needed (Some actions require Password validation, others not)
 *
 *  @see            ITBeepconsManagerDidEstablishedTheConnection:
 *
 *  @see            ITBeepconsManagerDidValidatedPassword:isValidated:withError:
 *
 *  @updated        2016-02-29
 *
 *  @warning        BEEPCONS don´t allow you to establish a connection and keep it open during a long time without any activity. If you open a connection
 *                  and any activity is detected, the BEEPCON itself will disconnect. For correct use of BEEPCONS do not establish long time connections.
 *                  The recommended pattern is CONNECT - WAIT CONNECTION CALL - WAIT PASSWORD VALIDATION IF NEEDED - DO YOUR WORK - DISCONNECT.
 *
 *  @warning        Some actions do not require that the client App calls directly to disconnect, because the action will end with a BEEPCON Reset, and thus
 *                  an automatic disconnection from the BEEPCON Side.
 *
 *  @code           [ManagerExample ConnectToBeepcon:MyBeepcon withPassword:@"0123"];
 */
//*****************************************************************************************************************************************************************
- (void) ConnectToBeepcon:(ITFoundedBeepcon *)WithThisFoundedBeepcon withPassword:(NSString *)password;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          Call this function to start the disconnection process from a connected BEEPCON.
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to disconnect from
 *
 *  @see            ITBeepconsManagerDidTerminatedTheConnection:
 *
 *  @updated        2016-02-29
 *
 *  @code           [ManagerExample DisconnectFromBeepcon:MyBeepcon];
 */
//*****************************************************************************************************************************************************************
- (void) DisconnectFromBeepcon:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


/********************************************************************************************************************
 SET BEEPCON DATA AND WORKING PARAMS COMMAND ROUTINES
 ********************************************************************************************************************/

//*****************************************************************************************************************************************************************
/*!
 *  @brief          This functions is used to update a new firmware to the BEEPCON device.
 *
 *  @discussion     The process to enable an update prior to calling this function is :
 *
 *                  1.  Connect to the BEEPCON device (with password)
 *                  2.  Once password is validated make a call to ReadVersionNumber: and wait its corresponding answer
 *                      Read VersionNumber will refresh the BEEPCON device actual version code numbers, that are internally needed to perform and update.
 *                  3.  Once Version is readed call this function to start the update
 *
 *                  (During UPDATE if you want to CANCEL the process, simply Disconnect from the BEEPCON Device prior to finish the Update).
 *                  (During UPDATE the SDK will call the ITBeepconsManagerFirmwareUdateProgress: protocol function)
 *
 *
 *  @param          WithThisFoundedBeepcon The ITFoundedBeepcon Object to disconnect from
 *
 *  @param          firmwaredata           The NSData with the firmware file bytes
 *
 *  @param          firmwarename           The complete name of the file from where the firmware data was extracted used to check compatibility
 *                                         Ex. VC_M001H0300S0104010128F0007.ota
 *
 *  @see            ReadVersionNumber:
 *
 *  @see            ITBeepconsManagerDidReadBeepconVersion:
 *
 *  @see            ITBeepconsManagerReportsFirmwareUdateProgress:withProgress:completed:
 *
 *  @warning        Only use files supplied directly from Ilunion Tecnología y Accesibilidad.
 *                  The file name format of an upgrade is readed as follows (example)
 *
 *                  Firmware file name :
 *
 *                                  VC_M001H0102S0103020122F0301.ota
 *
 *                                  VC_          - Always starts with this preffix
 *                                  M001         - Beepcon device model 001
 *                                  H0102        - Beepcon device Hardware version 01.02
 *                                  S0103020122  - Internal bluetooh version 01.03.02.0122 (not included on file) or X0103020122 (included on file)
 *                                  F3010        - Firmware version 03.01
 *                                  .ota         - Always has this extension
 *
 *                                  When a Firmware contains a new full bluetooth stack you will see the stack version is SXXXXXXXXX
 *
 *                  Rules for upgrading :
 *
 *                                  Model and Hardware must much with the BEEPCON Device.
 *                                  Stack must be X?????????, or match the Stack Device, ex. S01030122
 *
 *                  The SDK will apply this rules to block a non compliant file and report an error.
 *
 *                  User APP can use CheckTheConnectedBeepconFirmwareCompatibilityWithOtaName: function to check if a firmware file is compliant.
 *
 *                  A Firmware Upgrade takes some minutes to be UPLOADED to the BEEPCON device.
 *
 *                  When a BEEPCON Device is firmware uploaded it will reset all its working parameters to factory. Its work for the user app to read first this
 *                  values, upgrade the firmware and then restore them if this feature is needed.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewFirmwareWithData:(NSData *)firmwaredata FirmwareName:(NSString *)firmwarename;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This functions is used to check if a firmware file is compatible with the connected device.
 *
 *  @discussion     The process to check the compatibility is
 *
 *                  1.  connect to the BEEPCON device (with password)
 *                  2.  Once password is validated make a call to ReadVersionNumber:  and wait its corresponding answer
 *                      Read VersionNumber will refresh the BEEPCON device actual version code numbers, that are internally needed to perform this check.
 *                  3.  Once version is readed you can call this function to check compatibility of your files.
 *
 *  @param          firmwarename           The complete name of the file from where the firmware data was extracted used to check compatibility
 *                                         Ex. VC_M001H0300S0104010128F0007.ota
 *
 *  @param          error                  Reference to an error to return a friendly description of non compatibilities.
 *
 *  @see            ReadVersionNumber:
 *
 *  @see            ITBeepconsManagerDidReadBeepconVersion:
 *
 *  @return         TRUE if Compatible, FALSE otherwise.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (BOOL) CheckTheConnectedBeepconFirmwareCompatibilityWithOtaName:(NSString *)firmwarename error:(NSError **)error;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will Reset the calibration TxPower for the actual TxPower value to factory settings.
 *
 *  @discussion     SDK will answer with a call to ITBeepconsManagerDidWriteToBeepconDefaultFactoryCalibrationData:withError:
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconDefaultFactoryCalibrationData:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndResetDefaultFactoryCalibrationData:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will Set the NewCalData as the new Calibrated TXPower for the actual TxPower Value.
 *
 *  @discussion     It´s a good practice to measure the Mean Tx Power (dBm at 1 metre) once the BEEPCON has been placed at its final location. Otherwise
 *                  the BEEPCONS will broadcast a factory default Calibration Data. It´s the Client App who manages how to measure this mean Tx Power. It is recommended
 *                  to have at least 30 samples of RSSI and measure at least 15 seconds.
 *
 *  @param          WithThisFoundedBeepcon The ITFoundedBeepcon Object to take the action
 *
 *  @param          NewCalData             The new TxPower in dBm (Ex. -62)
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewTxDbCalibrationData:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        the valid values can depend on BEEPCON Model, once connected and password validated you can read the valid
 *                  values from MaxPowerDB1m and MinPowerDB1m readonly properties.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewTxDbCalibrationData:(signed char) NewCalData;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will Set the a new Password for the BEEPCON.
 *
 *  @param          WithThisFoundedBeepcon The ITFoundedBeepcon Object to take the action
 *
 *  @param          newpassword            The new Password with NSUTF8StringEncoding format
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewPassword:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        the valid length for a new password can be read from the MinLenForPassword and MaxLenForPassword
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewPassword:(NSString *)newpassword;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will Set the Name, Description Text and Url to the BEEPCON
 *
 *  @param          WithThisFoundedBeepcon The ITFoundedBeepcon Object to take the action
 *
 *  @param          newname                The new name for the BEEPCON with MaxLenForName bytes using NSUTF8StringEncoding
 *
 *  @param          newdescription         The new text description for the BEEPCON with max 480 bytes using NSUTF8StringEncoding
 *
 *  @param          newurl                 The new URL  for the BEEPCON with max 160 bytes using NSUTF8StringEncoding
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewTextInfo:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        Care must be taken to compute the real lenght in BYTES of a string, because some characters can be more than 1
 *                  byte lenght. (ex. á, .....). The Max lengths given are in BYTES.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewName:(NSString *)newname NewDescription:(NSString *)newdescription NewUrl:(NSString *)newurl;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will Set the HiIOd (Major) and LowId (Minor) for the BEEPCON
 *
 *  @param          WithThisFoundedBeepcon The ITFoundedBeepcon Object to take the action
 *
 *  @param          HighId                 The HighId (Max 2 bytes wide value, 0..0xFFFF)
 *
 *  @param          LowId                  The Low Id (Max 2 bytes wide value, 0..0xFFFF)
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewIdentifiers:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewIdHigh:(unsigned short)HighId NewIdLow:(unsigned short)LowId;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will set the new TxPower for the BEEPCON. With this value you can set the radiofrecuency power level that the BEEPCON
 *                  will use to transmit its data, thus having some control of the range of the BEEPCON.
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @param          txpower                 The new tx power value (0..MaxValueForTxPower)
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewTxPower:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        the valid values can depend on BEEPCON Model, once connected a password validated you can read the valid
 *                  values from MaxValueForTxPower readonly properties.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewTxPower:(unsigned char)txpower;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will set the new TxRate for the BEEPCON. With this value you can set the rate at wich the BEEPCON will broadcast
 *                  its data (broadcasts per second). The Rate affects directly the power comsumption of the BEEPCON so this parameter must be changed with care, as
 *                  affects the battery life. The minimun TxRate that fits your use case is the recommended value.
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @param          txrate                  The new tx rate value (0..MaxValueForTxRate)
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewTxRate:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        the valid values can depend on BEEPCON Model, once connected a password validated you can read the valid
 *                  values from MaxValueForTxRate readonly properties.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewTxRate:(unsigned char)txrate;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will set the new UUID for the BEEPCON. Be aware that once changed the UUID, in order to find again
 *                  the BEEPCON you need to set this UUID via the setUUIDToScan: method prior to start a Scan.
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @param          NewUUID                 The new 16 bytes UUID
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewUUID:WithError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        changing the UUID affect both the BEEPCON broadcast the iBeacon Broadcast, so you need to
 *                  change also the UUID to Locate in ITBeepconsLocator if you want this BEEPCON to be detected as iBeacon.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewUUID:(CBUUID *)NewUUID;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will set the new Tx Pattern  to the BEEPCON. A pattern means how many seconds the BEEPCON DEVICE is broadcasting for each
 *                  supported format. (iBeacon, Beepcon, Eddystone UID, Eddsytone URL and Eddystone TLM). The broadcast is sequential.
 *                  Also you decide how many time from booting the BEEPCON DEVICE you can access the programming parameters.
 *                  (As a BEEPCON in case beepcontime is zeroed or as a Eddystone URL-config).
 *                  All time units are in seconds.
 *
 *                  (Ex. 1 2 0 1 0 30 : 1 Second as iBeacon, 2 seconds as Beepcon, No EddysUID, 1 second as Eddys URL, No Eddys TLM, 30 seconds configurable from boot)
 *
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @param          newibeacontime          iBeacon Spec broadcasting seconds
 *
 *  @param          newbeepcontime          Beepcon propietary protocol broadcating seconds
 *
 *  @param          neweddystoneuidtime     Eddystone UID Spec Broadcasting time
 *
 *  @param          neweddystoneurltime     Eddystone URL Broadcasting time
 *
 *  @param          neweddystonetlmtime     Eddystone TLM Broadcasting time
 *
 *  @param          newconfigtime           Config time from boot, broadcasting BEEPCON and Eddystone URL-Config protocols
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewUUID:WithError:
 *
 *  @see            MinConfigTime
 *
 *  @see            MaxConfigTime
 *
 *  @see            MaxTimeForTxPattern
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @warning        Depending on your final application you may want to Broadcast with different patterns, or give more time for one etc.... This function allows
 *                  you to adapt the BEEPCON DEVICE to fit your needs. A zero Value disables the Broadcast of the zeroed Type
 *                  In order to avoid extraneous configurations that can result in a non programmable Beepcon anymore...the config time minimun is limited by the DEVICE
 *                  itself, so at least you will have some seconds to connect to it from boot. See MinConfigTime and MaxConfigTime. Also the time to broadcast each
 *                  pattern is limited by MaxTimeForTxPattern
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon NewiBeaconTime:(unsigned char)newibeacontime
                                                                        NewBeepconTime:(unsigned char)newbeepcontime
                                                                        NewEddystoneUIDTime:(unsigned char)neweddystoneuidtime
                                                                        NewEddystoneURLTime:(unsigned char)neweddystoneurltime
                                                                        NewEddystoneTLMTime:(unsigned char)neweddystonetlmtime
                                                                        NewConfigTime:(unsigned char)newconfigtime;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will set the the BEEPCON to quiet mode. This means that the Beeping function will be limited to short "beeps" and this will override 
 *                  the user beeping preferences.
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @param          quietmode                TRUE go to quiet mode, FALSE respect user preferences
 *
 *  @see            ITBeepconsManagerDidWriteToBeepconNewQuietMode:withError:
 *
 *  @warning        Needs connection with password validated.
 *
 *  @warning        The action will Autoreset the BEEPCON and Disconnect the current connection.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) WriteToBeepconAndReset:(ITFoundedBeepcon *)WithThisFoundedBeepcon QuietMode:(BOOL)quietmode;


/********************************************************************************************************************
 READ BEEPCON DATA COMMAND ROUTINES
 ********************************************************************************************************************/

//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the text information self stored in the BEEPCON. (Text info and Url)
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadTextInfo:withText:url:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadBeepconTextInfo:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the battery level of the BEEPCON.
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadBattery:withVoltage:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadBeepconBattery:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will make the BEEPCON Buzz. This allows you to play a localization sound on the BEEPCON.
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @param          SoundType               A value in the range 0..2 each playing a different sound (see also quiet mode, that can override this parameter)
 *
 *  @see            ITBeepconsManagerDidBuzz:witherror:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Buzzing, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) BuzzBeepcon:(ITFoundedBeepcon *)WithThisFoundedBeepcon WithSoundType:(char)SoundType;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will make the Led of the BEEPCON (if available on the BEEPCON hardware model) light.
 *
 *  @param          WithThisFoundedBeepcon  The ITFoundedBeepcon Object to take the action
 *
 *  @param          seconds                 A value in the range 0..200 seconds (0 will turn Led OFF)
 *
 *  @see            ITBeepconsManagerDidLightLed:withError:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After turning the Led On, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) LightLed:(ITFoundedBeepcon *)WithThisFoundedBeepcon DuringSeconds:(unsigned char)seconds;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the Major, Minor (HiId and LowId) and physical MAC of the device.
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadBeepconIdentifiers:withIdMajor:idMinor:mac:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadBeepconIdMajorAndMinor:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the different descriptors for the BEEPCON version.
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadBeepconVersion:withHardVersion:firmVersion:stackVersion:modelCode:otaFileCheck:quietMode:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadVersionNumber:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the TxPower and the calibrated TxPower of the BEEPCON
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadBeepconPower:withTxPower:dbAtOneMeterCalibrated:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadTxPowerMode:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the TxRate of the BEEPCON
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadRate:withTxRate:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadTxRateMode:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will read the TxPattern of the BEEPCON
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidReadTxPattern:withIbeaconTime:beepconTime:eddystoneUIDTime:eddystoneURLTime:eddystoneTLMTime:configTime:error:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ReadTxPattern:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


//*****************************************************************************************************************************************************************
/*!
 *  @brief          This will reset teh Password to the factory one "0123"
 *
 *  @param          WithThisFoundedBeepcon   The ITFoundedBeepcon Object to take the action
 *
 *  @see            ITBeepconsManagerDidResetPasswordToFactory:withError:
 *
 *  @warning        Needs a connection established.
 *
 *  @warning        After Reading, if no more commands need to be sent, disconnect from the BEEPCON via the disconnection method
 *
 *  @warning        You can only reset the pasword if you open the BEEPCON, remove the battery and place the battery again. Once you have place the battery
 *                  you have the ConfigTime seconds to reset the password.
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
- (void) ResetPasswordToFactorySettings:(ITFoundedBeepcon *)WithThisFoundedBeepcon;


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
