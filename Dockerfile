FROM python:3.8

FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime
RUN apt update
RUN apt-get install -y python3-pip python3-setuptools build-essential
RUN apt-get install -y yum
RUN apt-get install -y wget
RUN apt-get install -y libx11-6
RUN apt-get install -y libgl1
RUN apt-get install nvidia-modprobe
RUN apt-get clean

RUN groupadd -r algorithm && useradd -m --no-log-init -r -g algorithm algorithm

RUN mkdir -p /opt/algorithm /input /output \
    && chown algorithm:algorithm /opt/algorithm
RUN chown algorithm:algorithm /input
RUN chown algorithm:algorithm /output

WORKDIR /opt/algorithm


RUN  python -m pip install Cython -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN  python -m pip install pygco -i https://pypi.tuna.tsinghua.edu.cn/simple

ENV PATH="/home/algorithm/.local/bin:${PATH}"

RUN python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple


COPY --chown=algorithm:algorithm requirements.txt /opt/algorithm/requirements.txt
RUN python -m pip install --default-timeout=5000 -rrequirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --ignore-installed


COPY --chown=algorithm:algorithm ./process.py /opt/algorithm/process.py
COPY --chown=algorithm:algorithm ./losses_and_metrics_for_mesh.py /opt/algorithm/losses_and_metrics_for_mesh.py
COPY --chown=algorithm:algorithm ./meshsegnet.py /opt/algorithm/meshsegnet.py
COPY --chown=algorithm:algorithm ./Mesh_Segementation_MeshSegNet_17_classes_60samples_best.tar /opt/algorithm/Mesh_Segementation_MeshSegNet_17_classes_60samples_best.tar
COPY --chown=algorithm:algorithm ./latest_checkpoint.tar /opt/algorithm/checkpoints

USER algorithm
ENTRYPOINT python -m process $0 $@