/**
 * @file      global_msgs.h
 * @author    Joel Schonberger
 * @copyright Copyright (c) 2015 LS Research, LLC
 *
 * @brief     This file defines the necessary messages and type defintions to
 *            facilitate messaging across the Watch Host, Watch BLE SoC,
 *            and OneLink Mobile Application.
 *
 * Explicit type definitions are not used within messages to ensure that the
 * message structure sizes are as intended.  For instance, a enumerated type
 * is represented as int32_t, but the values can often be sent as a single uint8_t.
 * Avoid utilizing 'bool' in message types because the defintion of a bool
 * is often platform specific.
 */
#ifndef _GLOBAL_MSGS_H_
#define _GLOBAL_MSGS_H_

/*******************************************************************************
 * Pre-Processor Definitions
 ******************************************************************************/
     
#define FW_UPDATE_BLE_FRAGMENT_SIZE                     128

/*******************************************************************************
 * Global Type Definitions
 ******************************************************************************/

/*******************************************************************************
 * Global Message Definitions
 ******************************************************************************/

#ifndef __NO_LSR_C_FRAMEWORK_PACK__
#pragma pack(push, 1) /// Save existing packing mode, and set byte alignment
#endif


#ifndef BLE_SOC_APPLICATION
  #define BLE_SOC_APPLICATION (FALSE)
#endif

#if BLE_SOC_APPLICATION

  typedef uint8 header[6];
  typedef header LSR_MsgHeader_t;
  ASSERT_SIZE(LSR_MsgHeader_t, MESSAGE_HEADER_LENGTH);

  typedef enum _MSG_CODES_ MessageCode_t;
  ASSERT_SIZE(MessageCode_t, 1);

  typedef enum _MSG_IDS_ MessageId_t;
  ASSERT_SIZE(MessageId_t, 1);

#else

  #define ASSERT_SIZE(x,y)
  
  #define SIZE_OF_NUL (1)

  #define boolean uint8_t
  
  #define string_t char
  
#endif



typedef enum
{
    BLE_MODE_IDLE,          // Radio is off
    BLE_MODE_CONNECTABLE    // Advertising, connected, re-connects, etc.

} BleMode_t;

ASSERT_SIZE(BleMode_t, 1);

typedef enum
{
    STATUS_OK = 0x00,   ///< Anything other than 0 is failure. See @ref comdef.h or @ref bcomdef.h

} BleStatus_t;

typedef struct
{
    uint8_t mode;       ///< See @ref BleMode_t
    uint8_t status;     ///< See @ref BleStatus_t

} BleModePayload_t;



typedef struct
{
    LSR_MsgHeader_t header;
    BleModePayload_t payload;

} SetBleModeMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleModePayload_t payload;

} SetBleModeAckMsg_t;



#define BLE_ADDRESS_LENGTH  (6)

typedef struct
{
    uint8_t address[BLE_ADDRESS_LENGTH];

} BleAddressPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;

} GetBleAddressMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleAddressPayload_t payload;

} GetBleAddressMsgRsp_t;



typedef struct
{
    LSR_MsgHeader_t header;
    uint32_t secTime;       ///< Seconds since Jan 1, <LSR_RTC_YEAR_BASE> 00:00:00

} TimeSyncMsg_t;



#define MAXIMUM_LENGTH_OF_VERSION (32)

typedef struct
{
    uint8_t length;
    string_t version[MAXIMUM_LENGTH_OF_VERSION + SIZE_OF_NUL];

} BleVersionPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;

} GetBleFwVersionMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleVersionPayload_t payload;

} GetBleFwVersionMsgRsp_t;



// discuss: would individual messages be better?
// or is fewer messages better?
// ble connected, ble disconnected
// ble_pairing_success == bonded
typedef struct
{
    boolean initialized;
    boolean connected;  
    boolean linkLayerEncrypted;       
    boolean authenticated;
    boolean bonded;
    boolean keyExchangeBusy;
    boolean applicationLayerEncrypted;
    boolean ancsDiscovered;
    boolean ancsSubscribed;
    
} BleStatePayload_t;

