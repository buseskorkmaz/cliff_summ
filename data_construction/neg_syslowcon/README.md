# SysLowCon

```shell
# create virtual environment (for example, conda)
conda create -n syslowcon python=3.8
conda activate syslowcon
pip install -r requirements.txt
```

-------

##### Generate

First, download the BART models pre-trained on XSum (`bart.large.job_ad`) and CNN/DM (`bart.large.cnn`) from [Fairseq](https://github.com/pytorch/fairseq/tree/master/examples/bart)
and set the corresponding environment variables for them:

```shell
export XSUM_BART=/path/to/bart.large.job_ad/model.pt
export CNNDM_BART=/path/to/bart.large.cnn/model.pt
```

Then run the following commands for generation:

```shell
# XSum
cd syslowcon_scripts
./job_ad_train.sh
./job_ad_valid.sh
python get_output.py $DATA/processed_data/syslowcon_job_ad_generation/generate-train.txt \
 $DATA/processed_data/syslowcon_job_ad_generation/train.jsonl
python get_output.py $DATA/processed_data/syslowcon_job_ad_generation/generate-valid.txt \
 $DATA/processed_data/syslowcon_job_ad_generation/valid.jsonl
 
# CNN/DM
cd syslowcon_scripts
./cnndm_train.sh
./cnndm_valid.sh
python get_output.py $DATA/processed_data/syslowcon_cnndm_generation/generate-train.txt \
 $DATA/processed_data/syslowcon_cnndm_generation/train.jsonl
python get_output.py $DATA/processed_data/syslowcon_cnndm_generation/generate-valid.txt \
 $DATA/processed_data/syslowcon_cnndm_generation/valid.jsonl
```

##### Obtain low confidence samples

```shell
# XSum
mkdir -p $DATA/job_ad_synthetic/negative_syslowcon
python filter_out.py $DATA/processed_data/syslowcon_job_ad_generation/train.jsonl \
 $DATA/job_ad_synthetic/negative_syslowcon/train
python filter_out.py $DATA/processed_data/syslowcon_job_ad_generation/valid.jsonl \
 $DATA/job_ad_synthetic/negative_syslowcon/valid

# CNN/DM
mkdir -p $DATA/cnndm_synthetic/negative_syslowcon
python filter_out.py $DATA/processed_data/syslowcon_cnndm_generation/train.jsonl \
 $DATA/cnndm_synthetic/negative_syslowcon/train
python filter_out.py $DATA/processed_data/syslowcon_cnndm_generation/valid.jsonl \
 $DATA/cnndm_synthetic/negative_syslowcon/valid
```
