//
//  CTRestClient.h
//  CTRestClient
//
//  Created by Tanmoy Khanra on 24/02/16.
//  Copyright © 2016 Tanmoy Khanra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTJsonSerialization.h"

//Responsehandler
typedef void (^CTHTTPResponseHandler)(id data, NSError *error);

@interface CTRestClient : NSObject
{
    CTHTTPResponseHandler  ctHTTPResponseHandler;
}

- (id)init:(NSString *)url withBody:(NSString *)httpbody withMethod:(NSString *)method;

-(void)getJsonData:(CTHTTPResponseHandler)responseHandler;

-(void)saveOnlyParamswithCompletion:(CTHTTPResponseHandler )httpResponseHandler;

-(void)saveDataWithParams:(NSData *)data withFileName:(NSString *)fileName fileKey:(NSString *)key otherData:(NSDictionary *)params withCompletion:(CTHTTPResponseHandler)httpResponseHandler;


@end
