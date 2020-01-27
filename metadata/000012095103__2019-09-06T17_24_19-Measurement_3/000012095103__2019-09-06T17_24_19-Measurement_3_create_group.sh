#!/bin/sh
pip install --user pandas
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012095103__2019-09-06T17_24_19-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" pc
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012095103__2019-09-06T17_24_19-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" bf
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012095103__2019-09-06T17_24_19-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" ce
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012095103__2019-09-06T17_24_19-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" tm
