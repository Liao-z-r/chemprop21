@echo off
cd D:\Projects\jupyter_project

call activate chemprop2

chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir fine_tuning_checkpoints_rand_stereo_scaled --split-type RANDOM --checkpoint pretrain_checkpoints_stereo_scaled --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir fine_tuning_checkpoints_sca_stereo_scaled --split-type SCAFFOLD_BALANCED --checkpoint pretrain_checkpoints_stereo_scaled --save-smiles-splits --num-replicates 5

chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir from_scratch_checkpoints_rand_scaled --split-type RANDOM --save-smiles-splits --num-replicates 5
chemprop train --data-path critprop_expt_cpo_scaled.csv --task-type regression --output-dir from_scratch_checkpoints_sca_scaled --split-type SCAFFOLD_BALANCED --save-smiles-splits --num-replicates 5
