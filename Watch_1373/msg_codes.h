/*
 * @file      msg_codes.h
 * @author    Joel Schonberger
 * @copyright Copyright (c) 2015 LS Research, LLC
 *
 * @brief     This file defines the necessary messages codes to facilitate
 *            communication across the Watch Host, Watch BLE SoC,
 *            and Watch Mobile Application using LSR Messages.
 */
#ifndef _MSG_CODES_H_
#define _MSG_CODES_H_

/*******************************************************************************
 * Global Message Codes
 ******************************************************************************/

/** System LSR Message Codes
 *
 *  These values are meant to be used with LSR_MsgCode_t
 */
enum _MSG_CODES_
{
    // The intratask msg code allows a task to send a message to itself and
    // keep the details of the message private.
    INTRA_TASK_MSG_CODE = 0,

    GLOBAL_MSG_CODE_BASE = 1,
        ERROR_MSG_CODE,                                 // ErrorMsg_t
        SET_BLE_MODE_MSG_CODE,                          // SetBleModeMsg_t
        SET_BLE_MODE_ACK_MSG_CODE,                      // SetBleModeAckMsg_t
        CLEAR_BONDS_MSG_CODE,                           // ClearBondsMsg_t
        CLEAR_BONDS_ACK_MSG_CODE,                       // ClearBondsAckMsg_t
        GET_BLE_ADDRESS_MSG_CODE,                       // GetBleAddressMsg_t
        GET_BLE_ADDRESS_RSP_MSG_CODE,                   // GetBleAddressMsgRsp_t
        GET_BLE_FW_VERSION_MSG_CODE,                    // GetBleFwVersionMsg_t
        GET_BLE_FW_VERSION_RSP_MSG_CODE,                // GetBleFwVersionMsgRsp_t
        GET_BLE_STATE_MSG_CODE,                         // GetBleStateMsg_t
        GET_BLE_STATE_RSP_MSG_CODE,                     // GetBleStateMsgRsp_t
        BLE_STATE_ASYNC_MSG_CODE,                       // BleStateAsyncMsg_t
        DISPLAY_PASSKEY_ASYNC_MSG_CODE,                 // BlePasskeyAsyncMsg_t
        BLE_PAIRING_RESULT_ASYNC_MSG_CODE,              // BlePairingResultAsyncMsg_t
        BLE_RSSI_ASYNC_MSG_CODE,                        // BleRssiAsyncMsg_t
        SET_BLE_NAME_MSG_CODE,                          // SetBleNameMsg_t
        SET_BLE_NAME_ACK_MSG_CODE,                      // SetBleNameAckMsg_t
        SET_BLE_ADVERTISING_PARAMETERS_MSG_CODE,
        SET_BLE_ADVERTISING_PARAMETERS_ACK_MSG_CODE,
        BLE_ADVERTISING_PARAMETERS_ASYNC_MSG_CODE,
        SET_BLE_CONNECTION_PARAMETERS_MSG_CODE,         // SetBleConnectionParametersMsg_t
        SET_BLE_CONNECTION_PARAMETERS_ACK_MSG_CODE,     // SetBleConnectionParametersAckMsg_t
        BLE_CONNECTION_PARAMETERS_ASYNC_MSG_CODE,       // BleConnectionParametersAsyncMsg_t
        TIME_SYNC_MSG_CODE,
        CONNECTED_MSG_CODE,                             // LSR_Msg_t (No Payload)
        ONE_WAY_TEST_MSG_CODE,
        LOOPBACK_TEST_MSG_CODE,
        FW_PACKAGE_VERSION_ASYNC_MSG_CODE,              // WatchFirmwareVersionMsg_t
        DO_FW_DOWNLOAD_CODE,                            // LSR_Msg_t (No Payload)
        REQUEST_NEXT_FW_BLOCK_MSG_CODE,                 // RequestNextFirmwareBlock_t
        FW_UPDATE_DATA_MSG_CODE,                        // FirmwareUpdateDataMsg_t
        FITNESS_DASHBOARD_MSG_CODE,                     // PackedFitnessDashboardData_t
        FITNESS_DATA_MSG_CODE,                          // PackedFitnessData_t
        COLOR_PICKER_MSG_CODE,                          // ColorPickerMsg_t
        LAST_GLOBAL_MSG_CODE,

    /// Watch Host Internal Message Codes
    /// --> Add new codes to the Watch Host's internal_msgs.h file
    WATCH_HOST_MSG_CODE_BASE = 100,

    /// Watch BLE SoC Internal Message Codes
    WATCH_BLE_MSG_CODE_BASE = 200,

    LAST_MESSAGE_CODE, ///< NOTE: This is not accurate representation if Host or BLE bases are extended
};

/// Macro to determine if message code is a Global Message Code
#define IS_GLOBAL_MSG( msgCode )    ( ( ( msgCode ) > GLOBAL_MSG_CODE_BASE ) \
                                      && ( ( msgCode ) < LAST_GLOBAL_MSG_CODE ) )

#endif
/*******************************************************************************
 * End of File
 ******************************************************************************/
