import hashlib
import os
import math
from typing import Tuple, Optional
from PIL import Image

try:
    import cv2
    import numpy as np
    HAS_OPENCV = True
except ImportError:
    HAS_OPENCV = False


def calculate_sha256(image_path: str) -> Optional[str]:
    """Calculates SHA-256 hash of image file for exact duplicate identification."""
    if not os.path.exists(image_path):
        return None
    h = hashlib.sha256()
    with open(image_path, "rb") as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()


def calculate_dhash(image_path: str, hash_size: int = 8) -> Optional[str]:
    """
    Calculates difference hash (dHash) using PIL.
    Resizes image to (hash_size + 1, hash_size), converts to grayscale,
    and computes horizontal pixel gradients.
    """
    if not os.path.exists(image_path):
        return None
    try:
        with Image.open(image_path) as img:
            # Convert to grayscale and resize
            img = img.convert("L").resize((hash_size + 1, hash_size), Image.Resampling.LANCZOS)
            pixels = list(img.getdata())
            
            # Compute difference between adjacent pixels in each row
            diff = []
            for row in range(hash_size):
                row_offset = row * (hash_size + 1)
                for col in range(hash_size):
                    pixel_left = pixels[row_offset + col]
                    pixel_right = pixels[row_offset + col + 1]
                    diff.append(pixel_left > pixel_right)
            
            # Convert boolean array to hex string
            decimal_value = 0
            hex_string = []
            for i, val in enumerate(diff):
                if val:
                    decimal_value += 2 ** (i % 4)
                if (i % 4) == 3:
                    hex_string.append(hex(decimal_value)[2:])
                    decimal_value = 0
            return "".join(hex_string)
    except Exception:
        return None


def calculate_ahash(image_path: str, hash_size: int = 8) -> Optional[str]:
    """
    Calculates average hash (aHash) using PIL.
    Resizes to (hash_size, hash_size), converts to grayscale,
    and compares each pixel to the average pixel value.
    """
    if not os.path.exists(image_path):
        return None
    try:
        with Image.open(image_path) as img:
            img = img.convert("L").resize((hash_size, hash_size), Image.Resampling.LANCZOS)
            pixels = list(img.getdata())
            avg = sum(pixels) / len(pixels)
            diff = [p > avg for p in pixels]
            
            decimal_value = 0
            hex_string = []
            for i, val in enumerate(diff):
                if val:
                    decimal_value += 2 ** (i % 4)
                if (i % 4) == 3:
                    hex_string.append(hex(decimal_value)[2:])
                    decimal_value = 0
            return "".join(hex_string)
    except Exception:
        return None


def hamming_distance(hex1: Optional[str], hex2: Optional[str]) -> int:
    """Calculates Hamming distance between two hex hashes of equal length."""
    if not hex1 or not hex2 or len(hex1) != len(hex2):
        return 64  # Maximum difference for 64-bit hash
    
    # Count differing bits
    dist = 0
    for c1, c2 in zip(hex1, hex2):
        val1 = int(c1, 16)
        val2 = int(c2, 16)
        xor_val = val1 ^ val2
        dist += bin(xor_val).count("1")
    return dist


def perceptual_hash_similarity(hash1: Optional[str], hash2: Optional[str], max_bits: int = 64) -> float:
    """
    Normalizes Hamming distance into a 0.0 - 1.0 similarity score.
    Distance 0 = 1.0 (identical)
    Distance >= 32 = 0.0 (completely dissimilar)
    """
    if not hash1 or not hash2:
        return 0.0
    dist = hamming_distance(hash1, hash2)
    # Distance <= 10 is considered visually similar in perceptual hashing
    # Linear decay from 0 to 32 bits
    sim = max(0.0, 1.0 - (dist / 32.0))
    return round(sim, 3)


def compute_cv_feature_similarity(image_path1: str, image_path2: str) -> float:
    """
    Computes computer vision feature similarity using OpenCV:
    1. HSV Color Histogram correlation (50% weight)
    2. Canny Edge Density difference (50% weight)
    """
    if not HAS_OPENCV or not os.path.exists(image_path1) or not os.path.exists(image_path2):
        return 0.5  # Neutral fallback

    try:
        img1 = cv2.imread(image_path1)
        img2 = cv2.imread(image_path2)
        if img1 is None or img2 is None:
            return 0.5

        # Resize to standard comparison dimensions
        standard_size = (300, 300)
        img1 = cv2.resize(img1, standard_size)
        img2 = cv2.resize(img2, standard_size)

        # 1. HSV Histogram Comparison
        hsv1 = cv2.cvtColor(img1, cv2.COLOR_BGR2HSV)
        hsv2 = cv2.cvtColor(img2, cv2.COLOR_BGR2HSV)
        hist1 = cv2.calcHist([hsv1], [0, 1], None, [30, 32], [0, 180, 0, 256])
        hist2 = cv2.calcHist([hsv2], [0, 1], None, [30, 32], [0, 180, 0, 256])
        cv2.normalize(hist1, hist1, alpha=0, beta=1, norm_type=cv2.NORM_MINMAX)
        cv2.normalize(hist2, hist2, alpha=0, beta=1, norm_type=cv2.NORM_MINMAX)
        hist_corr = cv2.compareHist(hist1, hist2, cv2.HISTCMP_CORREL)
        hist_score = max(0.0, min(1.0, (hist_corr + 1.0) / 2.0))

        # 2. Edge Signature Comparison
        gray1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
        gray2 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
        edges1 = cv2.Canny(gray1, 100, 200)
        edges2 = cv2.Canny(gray2, 100, 200)
        edge_density1 = np.sum(edges1 > 0) / (300 * 300)
        edge_density2 = np.sum(edges2 > 0) / (300 * 300)
        edge_diff = abs(edge_density1 - edge_density2)
        edge_score = max(0.0, 1.0 - (edge_diff * 4.0))

        return round(0.5 * hist_score + 0.5 * edge_score, 3)
    except Exception:
        return 0.5


def calculate_image_similarity(
    image_path1: str,
    image_path2: str,
    phash1: Optional[str] = None,
    phash2: Optional[str] = None,
    sha1: Optional[str] = None,
    sha2: Optional[str] = None
) -> Tuple[float, str]:
    """
    Calculates overall visual similarity between two images.
    Returns (similarity_score: 0.0 - 1.0, match_type: 'EXACT_HASH' | 'PERCEPTUAL_MATCH' | 'CV_MATCH' | 'DISSIMILAR').
    """
    # 1. Exact SHA-256 Match
    s1 = sha1 or calculate_sha256(image_path1)
    s2 = sha2 or calculate_sha256(image_path2)
    if s1 and s2 and s1 == s2:
        return 1.0, "EXACT_HASH"

    # 2. Perceptual Hash Match (dHash)
    h1 = phash1 or calculate_dhash(image_path1)
    h2 = phash2 or calculate_dhash(image_path2)
    phash_sim = perceptual_hash_similarity(h1, h2)
    if phash_sim >= 0.90:
        return phash_sim, "PERCEPTUAL_MATCH"

    # 3. Computer Vision Feature Match (if files exist on disk)
    cv_sim = compute_cv_feature_similarity(image_path1, image_path2)

    # Weighted combination: 60% pHash, 40% CV feature comparison
    final_visual_score = round(0.60 * phash_sim + 0.40 * cv_sim, 3)
    match_type = "CV_MATCH" if final_visual_score >= 0.60 else "DISSIMILAR"
    return final_visual_score, match_type
