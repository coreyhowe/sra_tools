FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:02ab-main



RUN apt-get update -y &&\
    apt-get install -y wget libncurses5 &&\
    apt-get install gzip

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*


RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda config --add channels bioconda
RUN conda install python=3.7
RUN conda install -c bioconda -c bioinf-mcb sra-downloader


#RUN conda install sra-tools 


#RUN apt install sra-toolkit
#RUN pip install bioinfokit
#RUN conda install -c bioconda bioinfokit
#RUN vdb-config --restore-defaults


#ENV SRA_HOME /usr/local/bin

#ENV PATH=${SRA_HOME}:${PATH}

# STOP HERE:
# The following lines are needed to ensure your build environment works
# correctly with latch.
COPY wf /root/wf
RUN  sed -i 's/latch/wf/g' flytekit.config
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root

#ADD data /root/data/
#ADD __init__.py __init__.py
#RUN python3 __init__.py
