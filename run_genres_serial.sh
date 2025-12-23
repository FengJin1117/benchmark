#!/bin/bash
set -e

# ===== 需要评测的 genre（按顺序串行）=====
genres=(
  # blues
  # classical
  # country
  # electronic
  # jazz
  # rap
  rnb
  rock
  world
)

# ===== 固定使用的 GPU =====
GPU_ID=7
export CUDA_VISIBLE_DEVICES=${GPU_ID}

echo "[INFO] Use single GPU: ${GPU_ID}"
echo "===================================="

for genre in "${genres[@]}"; do
  echo
  echo "===================================="
  echo "[START] GENRE=${genre}"
  echo "===================================="

  bash infer_one.sh "${genre}" "${GPU_ID}"

  echo "===================================="
  echo "[DONE ] GENRE=${genre}"
  echo "===================================="
done

echo
echo "[ALL GENRES FINISHED]"