ASSERT_SIZE(BleStatePayload_t, 9);

typedef struct
{
    LSR_MsgHeader_t header;

} GetBleStateMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleStatePayload_t payload;

} GetBleStateMsgRsp_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleStatePayload_t payload;

} BleStateAsyncMsg_t;



typedef struct
{
    uint32_t passkey;

} BlePasskeyPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BlePasskeyPayload_t payload;

} BlePasskeyAsyncMsg_t;

typedef enum
{
    BLE_PAIRING_RESULT_SUCCESS,  // The display passkey message indicates that pairing has started.
    BLE_PAIRING_RESULT_TIMEOUT,  // This can occur if a connection isn't made (pairing isn't started)
                                 // or if pairing doesn't complete in a certain amount of time.
    BLE_PAIRING_RESULT_INVALID_PIN,

} BlePairingResult_t;

typedef struct
{
    uint8_t pairingResult;          // See @ref BlePairingResult_t

} BlePairingResultPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BlePairingResultPayload_t payload;

} BlePairingResultAsyncMsg_t;



enum eBleRssi
{
    INVALID_RSSI_LEVEL = 0,     ///< not used, makes debug print of level more natural
        RSSI_LEVEL_1,           ///< Lowest
        RSSI_LEVEL_2,           ///<
        RSSI_LEVEL_3,           ///<
        RSSI_LEVEL_4,           ///< Highest
    NUM_RSSI_LEVELS
};

typedef enum eBleRssi BleRssi_t;
ASSERT_SIZE(BleRssi_t, 1);

typedef struct
{
    uint8_t rssi;  // @ref BleRssi_t

} BleRssiPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleRssiPayload_t payload;

} BleRssiAsyncMsg_t;



#define MAXIMUM_LENGTH_OF_NAME (28)  // @ref BluetoothUtilities.h

typedef struct
{
    string_t name[MAXIMUM_LENGTH_OF_NAME + SIZE_OF_NUL];
    uint8_t status;

} BleNamePayload_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleNamePayload_t payload;

} SetBleNameMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleNamePayload_t payload;

} SetBleNameAckMsg_t;



// in the response the min/max connection intervals will be the same because
// they are the actual connection interval
typedef struct
{
    uint16_t minConnectionIntervalMs;
    uint16_t maxConnectionIntervalMs;
    uint16_t slaveLatency; // in intervals
    uint16_t connectionTimeoutMs;
    uint8_t status;

} BleConnectionParametersPayload_t;

ASSERT_SIZE(BleConnectionParametersPayload_t, 9);

typedef struct
{
    LSR_MsgHeader_t header;
    BleConnectionParametersPayload_t payload;

} SetBleConnectionParametersMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleConnectionParametersPayload_t payload;

} SetBleConnectionParametersAckMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    BleConnectionParametersPayload_t payload;

} BleConnectionParametersAsyncMsg_t;




typedef struct
{
    uint8_t status;     ///< See @ref BleStatus_t

} ClearBondsPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;

} ClearBondsMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    ClearBondsPayload_t payload;

} ClearBondsAckMsg_t;




#define TEST_PAYLOAD_MAX_LENGTH     (128-6)

typedef struct
{
    uint8_t data[TEST_PAYLOAD_MAX_LENGTH];

} TestPayload_t;

typedef struct
{
    LSR_MsgHeader_t header;
    TestPayload_t testPayload;

} TestMsg_t;


//
// Firmware update messages
// 
typedef struct
{
    LSR_MsgHeader_t header;
    
    // Device's current version
    uint8_t major;
    uint8_t minor;
    uint8_t build;
    
} WatchFirmwareVersionMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    uint16_t blockSize;
    
} RequestNextFirmwareBlockMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    uint8_t size;
    uint8_t data[FW_UPDATE_BLE_FRAGMENT_SIZE];
    
} FirmwareUpdateDataMsg_t;


/** Fit Data Task Messages */

// Packed Fitness data sizes and offsets
#define FITNESS_DASHBORAD_PACKED_SIZE       (10)
#define FITNESS_DATA_PACKED_SIZE            (14)
   
