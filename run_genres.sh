#!/bin/bash

# ===== 需要评测的 genre =====
genres=(
  classical  
#   country  
#   electronic  
#   jazz  
#   rap
#   rnb
#   rock  
#   world
)

# ===== 可用 GPU =====
gpus=(
  0
  1
  4
  5
  6
  7
)

num_gpus=${#gpus[@]}
idx=0

for genre in "${genres[@]}"; do
  gpu_id=${gpus[$((idx % num_gpus))]}
  echo "[DISPATCH] ${genre} -> GPU ${gpu_id}"

  bash infer_one.sh "${genre}" "${gpu_id}" &

  idx=$((idx + 1))
done

wait
echo "[ALL DONE]"
