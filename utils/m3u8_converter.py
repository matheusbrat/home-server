import sys
import os
import re

def convert_m3u8_paths(input_file, output_file):
    """
    Converts Windows-style file paths in an M3U8 file to Linux-style.

    Args:
        input_file (str): The path to the input M3U8 file.
        output_file (str): The path to the output M3U8 file.
    """
    try:
        with open(input_file, 'r', encoding='utf-8') as infile:
            lines = infile.readlines()
    except FileNotFoundError:
        print(f"Error: Input file not found: {input_file}")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading input file: {e}")
        sys.exit(1)

    converted_lines = []
    for line in lines:
        # Use a raw string for the regex to handle backslashes correctly
        converted_line = re.sub(r'^[a-zA-Z]:\\', '/music/', line)  # Basic drive letter conversion
        converted_line = converted_line.replace('\\', '/')  # Replace backslashes with forward slashes.
        converted_lines.append(converted_line)

    try:
        with open(output_file, 'w', encoding='utf-8') as outfile:
            outfile.writelines(converted_lines)
        print(f"Successfully converted paths and saved to {output_file}")
    except Exception as e:
        print(f"Error writing to output file: {e}")
        sys.exit(1)

def main():
    """
    Main function to handle command-line arguments.
    """
    if len(sys.argv) != 3:
        print("Usage: python m3u8_converter.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    convert_m3u8_paths(input_file, output_file)

if __name__ == "__main__":
    main()

