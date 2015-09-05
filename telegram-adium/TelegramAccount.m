/**
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02111-1301  USA
 *
 * Copyright Matthias Jentsch 2014-2015
 */

#import "TelegramAccount.h"
#import "tgp-ft.h"

#import <libpurple/conversation.h>
#import <Adium/ESFileTransfer.h>
#import <Adium/AIListContact.h>
#import <Adium/AIToolbarControllerProtocol.h>
#import <Adium/AIMenuControllerProtocol.h>
#import <Adium/AIChat.h>

#import <AIUtilities/AIToolbarUtilities.h>
#import <AIUtilities/AIImageAdditions.h>
#import <AIUtilities/AIMenuAdditions.h>


#include "telegram-purple.h"

@implementation TelegramAccount

- (const char*)protocolPlugin
{
	return "prpl-telegram";
}

- (NSString *)host
{
	return @"149.154.167.50";
}

- (BOOL)shouldDisplayOutgoingMUCMessages
{
  return NO;
}

- (int)port
{
	return 443;
}

- (void)configurePurpleAccount
{
  [super configurePurpleAccount];
  
  purple_account_set_string (account, TGP_KEY_PASSWORD_TWO_FACTOR,
                             [[self preferenceForKey:@"Telegram:"TGP_KEY_PASSWORD_TWO_FACTOR
                                               group:GROUP_ACCOUNT_STATUS]
                              UTF8String]);
  
  purple_account_set_string (account, TGP_KEY_ACCEPT_SECRET_CHATS,
                              [[self preferenceForKey:@"Telegram:"TGP_KEY_ACCEPT_SECRET_CHATS
                                                group:GROUP_ACCOUNT_STATUS]
                               UTF8String]);
  
  purple_account_set_bool (account, TGP_KEY_DISPLAY_READ_NOTIFICATIONS,
                              [[self preferenceForKey:@"Telegram:"TGP_KEY_DISPLAY_READ_NOTIFICATIONS
                                                group:GROUP_ACCOUNT_STATUS]
                               boolValue]);
  
  purple_account_set_bool (account, TGP_KEY_SEND_READ_NOTIFICATIONS,
                           [[self preferenceForKey:@"Telegram:"TGP_KEY_SEND_READ_NOTIFICATIONS
                                             group:GROUP_ACCOUNT_STATUS]
                            boolValue]);
  
  purple_account_set_bool (account, TGP_KEY_HISTORY_SYNC_ALL,
                              [[self preferenceForKey:@"Telegram:"TGP_KEY_HISTORY_SYNC_ALL
                                                group:GROUP_ACCOUNT_STATUS]
                               boolValue]);
  
  purple_account_set_int (account, TGP_KEY_HISTORY_RETRIEVAL_THRESHOLD,
                              [[self preferenceForKey:@"Telegram:"TGP_KEY_HISTORY_RETRIEVAL_THRESHOLD
                                                group:GROUP_ACCOUNT_STATUS]
                               intValue]);
  
  purple_account_set_int (account, TGP_KEY_INACTIVE_DAYS_OFFLINE,
                              [[self preferenceForKey:@"Telegram:"TGP_KEY_INACTIVE_DAYS_OFFLINE
                                                group:GROUP_ACCOUNT_STATUS]
                               intValue]);
}

#pragma mark Action Menu
-(NSMenu*)actionMenuForChat:(AIChat*)chat
{
  NSArray *listObjects = nil;
  AIListObject *listObject = nil;
  
  if (listObjects.count) {
    listObject = [listObjects objectAtIndex:0];
  }
  
  NSMenu *menu = [adium.menuController
            contextualMenuWithLocations: [NSArray arrayWithObjects:
            [NSNumber numberWithInteger: Context_GroupChat_Manage],
            [NSNumber numberWithInteger: Context_Group_Manage],
            [NSNumber numberWithInteger: Context_GroupChat_Action],
            nil] forChat: chat];
  
  [menu addItem:[NSMenuItem separatorItem]];

  [menu addItemWithTitle:@"Invite users by link..."
                  target:self
                  action:@selector(addUserByLink)
           keyEquivalent:@""
                     tag:0];
  return menu;
}
- (void)addUserByLink
{
  connection_data *conn = purple_connection_get_protocol_data (purple_account_get_connection(account));
  AIChat *chat = adium.interfaceController.activeChat;
  const char *subject = [[[chat chatCreationDictionary] objectForKey:@"subject"] UTF8String];
  export_chat_link_checked (conn->TLS, subject);
}

#pragma mark File transfer
- (BOOL)canSendOfflineMessageToContact:(AIListContact *)inContact
{
	return YES;
}

- (void)beginSendOfFileTransfer:(ESFileTransfer *)fileTransfer
{
  [super _beginSendOfFileTransfer:fileTransfer];
}

- (void)acceptFileTransferRequest:(ESFileTransfer *)fileTransfer
{
  [super acceptFileTransferRequest:fileTransfer];
}

- (void)rejectFileReceiveRequest:(ESFileTransfer *)fileTransfer
{
  [super rejectFileReceiveRequest:fileTransfer];
}

- (void)cancelFileTransfer:(ESFileTransfer *)fileTransfer
{
  [super cancelFileTransfer:fileTransfer];
}

@end