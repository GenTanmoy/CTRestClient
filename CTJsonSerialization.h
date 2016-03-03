//
//  CTJsonSerialization.h
//  TestRest
//
//  Created by Tanmoy Khanra on 01/03/16.
//  Copyright © 2016 Tanmoy Khanra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CTJSONSerializationHandeler)(NSDictionary *json, NSError *error);

@interface CTJsonSerialization : NSObject
{
    CTJSONSerializationHandeler  ctJSONSerializationHandeler;
}

+(void)getJsonResponseFromData:(NSData *)responseData  onCompletion:(CTJSONSerializationHandeler)jsonSerializationHandler;

@end
