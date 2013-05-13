//
//  GLShader.h
//  glimageprocess
//
//  Created by li yajie on 5/13/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLShader : NSObject
{
    GLuint type;
    
    GLuint shader;
    NSString *shaderString;
}

@property(nonatomic,readonly) GLuint shader;

-(id) initShaderWithType:(GLuint) type withString:(NSString*) shaderString;
/**
 *
 */
-(id) initShaderWithType:(GLuint) type withFile:(NSString*)fileName;

@end
