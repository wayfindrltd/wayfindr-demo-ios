//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*!
 *       @header             ITFoundedBeepcon.h
 *       @discussion         Header containing ITFoundedBeepcon Class
 *                           THIS SOFTWARE CAN BE USED ONLY UNDER NDA DISCLOSURE AGREEMENT
 *                           THIS CLASS ENCAPSULATES ALL THE FUNCTIONS THAT CAN BE PERFORMED WITH A BEEPCON ACROSS THE COREBLUETOOTH FRAMEWORK
 *                           SOME KNOWLEDGE OF THE IOS COREBLUETOOTH FRAMEWORK IS RECOMMENDED
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


//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
/*!
 *  @class           ITFoundedBeepcon
 *  @discussion      Class that encapsulates a Beepcon as an object, widely used in this SDK.
 *  @warning         See the SDK USING GUIDE text file
 *
 *  @updated        2016-02-29
 */
//*****************************************************************************************************************************************************************
//*****************************************************************************************************************************************************************
@interface ITFoundedBeepcon : NSObject


//*****************************************************************************************************************************************************************
/*!
 *  @brief         This is NSUUID UNIQUE number that is internally asigned by IOS to this BEEPCON
 *                 Its only for internal USE because IOS can change randomly this number on time
 *                 Can be used to index dictionaries etc...
 */
//*****************************************************************************************************************************************************************
@property NSUUID   *identifier;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         This is the Mean RSSI (Received Signal Strengt) (dB) measured for this BEEPCON during the Scan Proccess
 */
//*****************************************************************************************************************************************************************
@property NSNumber *meanRSSInum;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         This is the Power Level at 1m that the BEEPCON is transmitting info (dB)
 */
//*****************************************************************************************************************************************************************
@property NSNumber *TxPowernum;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         This is the difference in dB of the meanRSSI and the TxPower. This value is proportional to the distance of the BEEPCON.
 */
//*****************************************************************************************************************************************************************
@property NSNumber *LossedPowernum;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         A string descriptor (like Very Close, Close, Far) of the estimated distance to the BEEPCON
 */
//*****************************************************************************************************************************************************************
@property NSString *ProximityDescription;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         Name of the BEEPCON, as broadcasted
 */
//*****************************************************************************************************************************************************************
@property NSString *name;

//
//*****************************************************************************************************************************************************************
/*!
 *  @brief         High Identifier Serial Number, also known as major
 */
//*****************************************************************************************************************************************************************
@property NSNumber *hiid;

//*****************************************************************************************************************************************************************
/*!
 *  @brief         Low Identifier Serial Number, also known as minor
 */
//*****************************************************************************************************************************************************************
@property NSNumber *loid;

//*****************************************************************************************************************************************************************
/*!
 *  @brief         Number of broadcasts recieved of this BEEPCON in the last Scan
 */
//*****************************************************************************************************************************************************************
@property NSNumber *NumberOfBroadcasts;

//*****************************************************************************************************************************************************************
/*!
 *  @brief         When the BEEPCON is connected, number of internal retries to make this connection
 */
//*****************************************************************************************************************************************************************
@property int NumOfRetries;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         When a connection or other error occurs, this field has a string with a friendlye description of the error
 */
//*****************************************************************************************************************************************************************
@property NSString *ErrorDesc;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         Sometimes not all the advertised information is received OK (name, meanRSSI, TxPower or Identifier). The SDK will report on
 *                 this field TRUE if all the fields ar OK ore FALSE if some of them are missing.
 */
//*****************************************************************************************************************************************************************
@property BOOL AllAdvertiseDataHasReceivedOK;

//*****************************************************************************************************************************************************************
/*!
 *  @brief         When using the internal Engine for media computing, holds a friendly description of last calculus
 */
//*****************************************************************************************************************************************************************
@property NSString *LastDataComputed;


//*****************************************************************************************************************************************************************
/*!
 *  @brief         Date in format NSDate of last packet received time-date (Usefull to determine the time a Beepcon has not been in range
 *                 This property must be set (if needed) by the Object Creator. On this version it is not included in the constructor method.
 */
