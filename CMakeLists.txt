cmake_minimum_required(VERSION 3.12)

project(CDF2NCDF VERSION 1.0.0.0
  DESCRIPTION "CDF to NetCDF Build"
  LANGUAGES C)

set(CMAKE_PLATFORM_INDEPENDENT_CODE ON)

add_subdirectory(extern/cdfbuild)
add_subdirectory(extern/netcdf-c)
