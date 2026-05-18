#if TARGET_OS_SIMULATOR

#import <Foundation/Foundation.h>
#import <cstdlib>
#import <cstring>
#import <string>

extern "C" {

const char* rootfs_alloc(const char* path) {
    return path == nullptr ? nullptr : strdup(path);
}

const char* jbroot_alloc(const char* path) {
    return path == nullptr ? nullptr : strdup(path);
}

const char* jbrootat_alloc(int, const char* path) {
    return path == nullptr ? nullptr : strdup(path);
}

unsigned long long jbrand() {
    return 0;
}

const char* jbroot(const char* path) {
    return path;
}

const char* rootfs(const char* path) {
    return path;
}

NSString* __attribute__((overloadable)) jbroot(NSString* path) {
    return path;
}

NSString* __attribute__((overloadable)) rootfs(NSString* path) {
    return path;
}

}

std::string jbroot(std::string path) {
    return path;
}

std::string rootfs(std::string path) {
    return path;
}

#endif
