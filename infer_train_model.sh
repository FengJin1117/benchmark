#!/bin/bash
# 请输入genre：
GENRE="rock"
echo "评测GENRE: ${GENRE}"

# 设置GPU
export CUDA_VISIBLE_DEVICES=2
# 0.设置数据集
DIR="$(cd "$(dirname "$0")" && pwd)"
NEW_PATH="/data7/fwh/benchdata/suno_score_fix/${GENRE}"
sed -i "s|^OPENCPOP=.*|OPENCPOP=\"$NEW_PATH\"|" "$DIR/db.sh"
echo "数据集路径：${NEW_PATH}"
DATA_SOURCE="fix_suno_${GENRE}"


# 1.数据准备
./run.sh \
    --fs 44100 \
    --n_shift 512 \
    --win_length 2048 \
    --stage 1 \
    --stop_stage 4 \

# 2. 模型推理
echo "VISinger2"
./run.sh \
    --stage 7 \
    --stop_stage 7 \
    --svs_task gan_svs \
    --feats_extract fbank \
    --feats_normalize none \
    --inference_config conf/tuning/decode_vits.yaml \
    --inference_model 250epoch.pth \
    --write_collected_feats true \
    --inference_nj 3 \
    --svs_exp checkpoints/rock_visinger2 \
    --inference_tag "${DATA_SOURCE}"


# echo "音频推理完毕"