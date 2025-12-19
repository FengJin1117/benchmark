#!/bin/bash
echo "评测opencpop"

# 设置GPU
export CUDA_VISIBLE_DEVICES=2
# 0.设置数据集
DIR="$(cd "$(dirname "$0")" && pwd)"
NEW_PATH="/data7/fwh/data/opencpop_test_stars"
sed -i "s|^OPENCPOP=.*|OPENCPOP=\"$NEW_PATH\"|" "$DIR/db.sh"
echo "数据集路径：${NEW_PATH}"
DATA_SOURCE="fix_opencpop_stars"

# 1.数据准备
# ./run.sh \
#     --fs 44100 \
#     --n_shift 512 \
#     --win_length 2048 \
#     --stage 1 \
#     --stop_stage 4 \

# # 2. 模型推理
echo "RNN"
./run.sh \
    --stage 7 \
    --stop_stage 7 \
    --fs 44100 \
    --n_fft 2048 \
    --n_shift 512 \
    --win_length 2048 \
    --svs_task svs \
    --pitch_extract dio \
    --feats_extract fbank \
    --feats_normalize none \
    --score_feats_extract syllable_score_feats \
    --inference_config conf/tuning/decode_vits.yaml \
    --inference_model valid.loss.ave_2best.pth \
    --write_collected_feats true \
    --inference_nj 1 \
    --vocoder_file /data7/fwh/vocoder/train_nodev_opencpop_hifigan.v1/checkpoint-250000steps.pkl \
    --svs_exp checkpoints/opencpop_naive_rnn_dp/exp/svs_train_naive_rnn_dp_raw_phn_None_zh \
    --inference_tag "${DATA_SOURCE}"

echo "Xiaoice"
./run.sh \
    --stage 7 \
    --stop_stage 7 \
    --fs 44100 \
    --n_fft 2048 \
    --n_shift 512 \
    --win_length 2048 \
    --svs_task svs \
    --pitch_extract dio \
    --feats_extract fbank \
    --feats_normalize none \
    --score_feats_extract syllable_score_feats \
    --inference_config conf/tuning/decode_vits.yaml \
    --inference_model 470epoch.pth \
    --write_collected_feats true \
    --inference_nj 1 \
    --vocoder_file /data7/fwh/vocoder/train_nodev_opencpop_hifigan.v1/checkpoint-250000steps.pkl \
    --svs_exp checkpoints/opencpop_xiaoice/exp/svs_train_xiaoice_raw_phn_None_zh \
    --inference_tag "${DATA_SOURCE}"


echo "VISinger"
./run.sh \
    --stage 7 \
    --stop_stage 7 \
    --fs 44100 \
    --n_fft 2048 \
    --n_shift 512 \
    --win_length 2048 \
    --svs_task gan_svs \
    --pitch_extract dio \
    --feats_extract fbank \
    --feats_normalize none \
    --score_feats_extract syllable_score_feats \
    --inference_config conf/tuning/decode_vits.yaml \
    --inference_model 500epoch.pth \
    --write_collected_feats true \
    --inference_nj 3 \
    --svs_exp checkpoints/opencpop_visinger/exp/svs_visinger_normal \
    --inference_tag "${DATA_SOURCE}"

echo "VISinger2"
./run.sh \
    --stage 7 \
    --stop_stage 7 \
    --fs 44100 \
    --n_fft 2048 \
    --n_shift 512 \
    --win_length 2048 \
    --svs_task gan_svs \
    --pitch_extract dio \
    --feats_extract fbank \
    --feats_normalize none \
    --score_feats_extract syllable_score_feats \
    --inference_config conf/tuning/decode_vits.yaml \
    --inference_model 500epoch.pth \
    --write_collected_feats true \
    --inference_nj 3 \
    --svs_exp checkpoints/opencpop_visinger2/exp/svs_visinger2_normal \
    --inference_tag "${DATA_SOURCE}"


echo "音频推理完毕"