# for SPLIT in train valid
# do
#   for STG in maskent maskrel
#   do
#     python /dccstor/autofair/busekorkmaz/mask_regen/lib/python3.8/site-packages/fairseq/examples/roberta/multiprocessing_bpe_encoder.py \
#             --encoder-json /dccstor/autofair/busekorkmaz/cliff_summ/data/pretrain_language_models/fairseq.gpt2/encoder.json \
#             --vocab-bpe $DATA/pretrain_language_models/fairseq.gpt2/vocab.bpe \
#             --inputs "$DATA/job_ad_synthetic/negative_$STG/$SPLIT.raw_target" \
#             --outputs "$DATA/job_ad_synthetic/negative_$STG/$SPLIT.neg_target" \
#             --workers 60 \
#             --keep-empty;
#   done
# done

# for SPLIT in train validation test
# do
#   for LANG in source target
#   do
#     python /dccstor/autofair/busekorkmaz/mask_regen/lib/python3.8/site-packages/fairseq/examples/roberta/multiprocessing_bpe_encoder.py \
#             --encoder-json /dccstor/autofair/busekorkmaz/cliff_summ/data/pretrain_language_models/fairseq.gpt2/encoder.json \
#             --vocab-bpe $DATA/pretrain_language_models/fairseq.gpt2/vocab.bpe \
#             --inputs "$DATA/job_ad_raw/$SPLIT.$LANG" \
#             --outputs "$DATA/job_ad_raw/$SPLIT.bpe.$LANG" \
#             --workers 60 \
#             --keep-empty;
#   done
# done

# fairseq-preprocess --source-lang source --target-lang target \
#  --trainpref $DATA/processed_data/job_ad_regeneration/train.bpe \
#  --validpref $DATA/processed_data/job_ad_regeneration/valid.bpe \
#  --destdir $DATA/processed_data/job_ad_regeneration \
#  --workers 60 \
#  --srcdict $DATA/pretrain_language_models/fairseq.gpt2/dict.txt \
#  --tgtdict $DATA/pretrain_language_models/fairseq.gpt2/dict.txt
# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train python filter_generated.py --generated-docbins $DATA/processed_data/job_ad_regeneration_output/train_generated.doc \
#  --source-docbins $DATA/processed_data/job_ad_stanza_docbin/train.source \
#  --target-docbins $DATA/processed_data/job_ad_stanza_docbin/train.target \
#  --other $DATA/processed_data/job_ad_regeneration_output/train_generated.other \
#  $DATA/processed_data/job_ad_regeneration_output/train_filtered.jsonl

#  jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train python get_new_ent_out.py $DATA/processed_data/job_ad_regeneration_output/train_filtered.jsonl $DATA/job_ad_synthetic/negative_regenent/train

#  jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train python get_new_rel_out.py $DATA/processed_data/job_ad_regeneration_output/train_filtered.jsonl $DATA/job_ad_synthetic/negative_regenrel/train

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train \
# for SPLIT in train valid
# do
#   for STG in regenent regenrel
#   do
#     python /dccstor/autofair/busekorkmaz/mask_regen/lib/python3.8/site-packages/fairseq/examples/roberta/multiprocessing_bpe_encoder.py \
#             --encoder-json /dccstor/autofair/busekorkmaz/cliff_summ/data/pretrain_language_models/fairseq.gpt2/encoder.json \
#             --vocab-bpe $DATA/pretrain_language_models/fairseq.gpt2/vocab.bpe \
#             --inputs "$DATA/job_ad_synthetic/negative_$STG/$SPLIT.raw_target" \
#             --outputs "$DATA/job_ad_synthetic/negative_$STG/$SPLIT.neg_target" \
#             --workers 60 \
#             --keep-empty;
#   done
# done

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train python swap_entity.py $DATA/job_ad_raw/train.source $DATA/job_ad_raw/train.target \
#  $DATA/job_ad_synthetic/negative_swapent/train_swap_same_entity.jsonl

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train python swap_entity_out.py $DATA/job_ad_raw/train.bpe.source $DATA/job_ad_synthetic/negative_swapent/train_swap_same_entity.jsonl \
#  $DATA/job_ad_synthetic/negative_swapent/train
# # 

BEAM_SIZE=6
MAX_LEN_B=60
MIN_LEN=10
LEN_PEN=1.0

DATA_PATH=$DATA/job_ad_binarized
RESULT_PATH=$DATA/processed_data/syslowcon_job_ad_generation

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train 
fairseq-generate $DATA_PATH \
    --path /dccstor/autofair/busekorkmaz/cliff_summ/data_construction/neg_mask_regen/bart.large/model.pt --results-path $RESULT_PATH --task translation \
    --beam $BEAM_SIZE --max-len-b $MAX_LEN_B --min-len $MIN_LEN --lenpen $LEN_PEN --nbest $BEAM_SIZE \
    --no-repeat-ngram-size 3 --skip-invalid-size-inputs-valid-test \
    --batch-size 16 --fp16 \
    --truncate-source --gen-subset train;

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_train   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_train \
# for SPLIT in train validation test
# do
#   for LANG in source target
#   do
#     python /dccstor/autofair/busekorkmaz/mask_regen/lib/python3.8/site-packages/fairseq/examples/roberta/multiprocessing_bpe_encoder.py \
#             --encoder-json /dccstor/autofair/busekorkmaz/cliff_summ/data/pretrain_language_models/fairseq.gpt2/encoder.json \
#             --vocab-bpe $DATA/pretrain_language_models/fairseq.gpt2/vocab.bpe \
#             --inputs "$DATA/job_ad_raw/$SPLIT.$LANG" \
#             --outputs "$DATA/job_ad_raw/$SPLIT.bpe.$LANG" \
#             --workers 60 \
#             --keep-empty;
#   done
# done

# fairseq-preprocess --source-lang source --target-lang target \
#  --trainpref $DATA/job_ad_raw/train.bpe \
#  --validpref $DATA/job_ad_raw/validation.bpe \
#  --destdir $DATA/job_ad_binarized \
#  --workers 60 \
#  --srcdict $DATA/pretrain_language_models/fairseq.gpt2/dict.txt \
#  --tgtdict $DATA/pretrain_language_models/fairseq.gpt2/dict.txt

# python get_output.py $DATA/processed_data/syslowcon_job_ad_generation/generate-train.txt \
#  $DATA/processed_data/syslowcon_job_ad_generation/train.jsonl

python filter_out.py $DATA/processed_data/syslowcon_job_ad_generation/train.jsonl \
 $DATA/job_ad_synthetic/negative_syslowcon/train