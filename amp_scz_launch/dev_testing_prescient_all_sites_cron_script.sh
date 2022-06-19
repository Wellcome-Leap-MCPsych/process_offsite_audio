#!/bin/bash

# need to ensure that my account can write to processed folders, because Lochness does not always create the interview subfolders for a subject ID (needs to be one in GENERAL and PROTECTED)
# this is just a workaround for the dev server right now, for production we need to figure out an actual structure for file permissions
sudo chmod -R 770 /mnt/prescient/Prescient_data_sync/PHOENIX/*/*/processed

# activate python environment
. /home/cho/miniconda3/etc/profile.d/conda.sh
conda activate audio_process

# run audio side code for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/dev_testing_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_audio_process.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# run transcript side code for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/dev_testing_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_transcript_process.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# run video code for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/dev_testing_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_video_process.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# run accounting summary compilation for each config
for file in /home/cho/soft/process_offsite_audio/amp_scz_launch/dev_testing_prescient_site_configs/*.sh; do
	bash /home/cho/soft/process_offsite_audio/interview_summary_checks.sh "$file"
	# add spacing for when monitoring logs in real time
	echo ""
	echo ""
done

# at the end of the processing, make sure that all processed interview outputs are in the pronet group, so they can be appropriately synced back to datalake
# this is also a temporary workaround for dev server
sudo chgrp -R prescient /mnt/prescient/Prescient_data_sync/PHOENIX/*/*/processed/*
# similarly make sure for the box transfer folder!
sudo chgrp -R prescient /mnt/prescient/Prescient_data_sync/PHOENIX/PROTECTED/box_transfer

# finally run the utility for stats combined across sites
bash /home/cho/soft/process_offsite_audio/amp_scz_launch/final_all_sites_utility.sh /mnt/prescient/Prescient_data_sync/PHOENIX mennis2@partners.org PrescientDev

# note Kevin's code now handles the Mediaflux push, so that is not needed here!

# this is development cron script - some TODOs remain for this implementation as well as site testing (see docs) before production parts can be implemented