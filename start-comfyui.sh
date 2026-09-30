#!/bin/bash
docker exec -d -e CUDA_VISIBLE_DEVICES=0 comfyui bash -c 'cd /workspace && python3 main.py --listen 0.0.0.0 --lowvram --disable-smart-memory --auto-launch --enable-manager'