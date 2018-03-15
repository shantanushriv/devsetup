#!/bin/sh

# Please see the README and LICENSE information first.
# You are free to do modify or redistribute this code provided that the
# license & copyright information above are kept intact

# This program is a customizable script to generate the cscope database from your source code. 
# This makes it very easy to browse code from your favourite editor. 
# Copyright (C) 2009-2010 Venkatesh Rao 

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# /Change history/
#	
#	August 2010-
#	Script is now more generic and added license information
#	Taking second argument for the tags repository

#	June 2010-
#	Added success/error messages to show what is going on currently

#	Sep 2009-
#	Added more help
#	Made search directories more generic by using variables

#	Aug 2009-
#	Initial Version

usage="Too few arguments\\nUsage: $ $0 <full-path-to-sources-root> <full-path-to-tags-root>"

if [[ $# -le 1 ]]
then
	echo -e $usage
	exit
fi

# Set view before running this script
source=$1
repo=$2
echo "Source root: $source"
echo "Tag root: $repo"


# Search here
# --- Add more directories to search ---

# Generate output files here
cscope_files=$repo/cscope.files
cscope_tag_root=$repo

# Friendly messages
done_msg="Done!"
creating_tag_root_msg="Creating tags root directory ..."
removing_existing_tags_msg="Removing existing tags ..."
finding_files_msg="Finding files..."
find_done_msg="Files found!"
db_building_msg="Building database..."
db_done_msg="Cscope database generated!"
env_var_done_msg="CSCOPE_DB set to $CSCOPE_DB"

# Remove tags directory if it already exists
echo $removing_existing_tags_msg
rm -rf $repo
echo $done_msg

# Create tags directory
echo $creating_tag_root_msg
mkdir $repo
echo $done_msg

echo $finding_files_msg

# Change directory to root so that cscope.files has absolute pathnames for all files
cd /

# Find in source 
#find $source -name '*.cc' -o -name '*.h' -o -name '*.c' -o -name '*akefile' >> $cscope_files
#find $source -name '*.cc' -o -name '*.h' -o -name '*.c'  -o -name '*akefile' -o -name '*.xml' >> $cscope_files
find $source -name '*.py' -o -name '*.yaml' -o -name '*.yml'  -o -name '*akefile*' -o -name '*.pm' -o -name '*.sh' -o -name '*.xml' | grep -v '.virtualenv' >> $cscope_files

# Go back to original directory
cd -
echo $find_done_msg

echo $db_building_msg
# Generate tags for the files generated
# But first cd to the directory where cscope.files are generated
cd $cscope_tag_root
architecture=`uname -a`
if [[ $architecture =~ .*x86_64.* ]]
then
    echo "64 bit architecture.. calling that binary"    
    pycscope -R -i $cscope_files > /dev/null
fi    
echo $db_done_msg

# ----------------- FIX ME -----------------------------------
# Set environment variable CSCOPE_DB to the correct cscope.out file
#cs_db=CSCOPE_DB
#$cs_db=$cscope_out_dir/cscope.out
#export $cs_db
#echo $env_var_done_msg
# ------------------------------------------------------------
