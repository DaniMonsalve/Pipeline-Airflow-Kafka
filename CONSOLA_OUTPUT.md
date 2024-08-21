# Documentación de Salidas de Consola y Comentarios

Este documento proporciona las salidas de la consola y los comentarios asociados a cada comando ejecutado durante el proceso de configuración del pipeline.


## 1. Crear y configurar el entorno

```bash
# Crear un directorio para el proyecto y navegar a él
dani@LAPTOP-73U6RBEH:~$ mkdir ~/airflow_pipeline
dani@LAPTOP-73U6RBEH:~$ cd ~/airflow_pipeline

# Crear un entorno virtual
dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ virtualenv venv
created virtual environment CPython3.10.12.final.0-64 in 489ms
  creator CPython3Posix(dest=/home/dani/airflow_pipeline/venv, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=/home/dani/.local/share/virtualenv)
    added seed packages: pip==24.1, setuptools==70.1.0, wheel==0.43.0
  activators BashActivator,CShellActivator,FishActivator,NushellActivator,PowerShellActivator,PythonActivator

# Activar el entorno virtual
dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ source venv/bin/activate
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ export AIRFLOW_HOME=$(pwd)

# Instalar Apache Airflow
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ pip install apache-airflow
...

# Iniciar Airflow en modo standalone
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ airflow standalone
standalone | Airflow is ready
standalone | Login with username: admin  password: 3ZcCYCWCyHRpzHSV
standalone | Airflow Standalone is for development purposes only. Do not use this in production!
^Cstandalone | Shutting down components
standalone | Complete

# Descargar Apache Kafka
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ wget https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz

# Descomprimir el archivo
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ tar -xzvf kafka_2.12-3.8.0.tgz
...
# Eliminar el archivo comprimido
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ rm kafka_2.12-3.8.0.tgz

# Iniciar Zookeeper en una terminal
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/zookeeper-server-start.sh config/zookeeper.properties

# En otra terminal, iniciar el servidor Kafka
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-server-start.sh config/server.properties

# Crear un nuevo topic
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
Created topic quickstart-events.

# Producir un mensaje al topic
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
>Este es el primer topic enviado
>

# Consumir el mensaje desde el topic
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
Este es el primer topic enviado

# Descargar Spark
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz

# Descomprimir el archivo
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ tar -xzvf spark-3.5.2-bin-hadoop3.tgz
...

# Eliminar el archivo comprimido
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ rm spark-3.5.2-bin-hadoop3.tgz

# Renombrar el archivo de configuración
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3/conf$ mv spark-defaults.conf.template spark-defaults.conf

# Iniciar el master de Spark
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3$ ./sbin/start-master.sh
starting org.apache.spark.deploy.master.Master, logging to /home/dani/airflow_pipeline/spark-3.5.2-bin-hadoop3/logs/spark-dani-org.apache.spark.deploy.master.Master-1-LAPTOP-73U6RBEH.out

# Iniciar el worker de Spark
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3$ ./sbin/start-worker.sh spark://LAPTOP-73U6RBEH:7077

# Crear un nuevo topic para Airflow
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-topics.sh --create --topic airflow-spark --bootstrap-server localhost:9092
Created topic airflow-spark.

# Producir mensajes al topic
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-producer.sh --topic airflow-spark --bootstrap-server localhost:9092

# Consumir mensajes del topic 'airflow-spark'
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-consumer.sh --topic airflow-spark --from-beginning --bootstrap-server localhost:9092
{"id": "f02bbbc6-f204-48da-9010-2bf82dc34186", "first_name": "Savitha", "last_name": "Keshri", "gender": "female", "address": "6471 Janpath, New Delhi, Goa, India", "post_code": 69863, "email": "savitha.keshri@example.com", "username": "lazyladybug659", "dob": "1950-03-10T13:24:16.856Z", "registered_date": "2005-04-08T18:37:32.207Z", "phone": "9645427035", "picture": "https://randomuser.me/api/portraits/med/women/82.jpg"}
...
