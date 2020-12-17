#import "JitsiPlugin.h"
#import "JitsiMeet.framework/Headers/JitsiMeetConferenceOptions.h"


@implementation JitsiPlugin

CDVPluginResult *jitsiPluginResult = nil;

- (void)join:(CDVInvokedUrlCommand *)command {
    NSString* serverUrl = [command.arguments objectAtIndex:0];
    NSString* room = [command.arguments objectAtIndex:1];
    NSString* token = [command.arguments objectAtIndex:2];
    Boolean isAudioOnly = [[command.arguments objectAtIndex:3] boolValue];
    commandBack = command;
    jitsiMeetView = [[JitsiMeetView alloc] initWithFrame:self.viewController.view.frame];
    jitsiMeetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    jitsiMeetView.delegate = self;
    
    JitsiMeetConferenceOptions *options = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
        builder.serverURL = [NSURL URLWithString: serverUrl];
        builder.room = room;
        builder.token = token;
        builder.subject = @" ";
        builder.welcomePageEnabled = NO;
        builder.audioOnly = isAudioOnly;
        builder.setFeatureFlag("chat.enabled", withBoolean: true);
        builder.setFeatureFlag("invite.enabled", withBoolean: false);
        builder.setFeatureFlag("calendar.enabled", withBoolean: false);
        builder.setFeatureFlag("video-share.enabled", withBoolean: false);
        builder.setFeatureFlag("live-streaming.enabled", withBoolean: false);
    }];
    
    [jitsiMeetView join: options];
    [self.viewController.view addSubview:jitsiMeetView];
}


- (void)destroy:(CDVInvokedUrlCommand *)command {
    if(jitsiMeetView){
        [jitsiMeetView removeFromSuperview];
        jitsiMeetView = nil;
    }
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DESTROYED"];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:command.callbackId];
}

void _onJitsiMeetViewDelegateEvent(NSString *name, NSDictionary *data) {
    NSLog(
        @"[%s:%d] JitsiMeetViewDelegate %@ %@",
        __FILE__, __LINE__, name, data);

}

- (void)conferenceFailed:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_FAILED", data);
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_FAILED"];
    [jitsiPluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:commandBack.callbackId];
}

- (void)conferenceJoined:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_JOINED", data);
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_JOINED"];
    [jitsiPluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:commandBack.callbackId];
}

- (void)conferenceLeft:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_LEFT", data);
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_LEFT"];
    [jitsiPluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:commandBack.callbackId];

}

- (void)conferenceWillJoin:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_WILL_JOIN", data);
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_WILL_JOIN"];
    [jitsiPluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:commandBack.callbackId];
}

- (void)conferenceTerminated:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_TERMINATED", data);
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_TERMINATED"];
    [jitsiPluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:commandBack.callbackId];
}

- (void)loadConfigError:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"LOAD_CONFIG_ERROR", data);
    jitsiPluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"LOAD_CONFIG_ERROR"];
    [jitsiPluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:jitsiPluginResult callbackId:commandBack.callbackId];
}


@end
