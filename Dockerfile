# Use PyTorch base image with CUDA support
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Clone the BAGEL repository
RUN git clone https://github.com/bytedance-seed/BAGEL.git .

# Set environment variables
ENV PYTHONPATH=/app
ENV HF_HOME=/app/huggingface_cache

# Create a non-root user and switch to it
RUN useradd -m -u 1000 user
USER user
WORKDIR /app

# Command to run when the container starts
CMD ["bash"]
