/**
 * @file      lsr_msg.h
 * @author    Joel Schonberger
 * @copyright Copyright (c) 2014 LS Research, LLC
 *
 * @brief    This header includes defintions needed for the LSR Message structure.
 *
 * The LSR Message allows standardization of messaging for inter-process
 * communication (IPC) as well as device-to-device communication.  Although the
 * LSR Message can standalone, it is intended to be used with the LSR Message
 * Framework.
 *
 * To make the LSR Message as flexible as possible a number of header sizing
 * options are available.  If using LSR Messages for device-to-device communication
 * the same header structure (sizing options) must be utilizied.  To help facilitate
 * device-to-device communicatinos some endian information is provided within the
 * header.  This allows devices receiving LSR messages to test the provided endian
 * value against a known value to determine if the header and/or payload needs swapped.
 *
 * Device-to-device communication is handled by the "transporter".  Refer to the
 * LSR Message Framework for further documentation regarding the "transporter".
 */

#ifndef _LSR_MSG_H_
#define _LSR_MSG_H_

/*******************************************************************************
 * Includes
 ******************************************************************************/

#ifndef __NO_LSR_C_FRAMEWORK_H__

#include "lsr.h"
#include "lsr_endian_utils.h"

#endif

EXTERN_C_BEGIN

/*******************************************************************************
 * Pre-Processor Definitions
 ******************************************************************************/

/// LSR Message Header Size Options (Refer to Type Definitions Section for usage)
#define LSR_MSG_LARGE_HEADER           (0) ///< 32-bit header fields
#define LSR_MSG_MEDIUM_HEADER          (1) ///< 16-bit header fields
#define LSR_MSG_SMALL_HEADER           (2) ///< 8-bit header fields
#define LSR_MSG_CUSTOM_HEADER          (3) ///< Custom header fields

/// Use a Medium Message Header by Default
#ifndef LSR_MSG_HEADER_SIZE_OPT
    #define LSR_MSG_HEADER_SIZE_OPT    (LSR_MSG_MEDIUM_HEADER)
#endif

/// Disable Device-to-Device Transporters by Default
#ifndef LSR_MSG_INTERTASK_ONLY
    #define LSR_MSG_INTERTASK_ONLY     (TRUE)
#endif

/// Default endian swapping to reflect the intertask-only setting
#ifndef LSR_MSG_ENDIAN_SWAPPING
    #define LSR_MSG_ENDIAN_SWAPPING    (!LSR_MSG_INTERTASK_ONLY)
#endif

/// Setup the default LSR Message Alloc (allocates memory of a LSR_Msg_t structure)
/// This is used to allocate message buffers
#ifndef LSR_MSG_MALLOC
    #define LSR_MSG_MALLOC(s)           lsr_buf_calloc(s, THIS_FILE, __LINE__)
#endif

/// Setup the default LSR Message Alloc from ISR (allocates memory of a LSR_Msg_t structure)
/// This is used to allocate message buffers in an ISR safe manner
#ifndef LSR_MSG_ISR_MALLOC
    #define LSR_MSG_ISR_MALLOC(s)       lsr_buf_calloc_from_isr(s, THIS_FILE, __LINE__)
#endif

/// Setup the default LSR Message Free (deallocates memory of a LSR_Msg_t structure)
/// This is used to free message buffers
#ifndef LSR_MSG_FREE
    #define LSR_MSG_FREE(p)             lsr_buf_free(p, THIS_FILE, __LINE__)
#endif

/// Setup the default LSR Message Free from ISR (deallocates memory of a LSR_Msg_t structure)
/// This is used to free message buffers in an ISR safe manner
#ifndef LSR_MSG_ISR_FREE
    #define LSR_MSG_ISR_FREE(p)         lsr_buf_free_from_isr(p, THIS_FILE, __LINE__)
#endif

/// Value used to test endianess
#define LSR_MSG_ENDIAN_TEST_VALUE      (0x1234)

