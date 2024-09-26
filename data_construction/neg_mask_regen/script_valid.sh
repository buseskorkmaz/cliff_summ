# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python filter_generated.py --generated-docbins $DATA/processed_data/job_ad_regeneration_output/valid_generated.doc \
#  --source-docbins $DATA/processed_data/job_ad_stanza_docbin/valid.source \
#  --target-docbins $DATA/processed_data/job_ad_stanza_docbin/valid.target \
#  --other $DATA/processed_data/job_ad_regeneration_output/valid_generated.other \
#  $DATA/processed_data/job_ad_regeneration_output/valid_filtered.jsonl

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python detect_relation_ne_summary.py $DATA/processed_data/job_ad_regeneration_output/valid_generated.txt \
#  $DATA/processed_data/job_ad_regeneration_output/valid_generated.doc

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python filter_generated.py --generated-docbins $DATA/processed_data/job_ad_regeneration_output/valid_generated.doc \
#  --source-docbins $DATA/processed_data/job_ad_stanza_docbin/valid.source \
#  --target-docbins $DATA/processed_data/job_ad_stanza_docbin/valid.target \
#  --other $DATA/processed_data/job_ad_regeneration_output/valid_generated.other \
#  $DATA/processed_data/job_ad_regeneration_output/valid_filtered.jsonl

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python get_new_ent_out.py $DATA/processed_data/job_ad_regeneration_output/valid_filtered.jsonl $DATA/job_ad_synthetic/negative_regenent/valid


# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python get_new_rel_out.py $DATA/processed_data/job_ad_regeneration_output/valid_filtered.jsonl $DATA/job_ad_synthetic/negative_regenrel/valid

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python swap_entity.py $DATA/job_ad_raw/validation.source $DATA/job_ad_raw/validation.target \
#  $DATA/job_ad_synthetic/negative_swapent/valid_swap_same_entity.jsonl

# jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid python swap_entity_out.py $DATA/job_ad_raw/validation.bpe.source $DATA/job_ad_synthetic/negative_swapent/valid_swap_same_entity.jsonl \
#  $DATA/job_ad_synthetic/negative_swapent/valid

# BEAM_SIZE=6
# MAX_LEN_B=60
# MIN_LEN=10
# LEN_PEN=1.0

# DATA_PATH=$DATA/job_ad_binarized
# RESULT_PATH=$DATA/processed_data/syslowcon_job_ad_generation


# # jbsub -queue x86_6h -mem 40g -cores 4+1 -o /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid   -e /dccstor/autofair/busekorkmaz/cliff_summ/logs_valid 
# fairseq-generate $DATA_PATH \
#     --path /dccstor/autofair/busekorkmaz/cliff_summ/data_construction/neg_mask_regen/bart.large/model.pt --results-path $RESULT_PATH --task translation \
#     --beam $BEAM_SIZE --max-len-b $MAX_LEN_B --min-len $MIN_LEN --lenpen $LEN_PEN --nbest $BEAM_SIZE \
#     --no-repeat-ngram-size 3 --skip-invalid-size-inputs-valid-test \
#     --batch-size 16 --fp16 \
#     --truncate-source --gen-subset valid;

# python get_output.py $DATA/processed_data/syslowcon_job_ad_generation/generate-valid.txt \
#  $DATA/processed_data/syslowcon_job_ad_generation/valid.jsonl

python filter_out.py $DATA/processed_data/syslowcon_job_ad_generation/valid.jsonl \
 $DATA/job_ad_synthetic/negative_syslowcon/valid
