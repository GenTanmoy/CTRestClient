//
//  CTJsonSerialization.m
//  TestRest
//
//  Created by Tanmoy Khanra on 01/03/16.
//  Copyright © 2016 Tanmoy Khanra. All rights reserved.
//

#import "CTJsonSerialization.h"

@implementation CTJsonSerialization
+(void)getJsonResponseFromData:(NSData *)responseData onCompletion:(CTJSONSerializationHandeler)jsonSerializationHandler
    {
        if (responseData) {
            NSError *jsonParserError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParserError];
            
            if (jsonParserError) {
                jsonSerializationHandler(nil,jsonParserError);
                
            }else{
                jsonSerializationHandler(json,nil);
            }
            
        }else{
            NSError *responseError = [NSError errorWithDomain:@"com.tanmoy.serviceresponsenil" code:2016 userInfo:nil];
            jsonSerializationHandler(nil,responseError);
            
        }
    }

@end
