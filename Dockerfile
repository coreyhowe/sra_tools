FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:02ab-main

RUN apt-get update -y &&\
    apt-get install -y wget libncurses5 &&\
    apt-get install gzip

#RUN apt-get install -y sra-toolkit
#RUN conda install -c bioconda -c bioinf-mcb sra-downloader





RUN chmod -R 777 /root
RUN chmod -R 777 "${HOME}"

RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz &&\
  tar -xzf sratoolkit.3.0.0-ubuntu64.tar.gz &&\
  rm -r sratoolkit.3.0.0-ubuntu64.tar.gz 

ENV PATH=$PATH:sratoolkit.3.0.0-ubuntu64/bin


ARG NCBI_CONF_DIR="${HOME}/.ncbi"
RUN mkdir -p "${NCBI_CONF_DIR}"

RUN mkdir -p /root/.ncbi 
RUN printf '/LIBS/IMAGE_GUID = "%s"\n' uuidgen > /root/.ncbi/user-settings.mkfg 
RUN printf '/libs/cloud/report_instance_identity = "true"\n' >> /root/.ncbi/user-settings.mkfg
#COPY /root/.ncbi/user-settings.mkfg a "${NCBI_CONF_DIR}/user-settings.mkfg"

RUN sed -i 's/IMAGE_GUID/GUID/' /root/.ncbi/user-settings.mkfg







#RUN vdb-config --interactive 


#RUN pip install python-on-whales
#RUN python-on-whales download-cli




#RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/setup-apt.sh &&/
#	bash setup-apt.sh
#RUN ls
#RUN apt-get update && \
 #     apt-get -y install sudo
#RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
#RUN sudo sh setup-apt.sh


# STOP HERE:
# The following lines are needed to ensure your build environment works
# correctly with latch.
COPY wf /root/wf
RUN  sed -i 's/latch/wf/g' flytekit.config
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root
