# CUDA_VISIBLE_DEVICES=0 ./train_job_ad_multi_neg.sh \
#   "$DATA/job_ad_synthetic/negative_syslowcon $DATA/job_ad_synthetic/negative_swapent" \
#   $TRAINED_MODELS/bart_job_ad/syslowcon_swapent

./decode_job_ad.sh /dccstor/autofair/busekorkmaz/cliff_summ/models/bart_job_ad/checkpoint_last.pt dccstor/autofair/busekorkmaz/cliff_summ/output/

# fairseq-preprocess --source-lang source --target-lang target \
#  --testpref $DATA/job_ad_raw/test.bpe \
#  --destdir $DATA/job_ad_binarized/test.bpe \
#  --workers 60 \
#  --srcdict $DATA/pretrain_language_models/fairseq.gpt2/dict.txt \
#  --tgtdict $DATA/pretrain_language_models/fairseq.gpt2/dict.txt