FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV HF_HUB_OFFLINE=1
ENV TRANSFORMERS_OFFLINE=1

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    python3-pip \
    git \
    wget \
    curl \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python

COPY requirements.txt manager_requirements.txt .

RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir -r manager_requirements.txt

COPY . .

ENV PYTHONPATH=/workspace
ENV CUDA_MODULE_LOADING=LAZY

EXPOSE 8188

# 显存够大的话，这里应该可以调整 lowvram、 disable-smart-memory 这些参数的，问一下AI
# CMD ["python", "main.py", "--listen", "0.0.0.0", "--enable-manager"]
CMD ["python", "main.py", "--listen", "0.0.0.0", "--lowvram", "--disable-smart-memory", "--auto-launch", "--enable-manager"]
