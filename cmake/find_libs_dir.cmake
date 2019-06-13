function(find_lib_dir DIR)
    if("${${DIR}}" STREQUAL "")
        if("$ENV{${DIR}}" STREQUAL "")
            message(WARNING
                "${DIR} is not defined. Probably some libraries won't be found during the build. "
                "Define ${DIR} with -D during the configuration, or "
                "define ${DIR} as an environment variable."
            )
        else()
            message("${DIR} was not defined, defaulting to the environment variable.")
            set(LIB_DIR "$ENV{${DIR}}")
        endif()
    else()
        set(LIB_DIR "${${DIR}}")
    endif()
    file(TO_CMAKE_PATH "${LIB_DIR}" CMAKE_LIB_DIR)
    set("${DIR}" "${CMAKE_LIB_DIR}" CACHE STRING "Directory of libraries" FORCE)
    message(STATUS "${DIR}=\"${${DIR}}\"")
endfunction()

if("${CMAKE_SYSTEM_NAME}" MATCHES "Windows")
    find_lib_dir(C_LIBS_DIR)
    find_lib_dir(CXX_LIBS_DIR)
endif()
