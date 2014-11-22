# Locate Lua library
# This module defines
#  LUA_EXECUTABLE, if found
#  LUA_FOUND, if false, do not try to link to Lua 
#  LUA_LIBRARIES
#  LUA_INCLUDE_DIR, where to find lua.h
#  LUA_VERSION_STRING, the version of Lua found (since CMake 2.8.8)
#
# Note that the expected include convention is
#  #include "lua.h"
# and not
#  #include <lua/lua.h>
# This is because, the lua location is not standardized and may exist
# in locations other than lua/

#=============================================================================
# Copyright 2007-2009 Kitware, Inc.
# Modified to support Lua 5.2 by LuaDist 2012
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)
#
# The required version of Lua can be specified using the
# standard syntax, e.g. FIND_PACKAGE(Lua 5.1)
# Otherwise the module will search for any available Lua implementation

# Always search for non-versioned lua first (recommended)
SET(_POSSIBLE_LUA_INCLUDE include include/lua)
SET(_POSSIBLE_LUA_EXECUTABLE lua)
SET(_POSSIBLE_LUA_LIBRARY lua)

# Determine possible naming suffixes (there is no standard for this)
IF(Lua_FIND_VERSION_MAJOR AND Lua_FIND_VERSION_MINOR)
  SET(_POSSIBLE_SUFFIXES "${Lua_FIND_VERSION_MAJOR}${Lua_FIND_VERSION_MINOR}" "${Lua_FIND_VERSION_MAJOR}.${Lua_FIND_VERSION_MINOR}" "-${Lua_FIND_VERSION_MAJOR}.${Lua_FIND_VERSION_MINOR}")
ELSE(Lua_FIND_VERSION_MAJOR AND Lua_FIND_VERSION_MINOR)
  SET(_POSSIBLE_SUFFIXES "52" "5.2" "-5.2" "51" "5.1" "-5.1")
ENDIF(Lua_FIND_VERSION_MAJOR AND Lua_FIND_VERSION_MINOR)

# Set up possible search names and locations
FOREACH(_SUFFIX ${_POSSIBLE_SUFFIXES})
  LIST(APPEND _POSSIBLE_LUA_INCLUDE "include/lua${_SUFFIX}")
  LIST(APPEND _POSSIBLE_LUA_EXECUTABLE "lua${_SUFFIX}")
  LIST(APPEND _POSSIBLE_LUA_LIBRARY "lua${_SUFFIX}")
ENDFOREACH(_SUFFIX)

# Find the lua executable
FIND_PROGRAM(LUA_EXECUTABLE lua /opt/bin)

# Find the lua header
FIND_PATH(LUA_INCLUDE_DIR lua.h /opt/include)

# Find the lua library
FIND_LIBRARY(LUA_LIBRARY lua /opt/lib)

list(APPEND CMAKE_FIND_LIBRARY_SUFFIXES .so.6 .so.2)
FIND_LIBRARY(LUA_MATH_LIBRARY m /opt/lib)
FIND_LIBRARY(LUA_LDL_LIBRARY dl /opt/lib)

MESSAGE( STATUS "LUA_EXECUTABLE:   " ${LUA_EXECUTABLE} )
MESSAGE( STATUS "SUFFIXES:         " ${CMAKE_FIND_LIBRARY_SUFFIXES} )
MESSAGE( STATUS "LUA_INCLUDE_DIR:  " ${LUA_INCLUDE_DIR} )
MESSAGE( STATUS "LUA_LIBRARY:      " ${LUA_LIBRARY} )
MESSAGE( STATUS "LUA_MATH_LIBRARY: " ${LUA_MATH_LIBRARY} )
MESSAGE( STATUS "LUA_LDL_LIBRARY:  " ${LUA_LDL_LIBRARY} )

SET( LUA_LIBRARIES "${LUA_LIBRARY};${LUA_MATH_LIBRARY};${LUA_LDL_LIBRARY}" CACHE STRING "Lua Libraries")

MESSAGE( STATUS "LUA_LIBRARIES:    " ${LUA_LIBRARIES} )

# Determine Lua version
IF(LUA_INCLUDE_DIR AND EXISTS "${LUA_INCLUDE_DIR}/lua.h")
  FILE(STRINGS "${LUA_INCLUDE_DIR}/lua.h" lua_version_str REGEX "^#define[ \t]+LUA_RELEASE[ \t]+\"Lua .+\"")

  STRING(REGEX REPLACE "^#define[ \t]+LUA_RELEASE[ \t]+\"Lua ([^\"]+)\".*" "\\1" LUA_VERSION_STRING "${lua_version_str}")
  UNSET(lua_version_str)
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LUA_FOUND to TRUE if 
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Lua
                                  REQUIRED_VARS LUA_LIBRARIES LUA_INCLUDE_DIR
                                  VERSION_VAR LUA_VERSION_STRING)

MARK_AS_ADVANCED(LUA_INCLUDE_DIR LUA_LIBRARIES LUA_LIBRARY LUA_MATH_LIBRARY LUA_EXECUTABLE)