#define CURRENTSTEPS_SIZE                   (14)
#define CURRENT_STEPS_OFFSET                (13)
#define CURRENTHEARTRATE_SIZE               (8)
#define CURRENTHEARTRATE_OFFSET             (21)
#define CURRENTCALORIES_SIZE                (13)
#define CURRENTCALORIES_OFFSET              (34)
#define CURRENTSLEEP_SIZE                   (11)
#define CURRENTSLEEP_OFFSET                 (45)
#define CURRENTACTIVEMINUTES_SIZE           (11)
#define CURRENTACTIVEMINUTES_OFFSET         (56)
#define CURRENTSPO2_SIZE                    (7)
#define CURRENTSPO2_OFFSET                  (63)
#define CURRENTVO2_SIZE                     (7)
#define CURRENTVO2_OFFSET                   (70)
#define CURRENTACTIVITY_SIZE                (3)
#define CURRENTACTIVITY_OFFSET              (73)
   // TODO: wck remove need for dual offsets and sizing
#define TIMESTAMP_SIZE                      (16)
#define TIMESTAMP_OFFSET1                   (89)
#define TIMESTAMP_OFFSET2                   (105) 

typedef struct _LSR_FitnessData_ //< Used for the unpacked FITNESS_DATA_MSG_CODE message
{
    uint32_t currentTotalSteps;
    uint8_t currentHeartRate;
    uint16_t currentCaloriesBurned;
    uint16_t currentSleepMinutes;
    uint16_t currentTotalActiveMinutes;
    uint8_t currentSpO2Value;
    uint8_t currentVO2Value;
    uint8_t currentActivity;
    uint32_t timestamp;
} LSR_FitnessData_t;


typedef struct _PackedFitnessDataMsg_ //< Used for the packed FITNESS_DATA_MSG_CODE message
{
    LSR_MsgHeader_t header;     ///< LSR Message Header
    uint8_t data[FITNESS_DATA_PACKED_SIZE];
} PackedFitnessDataMsg_t;

typedef struct _LSR_FitnessDashboardData_ //< Used for the unpacked FITNESS_DASHBOARD_MSG_CODE message
{
    uint32_t currentTotalSteps;
    uint8_t currentHeartRate;
    uint16_t currentCaloriesBurned;
    uint16_t currentSleepMinutes;
    uint16_t currentTotalActiveMinutes;
    uint8_t currentSpO2Value;
    uint8_t currentVO2Value;
    uint8_t currentActivity;
} LSR_FitnessDashboardData_t;

typedef struct _PackedFitnessDashboardDataMsg_//< Used for the packed FITNESS_DASHBOARD_MSG_CODE message
{
    LSR_MsgHeader_t header;     ///< LSR Message Header
    uint8_t data[FITNESS_DASHBORAD_PACKED_SIZE];
} PackedFitnessDashboardDataMsg_t;

typedef struct
{
    LSR_MsgHeader_t header;
    uint32_t color;
} ColorPickerMsg_t;

#define ERROR_MSG_MAX_FILENAME_LENGTH   (24)
#define ERROR_MSG_MAX_PARAMS            (4)

typedef struct
{
    LSR_MsgHeader_t header;                       ///< LSR Message Header
    uint16_t errNo;                               ///< Error number (Refer to lsr_error_num.h or watch_error_dictionary.json)
    char filename[ERROR_MSG_MAX_FILENAME_LENGTH]; ///< Calling Filename (static, could use __FILE__)
    uint16_t lineNo;                              ///< Calling Line Number (could use __LINE__)
    uint16_t mask;                                ///< Error Parameter Mask (refer to LSR_ErrorParam_Options)
    uint32_t param[ERROR_MSG_MAX_PARAMS];         ///< Error Parameters (everything stored as uint32_t)
    uint32_t time;                                ///< Error Time (obtained with lsr_error_get_time())
} ErrorMsg_t;






#ifndef __NO_LSR_C_FRAMEWORK_PACK__
#pragma pack(pop) /// Restore previous packing mode
#endif

#endif
/*******************************************************************************
 * End of File
 ******************************************************************************/
