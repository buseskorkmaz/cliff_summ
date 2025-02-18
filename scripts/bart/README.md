# CLIFF

Code for EMNLP 2021 paper "CLIFF: Contrastive Learning for Improving Faithfulness and Factuality in Abstractive Summarization"

---------

## News

- Codes for using unlikelihood training and in-batch negatives are added. Please check [train_job_ad_batch_neg.sh](scripts/bart/train_job_ad_batch_neg.sh) and [train_job_ad_single_neg_ull.sh](scripts/bart/train_job_ad_single_neg_ull.sh).
Related Fairseq codes are here: [unlikelihood_translation.py](models/bart/unlikelihood_translation.py) and [contrastive_translation_batch_neg.py](models/bart/contrastive_translation_batch_neg.py).
- A cleaner implementation is available. The new implementation uses less system RAM and is compatible with the current version of Fairseq.
Check [here](new_fairseq_implementation).
- We find that the newer version of QuestEval produces much lower scores than the version (commit `0e94a74`) we used in our paper.
Please do not directly take the QuestEval results from the paper if you are using the newer version.

---------

## Data Construction

For data construction, please refer to [data_construction](data_construction).
Constructed datasets are also available in [Google Drive](https://drive.google.com/drive/folders/1b7JD419DBJv2BrNduBYOs8floP1JgO0-?usp=sharing).

---------

## Training

The following scripts require that your `$DATA` folder is organized the same as the `data` folder
in [Google Drive](https://drive.google.com/drive/folders/1b7JD419DBJv2BrNduBYOs8floP1JgO0-?usp=sharing).

#### BART

Our experiments with BART use [Fairseq](https://github.com/pytorch/fairseq) at commit `0db28cd`. Newer versions might also work.
Please download the pre-trained BART model [here](https://github.com/pytorch/fairseq/tree/master/examples/bart)
and set `BART_PATH` to the downloaded model:

```shell
export BART_PATH=/path/to/bart/model.pt
```

##### Single Negative Strategy

The following command trains the models with negative samples constructed by `SysLowCon`.
It saves the trained models in `$TRAINED_MODELS/job_ad/syslowcon` and `$TRAINED_MODELS/cnndm/syslowcon`.
Please change `$DATA/job_ad_synthetic/negative_syslowcon` to other negative samples to train the corresponding models.

```shell
# XSum
cd scripts/bart
CUDA_VISIBLE_DEVICES=0,1 ./train_job_ad_single_neg.sh \
  $DATA/job_ad_synthetic/negative_syslowcon $TRAINED_MODELS/bart_job_ad/syslowcon

# CNN/DM
cd scripts/bart
CUDA_VISIBLE_DEVICES=0,1 ./train_cnndm_single_neg.sh \
  $DATA/cnndm_synthetic/negative_syslowcon $TRAINED_MODELS/bart_cnndm/syslowcon
```

##### Multiple Negative Strategies

The following command trains the models with negative samples constructed by `SysLowCon` and `SwapEnt`.
It saves the trained models in `$TRAINED_MODELS/job_ad/syslowcon_swapent` and `$TRAINED_MODELS/cnndm/syslowcon_swapent`.

```shell
# XSum
cd scripts/bart
CUDA_VISIBLE_DEVICES=0,1 ./train_job_ad_mutli_neg.sh \
  "$DATA/job_ad_synthetic/negative_syslowcon $DATA/job_ad_synthetic/negative_swapent" \
  $TRAINED_MODELS/bart_job_ad/syslowcon_swapent

# CNN/DM
cd scripts/bart
CUDA_VISIBLE_DEVICES=0,1 ./train_cnndm_multi_neg.sh \
  "$DATA/cnndm_synthetic/negative_syslowcon $DATA/cnndm_synthetic/negative_swapent" \
  $TRAINED_MODELS/bart_cnndm/syslowcon_swapent
```

#### Pegasus

Our experiments with Pegasus use [Huggingface Transformers](https://github.com/huggingface/transformers) `4.5.1`.
Newer versions might also work.

##### Single Negative Strategy

```shell
# XSum
cd scripts/pegasus
CUDA_VISIBLE_DEVICES=0,1 ./train_job_ad_single_neg.sh \
  $DATA/job_ad_synthetic/negative_syslowcon $TRAINED_MODELS/pegasus_job_ad/syslowcon
  
# CNN/DM
cd scripts/pegasus
CUDA_VISIBLE_DEVICES=0,1 ./train_cnndm_single_neg.sh \
  $DATA/cnndm_synthetic/negative_syslowcon $TRAINED_MODELS/pegasus_cnndm/syslowcon
```

## Decoding

The following examples show how to decode trained models. Model checkpoints are available in 
[Google Drive](https://drive.google.com/drive/folders/1b7JD419DBJv2BrNduBYOs8floP1JgO0-?usp=sharing).

#### BART

```shell
# XSum
cd scripts/bart
./decode_job_ad.sh $TRAINED_MODELS/bart_job_ad/syslowcon/checkpoint_last.pt /path/to/save/dir

# CNN/DM
cd scripts/bart
./decode_cnndm.sh $TRAINED_MODELS/bart_cnndm/syslowcon/checkpoint_last.pt /path/to/save/dir
```

#### Pegasus

```shell
# XSum
cd scripts/pegasus
python run_generation.py $DATA/job_ad_raw/test.source $TRAINED_MODELS/pegasus_job_ad/syslowcon /path/to/save/dir

# CNN/DM
cd scripts/pegasus
python run_generation.py $DATA/cnndm_raw/test.source $TRAINED_MODELS/pegasus_cnndm/syslowcon /path/to/save/dir
```