/// Invalid Receiver or Transmitter ID
#define LSR_MSG_INVALID_ID             ((LSR_MsgID_t) (~0))

/// Default reserved byte value
#define LSR_MSG_RSVD_DEFAULT           (0)

/**
 * @brief LSR_MSG_INIT is a macro used to initialize a LSR Message with
 *        default arguments.
 *
 * @param pHeader - Pointer to the LSR Message Header
 * @param msgCode - Message code used to identify the type of message
 * @param msgType - Data type of message (struct containing LSR_MsgHeader_t)
 * @param txID    - The ID of the message sender
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_header_init directly
 *
 * Example:
 *
 *     // Set Mode of Operation Message
 *     typedef struct _SetModeMsg_
 *     {
 *         LSR_MsgHeader_t header;
 *         // Payload
 *         OpMode_t    mode;      // Idle, Connect, Status Update, Data Transfer
 *         OpModeReq_t requestor; // Host, Link, Auto
 *    } SetModeMsg_t;
 *
 *    // This example uses dynamic allocation, but it could be statically
 *    // allocated or pulled from a memory pool
 *    pSetModeMsg = (SetModeMsg_t*) LSR_MSG_MALLOC( sizeof( SetModeMsg_t ) );
 *
 *    // Initialize the Message Header
 *    LSR_MSG_INIT( &( pSetModeMsg->header ), // Pointer to the message header
 *                  SET_MODE_MSG,             // Message Code known to the sender and receiver
 *                  SetModeMsg_t,             // Type provided to determine size of message
 *                  MY_MSG_ID );              // Message ID of the sender (it's receiver ID)
 */
#define LSR_MSG_INIT( pHeader, msgCode, msgType, txID ) \
    lsr_msg_header_init( ( pHeader ), \
                         (LSR_MsgCode_t) ( msgCode ), \
                         (LSR_MsgSize_t) ( sizeof( msgType ) ), \
                         (LSR_MsgID_t) LSR_MSG_INVALID_ID, \
                         (LSR_MsgID_t) ( txID ), \
                         (LSR_MsgOptions_t) LSR_MSG_OPT_DEFAULT, \
                         (LSR_MsgReserved_t) LSR_MSG_RSVD_DEFAULT )

/**
 * @brief LSR_MSG_EMPTY_INIT is a macro used to initialize an empty LSR Message with
 *        default arguments.
 *
 * @param pHeader - Pointer to the LSR Message Header
 * @param msgCode - Message code used to identify the type of message
 * @param txID    - The ID of the message sender
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_header_init directly
 *
 * Example:
 *
 *    // This example uses dynamic allocation, but it could be statically
 *    // allocated or pulled from a memory pool
 *    pMsg = (LSR_Msg_t *) LSR_MSG_MALLOC( sizeof( LSR_Msg_t ) );
 *
 *    // Initialize the Message Header
 *    LSR_MSG_EMPTY_INIT( &( pMsg->header ),     // Pointer to the message header
 *                        USER_BUTTON_PRESS_MSG, // Message Code known to the sender and receiver
 *                        MY_MSG_ID );           // Message ID of the sender (it's receiver ID)
 */
#define LSR_MSG_EMPTY_INIT( pHeader, msgCode, txID ) \
    lsr_msg_header_init( ( pHeader ), \
                         (LSR_MsgCode_t) ( msgCode ), \
                         (LSR_MsgSize_t) ( sizeof( LSR_MsgHeader_t ) ), \
                         (LSR_MsgID_t) LSR_MSG_INVALID_ID, \
                         (LSR_MsgID_t) ( txID ), \
                         (LSR_MsgOptions_t) LSR_MSG_OPT_DEFAULT, \
                         (LSR_MsgReserved_t) LSR_MSG_RSVD_DEFAULT )

