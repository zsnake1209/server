# Copyright (c) 2006, 2015, Oracle and/or its affiliates. All rights reserved.
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
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/include
  ${PCRE_INCLUDES}
  ${CMAKE_SOURCE_DIR}/mysys_ssl
  ${ZLIB_INCLUDE_DIR}
  ${SSL_INCLUDE_DIRS}
  ${CMAKE_SOURCE_DIR}/libmysql
  ${CMAKE_SOURCE_DIR}/sql
  ${CMAKE_SOURCE_DIR}/strings
  ${MY_READLINE_INCLUDE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
)

INCLUDE_DIRECTORIES(
  BEFORE
  ${CONNECTOR_C_INSTALLDIR}/include/mariadb
)
## We will need libeay32.dll and ssleay32.dll when running client executables.
COPY_OPENSSL_DLLS(copy_openssl_client)

IF(WITH_LIBMARIADB)
  ADD_DEFINITIONS(-DHAVE_LIBMARIADB=1)
  SET(PASSWORD_SOURCE ${CMAKE_SOURCE_DIR}/client/get_password.c)
  SET(static_link_library mariadbclient)
ELSE()
  SET(static_link_library mysqlclient)
ENDIF()

ADD_DEFINITIONS(${SSL_DEFINES})
MYSQL_ADD_EXECUTABLE(mysql ${PASSWORD_SOURCE} completion_hash.cc mysql.cc readline.cc
                           ${CMAKE_SOURCE_DIR}/sql/sql_string.cc)
TARGET_LINK_LIBRARIES(mysql ${static_link_library} mysys)
IF(UNIX)
  TARGET_LINK_LIBRARIES(mysql ${MY_READLINE_LIBRARY})
  SET_TARGET_PROPERTIES(mysql PROPERTIES ENABLE_EXPORTS TRUE)
ENDIF(UNIX)

MYSQL_ADD_EXECUTABLE(mysqltest mysqltest.cc COMPONENT Test)
SET_SOURCE_FILES_PROPERTIES(mysqltest.cc PROPERTIES COMPILE_FLAGS "-DTHREADS")
TARGET_LINK_LIBRARIES(mysqltest  ${static_link_library} pcre pcreposix)
SET_TARGET_PROPERTIES(mysqltest PROPERTIES ENABLE_EXPORTS TRUE)


MYSQL_ADD_EXECUTABLE(mysqlcheck mysqlcheck.c)
TARGET_LINK_LIBRARIES(mysqlcheck ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysqldump mysqldump.c ../sql-common/my_user.c)
TARGET_LINK_LIBRARIES(mysqldump ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysqlimport mysqlimport.c)
SET_SOURCE_FILES_PROPERTIES(mysqlimport.c PROPERTIES COMPILE_FLAGS "-DTHREADS")
TARGET_LINK_LIBRARIES(mysqlimport ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysql_upgrade mysql_upgrade.c COMPONENT Server)
TARGET_LINK_LIBRARIES(mysql_upgrade ${static_link_library})
ADD_DEPENDENCIES(mysql_upgrade GenFixPrivs)

MYSQL_ADD_EXECUTABLE(mysqlshow mysqlshow.c)
TARGET_LINK_LIBRARIES(mysqlshow ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysql_plugin mysql_plugin.c)
TARGET_LINK_LIBRARIES(mysql_plugin ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysqlbinlog mysqlbinlog.cc)
TARGET_LINK_LIBRARIES(mysqlbinlog ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysqladmin ${PASSWORD_SOURCE} mysqladmin.cc)
TARGET_LINK_LIBRARIES(mysqladmin ${static_link_library})

MYSQL_ADD_EXECUTABLE(mysqlslap mysqlslap.c)
SET_SOURCE_FILES_PROPERTIES(mysqlslap.c PROPERTIES COMPILE_FLAGS "-DTHREADS")
TARGET_LINK_LIBRARIES(mysqlslap ${static_link_library})

# "WIN32" also covers 64 bit. "echo" is used in some files below "mysql-test/".
IF(WIN32)
  MYSQL_ADD_EXECUTABLE(echo echo.c COMPONENT Junk)
ENDIF(WIN32)

# async_example is just a code example, do not install it.
ADD_EXECUTABLE(async_example async_example.c)
TARGET_LINK_LIBRARIES(async_example ${static_link_library})

SET_TARGET_PROPERTIES (mysqlcheck mysqldump mysqlimport mysql_upgrade mysqlshow mysqlslap mysql_plugin async_example
PROPERTIES HAS_CXX TRUE)

ADD_DEFINITIONS(-DHAVE_DLOPEN)

