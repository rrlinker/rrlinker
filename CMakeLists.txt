cmake_minimum_required(VERSION 3.14)

project(
    rrlinker
    VERSION 0.1
    DESCRIPTION "Remote Run-time Linker of MS COFF (.obj) files."
    LANGUAGES CXX
)

function(add_target)
    cmake_parse_arguments("" "" "NAME" "DEPENDS;OS" ${ARGN})
    if("${CMAKE_SYSTEM_NAME}" IN_LIST _OS)
        message(STATUS "${_NAME} is enabled")
        add_subdirectory("${_NAME}")
    else()
        message(STATUS "${_NAME} is disabled")
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
