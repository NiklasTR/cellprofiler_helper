#!/bin/sh
pip install --user pandas
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-28T18_17_15-Measurement_2/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" pc
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-29T18_47_53-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" pc
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-28T18_17_15-Measurement_2/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" bf
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-29T18_47_53-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" bf
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-28T18_17_15-Measurement_2/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" ce
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-29T18_47_53-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" ce
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-28T18_17_15-Measurement_2/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" tm
python ~/dcp_helper/python/ManualMetadata_dir.py ~/dcp_helper/metadata/000012094903__2019-08-29T18_47_53-Measurement_3/ "['Metadata_parent','Metadata_timepoint', 'Metadata_well', 'Metadata_fld', 'Metadata_channel']" tm
