#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

# spectrogram-related arguments
fs=44100 # 24000 or 44100
fmin=
fmax=
n_fft=
n_shift=
win_length=
svs_exp="" 

if [ $fs -eq 24000 ]; then
    fmin=0
    fmax=22050
    n_fft=2048
    n_shift=300
    win_length=1200
elif [ $fs -eq 44100 ]; then
    fmin=0
    fmax=22050
    n_fft=2048
    n_shift=512
    win_length=2048
fi

score_feats_extract=syllable_score_feats   # frame_score_feats | syllable_score_feats

opts="--audio_format wav "


train_set=test
valid_set=test
# test_sets="dev test"
test_sets="test" # 直接测试test

# train_set=opencpop
# valid_set=opencpop
# test_sets="opencpop"

# training and inference configuration
train_config=conf/train.yaml
inference_config=conf/decode.yaml
inference_tag=""

# text related processing arguments
g2p=None
cleaner=none

pitch_extract=dio
ying_extract=None
feats_extract=fbank

# 这里指定了训练集
./svs.sh \
    --lang zh \
    --local_data_opts "--stage 0" \
    --feats_type raw \
    --pitch_extract "${pitch_extract}" \
    --ying_extract "${ying_extract}" \
    --feats_extract "${}" feats_extract
    --fs "${fs}" \
    --fmax "${fmax}" \
    --fmin "${fmin}" \
    --n_fft "${n_fft}" \
    --n_shift "${n_shift}" \
    --win_length "${win_length}" \
    --token_type phn \
    --g2p ${g2p} \
    --cleaner ${cleaner} \
    --train_config "${train_config}" \
    --inference_config "${inference_config}" \
    --inference_tag "${inference_tag}" \
    --train_set "${train_set}" \
    --valid_set "${valid_set}" \
    --test_sets "${test_sets}" \
    --score_feats_extract "${score_feats_extract}" \
    --srctexts "data/${train_set}/text" \
    --svs_exp "${svs_exp}" \
    ${opts} "$@"

# 只有test数据集
# ./svs.sh \
#     --lang zh \
#     --local_data_opts "--stage 0" \
#     --feats_type raw \
#     --pitch_extract "${pitch_extract}" \
#     --ying_extract "${ying_extract}" \
#     --fs "${fs}" \
#     --fmax "${fmax}" \
#     --fmin "${fmin}" \
#     --n_fft "${n_fft}" \
#     --n_shift "${n_shift}" \
#     --win_length "${win_length}" \
#     --token_type phn \
#     --g2p ${g2p} \
#     --cleaner ${cleaner} \
#     --inference_config "${inference_config}" \
#     --inference_tag "${inference_tag}" \
#     --test_sets "${test_sets}" \
#     --score_feats_extract "${score_feats_extract}" \
#     --svs_exp "${svs_exp}" \
#     ${opts} "$@"