#Alex Brown	
#ESM 267
#Oct 20, 2019

# Goal of the script: Extract outline of SB County and re-project it into NAD83/California Albers using OGR. Reproject and cut tiff using GDAL

# shows the commands being run
set -x

#Create a new folder. This should allow it to run more easily on other computers.
mkdir -p output

# Shapefile information
ogrinfo -al -so tl_2018_us_county/tl_2018_us_county.shp
 
# Reproject the county raster data to NAD83/California Albers
ogr2ogr -t_srs EPSG:3310 output/counties.shp tl_2018_us_county/tl_2018_us_county.shp

# Check output file is California Albers
ogrinfo -al -so output/counties.shp

#Clip only SB county 
ogr2ogr -where "name='Santa Barbara'" output/SB_County.shp output/counties.shp

#Extract MODIS image using gdalwarp. Reproject into California Albers

#Reproject MODIS tiff file using gdalwarp into California Albers
gdalwarp -t_srs EPSG:3310 crefl2_A2019257204722-2019257205812_250m_ca-south-000_143.tif output/CA_reprojection.tif

#Crop MODIS file to SB_county.shp
gdalwarp -cutline output/SB_County.shp -crop_to_cutline -dstalpha output/CA_reprojection.tif output/SB_County.tif