# Data Construction

### Binarized Data

```shell
# If you haven't download fairseq GPT2 BPE files before:
mkdir -p $DATA/fairseq.gpt2
wget -O $DATA/fairseq.gpt2/encoder.json 'https://dl.fbaipublicfiles.com/fairseq/gpt2_bpe/encoder.json'
wget -O $DATA/fairseq.gpt2/vocab.bpe 'https://dl.fbaipublicfiles.com/fairseq/gpt2_bpe/vocab.bpe'
wget -O $DATA/fairseq.gpt2/dict.txt 'https://dl.fbaipublicfiles.com/fairseq/gpt2_bpe/dict.txt'

# XSum
for SPLIT in train validation test
do
  for LANG in source target
  do
    python -m examples.roberta.multiprocessing_bpe_encoder \
            --encoder-json $DATA/fairseq.gpt2/encoder.json  \
            --vocab-bpe $DATA/fairseq.gpt2/vocab.bpe \
            --inputs "$DATA/job_ad_raw/$SPLIT.$LANG" \
            --outputs "$DATA/job_ad_raw/$SPLIT.bpe.$LANG" \
            --workers 60 \
            --keep-empty;
  done
done

fairseq-preprocess --source-lang source --target-lang target \
 --trainpref $DATA/job_ad_raw/train.bpe \
 --validpref $DATA/job_ad_raw/validation.bpe \
 --destdir $DATA/job_ad_binarized \
 --workers 60 \
 --srcdict $DATA/fairseq.gpt2/dict.txt \
 --tgtdict $DATA/fairseq.gpt2/dict.txt

# CNN/DM
for SPLIT in train val test
do
  for LANG in source target
  do
    python -m examples.roberta.multiprocessing_bpe_encoder \
            --encoder-json $DATA/fairseq.gpt2/encoder.json  \
            --vocab-bpe $DATA/fairseq.gpt2/vocab.bpe \
            --inputs "$DATA/cnndm_raw/$SPLIT.$LANG" \
            --outputs "$DATA/cnndm_raw/$SPLIT.bpe.$LANG" \
            --workers 60 \
            --keep-empty;
  done
done

fairseq-preprocess --source-lang source --target-lang target \
 --trainpref $DATA/cnndm_raw/train.bpe \
 --validpref $DATA/cnndm_raw/val.bpe \
 --destdir $DATA/cnndm_binarized \
 --workers 60 \
 --srcdict $DATA/fairseq.gpt2/dict.txt \
 --tgtdict $DATA/fairseq.gpt2/dict.txt
```

### Positive Samples

Please check [pos_backtranslation](pos_backtranslation) for constructing positive samples.

### Negative Samples

| Strategy |
| --- |
| [SwapEnt](neg_swapent) |
| [MaskEnt / MaskRel / RegenEnt / RegenRel](neg_mask_regen) |
| [SysLowCon](neg_syslowcon) |
