/*
 * @file      msg_ids.h
 * @author    Joel Schonberger
 * @copyright Copyright (c) 2015 LS Research, LLC
 *
 * @brief     This file defines the necessary messages IDs to facilitate
 *            communication across the Watch Host, Watch BLE SoC,
 *            and Watch Mobile Application using LSR Messages.
 */
#ifndef _MSG_IDS_H_
#define _MSG_IDS_H_

/*******************************************************************************
 * Global Message Receiver IDs
 ******************************************************************************/

/** System LSR Message Receiver IDs
 *
 *  These values are meant to be used with LSR_MsgID_t
 */
enum _MSG_IDS_
{
    /// Watch Host Processor Message Receivers
    WATCH_HOST_NODE_ID = 10,
        WATCH_HOST_MANAGER_ID,
        WATCH_HOST_DISPLAY_ID,
        WATCH_HOST_FIT_ANALYZER_ID,
        WATCH_HOST_FIT_DATA_ID,
        WATCH_HOST_FIT_GOAL_ID,
        WATCH_HOST_FIT_SENSOR_ID,
        WATCH_HOST_PWR_MGT_ID,
        WATCH_HOST_USER_INTF_ID,
        WATCH_HOST_SETTINGS_ID,
        WATCH_HOST_PANIC_ID,
        WATCH_HOST_TIME_MGT_ID,
        WATCH_HOST_TRANSPORTER_TX_ID,
        WATCH_HOST_TRANSPORTER_RX_ID,
        WATCH_HOST_BLE_ID,
        LAST_WATCH_HOST_ID,

    /// Watch BLE Processor Message Receivers
    WATCH_BLE_NODE_ID = 50,
        WATCH_BLE_CLI_ID,
        WATCH_BLE_HSI_ID,
        LAST_WATCH_BLE_ID,

    /// Watch Mobile Application Message Receivers
    WATCH_MOBILE_APP_NODE_ID = 100,
        LAST_WATCH_MOBILE_APP_ID,
};

/// Macro to determine if the Receiver Id is the Host Processor Node Id
#define IS_WATCH_HOST_NODE_ID( id )          ( ( id ) == WATCH_HOST_NODE_ID )

/// Macro to determine if the Receiver Id is within the Host Processor
#define IS_WATCH_HOST_TASK_ID( id )          ( ( ( id ) > WATCH_HOST_NODE_ID ) \
                                               && ( ( id ) < LAST_WATCH_HOST_ID ) )

/// Macro to determine if the Receiver Id is the BLE Processor Node Id
#define IS_WATCH_BLE_NODE_ID( id )           ( ( id ) == WATCH_BLE_NODE_ID )

/// Macro to determine if the Receiver Id is within the BLE Processor
#define IS_WATCH_BLE_TASK_ID( id )           ( ( ( id ) > WATCH_BLE_NODE_ID ) \
                                               && ( ( id ) < LAST_WATCH_BLE_ID ) )

/// Macro to determine if the Receiver Id is the Mobile Application Node Id
#define IS_WATCH_MOBILE_APP_NODE_ID( id )    ( ( id ) == WATCH_MOBILE_APP_NODE_ID )

/// Macro to determine if the Receiver Id is within the Mobile Application
#define IS_WATCH_MOBILE_APP_TASK_ID( id )    ( ( ( id ) > WATCH_MOBILE_APP_NODE_ID ) \
                                               && ( ( id ) < LAST_WATCH_MOBILE_APP_ID ) )

#endif
/*******************************************************************************
 * End of File
 ******************************************************************************/