/**
 * @brief LSR_MSG_CBACK_INIT is a macro used to initialize a LSR Callback
 *        Message with default arguments.
 *
 * @param pHeader - Pointer to the LSR Message Header
 * @param msgCode - Message code used to identify the type of message
 * @param msgType - Data type of message (struct containing LSR_MsgHeader_t)
 * @param txID    - The ID of the message sender
 * @param pCB     - Callback function pointer. See LSR_MsgCBackHeader_t
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_header_init directly
 *
 * Example:
 *
 *     // Set Mode of Operation Message
 *     typedef struct _SetModeMsg_
 *     {
 *         LSR_MsgCBackHeader_t header;
 *         // Payload
 *         OpMode_t    mode;      // Idle, Connect, Status Update, Data Transfer
 *         OpModeReq_t requestor; // Host, Link, Auto
 *    } SetModeMsg_t;
 *
 *    // This example uses dynamic allocation, but it could be statically
 *    // allocated or pulled from a memory pool
 *    pSetModeMsg = (SetModeMsg_t*) LSR_MSG_MALLOC( sizeof( SetModeMsg_t ) );
 *
 *    // Initialize the Message Header
 *    LSR_MSG_INIT( &( pSetModeMsg->header ), // Pointer to the message header
 *                  SET_MODE_MSG,             // Message Code known to the sender and receiver
 *                  SetModeMsg_t,             // Type provided to determine size of message
 *                  MY_MSG_ID,                // Message ID of the sender (it's receiver ID)
 *                  NULL );                   // Callback function pointer or NULL if no callback
 */
#define LSR_MSG_CBACK_INIT( pHeader, msgCode, msgType, txID, pCB ) \
    lsr_msg_header_init( ( (LSR_MsgHeader_t*)(pHeader) ), \
                           (LSR_MsgCode_t) ( msgCode ), \
                           (LSR_MsgSize_t) ( sizeof( msgType ) ), \
                           (LSR_MsgID_t) LSR_MSG_INVALID_ID, \
                           (LSR_MsgID_t) ( txID ), \
                           (LSR_MsgOptions_t) LSR_MSG_OPT_DEFAULT, \
                           (LSR_MsgReserved_t) LSR_MSG_RSVD_DEFAULT ); \
    (pHeader)->pCBack = (pCB);

/**
 * @brief LSR_MSG_EMPTY_CBACK_INIT is a macro used to initialize an empty LSR
 *        Callback Message with default arguments.
 *
 * @param pHeader - Pointer to the LSR Message Header
 * @param msgCode - Message code used to identify the type of message
 * @param txID    - The ID of the message sender
 * @param pCB     - Callback function pointer. See LSR_MsgCBackHeader_t
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_header_init directly
 *
 * Example:
 *
 *    // This example uses dynamic allocation, but it could be statically
 *    // allocated or pulled from a memory pool
 *    pMsg = (LSR_Msg_t *) LSR_MSG_MALLOC( sizeof( LSR_Msg_t ) );
 *
 *    // Initialize the Message Header
 *    LSR_MSG_EMPTY_CBACK_INIT( (LSR_MsgCBackHeader_t*)&( pMsg->header ), // Pointer to the message header
 *                              USER_BUTTON_PRESS_MSG,                    // Message Code known to the sender and receiver
 *                              MY_MSG_ID,                                // Message ID of the sender (it's receiver ID)
 *                              NULL );                                   // Callback function pointer or NULL if no callback
 */
#define LSR_MSG_EMPTY_CBACK_INIT( pHeader, msgCode, txID, pCB ) \
    lsr_msg_header_init( ( (LSR_MsgHeader_t*)(pHeader) ), \
                           (LSR_MsgCode_t) ( msgCode ), \
                           (LSR_MsgSize_t) ( sizeof( LSR_MsgCBackHeader_t ) ), \
                           (LSR_MsgID_t) LSR_MSG_INVALID_ID, \
                           (LSR_MsgID_t) ( txID ), \
                           (LSR_MsgOptions_t) LSR_MSG_OPT_DEFAULT, \
                           (LSR_MsgReserved_t) LSR_MSG_RSVD_DEFAULT ); \
    (pHeader)->pCBack = (pCB);

