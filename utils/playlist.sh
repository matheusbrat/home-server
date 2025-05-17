#!/bin/bash

# Set the directory containing the M3U8 files
m3u8_dir="$1"  # Get the directory from the first command-line argument
output_dir="$2" # Get the output directory from the second command-line argument
python_script="m3u8_converter.py" # Name of the python script

# Check if the input directory is provided
if [ -z "$m3u8_dir" ]; then
  echo "Error: Please provide the directory containing the M3U8 files as the first argument."
  echo "Usage: $0 <input_directory> <output_directory>"
  exit 1
fi

# Check if the input directory exists
if [ ! -d "$m3u8_dir" ]; then
  echo "Error: Input directory not found: $m3u8_dir"
  exit 1
fi

# Check if the output directory is provided
if [ -z "$output_dir" ]; then
  echo "Error: Please provide the output directory as the second argument."
  echo "Usage: $0 <input_directory> <output_directory>"
  exit 1
fi

# Check if the output directory exists, create it if it doesn't
if [ ! -d "$output_dir" ]; then
  echo "Output directory not found: $output_dir. Creating it."
  mkdir -p "$output_dir" # Use -p to create parent directories if needed
  if [ $? -ne 0 ]; then
    echo "Error creating output directory: $output_dir"
    exit 1
  fi
fi

# Check if the python script exists
if [ ! -f "$python_script" ]; then
  echo "Error: Python script not found: $python_script.  Make sure it is in the same directory as this bash script, or provide the correct path."
  exit 1
fi

# Loop through all .m3u8 files in the directory
find "$m3u8_dir" -name "*.m3u8" -print0 | while IFS= read -r -d $'\0' file; do
  # Create an output filename in the specified output directory
  filename=$(basename "$file") # Get the filename without the path
  output_file="$output_dir/$filename"

  # Convert the paths in the M3U8 file
  echo "Converting: $file to $output_file"
  python3 "$python_script" "$file" "$output_file"
  if [ $? -ne 0 ]; then
    echo "Error converting $file.  Check the python script for details."
  fi
done

echo "Conversion complete."

