dani@LAPTOP-73U6RBEH:~$ mkdir ~/airflow_pipeline
dani@LAPTOP-73U6RBEH:~$ cd ~/airflow_pipeline
dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ virtualenv venv
created virtual environment CPython3.10.12.final.0-64 in 489ms
  creator CPython3Posix(dest=/home/dani/airflow_pipeline/venv, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=/home/dani/.local/share/virtualenv)
    added seed packages: pip==24.1, setuptools==70.1.0, wheel==0.43.0
  activators BashActivator,CShellActivator,FishActivator,NushellActivator,PowerShellActivator,PythonActivator
dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ source venv/bin/activate
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ export AIRFLOW_HOME=$(pwd)
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ pip install apache-airflow
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ airflow standalone #Para indicar que airflow se va a ejecutar utilizando una sola máquina.
standalone | Airflow is ready
standalone | Login with username: admin  password: 3ZcCYCWCyHRpzHSV
standalone | Airflow Standalone is for development purposes only. Do not use this in production!

^Cstandalone | Shutting down components
standalone | Complete

#Acceder a la carpeta AIRFLOW_PIPELINE desde VS_Code y modificar el documento airflow.cfg para desactivar los pipelines de ejemplo y que airflow descarga por defecto. (Imagen 1)

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ wget https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz #Descarga de Apache-Kafka desde la página https://kafka.apache.org/downloads, copiando el enlace de la última versión binaria.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ ls
airflow.cfg  airflow.db  kafka_2.12-3.8.0.tgz  logs  standalone_admin_password.txt  venv  webserver_config.py
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ tar -xzvf kafka_2.12-3.8.0.tgz #Para descomprimir la carpeta .tgz
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ rm kafka_2.12-3.8.0.tgz #Eliminar la carpeta .tgz
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ ls -l
total 1348
-rw------- 1 dani dani   87078 Aug 20 16:58 airflow.cfg
-rw-r--r-- 1 dani dani 1261568 Aug 20 17:01 airflow.db
drwxr-xr-x 7 dani dani    4096 Jul 23 10:07 kafka_2.12-3.8.0
drwxr-xr-x 4 dani dani    4096 Aug 20 16:58 logs
-rw------- 1 dani dani      16 Aug 20 16:58 standalone_admin_password.txt
drwxr-xr-x 5 dani dani    4096 Aug 20 16:53 venv
-rw-r--r-- 1 dani dani    4762 Aug 20 16:58 webserver_config.py
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/zookeeper-server-start.sh config/zookeeper.properties #Inicia zookeeper

#En otra terminal, Reinicilizar el servidor de Kafka:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-server-start.sh config/server.properties 

#En otra terminal, crear topic:
(base) PS C:\Users\danie> wsl
dani@LAPTOP-73U6RBEH:/mnt/c/Users/danie$ cd ~/airflow_pipeline
dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ cd kafka_2.12-3.8.0
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
Created topic quickstart-events.
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
>Este es el primer topic enviado
>

#En otra terminal, activar el consumidor:
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
Este es el primer topic enviado
Segundo mensaje


#Descarga Spark en el entorno de trabajo:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ tar -xzvf spark-3.5.2-bin-hadoop3.tgz #Para descomprimir la carpeta .tgz
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ rm spark-3.5.2-bin-hadoop3.tgz #Eliminar la carpeta .tgz

#Ajustar configuración de Spark:
	#Renombrar el archivo 'spark-defaults.conf.template" dentro de la carpeta conf como spark-defaults.conf:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3/conf$ ls -l
total 36
-rw-r--r-- 1 dani dani 1105 Aug  6 13:51 fairscheduler.xml.template
-rw-r--r-- 1 dani dani 3350 Aug  6 13:51 log4j2.properties.template
-rw-r--r-- 1 dani dani 9141 Aug  6 13:51 metrics.properties.template
-rw-r--r-- 1 dani dani 1292 Aug  6 13:51 spark-defaults.conf.template
-rwxr-xr-x 1 dani dani 4694 Aug  6 13:51 spark-env.sh.template
-rw-r--r-- 1 dani dani  865 Aug  6 13:51 workers.template
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3/conf$ mv spark-defaults.conf.template spark-defaults.conf
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3/conf$ ls -l
total 36
-rw-r--r-- 1 dani dani 1105 Aug  6 13:51 fairscheduler.xml.template
-rw-r--r-- 1 dani dani 3350 Aug  6 13:51 log4j2.properties.template
-rw-r--r-- 1 dani dani 9141 Aug  6 13:51 metrics.properties.template
-rw-r--r-- 1 dani dani 1292 Aug  6 13:51 spark-defaults.conf
-rwxr-xr-x 1 dani dani 4694 Aug  6 13:51 spark-env.sh.template
-rw-r--r-- 1 dani dani  865 Aug  6 13:51 workers.template