/**
 * @brief LSR_MSG_SEND is a macro used to send a LSR Message utilizing the
 *        LSR Message Framework.
 *
 * @param rxID  - the ID of the message receiver
 * @param pData - pointer to the buffer containing the LSR Message Header
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_framework_send directly.  This macro assumes that the
 * string THIS_FILE exists in each file in which it is called from.
 *
 * Example:
 *
 *     // Assuming LSR_MSG_INIT has already been called
 *
 *     if ( LSR_MSG_SEND( MODE_MANAGER_MSG_ID, pSetModeMsg ) != LSR_OK )
 *     {
 *         LSR_TRACE0( THIS_FILE, __LINE__, LSR_TRACE_ERROR_LEVEL,
 *                     "Failed to send LSR Message to 0x%x",
 *                     MODE_MANAGER_MSG_ID );
 *
 *
 *         LSR_ASSERT_FORCE( THIS_FILE, __LINE__ );
 *
 *         LSR_MSG_FREE( pMsg );
 *     }
 */
#define LSR_MSG_SEND( rxID, pData ) \
    lsr_msg_framework_send( (LSR_MsgID_t) ( rxID ), \
                            (LSR_Msg_t*) ( pData ), \
                            THIS_FILE, \
                            __LINE__ )

/**
 * @brief LSR_MSG_SEND_TO_FRONT is a macro used to send a LSR Message
 *        utilizing the LSR Message Framework.
 *
 * @param rxID  - the ID of the message receiver
 * @param pData - pointer to the buffer containing the LSR Message Header
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_framework_send_to_front directly.  This macro assumes that the
 * string THIS_FILE exists in each file in which it is called from.
 *
 * Example:
 *
 *     // Assuming LSR_MSG_INIT has already been called
 *
 *     if ( LSR_MSG_SEND_TO_FRONT( MODE_MANAGER_MSG_ID, pSetModeMsg ) != LSR_OK )
 *     {
 *         LSR_TRACE0( THIS_FILE, __LINE__, LSR_TRACE_ERROR_LEVEL,
 *                     "Failed to send LSR Message to 0x%x",
 *                     MODE_MANAGER_MSG_ID );
 *
 *
 *         LSR_ASSERT_FORCE( THIS_FILE, __LINE__ );
 *
 *         LSR_MSG_FREE( pMsg );
 *     }
 */
#define LSR_MSG_SEND_TO_FRONT( rxID, pData ) \
    lsr_msg_framework_send_to_front( (LSR_MsgID_t) ( rxID ), \
                                     (LSR_Msg_t*) ( pData ), \
                                     THIS_FILE, \
                                     __LINE__ )

/**
 * @brief LSR_MSG_SEND_FROM_ISR is a macro used to send a LSR Message utilizing the
 *        LSR Message Framework from an ISR context.
 *
 * @param rxID  - the ID of the message receiver
 * @param pData - pointer to the buffer containing the LSR Message Header
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_framework_send_from_isr directly.  This macro assumes that the
 * string THIS_FILE exists in each file in which it is called from.
 *
 * Example:
 *
 *     // Assuming LSR_MSG_INIT has already been called
 *
 *     if ( LSR_MSG_SEND_FROM_ISR( MODE_MANAGER_MSG_ID, pSetModeMsg ) != LSR_OK )
 *     {
 *         LSR_MSG_ISR_FREE( pMsg );
 *     }
 */
#define LSR_MSG_SEND_FROM_ISR( rxID, pData ) \
    lsr_msg_framework_send_from_isr( (LSR_MsgID_t) ( rxID ), \
                                     (LSR_Msg_t*) ( pData ), \
                                     THIS_FILE, \
                                     __LINE__ )

