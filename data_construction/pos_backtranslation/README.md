# Back Translation

```shell
# create virtual environment (for example, conda)
conda create -n pos_bt python=3.8
conda activate pos_bt
pip install -r requirements.txt
```

Note that Fairseq has renamed their branch and you might encounter `HTTPError`. Please refer to [this issue](https://github.com/pytorch/fairseq/issues/3955) to resolve it.

-------

We use [nlpaug](https://github.com/makcedward/nlpaug/) `1.1.3`. Please follow their installation instruction.
**Note: nlpaug switch to transformers for their back translation model in the newer version, which is not compatible with our code.**

Back translated samples with novel entities are discarded. 
We use the Wikipedia [demonym list](https://en.wikipedia.org/wiki/List_of_adjectival_and_demonymic_forms_for_countries_and_nations) 
and [countryinfo](https://github.com/porimol/countryinfo) library to
keep the paraphrases that exchange nations' names with their adjectival and demonymic forms.

#### Create raw positive samples

```shell
# XSum
mkdir -p /dccstor/autofair/busekorkmaz/cliff_summ/data/job_ad_synthetic/positive_bt
python nlpaug_bt.py /dccstor/autofair/busekorkmaz/cliff_summ/data/job_ad_raw/train.target /dccstor/autofair/busekorkmaz/cliff_summ/data/job_ad_synthetic/positive_bt/train
python nlpaug_bt.py /dccstor/autofair/busekorkmaz/cliff_summ/data/job_ad_raw/validation.target /dccstor/autofair/busekorkmaz/cliff_summ/data/job_ad_synthetic/positive_bt/valid

# CNN/DM
mkdir -p $DATA/cnndm_synthetic/positive_bt
python nlpaug_bt.py $DATA/cnndm_raw/train.target $DATA/cnndm_synthetic/positive_bt/train
python nlpaug_bt.py $DATA/cnndm_raw/val.target $DATA/cnndm_synthetic/positive_bt/valid
```

#### Filter invalid positive samples

```shell
# XSum
mkdir -p $DATA/job_ad_synthetic/positive_bt_filter
python nlpaug_bt_filter.py $DATA/job_ad_synthetic/positive_bt/train.raw_target $DATA/job_ad_raw/train.target $DATA/job_ad_synthetic/positive_bt_filter/train
python nlpaug_bt_filter.py $DATA/job_ad_synthetic/positive_bt/valid.raw_target $DATA/job_ad_raw/validation.target $DATA/job_ad_synthetic/positive_bt_filter/valid

# CNN/DM
mkdir -p $DATA/cnndm_synthetic/positive_bt_filter
python nlpaug_bt_filter.py $DATA/cnndm_synthetic/positive_bt/train.raw_target $DATA/cnndm_raw/train.target $DATA/cnndm_synthetic/positive_bt_filter/train
python nlpaug_bt_filter.py $DATA/cnndm_synthetic/positive_bt/valid.raw_target $DATA/cnndm_raw/val.target $DATA/cnndm_synthetic/positive_bt_filter/valid
```

#### Further processing

```shell
# XSum
python convert_and_combine.py $DATA/job_ad_synthetic/positive_bt_filter/train.raw_target \
 /$DATA/job_ad_raw/train.target $DATA/job_ad_synthetic/positive_bt_filter/train.raw_other \
 $DATA/job_ad_synthetic/positive_bt_filter/train 
python convert_and_combine.py $DATA/job_ad_synthetic/positive_bt_filter/valid.raw_target \
 /$DATA/job_ad_raw/validation.target $DATA/job_ad_synthetic/positive_bt_filter/valid.raw_other \
 $DATA/job_ad_synthetic/positive_bt_filter/valid
 
# CNN/DM
python convert_and_combine.py $DATA/cnndm_synthetic/positive_bt_filter/train.raw_target \
 /$DATA/cnndm_raw/train.target $DATA/cnndm_synthetic/positive_bt_filter/train.raw_other \
 $DATA/cnndm_synthetic/positive_bt_filter/train 
python convert_and_combine.py $DATA/cnndm_synthetic/positive_bt_filter/valid.raw_target \
 /$DATA/cnndm_raw/val.target $DATA/cnndm_synthetic/positive_bt_filter/valid.raw_other \
 $DATA/cnndm_synthetic/positive_bt_filter/valid
```
