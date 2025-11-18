# database
* unknown target values can be left blank to train the model
* cis and trans isomers can be combined to one canonical SMILES? no
* SMILES can be converted to canonical SMILES. no isomeric smiles are ok
* find out identical smiles so that "results analysis' sort" and "warning in 'quiet.log'" may be solved
* more data can be gotten from modify the "trans" and "cis" names from 'names_input.txt'

# model training
* split by molecule scaffold
* scaled target? (probably no)
* Tc as a target instead of Tc/pc?
* cross validation seems to be not correct *check*
* hyperparameter optimization should be run without test set *check*

## command line:
1.chemprop_train --data_path data_input.csv --dataset_type regression --save_dir checkpoints_default --num_folds 10

2.chemprop_train --data_path data_input.csv --dataset_type regression --save_dir checkpoints_cv_no_test --num_folds 10 --save_preds --save_smiles_splits --split_type cv-no-test
error occurs *because of zero test set*

3.chemprop_train --data_path data_input.csv --dataset_type regression --save_dir checkpoints_cv --num_folds 10 --save_preds --save_smiles_splits --split_type cv

### using fold 0 train+val dataset for heper-opt
chemprop_hyperopt --data_path hyper_opt_input.csv --dataset_type regression --num_iters 20 --config_save_path hyper_opt_config.json
saved in C:\Users\liaoz\AppData\Local\Temp\tmpob9mcca5

chemprop_hyperopt --data_path hyper_opt_input.csv --dataset_type regression --num_iters 100 --config_save_path hyper_opt_config_all.json --log_dir hyper_opt_config_all --search_parameter_keywords all
saved in C:\Users\liaoz\AppData\Local\Temp\tmp7ywnh6uy

4.chemprop_train --data_path data_input.csv --dataset_type regression --config_path hyper_opt_config_all.json --save_dir checkpoints_cv_hyperopt_all --num_folds 10 --save_preds --save_smiles_splits --split_type cv
fold 1 seems to behave abnormally

5.chemprop_train --data_path data_input.csv --dataset_type regression --config_path hyper_opt_config_all.json --save_dir checkpoints_cv_hyperopt_all_100_epoch --num_folds 10 --save_preds --save_smiles_splits --split_type cv --epochs 100
fold 1 seems to behave abnormally

6.chemprop_train --data_path data_input.csv --dataset_type regression --config_path hyper_opt_config.json --save_dir checkpoints_cv_hyperopt --num_folds 10 --save_preds --save_smiles_splits --split_type cv

7.chemprop_train --data_path data_input_Tc.csv --dataset_type regression --save_dir checkpoints_cv_Tc --num_folds 10 --save_preds --save_smiles_splits --split_type cv

chemprop_hyperopt --data_path hyper_opt_input_Tc.csv --dataset_type regression --num_iters 20 --config_save_path hyper_opt_config_Tc.json --log_dir hyper_opt_config_Tc 
saved in C:\Users\liaoz\AppData\Local\Temp\tmpxnf0gvbo

8.chemprop_train --data_path data_input_Tc.csv --dataset_type regression --config_path hyper_opt_config_Tc.json --save_dir checkpoints_cv_Tc_hyperopt --num_folds 10 --save_preds --save_smiles_splits --split_type cv


tensorboard --logdir=<checkpoints>

需要更多数据点，aspen里有6000+个点
去掉同分异构数据点，转化成规范化smiles
根据分子骨架划分数据集
加入根据不同基团/原子对结果影响的分析

数据库：hyper_opt_input_Tc.csv
超参数优化结果：hyper_opt_config_Tc.json
用超参数训练结果：xxxxxx


预训练：
chemprop train --data-path final_pretrain_data_unique_mean.csv --task-type regression --output-dir pretrain_checkpoints --save-smiles-splits
chemprop train --data-path final_pretrain_data.csv --task-type regression --output-dir pretrain_checkpoints_stereo --save-smiles-splits

chemprop train --data-path final_pretrain_data_Zscored_scaled.csv --task-type regression --output-dir pretrain_checkpoints_stereo_scaled --save-smiles-splits


2组超参数优化：(一直报错)
chemprop hpopt --data-path critprop_expt_cpo_scaled.csv --task-type regression --search-parameter-keywords basic --hpopt-save-dir hyperopt_results_rand --split-type RANDOM --log hyperopt_results_rand_log.txt --accelerator gpu
chemprop hpopt --data-path critprop_expt_cpo_scaled.csv --task-type regression --search-parameter-keywords basic --hpopt-save-dir hyperopt_results_sca --split-type SCAFFOLD_BALANCED --checkpoint pretrain_checkpoints_stereo_scaled --log hyperopt_results_sca_log

2组交叉验证结合预训练：
chemprop train --data-path critprop_expt.csv --task-type regression --output-dir fine_tuning_checkpoints_rand --split-type RANDOM --checkpoint pretrain_checkpoints --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt.csv --task-type regression --output-dir fine_tuning_checkpoints_sca --split-type SCAFFOLD_BALANCED --checkpoint pretrain_checkpoints --save-smiles-splits --num-replicates 5

chemprop train --data-path critprop_expt.csv --task-type regression --output-dir fine_tuning_checkpoints_rand_stereo --split-type RANDOM --checkpoint pretrain_checkpoints_stereo --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt.csv --task-type regression --output-dir fine_tuning_checkpoints_sca_stereo --split-type SCAFFOLD_BALANCED --checkpoint pretrain_checkpoints_stereo --save-smiles-splits --num-replicates 5

chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir fine_tuning_checkpoints_rand_stereo_scaled --split-type RANDOM --checkpoint pretrain_checkpoints_stereo_scaled --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir fine_tuning_checkpoints_sca_stereo_scaled --split-type SCAFFOLD_BALANCED --checkpoint pretrain_checkpoints_stereo_scaled --save-smiles-splits --num-replicates 5


2组交叉验证from scratch：
chemprop train --data-path critprop_expt.csv --task-type regression --output-dir from_scratch_checkpoints_rand --split-type RANDOM --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt.csv --task-type regression --output-dir from_scratch_checkpoints_sca --split-type SCAFFOLD_BALANCED --save-smiles-splits --num-replicates 5

chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir from_scratch_checkpoints_rand_scaled --split-type RANDOM --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir from_scratch_checkpoints_sca_scaled --split-type SCAFFOLD_BALANCED --save-smiles-splits --num-replicates 5

chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir tmp --split-type RANDOM --save-smiles-splits --accelerator gpu --log tmp/logfile.txt