#Se procede a configurar el archivo spark-defaults.conf (Imagen 2)

#En otra terminal, se abre el servidor de spark copiando la dirección del master en "localhost:9090" (imagen 3):
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3$ ./sbin/start-master.sh
starting org.apache.spark.deploy.master.Master, logging to /home/dani/airflow_pipeline/spark-3.5.2-bin-hadoop3/logs/spark-dani-org.apache.spark.deploy.master.Master-1-LAPTOP-73U6RBEH.out
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3$ ./sbin/start-worker.sh spark://LAPTOP-73U6RBEH.:7077

#Se comprueba que el worker se encuentra registrado: (Imagen 4)


#Instanciar un DAG:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-topics.sh --create --topic airflow-spark --bootstrap-server localhost:9092
Created topic airflow-spark. #Se crea un topic con el mismo nombre que el que definimos en el archivo .py a ejecutar (Imagen 5)

#Los resultados se cargan correctamente en kafka: (Consultar capturas de pantalla de Airflow)

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-consumer.sh --topic airflow-spark --from-beginning --bootstrap-server localhost:9092
{"id": "f02bbbc6-f204-48da-9010-2bf82dc34186", "first_name": "Savitha", "last_name": "Keshri", "gender": "female", "address": "6471 Janpath, New Delhi, Goa, India", "post_code": 69863, "email": "savitha.keshri@example.com", "username": "lazyladybug659", "dob": "1950-03-10T13:24:16.856Z", "registered_date": "2005-04-08T18:37:32.207Z", "phone": "9645427035", "picture": "https://randomuser.me/api/portraits/med/women/82.jpg"}
{"id": "7aee1e07-293c-4eac-829f-2b0f7a6ea643", "first_name": "Alex", "last_name": "Murphy", "gender": "female", "address": "5007 Killarney Road, Dublin, Galway City, Ireland", "post_code": 85136, "email": "alex.murphy@example.com", "username": "heavydog772", "dob": "1953-12-31T14:52:14.653Z", "registered_date": "2002-11-19T20:29:43.504Z", "phone": "061-285-8526", "picture": "https://randomuser.me/api/portraits/med/women/61.jpg"}
{"id": "8065a760-f751-43b4-a2f2-77009ad48918", "first_name": "Tom", "last_name": "Hofstede", "gender": "male", "address": "3280 Hellendaalstraat, Oosterblokker, Zeeland, Netherlands", "post_code": "8286 ZT", "email": "tom.hofstede@example.com", "username": "purplezebra297", "dob": "1974-08-21T12:08:31.326Z", "registered_date": "2021-03-17T08:43:27.541Z", "phone": "(0733) 616181", "picture": "https://randomuser.me/api/portraits/med/men/34.jpg"}
{"id": "a5436bcd-fce1-47f7-be3e-097a3599775c", "first_name": "\u062f\u0631\u0633\u0627", "last_name": "\u0633\u0647\u064a\u0644\u064a \u0631\u0627\u062f", "gender": "female", "address": "6056 \u0647\u0644\u0627\u0644 \u0627\u062d\u0645\u0631, \u062e\u0645\u06cc\u0646\u06cc\u200c\u0634\u0647\u0631, \u06cc\u0632\u062f, Iran", "post_code": 94150, "email": "drs.shylyrd@example.com", "username": "blackfish793", "dob": "1964-01-24T04:50:04.081Z", "registered_date": "2012-03-03T19:26:19.459Z", "phone": "036-75107536", "picture": "https://randomuser.me/api/portraits/med/women/39.jpg"}
{"id": "07556eeb-1f5b-45f9-ba74-b9b51efe52dd", "first_name": "Nadia", "last_name": "Opseth", "gender": "female", "address": "3320 Skabos vei, Lang\u00f8rjan, Tr\u00f8ndelag, Norway", "post_code": "5036", "email": "nadia.opseth@example.com", "username": "bigdog344", "dob": "1998-06-05T16:45:36.374Z", "registered_date": "2019-05-18T10:55:33.530Z", "phone": "70017997", "picture": "https://randomuser.me/api/portraits/med/women/93.jpg"}
