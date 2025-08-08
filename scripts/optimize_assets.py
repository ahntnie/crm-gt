#!/usr/bin/env python3
"""
Script tối ưu hóa assets cho Flutter app
Giảm dung lượng hình ảnh và tối ưu hóa SVG
"""

import os
import sys
from PIL import Image
import subprocess
import shutil

def optimize_image(input_path, output_path, quality=85, max_size=(1024, 1024)):
    """Tối ưu hóa hình ảnh"""
    try:
        with Image.open(input_path) as img:
            # Convert to RGB if necessary
            if img.mode in ('RGBA', 'LA', 'P'):
                img = img.convert('RGB')
            
            # Resize if too large
            if img.size[0] > max_size[0] or img.size[1] > max_size[1]:
                img.thumbnail(max_size, Image.Resampling.LANCZOS)
            
            # Save optimized image
            img.save(output_path, 'JPEG', quality=quality, optimize=True)
            
            original_size = os.path.getsize(input_path)
            optimized_size = os.path.getsize(output_path)
            reduction = ((original_size - optimized_size) / original_size) * 100
            
            print(f"✓ {input_path} -> {output_path}")
            print(f"  Size: {original_size/1024:.1f}KB -> {optimized_size/1024:.1f}KB ({reduction:.1f}% reduction)")
            
    except Exception as e:
        print(f"✗ Error optimizing {input_path}: {e}")

def optimize_svg(input_path, output_path):
    """Tối ưu hóa SVG (cần cài đặt svgo)"""
    try:
        # Check if svgo is installed
        result = subprocess.run(['svgo', '--version'], capture_output=True, text=True)
        if result.returncode != 0:
            print(f"⚠ svgo not found, skipping SVG optimization for {input_path}")
            return
        
        # Optimize SVG
        subprocess.run([
            'svgo', 
            '--multipass',
            '--precision=2',
            '--disable=removeViewBox',
            input_path,
            '-o', output_path
        ], check=True)
        
        original_size = os.path.getsize(input_path)
        optimized_size = os.path.getsize(output_path)
        reduction = ((original_size - optimized_size) / original_size) * 100
        
        print(f"✓ {input_path} -> {output_path}")
        print(f"  Size: {original_size} bytes -> {optimized_size} bytes ({reduction:.1f}% reduction)")
        
    except Exception as e:
        print(f"✗ Error optimizing SVG {input_path}: {e}")

def main():
    """Main function"""
    print("🚀 Starting assets optimization...")
    
    # Create backup directory
    backup_dir = "assets_backup"
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)
        print(f"📁 Created backup directory: {backup_dir}")
    
    # Optimize images
    image_extensions = ['.png', '.jpg', '.jpeg', '.webp']
    image_dir = "assets/images"
    
    if os.path.exists(image_dir):
        print(f"\n🖼️  Optimizing images in {image_dir}...")
        
        for filename in os.listdir(image_dir):
            if any(filename.lower().endswith(ext) for ext in image_extensions):
                input_path = os.path.join(image_dir, filename)
                output_path = os.path.join(image_dir, f"optimized_{filename}")
                
                # Backup original
                backup_path = os.path.join(backup_dir, filename)
                shutil.copy2(input_path, backup_path)
                
                # Optimize
                optimize_image(input_path, output_path)
                
                # Replace original with optimized
                os.remove(input_path)
                os.rename(output_path, input_path)
    
    # Optimize SVGs
    svg_dir = "assets/svgs"
    
    if os.path.exists(svg_dir):
        print(f"\n🎨 Optimizing SVGs in {svg_dir}...")
        
        for filename in os.listdir(svg_dir):
            if filename.lower().endswith('.svg'):
                input_path = os.path.join(svg_dir, filename)
                output_path = os.path.join(svg_dir, f"optimized_{filename}")
                
                # Backup original
                backup_path = os.path.join(backup_dir, filename)
                shutil.copy2(input_path, backup_path)
                
                # Optimize
                optimize_svg(input_path, output_path)
                
                # Replace original with optimized
                os.remove(input_path)
                os.rename(output_path, input_path)
    
    print(f"\n✅ Assets optimization completed!")
    print(f"📦 Original files backed up in: {backup_dir}")
    print(f"💡 To restore: copy files from {backup_dir} back to assets/")

if __name__ == "__main__":
    main() 