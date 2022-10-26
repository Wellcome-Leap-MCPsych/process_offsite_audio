#!/bin/bash

# need to ensure that my account can write to processed folders, because Lochness does not always create the interview subfolders for a subject ID (needs to be one in GENERAL and PROTECTED)
chmod -R 770 /mnt/prescient/Prescient_production/PHOENIX/*/*/processed
# needed to drop sudo though to prevent asking for password from stalling the cron. hopefully it works fine anyways!

# activate python environment
source ~/.bash_profile
source /home/cho/miniconda3/etc/profile.d/conda.sh
conda activate audio_process

# run audio side code for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/production_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_audio_process.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# run transcript side code for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/production_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_transcript_process.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# run video code for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/production_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_video_process.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# run accounting summary compilation for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/production_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_summary_checks.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# at the end of the processing, make sure that all processed interview outputs are in the pronet group, so they can be appropriately synced back to datalake
chgrp -R prescient /mnt/prescient/Prescient_production/PHOENIX/*/*/processed/*
# similarly make sure for the box transfer folder!
chgrp -R prescient /mnt/prescient/Prescient_production/PHOENIX/PROTECTED/box_transfer
#final permissions update
chmod -R 770 /mnt/prescient/Prescient_production/PHOENIX/*/*/processed

# finally run the utility for stats combined across sites
bash /home/cho/soft/process_offsite_audio/amp_scz_launch/final_all_sites_utility.sh /mnt/prescient/Prescient_production/PHOENIX mennis2@partners.org PrescientProduction "yes"

# note Kevin's code now handles the Mediaflux push, so that is not needed here!
