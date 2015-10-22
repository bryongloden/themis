#import <objcthemis/smessage.h>
#import <objcthemis/ssession.h>

#import "SMessageClient.h"
#import "skeygen.h"


@interface SMessageClient ()

@property (nonatomic, strong) NSData * clientPrivateKey;
@property (nonatomic, strong) NSData * clientPublicKey;

@end

@implementation SMessageClient


- (void)postRequestTo:(NSString *)stringURL message:(NSData *)message completion:(void (^)(NSData * data, NSError * error))completion {

    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    NSDictionary *dictionary = @{@"message": [message base64EncodedStringWithOptions:0]};
    NSError * jsonError = nil;
    NSData * body = [NSJSONSerialization dataWithJSONObject:dictionary
                                                    options:0 error:&jsonError];

    if (!jsonError) {
        NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request
                                                                    fromData:body
                                                           completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {

                                                               if (error || ((NSHTTPURLResponse *)response).statusCode != 200) {
                                                                   NSLog(@"Oops, response %@\nerror: %@", response, error);
                                                                   data = nil;

                                                               } else {
                                                                   NSLog(@"response %@\n", response);
                                                               }
                                                               if (completion) {
                                                                   completion(data, error);
                                                               }
                                                           }];
        [uploadTask resume];
    }


//    NSURL * url = [NSURL URLWithString:URL];
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString * params = [NSString stringWithFormat:@"message=%@", [message base64EncodedStringWithOptions:0]];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
//
//    NSData * postdata = [params dataUsingEncoding:NSUTF8StringEncoding];
//    [urlRequest setHTTPBody:postdata];
//    [urlRequest setValue:[NSString stringWithFormat:@"%li", postdata.length] forHTTPHeaderField:@"Content-Length"];
//
//    __block NSData * res = nil;
//    NSURLResponse * response = nil;
//    NSError * error = nil;
//    res = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//    if (error || ((NSHTTPURLResponse *) response).statusCode != 200) {
//        NSLog(@"Error:%@ %@\n", response, error);
//    }
//    NSLog(@"Response:%@\n", res);
//    completion(res, nil);
}


- (void)secureMessageCITest {
//    [self generateClientKeys];
//    return;

    NSString * userid = @"thGnBKCqvoZWVRe";
    NSData * serverPublicKey = [[NSData alloc] initWithBase64EncodedString:@"VUVDMgAAAC2b8Au0AoMtZ9sIglcmbx7CWmK4VNF7IKWeEDC4n36EJwpZfNxn" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData * clientPrivateKey = [[NSData alloc] initWithBase64EncodedString:@"UkVDMgAAAC3eNLCtALLuiyU+v3bEpkub0rdqWN41VORwqRf9hc53kvA+eY0F" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    TSMessage * encrypter = [[TSMessage alloc] initInEncryptModeWithPrivateKey:clientPrivateKey
                                                                 peerPublicKey:serverPublicKey];

    NSString * message = @"This is test message";

    NSError * themisError = nil;
    NSData * encryptedMessage = [encrypter wrapData:[message dataUsingEncoding:NSUTF8StringEncoding] error:&themisError];
    if (themisError) {
        NSLog(@"encryption error: %@", themisError);
        return;
    }

    NSString * stringURL = [NSString stringWithFormat:@"%@%@/", @"https://themis.cossacklabs.com/api/", userid];
    [self postRequestTo:stringURL message:encryptedMessage
             completion:^(NSData * data, NSError * error) {
                 if (error || !data) {
                     NSLog(@"response error %@", error);
                     return;
                 }

                 NSError * wrappingError = nil;
                 NSData * unwrap = [encrypter unwrapData:data error:&wrappingError];
                 if (wrappingError) {
                     NSLog(@"decryption error: %@", wrappingError);
                     return;
                 }

                 NSLog(@"Unwraped response %@",[[NSString alloc] initWithData:unwrap encoding:NSUTF8StringEncoding] );

             }];
}


- (void)generateClientKeys {
    TSKeyGen * keygenEC = [[TSKeyGen alloc] initWithAlgorithm:TSKeyGenAsymmetricAlgorithmEC];

    if (!keygenEC) {
        NSLog(@"%s Error occured while initializing object keygenEC", sel_getName(_cmd));
        return;
    }

    self.clientPrivateKey = keygenEC.privateKey;
    self.clientPublicKey = keygenEC.publicKey;
    
    NSLog(@"client private key %@", [self.clientPrivateKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
    NSLog(@"client public key %@", [self.clientPublicKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
}

@end