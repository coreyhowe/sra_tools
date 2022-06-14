"""
Download sequence data from the SRA
"""

import subprocess
from pathlib import Path
import os

from latch import small_task, large_task, workflow
from latch.types import LatchFile, LatchDir


@small_task
def getseq_task(id: str, output_dir: LatchDir) -> LatchDir:
	
	
	#command
	_fastqdump_cmd = [
		"sra-downloader",
		id,
		"--save-dir",
		"root/"
		]
		
	subprocess.run(_fastqdump_cmd)
	
	return LatchDir("root/", output_dir.remote_path)
	
	
@workflow
def sra_tools(id: str, output_dir: LatchDir) -> LatchDir: 
    """

	# SRA Tools
	
	
    

    __metadata__:
        display_name: Download sequence files from SRA
        author:
            name: Corey Howe
            email: 	
            github: https://github.com/coreyhowe
        repository: https://github.com/coreyhowe/latch_sra-tools
        license:
            id: MIT

    Args:

        id:
          SRA accession id 

          __metadata__:
            display_name: SRA Accession ID
            
        output_dir:
          The directory where results will go.
          
          __metadata__:
            display_name: Output Directory
    """
    return getseq_task(id=id, output_dir=output_dir)


    