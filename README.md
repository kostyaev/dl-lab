# All-in-one Docker image for Deep Learning.

This image includes:
- Python3.7
- Tensorflow 2 (latest) 
- PyTorch (latest)
- Jupyter Notebook (with tqdm progress bar fixes)

## How to run

Optional step. Install Nvidia-docker to pass your GPU to container. 

```
docker run -d --gpus all -name dl-lab -p 8888:8888 \\
	   -v /home/ubuntu/data/:/home/ubuntu/data/ \\
	   -v /home/ubuntu/.ssh:/home/ubuntu/.ssh \\
	   --shm-size=4gb --restart=always -e "PASSWORD=some_password_for_jupyter" dl-lab-py3-image```
