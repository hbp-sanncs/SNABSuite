#  SNABSuite -- Spiking Neural Architecture Benchmark Suite
#  Copyright (C) 2018  Christoph Jenzen
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.


find_package(PythonLibs 2.7 REQUIRED )
find_package(PythonInterp 2.7 REQUIRED)

include(ExternalProject)
ExternalProject_Add(cypress_ext
    GIT_REPOSITORY        "https://github.com/hbp-unibi/cypress/"
    GIT_TAG               pybind
    UPDATE_COMMAND        git pull
    CMAKE_ARGS            -DSTATIC_LINKING=${STATIC_LINKING} -DCMAKE_INSTALL_PREFIX:path=<INSTALL_DIR> -DCMAKE_BUILD_TYPE:STRING=${DCMAKE_BUILD_TYPE}
    INSTALL_COMMAND 	  ""
    EXCLUDE_FROM_ALL      1
)
ExternalProject_Get_Property(cypress_ext SOURCE_DIR BINARY_DIR)


set(CYPRESS_INCLUDE_DIRS 
	${SOURCE_DIR}/
	${SOURCE_DIR}/external/pybind11/include/
	${BINARY_DIR}/include/
	${PYTHON_INCLUDE_DIRS}
)
set(CYPRESS_LIBRARY
	${BINARY_DIR}/libcypress.a
    ${PYTHON_LIBRARIES}
    -pthread
)

set(GTEST_LIBRARIES
    ${BINARY_DIR}/googletest-prefix/src/googletest-build/googlemock/gtest/libgtest.a
	${BINARY_DIR}/googletest-prefix/src/googletest-build/googlemock/gtest/libgtest_main.a
)
set(GTEST_INCLUDE_DIRS ${BINARY_DIR}/googletest-prefix/src/googletest/googletest/include/)
set(GTEST_FOUND TRUE)
message(warning ${PYTHON_EXECUTABLE})
execute_process(
    COMMAND "${PYTHON_EXECUTABLE}" -c
            "from __future__ import print_function\nimport numpy; print(numpy.get_include(), end='')"
            OUTPUT_VARIABLE numpy_path)
            
find_path(PYTHON_NUMPY_INCLUDE_DIR numpy/arrayobject.h 
    HINTS "${numpy_path}" "${PYTHON_INCLUDE_PATH}" NO_DEFAULT_PATH)

include_directories(
	${CYPRESS_INCLUDE_DIRS}
	${GTEST_INCLUDE_DIRS}
    ${PYTHON_NUMPY_INCLUDE_DIR}
)
