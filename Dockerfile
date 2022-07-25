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
    && chown algorithm:algorithm /opt/algorithm /input /output



WORKDIR /opt/algorithm

RUN  python -m pip install Cython -i https://pypi.tuna.tsinghua.edu.cn/simple/

RUN  python -m pip install pygco -i https://pypi.tuna.tsinghua.edu.cn/simple/

ENV PATH="/home/algorithm/.local/bin:${PATH}"

RUN python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple/


COPY --chown=algorithm:algorithm requirements.txt /opt/algorithm/requirements.txt
RUN python -m pip install --default-timeout=1000 -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ --ignore-installed
#RUN python -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/

#RUN python -m pip install open3d==0.15.2 -i https://pypi.tuna.tsinghua.edu.cn/simple/

COPY --chown=algorithm:algorithm ./process.py /opt/algorithm/process.py
COPY --chown=algorithm:algorithm ./losses_and_metrics_for_mesh.py /opt/algorithm/losses_and_metrics_for_mesh.py
COPY --chown=algorithm:algorithm ./meshsegnet.py /opt/algorithm/meshsegnet.py
COPY --chown=algorithm:algorithm ./Mesh_Segementation_MeshSegNet_17_classes_60samples_best.tar /opt/algorithm/Mesh_Segementation_MeshSegNet_17_classes_60samples_best.tar
#COPY --chown=algorithm:algorithm ./open3d-0.15.2-cp38-cp38-manylinux_2_27_x86_64.whl /opt/algorithm/open3d-0.15.2-cp38-cp38-manylinux_2_27_x86_64.whl
#COPY --chown=algorithm:algorithm ./Pillow-9.2.0-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl /opt/algorithm/Pillow-9.2.0-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
#COPY --chown=algorithm:algorithm ./matplotlib-3.5.2-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.whl /opt/algorithm/matplotlib-3.5.2-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.whl
#COPY --chown=algorithm:algorithm ./jupyterlab-3.4.4-py3-none-any.whl /opt/algorithm/jupyterlab-3.4.4-py3-none-any.whl
#COPY --chown=algorithm:algorithm ./Pygments-2.12.0-py3-none-any.whl /opt/algorithm/Pygments-2.12.0-py3-none-any.whl
#COPY --chown=algorithm:algorithm ./PyYAML-6.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl /opt/algorithm/PyYAML-6.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl
COPY --chown=algorithm:algorithm ./input /opt/algorithm/input
COPY --chown=algorithm:algorithm ./output /opt/algorithm/output
COPY --chown=algorithm:algorithm ./input/3d-teeth-scan.obj /opt/algorithm/input/3d-teeth-scan.obj
RUN chmod 777 /opt/algorithm/output
#RUN chmod 777 /opt/algorithm/open3d-0.15.2-cp38-cp38-manylinux_2_27_x86_64.whl
#RUN chmod 777 /opt/algorithm/Pillow-9.2.0-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
#RUN chmod 777 /opt/algorithm/matplotlib-3.5.2-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.whl
#RUN chmod 777 /opt/algorithm/jupyterlab-3.4.4-py3-none-any.whl
#RUN chmod 777 /opt/algorithm/Pygments-2.12.0-py3-none-any.whl
#RUN chmod 777 /opt/algorithm/PyYAML-6.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl
#RUN python -m pip install /opt/algorithm/Pillow-9.2.0-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
#RUN python -m pip install /opt/algorithm/matplotlib-3.5.2-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.whl
#RUN python -m pip install /opt/algorithm/jupyterlab-3.4.4-py3-none-any.whl
#RUN python -m pip install /opt/algorithm/Pygments-2.12.0-py3-none-any.whl
#RUN python -m pip install /opt/algorithm/PyYAML-6.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl
#RUN python -m pip install /opt/algorithm/open3d-0.15.2-cp38-cp38-manylinux_2_27_x86_64.whl
COPY --chown=algorithm:algorithm ./latest_checkpoint.tar /opt/algorithm/checkpoints

USER algorithm
ENTRYPOINT python -m process $0 $@
