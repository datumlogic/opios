/*
 
 Copyright (c) 2012, SMB Phone Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 
 */

#import <Foundation/Foundation.h>

@class HOPConversation;
@class HOPMessageRecord;

typedef enum
{
    SystemMessage_EstablishSessionBetweenTwoPeers,
    SystemMessage_IsContactAvailable,
    SystemMessage_IsContactAvailable_Response,
    SystemMessage_CallAgain,
    SystemMessage_CheckAvailability,
    SystemMessage_APNS_Request,
    SystemMessage_APNS_Response,
    
    
    SystemMessage_None = 111
}SystemMessageTypes;

@interface MessageManager : NSObject

+ (id) sharedMessageManager;

- (HOPMessageRecord*) createSystemMessageWithType:(HOPSystemMessageType) type messageType:(int) messageType reasonCode:(int)reasonCode andRecipient:(HOPRolodexContact*) contact conversation:(HOPConversation*) conversation;

- (void) sendCallSystemMessage:(HOPCallSystemMessageType) callSystemMessage reasonCode:(int) reasonCode forConversation:(HOPConversation*) conversation;

- (void) parseSystemMessage:(HOPMessageRecord*) inMessage forConversation:(HOPConversation*) conversation;
- (void) sendMessage:(NSString*) message replacesMessageID:(NSString*) replacesMessageID forConversation:(HOPConversation*) conversation;
- (void) onMessageReceived:(HOPMessageRecord*) message forConversation:(HOPConversation*) conversation;

- (SystemMessageTypes) getTypeForSystemMessage:(HOPMessageRecord*) message;

- (void) resendMessages;
- (void) resendMessage:(HOPMessageRecord*) message conversation:(HOPConversation*) conversation;
@end
