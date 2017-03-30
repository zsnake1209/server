# Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA 

MACRO (MYSQL_USE_BUNDLED_ZLIB)
  SET(ZLIB_LIBRARY  zlib)
  SET(ZLIB_INCLUDE_DIR  ${CMAKE_SOURCE_DIR}/zlib)
  SET(ZLIB_FOUND  TRUE)
  SET(WITH_ZLIB "bundled" CACHE STRING "Use bundled zlib")
  ADD_SUBDIRECTORY(zlib)
  GET_TARGET_PROPERTY(src zlib SOURCES)
  FOREACH(file ${src})
    SET(ZLIB_SOURCES ${ZLIB_SOURCES} ${CMAKE_SOURCE_DIR}/zlib/${file})
  ENDFOREACH()
ENDMACRO()

# MYSQL_CHECK_ZLIB_WITH_COMPRESS
#
# Provides the following configure options:
# WITH_ZLIB_BUNDLED
# If this is set,we use bindled zlib
# If this is not set,search for system zlib. 
# if system zlib is not found, use bundled copy
# ZLIB_LIBRARIES, ZLIB_INCLUDE_DIR and ZLIB_SOURCES
# are set after this macro has run

MACRO (MYSQL_CHECK_ZLIB_WITH_COMPRESS)  
  IF(WITH_ZLIB STREQUAL "bundled")
    MYSQL_USE_BUNDLED_ZLIB()
  ELSE()
    FIND_PACKAGE(ZLIB)
    IF(NOT ZLIB_FOUND)
      MYSQL_USE_BUNDLED_ZLIB()
    ENDIF()
  ENDIF()
  SET(HAVE_COMPRESS 1)
ENDMACRO()
