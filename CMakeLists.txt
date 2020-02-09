cmake_minimum_required(VERSION 3.14)

project(
    rrlinker
    VERSION 0.1
    DESCRIPTION "Remote Run-time Linker of MS COFF (.obj) files."
    LANGUAGES CXX
)

include("${CMAKE_SOURCE_DIR}/cmake/find_libs_dir.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/find_arch.cmake")

function(add_target)
    cmake_parse_arguments("" "" "NAME" "DEPENDS;OS" ${ARGN})
    if("${_OS}" MATCHES ${CMAKE_SYSTEM_NAME})
        message(STATUS "Adding target ${_NAME}")
        list(APPEND ADD_ARGS "-DARCH=${ARCH}")
        if(NOT "${C_LIBS_DIR}" STREQUAL "")
            list(APPEND ADD_ARGS "-DC_LIBS_DIR=${C_LIBS_DIR}")
        endif()
        if(NOT "${CXX_LIBS_DIR}" STREQUAL "")
            list(APPEND ADD_ARGS "-DCXX_LIBS_DIR=${CXX_LIBS_DIR}")
        endif()
        add_custom_target(
            ${_NAME} ALL
            COMMENT "Building ${_NAME}"
            DEPENDS "${_DEPENDS}"
                "${CMAKE_SOURCE_DIR}/${_NAME}"
            VERBATIM
            WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
            COMMAND "${CMAKE_COMMAND}"
                ${ADD_ARGS}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -S "${CMAKE_SOURCE_DIR}/${_NAME}"
                -B "${CMAKE_SOURCE_DIR}/${_NAME}/build/${ARCH}"
                -G "${CMAKE_GENERATOR}"
                -A "${CMAKE_GENERATOR_PLATFORM}"
                "${CMAKE_SOURCE_DIR}/${_NAME}"
            COMMAND "${CMAKE_COMMAND}"
                --build "${CMAKE_SOURCE_DIR}/${_NAME}/build/${ARCH}"
                --config $<CONFIG>
        )
    endif()
endfunction()

add_target(
    NAME librrlcom
    OS Windows Linux
)

add_target(
    NAME librrlcrypto
    DEPENDS librrlcom
    OS Windows Linux
)

add_target(
    NAME librrlclient
    DEPENDS librrlcom
    OS Windows
)

add_target(
    NAME client_example
    DEPENDS librrlclient librrlcom
    OS Windows
)

add_target(
    NAME svcrrlinker
    DEPENDS librrlcrypto librrlcom
    OS Linux
)