/**
 * @brief LSR_MSG_SEND_TO_FRONT_FROM_ISR is a macro used to send a LSR
 *        Message utilizing the LSR Message Framework from an ISR context.
 *
 * @param rxID  - the ID of the message receiver
 * @param pData - pointer to the buffer containing the LSR Message Header
 *
 * It is recommended to use this macro as an alternative to calling
 * lsr_msg_framework_send_to_front_from_isr directly.  This macro assumes that the
 * string THIS_FILE exists in each file in which it is called from.
 *
 * Example:
 *
 *     // Assuming LSR_MSG_INIT has already been called
 *
 *     if ( LSR_MSG_SEND_TO_FRONT_FROM_ISR( MODE_MANAGER_MSG_ID, pSetModeMsg ) != LSR_OK )
 *     {
 *         LSR_MSG_ISR_FREE( pMsg );
 *     }
 */
#define LSR_MSG_SEND_TO_FRONT_FROM_ISR( rxID, pData ) \
    lsr_msg_framework_send_to_front_from_isr( (LSR_MsgID_t) ( rxID ), \
                                              (LSR_Msg_t*) ( pData ), \
                                              THIS_FILE, \
                                              __LINE__ )

/** @brief LSR_MSG_CREATE_DATA_PTR is a macro used to create a type specific
 *         pointer to the payload of an LSR Message.  If Device-to-Device
 *         communication and endian swapping are both enabled, a boolean
 *         named payloadNeedsSwapped is provided to indicate whether or not the
 *         application code needs to swap the payload values.
 *
 *  @param msgType  - Data type of message payload
 *  @param pTypePtr - Pointer to the LSR Message payload
 *  @param pMsg     - Pointer to the LSR Message
 *
 * There isn't a large advantage to using this macro unless device-to-device
 * communication and endian swapping are both enabled
 */
#if ((LSR_MSG_INTERTASK_ONLY == FALSE) && (LSR_MSG_ENDIAN_SWAPPING == TRUE))

    #define LSR_MSG_CREATE_DATA_PTR( msgType, pTypePtr, pMsg ) \
        msgType *pTypePtr = (msgType*) ( pMsg ); \
        bool payloadNeedsSwapped = \
                !lsr_msg_correct_endian( &( ( pMsg )->header ), false )

#else

    #define LSR_MSG_CREATE_DATA_PTR( msgType, pTypePtr, pMsg ) \
        msgType *pTypePtr = (msgType*) ( pMsg );

#endif

/*******************************************************************************
 * Type Definitions
 ******************************************************************************/

/** LSR Message ID Type */
#if (LSR_MSG_HEADER_SIZE_OPT == LSR_MSG_LARGE_HEADER)
    typedef uint32_t LSR_MsgCode_t;     ///< 32-bit Message Code
    typedef uint32_t LSR_MsgSize_t;     ///< 32-bit Message Size
    typedef uint32_t LSR_MsgID_t;       ///< 32-bit Message ID
    typedef uint32_t LSR_MsgOptions_t;  ///< 32-bit Message Options
    typedef uint32_t LSR_MsgReserved_t; ///< 32-bit Message Reserved Area
#elif (LSR_MSG_HEADER_SIZE_OPT == LSR_MSG_MEDIUM_HEADER)
    typedef uint16_t LSR_MsgCode_t;     ///< 16-bit Message Code
    typedef uint16_t LSR_MsgSize_t;     ///< 16-bit Message Size
    typedef uint16_t LSR_MsgID_t;       ///< 16-bit Message ID
    typedef uint16_t LSR_MsgOptions_t;  ///< 16-bit Message Options
    typedef uint16_t LSR_MsgReserved_t; ///< 16-bit Message Reserved Area
#elif (LSR_MSG_HEADER_SIZE_OPT == LSR_MSG_SMALL_HEADER)
    typedef uint8_t LSR_MsgCode_t;      ///< 8-bit Message Code
    typedef uint8_t LSR_MsgSize_t;      ///< 8-bit Message Size
    typedef uint8_t LSR_MsgID_t;        ///< 8-bit Message ID
    typedef uint8_t LSR_MsgOptions_t;   ///< 8-bit Message Options
    typedef uint8_t LSR_MsgReserved_t;  ///< 8-bit Message Reserved Area