//*****************************************************************************************************************************************************************
@property NSDate *LastPacketReceivedDate;




//*****************************************************************************************************************************************************************
/*!
 *  @brief          initializer for the ITFoundedBeepcon class
 *
 *  @param          thisname                 The Name of the BEEPCON
 *
 *  @param          thismeanrssi             The mean rssi of the BEEPCON
 *
 *  @param          thistxpower              The TxPower that the BEEPCON declares to transmit at 1m
 *
 *  @param          withthisloid             The Low Identifier
 *
 *  @param          withthishiid             The High Identifier
 *
 *  @param          WithThisMac              Deprecated
 *
 *  @return         The ITFoundedBeepcon Object
 *
 *  @warning        Normally you create ITFoundedBeepcon (if needed by the client APP) when some report is received via the ITBeepconsManager Class. For example
 *                  upon receiving a ITBeepconsManagerReportingWithId:Name:Rssi:TxPower:HiId:LowId:MeanRSSI:NumberOfBroadcasts:Mac:
 *                  During Scanning the SDK creates and maintains it´s own ITFoundedBeepcon objects that can the be retrieved via the GetFoundedPeripherals: method
 *
 *  @see            ITBeepconsManager.h
 *
 *  @see            ITBeepconsManagerReportingWithId:Name:Rssi:TxPower:HiId:LowId:MeanRSSI:NumberOfBroadcasts:Mac:
 *
 *  @see            GetFoundedPeripherals:
 */
//*****************************************************************************************************************************************************************
- (id) initWithIOSId:(NSUUID *)thisIOSident Name:(NSString *)thisname MeanRssi:(NSNumber *)thismeanrssi TxPower:(NSNumber *)thistxpower LoId:(NSNumber *)withthisloid HiId:(NSNumber *)withthishiid Mac:(NSString *)WithThisMac;



//*****************************************************************************************************************************************************************
/*!
 *  @brief          This merges the data of an existing ITFoundedBeepcon with the new data received, if they have the same IOS identifier.
 *
 *  @param          OldDevice                The existing ITFoundedBeepcon object
 *
 *  @param          thisIOSident             The IOS Id reported with the new data (Must be Equal to the ID of the ITfoundedBeepcon Object)
 *
 *  @param          thisname                 The Name of the Beepcon
 *
 *  @param          thismeanrssi             The mean rssi of the Beepcon
 *
 *  @param          thistxpower              The TxPower that the Beepcon declares to transmit at 1m
 *
 *  @param          withthisloid             The Low Identifier of the Beepcon
 *
 *  @param          withthishiid             The High Identifier of the Beepcon
 *
 *  @param          thismac                  Deprecated
 *
 *  @return         The ITFoundedBeepcon Object merged
 *
 *  @warning        During broadcasts, its possible that not all the information arrives correctly (for example, some field is missing). This function allows to merge the information that arrives in
 *                  different broadcasts of the same Beepcon.
 *
 *  @see            ITBeepconsManager.h
 *
 *  @see            ITBeepconsManagerReportingWithId:Name:Rssi:TxPower:HiId:LowId:MeanRSSI:NumberOfBroadcasts:Mac:
 *
 *  @see            GetFoundedPeripherals:
 */
//*****************************************************************************************************************************************************************
+ (ITFoundedBeepcon *) mergeDevice:(ITFoundedBeepcon *)OldDevice  WithIosId:(NSUUID *)thisIOSident WithName:(NSString *)thisname WithMeanRssi:(NSNumber *)thismeanrssi WithTxPower:(NSNumber *)thistxpower WithLoId:(NSNumber *)withthisloid WithHiId:(NSNumber *)withthishiid WiththisMac:(NSString *)thismac;

//*****************************************************************************************************************************************************************
/*!
 *  @brief          Returns a string with a friendly description of Lossed Power (Near, far...).
 *
 *  @param          lossedpower                The Lossed Power Value
 *
 *  @return         The friendly description in NSString Format
 *
 */
//*****************************************************************************************************************************************************************
+ (NSString *) GetProximityDescriptionOfLossedPower:(NSNumber *)lossedpower;

@end




