# #!/bin/env python3

# from PIL import Image
# import sys

# # Open the image
# image_name = sys.argv[1].split('.')

# image = Image.open(sys.argv[1]) # Replace 'your_image.bmp' with the image filename
# image_vga = Image.open(sys.argv[2])  # Replace 'your_image.bmp' with the image filename

# # Get image size
# width, height = image_vga.size

# # Create a binary file for output
# with open(sys.argv[3], 'wb') as binary_file:
#     # Write height and width as 1-byte values
#     binary_file.write(bytes([height % 256, height // 256])) # first word height, second word width

#     # Iterate through each row
#     for y in range(height):
#         row_colors = []
#         current_color = None
#         color_count = 0

#         width_row_data = 0

#         # Iterate through each pixel in the row
#         for x in range(width):
#             pixel = image.getpixel((x, y))
#             # Check if the pixel is transparent (alpha channel is 0)
#             if pixel[3] == 0:
#                 dos_color = -1
#             # Convert RGB values to DOS 256-bit color
#             else:
#                 dos_color = image_vga.getpixel((x, y))

#             if current_color is None:
#                 current_color = dos_color
#                 color_count = 1
#             elif current_color == dos_color and color_count < 255:
#                 color_count += 1
#             else:
#                 if current_color == -1:
#                     row_colors.append((0, 0, color_count))
#                     width_row_data += 3
#                 else:
#                     row_colors.append((current_color, color_count))
#                     width_row_data += 2
#                 current_color = dos_color
#                 color_count = 1

#         # Append the last color run
#         if current_color == -1:
#             row_colors.append((0, 0, color_count))
#             width_row_data += 3
#         else:
#             row_colors.append((current_color, color_count))
#             width_row_data += 2

#         # Write the width of the row
#         binary_file.write(bytes([width_row_data % 256, width_row_data // 256]))

#         # Write color data for each run
#         for color_tuple in row_colors:
#             binary_file.write(bytes(color_tuple))

# print(f"Binary file '{sys.argv[3]}' has been generated.")

from PIL import Image, ImageEnhance

# Load the image
image = Image.open('QWE.png')

image = image.resize((320,200))

# Ensure the image is in the correct mode (8-bit pixels, 256 colors)
image = image.convert('P')

# Get the pixel data
pixels = list(image.getdata())

# Get the palette data
palette = image.getpalette()

# Get image dimensions
width, height = image.size

# Convert pixel data to a format suitable for assembly
pixel_data = []
for y in range(height):
    for x in range(width):
        pixel_data.append(pixels[y * width + x])

# Write the pixel data and palette to a file
with open('pixel_data.asm', 'w') as file:
    file.write('pixel_data: db ')
    for i in range(len(pixel_data)):
        file.write(f'0x{pixel_data[i]:02X}')
        if i != len(pixel_data) - 1:
            file.write(', ')

    file.write('\n\npalette_data: db ')
    for i in range(0, len(palette), 3):
        file.write(f'0x{palette[i]//4:02X}, 0x{palette[i+1]//4:02X}, 0x{palette[i+2]//4:02X}')
        if i != len(palette) - 3:
            file.write(', ')

print("Pixel data and palette have been written to pixel_data.asm")