#elif (LSR_MSG_HEADER_SIZE_OPT == LSR_MSG_CUSTOM_HEADER)
    #ifdef LSR_MSG_CODE_TYPE_SIZE
        typedef LSR_MSG_CODE_TYPE_SIZE LSR_MsgCode_t;           ///< Custom Message Code
    #else
        #error "LSR_MSG_CODE_TYPE_SIZE must be defined if LSR_MSG_CUSTOM_HEADER is defined"
    #endif
    #ifdef LSR_MSG_ID_TYPE_SIZE
        typedef LSR_MSG_ID_TYPE_SIZE LSR_MsgID_t;               ///< Custom Message ID
    #else
        #error "LSR_MSG_ID_TYPE_SIZE must be defined if LSR_MSG_CUSTOM_HEADER is defined"
    #endif
    #ifdef LSR_MSG_SIZE_TYPE_SIZE
        typedef LSR_MSG_SIZE_TYPE_SIZE LSR_MsgSize_t;           ///< Custom Message Size (Header Inclusive)
    #else
        #error "LSR_MSG_SIZE_TYPE_SIZE must be defined if LSR_MSG_CUSTOM_HEADER is defined"
    #endif
    #ifdef LSR_MSG_OPTION_TYPE_SIZE
        typedef LSR_MSG_OPTION_TYPE_SIZE LSR_MsgOptions_t;      ///< Custom Message Options
    #else
        #error "LSR_MSG_OPTION_TYPE_SIZE must be defined if LSR_MSG_CUSTOM_HEADER is defined"
    #endif
    #ifdef LSR_MSG_RESERVED_TYPE_SIZE
        typedef LSR_MSG_RESERVED_TYPE_SIZE LSR_MsgReserved_t;   ///< Custom Message Reserved Area
    #else
        #error "LSR_MSG_RESERVED_TYPE_SIZE must be defined if LSR_MSG_CUSTOM_HEADER is defined"
    #endif
#else
    #error "Invalid LSR_MSG_HEADER_SIZE_OPT value"
#endif

#ifndef __NO_LSR_C_FRAMEWORK_H__
#pragma pack(push, 1) /// Save existing packing mode, and set byte alignment
#endif

/** LSR Message Header Structure (Byte-Aligned) */
typedef struct _LSR_MsgHeader_
{
    LSR_MsgSize_t msgSize;    ///< Size of the message in bytes (header inclusive)
    LSR_MsgCode_t msgCode;    ///< Identifies the type of payload or acts as an 'event' specifier
    LSR_MsgID_t rxID;         ///< Identifies the message destination
    LSR_MsgID_t txID;         ///< Identifies the message sender
    LSR_MsgOptions_t options; ///< Used to pass message specific configuration options
    LSR_MsgReserved_t rsvd;   ///< Reserved additional space for application specific use
#if ((LSR_MSG_INTERTASK_ONLY == FALSE) && (LSR_MSG_ENDIAN_SWAPPING == TRUE))
    uint16_t headerEndian;    ///< Used to determine if the header endian is correct
    uint16_t payloadEndian;   ///< Used to determine if the payload endian is correct
#endif
} LSR_MsgHeader_t;

/** LSR Message Callback Header Structure (For internal messaging only) */
typedef struct _LSR_MsgCBackHeader_
{
    LSR_MsgHeader_t header; ///< Message Header to provide identifying, routing, and configuration data
    LSR_Result_t (*pCBack)( void *pData, uint32_t dataSize ); ///< Callback Function to invoke from receiving task context
} LSR_MsgCBackHeader_t;

