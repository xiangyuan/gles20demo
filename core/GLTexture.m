//
//  GLTexture.m
//  glimageprocess
//
//  Created by li yajie on 5/2/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import "GLTexture.h"

@implementation GLTexture
{
    GLuint texture[1];
}
@synthesize textureFileName;

/**
 * init the texture
 */
-(id) initTexture:(NSString*) fileName {
    self = [super init];
    if (self) {
        // init the texture
        glGenTextures(1, texture);
        glBindTexture(GL_TEXTURE_2D, texture[0]);
        GLenum __error = glGetError();
        if(__error) printf("initTexture error 0x%04X in %s %d\n", __error, __FUNCTION__, __LINE__);
        // set texture config
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        __error = glGetError();
        if(__error) printf("initTexture error 0x%04X in %s %d\n", __error, __FUNCTION__, __LINE__);
        // read the 2d sample data
//        NSData * data = [NSData dataWithContentsOfFile:filePath];
        CGImageRef imageref = [UIImage imageNamed:fileName].CGImage;
        GLuint width = CGImageGetWidth(imageref);
        GLuint height = CGImageGetHeight(imageref);
        void *imageData = malloc(width * height * 4);
         CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast| kCGBitmapByteOrder32Big);
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClearRect(context, CGRectMake(0, 0, width, height));
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageref);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
        CGColorSpaceRelease(colorSpace);
        free(imageData);
        CGContextRelease(context);
    }
    return self;
}

/**
 * use the texture
 */
-(void) useTexture {
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    GLenum __error = glGetError();
    if(__error) printf("useTexture error 0x%04X in %s %d\n", __error, __FUNCTION__, __LINE__);

}
- (void)dealloc
{
    glDeleteTextures(1, &texture[0]);
    [textureFileName release];
    [super dealloc];
}
@end
