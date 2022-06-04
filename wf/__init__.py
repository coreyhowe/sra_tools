"""
Download sequence data from the SRA
"""

import subprocess
from pathlib import Path
import os

from latch import small_task, large_task, workflow
from latch.types import LatchFile, LatchDir

@large_task
def getseq_task(id: str, output_dir: LatchDir) -> LatchDir:

	#output_prefix = "sra"

	# directory of output
	local_dir = Path(dir).resolve()
	local_id = Path(id).resolve()

	
	#local_prefix = os.path.join(local_dir, output_prefix)
	
	#command1 
	#_config_cmd = [
	#"vdb-config",
	#"--restore-defaults",
	#]
	
	# command2
	_fastqdump_cmd = [
        "fastq-dump",
        "-v",
        str(id),
        "--split-files",
        "--gzip",
        "-O",
        str(local_dir),
		]
		
	#subprocess.run(_config_cmd)		
	subprocess.run(_fastqdump_cmd)

	return LatchDir(str(local_dir), output_dir.remote_path) #f"latch:///{output_dir}/")

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

#local iteration
#if __name__ == "__main__":
 #   sra_tools(id="SRR11934713",
 #   output_dir=LatchDir("/root/"))     
    