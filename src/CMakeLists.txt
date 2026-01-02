cmake_minimum_required(VERSION 3.12)
project(chipmunk2d_physics_ffi LANGUAGES C)

# 1. Global Visibility - Prevents symbol clashes in Flutter/Dart
# Use hidden visibility by default, but FFI_PLUGIN_EXPORT will override to export symbols
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

# 2. Set C standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 3. Gather sources
file(GLOB CHIPMUNK_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../chipmunk2d/src/*.c")

# 4. ROBUST REMOVAL of cpHastySpace.c (Fixes Linux/Android build errors)
list(FILTER CHIPMUNK_SOURCES EXCLUDE REGEX "cpHastySpace\\.c$")

# 5. Define the library/executable
# For Emscripten, we use add_executable to generate the JS+WASM pair.
if(EMSCRIPTEN)
    add_executable(${PROJECT_NAME}
        chipmunk2d_physics_ffi.c
        ${CHIPMUNK_SOURCES}
    )
else()
    add_library(${PROJECT_NAME} SHARED
        chipmunk2d_physics_ffi.c
        ${CHIPMUNK_SOURCES}
    )
endif()

# 6. Target-based Includes
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../chipmunk2d/include
)

# 6.5. Link Android Log Library (required for cpMessage)
if(ANDROID)
    find_library(log_lib log)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${log_lib})
endif()

# 7. Compile Parameters
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W4 /Ox /fp:fast)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE 
        -Wall -Wextra -O3 
        $<$<CONFIG:Release>:-ffast-math>
        -fPIC
    )
endif()

# 8. Output Naming Logic
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")

if(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".dylib")
elseif(WIN32)
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".dll")
elseif(EMSCRIPTEN)
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".js")
else()
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".so")
endif()

# 9. Web/Emscripten settings
if(EMSCRIPTEN)
    target_link_options(${PROJECT_NAME} PRIVATE
        "SHELL:-s EXPORT_NAME='${PROJECT_NAME}'"
        "SHELL:-s MODULARIZE=1"
        "SHELL:-s EXPORT_ES6=1"
        "SHELL:-s EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
        "SHELL:-s ALLOW_MEMORY_GROWTH=1"
        "SHELL:-s WASM=1"
        "SHELL:-s EXPORTED_FUNCTIONS=['_malloc','_free']"
        "SHELL:-s EXPORT_ALL=1"
    )
endif()