/**
 * @brief LSR Message Structure
 *
 * This struct acts as a template for application specific messages.  Payload entries can
 * be added after the header entry.  The LSR_MsgHeader_t or LSR_MsgCBackHeader_t can be
 * interchanged depending on desired functionality.
 *
 * Example:
 *
 *     // Set Mode of Operation Message
 *     typedef struct _SetModeMsg_
 *     {
 *         LSR_MsgHeader_t header;
 *         // Payload
 *         OpMode_t    mode;      // Idle, Connect, Status Update, Data Transfer
 *         OpModeReq_t requestor; // Host, Link, Auto
 *    } SetModeMsg_t;
 */
typedef struct _LSR_Msg_
{
    // This can also be a LSR_MsgCBackHeader_t
    LSR_MsgHeader_t header; ///< Message Header to provide identifying, routing, and configuration data
    /// Optional Payload Below
} LSR_Msg_t;

#ifndef __NO_LSR_C_FRAMEWORK_H__
#pragma pack(pop) /// Restore previous packing mode
#endif

/*******************************************************************************
 * Constants
 ******************************************************************************/

/** LSR Message Options (1-Hot Encoding) */
enum _LSR_MsgOptions_
{
    LSR_MSG_OPT_NONE                  = 0x0, ///< No Options
    LSR_MSG_OPT_DO_NOT_FREE           = 0x1, ///< The receiving task will not free the memory associated with the message
    LSR_MSG_OPT_YIELD_AFTER_SEND      = 0x2, ///< The framework yields the sender task after the message is queued
    LSR_MSG_OPT_BLOCK_UNTIL_PROCESSED = 0x4, ///< The receiving task will block until the message is fully processed
    LSR_MSG_OPT_FROM_ISR              = 0x8, ///< The transmitter is an ISR routine

    // Last Entry
    LSR_MSG_OPT_DEFAULT = LSR_MSG_OPT_NONE,  ///< Default Options
};

/*******************************************************************************
 * Function Prototypes
 ******************************************************************************/

/**
 * @brief This function initializes the message header
 *
 * @param pThis   - LSR Message Header Pointer
 * @param msgCode - Message Code (type identifier)
 * @param msgSize - Message Size (bytes)
 * @param rxID    - Receiver (Destination) ID
 * @param txID    - Transmitter (Sender) ID
 * @param options - Message Options
 *
 * @return None
 *
 * It is recommended to use the LSR_MSG_INIT macro instead of this function directly
 */
void lsr_msg_header_init( LSR_MsgHeader_t *pThis,
                          LSR_MsgCode_t msgCode,
                          LSR_MsgSize_t msgSize,
                          LSR_MsgID_t rxID,
                          LSR_MsgID_t txID,
                          LSR_MsgOptions_t options,
                          LSR_MsgReserved_t rsvd );

/**
 * @brief This function checks if the header or payload endian is correct relative
 *        to the native architecture (determined using the LSR_MSG_ENDIAN_TEST_VALUE).
 *
 * @param pThis    - LSR Message Header Pointer
 * @param isHeader - TRUE if header, FALSE if payload
 *
 * @retval TRUE Correct Endian Value
 * @retval FALSE Incorrect Endian Value (needs swapping)
 */
bool lsr_msg_correct_endian( LSR_MsgHeader_t *pThis,
                             bool isHeader );

/**
 * @brief This function will endian swap the message header values if the endianess
 *        doesn't match the native architecture.
 *
 * @param pThis - LSR Message Header Pointer
 *
 * @return None
 */
void lsr_msg_swap_header_endian( LSR_MsgHeader_t *pThis );

/**
 * @brief This function updates the payload endian value, such that the
 *        endian test will pass.  This is only to be used after the
 *        the application has swapped the payload.
 *
 * @param pThis - LSR Message Pointer
 *
 * @return None
 */
void lsr_msg_payload_endian_swapped( LSR_Msg_t *pThis );

EXTERN_C_END
#endif
/*******************************************************************************
 * End of File
 ******************************************************************************/
