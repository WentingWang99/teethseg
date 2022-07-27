FROM python:3.8
FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-runtime
RUN apt update 
RUN apt-get install -y python3-pip python3-setuptools build-essential
RUN apt-get install -y yum
RUN apt-get install -y wget
RUN apt-get install -y libx11-6
RUN apt-get install -y libgl1
RUN apt-get clean
RUN groupadd -r algorithm && useradd -m --no-log-init -r -g algorithm algorithm

RUN mkdir -p /opt/algorithm /input /output \
    && chown algorithm:algorithm /opt/algorithm /input /output
USER algorithm

WORKDIR /opt/algorithm

ENV PATH="/home/algorithm/.local/bin:${PATH}"
RUN python -m pip install --user -U pip
RUN python -m pip install Cython==0.29.30
RUN python -m pip install wget

RUN  python -m pip install pygco


COPY --chown=algorithm:algorithm requirements.txt /opt/algorithm/
RUN python -m pip install --user -rrequirements.txt

COPY --chown=algorithm:algorithm process.py /opt/algorithm/
COPY --chown=algorithm:algorithm meshsegnet.py /opt/algorithm/
COPY --chown=algorithm:algorithm losses_and_metrics_for_mesh.py /opt/algorithm/
COPY --chown=algorithm:algorithm Mesh_Segementation_MeshSegNet_15_classes_60samples_best_5.tar /opt/algorithm/

ENTRYPOINT python -m process $0 $@