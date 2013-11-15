//
//  FDMessagesViewController.m
//  find
//
//  Created by zhangbin on 11/15/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMessagesViewController.h"
#import "JSAvatarImageFactory.h"
#import "UIButton+JSMessagesView.h"

#define kSubtitleJobs @"Jobs"
#define kSubtitleCook @"Mr. Cook"

@interface FDMessagesViewController ()<JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (readwrite) NSMutableArray *messages;
@property (readwrite) NSMutableArray *timestamps;
@property (readwrite) NSMutableArray *subtitles;
@property (readwrite) NSDictionary *avatars;

@end

@implementation FDMessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.delegate = self;
    self.dataSource = self;

	_messages = [NSMutableArray array];
    
    _timestamps = [NSMutableArray array];
	
	_subtitles = [NSMutableArray array];
    
	_avatars = @{kSubtitleJobs : [UIImage imageFromColor:[UIColor redColor]],
					 kSubtitleCook : [UIImage imageFromColor:[UIColor blueColor]]
					 };
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.messageInputView resignFirstResponder];
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text
{
	//TODO: @(1)
	[[FDAFHTTPClient shared] sendPrivateMessage:text toUser:@(1) withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[_messages addObject:text];
			[_timestamps addObject:[NSDate date]];
			if((_messages.count - 1) % 2) {
				[JSMessageSoundEffect playMessageSentSound];
				//TODO: add user self avatar
				[_subtitles addObject:kSubtitleCook];
			}
			else {
				[JSMessageSoundEffect playMessageReceivedSound];
				//TODO: add target avatar
				[_subtitles addObject:kSubtitleJobs];
			}
			[self finishSend];
			[self scrollToBottomAnimated:YES];
		}
	}];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          style:JSBubbleImageViewStyleClassicBlue];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type style:JSBubbleImageViewStyleClassicSquareGray];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyAll;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyAll;
}

#pragma mark - Messages view delegate: OPTIONAL

//  *** Implement to customize cell further
//
//  - (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
//  {
//      [cell.bubbleView setFont:[UIFont boldSystemFontOfSize:9.0]];
//      [cell.bubbleView setTextColor:[UIColor whiteColor]];
//  }

//  *** Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
- (UIButton *)sendButtonForInputView
{
	UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sendButton.frame = CGRectMake(0, 0, 60, 30);
	[sendButton setTitle:@"hello" forState:UIControlStateNormal];
	return sendButton;
    //return [UIButton js_defaultSendButton_iOS6];
}

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_timestamps objectAtIndex:indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *subtitle = [_subtitles objectAtIndex:indexPath.row];
    UIImage *image = [_avatars objectForKey:subtitle];
    return [[UIImageView alloc] initWithImage:image];
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_subtitles objectAtIndex:indexPath.row];
}

@end
