# Documentación de Salidas de Consola y Comentarios

Este documento proporciona las salidas de la consola y los comentarios asociados a cada comando ejecutado durante el proceso de configuración del pipeline.


## 1. Crear y configurar el entorno

```bash 
dani@LAPTOP-73U6RBEH:~$ mkdir ~/airflow_pipeline
# Crea un directorio llamado 'airflow_pipeline' en el directorio home del usuario 'dani'.

dani@LAPTOP-73U6RBEH:~$ cd ~/airflow_pipeline
# Cambia al directorio 'airflow_pipeline' recién creado.

dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ virtualenv venv
# Crea un entorno virtual llamado 'venv' dentro del directorio 'airflow_pipeline'. Esto aísla las dependencias de Python.

created virtual environment CPython3.10.12.final.0-64 in 489ms
  creator CPython3Posix(dest=/home/dani/airflow_pipeline/venv, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=/home/dani/.local/share/virtualenv)
    added seed packages: pip==24.1, setuptools==70.1.0, wheel==0.43.0
  activators BashActivator,CShellActivator,FishActivator,NushellActivator,PowerShellActivator,PythonActivator
# Mensaje de confirmación de la creación del entorno virtual con las versiones de paquetes instalados.

dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ source venv/bin/activate
# Activa el entorno virtual 'venv'. Todos los paquetes de Python instalados ahora se mantendrán en este entorno.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ export AIRFLOW_HOME=$(pwd)
# Establece la variable de entorno AIRFLOW_HOME para que apunte al directorio actual, que se utilizará como el directorio de trabajo de Airflow.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ pip install apache-airflow
# Instala Apache Airflow dentro del entorno virtual. Airflow es una plataforma de orquestación de flujos de trabajo.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ airflow standalone
# Inicia Airflow en modo standalone, que es adecuado para desarrollo. No se recomienda para producción.

standalone | Airflow is ready
standalone | Login with username: admin  password: 3ZcCYCWCyHRpzHSV
standalone | Airflow Standalone is for development purposes only. Do not use this in production!
# Airflow ha iniciado correctamente y proporciona credenciales para acceder a la interfaz de usuario.
```
Acceder a la carpeta AIRFLOW_PIPELINE desde VS_Code y modificar el documento airflow.cfg para desactivar los pipelines de ejemplo y que airflow descarga por defecto. (Imagen 1)
  Es necesario modificar el archivo 'airflow.cfg' para desactivar los DAGs de ejemplo que Airflow incluye por defecto.

<img width="957" alt="Desactivar los ejemplos de pipelines en airflow descagados por defecto" src="https://github.com/user-attachments/assets/8d2f9559-4892-4c7a-a9a1-293252eb5f88">

```
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ wget https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz
# Descarga Apache Kafka desde el sitio oficial.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ tar -xzvf kafka_2.12-3.8.0.tgz
# Descomprime el archivo .tgz de Kafka para acceder a los archivos binarios.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ rm kafka_2.12-3.8.0.tgz
# Elimina el archivo .tgz descargado para liberar espacio.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ ls -l
# Muestra el contenido del directorio con detalles, incluyendo el archivo de configuración de Airflow, la base de datos de Airflow, los logs, y los archivos de Kafka y Spark.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/zookeeper-server-start.sh config/zookeeper.properties
# Inicia el servidor Zookeeper, que es necesario para la coordinación de Kafka.

#En otra terminal, reinicializar el servidor de Kafka:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-server-start.sh config/server.properties 
# Inicia el servidor de Kafka con la configuración proporcionada en server.properties.

#En otra terminal, crear topic:
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
# Crea un topic llamado 'quickstart-events' en Kafka para el envío y recepción de mensajes.

#En otra terminal, activar el productor de mensajes:
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
# Inicia el productor de Kafka para enviar mensajes al topic 'quickstart-events'.

>Este es el primer topic enviado
# Mensaje enviado al topic.

#En otra terminal, activar el consumidor:
dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
# Inicia el consumidor de Kafka que lee los mensajes del topic 'quickstart-events'.

Este es el primer topic enviado
Segundo mensaje
# Los mensajes enviados son consumidos correctamente y mostrados en la terminal.

#Descarga Spark en el entorno de trabajo:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz
# Descarga Apache Spark desde el sitio oficial.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ tar -xzvf spark-3.5.2-bin-hadoop3.tgz
# Descomprime el archivo .tgz de Spark para acceder a los archivos binarios.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline$ rm spark-3.5.2-bin-hadoop3.tgz
# Elimina el archivo .tgz descargado para liberar espacio.

#Renombrar el archivo 'spark-defaults.conf.template' dentro de la carpeta conf como spark-defaults.conf:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3/conf$ mv spark-defaults.conf.template spark-defaults.conf
# Renombra el archivo de plantilla 'spark-defaults.conf.template' a 'spark-defaults.conf' para que Spark lo utilice como configuración.
```
Ajustar configuración de Spark:
  Aquí es donde se realizarían ajustes adicionales en 'spark-defaults.conf' para personalizar la configuración de Spark (Imagen 2).

  <img width="956" alt="Configuración spark-defaults conf" src="https://github.com/user-attachments/assets/0b0cc10a-7cae-4d90-9454-4f78eb29db9f">

```
```
En otra terminal, se abre el servidor de Spark copiando la dirección del master en "localhost:9090" (imagen 3):

  <img width="954" alt="Copiar dirección del master" src="https://github.com/user-attachments/assets/e4c04eda-965a-4475-94bb-85be07343677">

```
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3$ ./sbin/start-master.sh
# Inicia el maestro de Spark.
```

```
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/spark-3.5.2-bin-hadoop3$ ./sbin/start-worker.sh spark://LAPTOP-73U6RBEH.:7077
# Inicia un worker que se conecta al maestro de Spark para ejecutar trabajos distribuidos.
```
Se comprueba que el worker se encuentra registrado: (Imagen 4)
 Verifica en la interfaz de Spark que el worker esté registrado correctamente con el maestro.
  
  <img width="953" alt="Se comprrueba que el worker se encuentra registrado" src="https://github.com/user-attachments/assets/1d7f431a-8865-4850-adac-29783b6b1d2e">
  
```
#Instanciar un DAG:
(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-topics.sh --create --topic airflow-spark --bootstrap-server localhost:9092
# Crea un topic en Kafka llamado 'airflow-spark' para ser utilizado en la integración con Airflow.
```
Se crea un topic con el mismo nombre que el que definimos en el archivo .py a ejecutar: (Imagen 5)
  <img width="957" alt="Nombre del topic en dag_1 py" src="https://github.com/user-attachments/assets/6be1a5ac-9a04-4ca6-855f-574b32dbb030">

```
#Los resultados se cargan correctamente en kafka: (Consultar capturas de pantalla de Airflow)
# Verifica que los resultados se cargan correctamente en el topic 'airflow-spark'.

(venv) dani@LAPTOP-73U6RBEH:~/airflow_pipeline/kafka_2.12-3.8.0$ bin/kafka-console-consumer.sh --topic airflow-spark --from-beginning --bootstrap-server localhost:9092
# Inicia un consumidor para leer mensajes del topic 'airflow-spark' en Kafka.

{"id": "f02bbbc6-f204-48da-9010-2bf82dc34186", "first_name": "Savitha", "last_name": "Keshri", "gender": "female", "address": "6471 Janpath, New Delhi, Goa, India", "post_code": 69863, "email": "savitha.keshri@example.com", "username": "lazyladybug659", "dob": "1950-03-10T13:24:16.856Z", "registered_date": "2005-04-08T18:37:32.207Z", "phone": "9645427035", "picture": "https://randomuser.me/api/portraits/med/women/82.jpg"}
{"id": "7aee1e07-293c-4eac-829f-2b0f7a6ea643", "first_name": "Alex", "last_name": "Murphy", "gender": "female", "address": "5007 Killarney Road, Dublin, Galway City, Ireland", "post_code": 85136, "email": "alex.murphy@example.com", "username": "heavydog772", "dob": "1953-12-31T14:52:14.653Z", "registered_date": "2002-11-19T20:29:43.504Z", "phone": "061-285-8526", "picture": "https://randomuser.me/api/portraits/med/women/61.jpg"}
{"id": "8065a760-f751-43b4-a2f2-77009ad48918", "first_name": "Tom", "last_name": "Hofstede", "gender": "male", "address": "3280 Hellendaalstraat, Oosterblokker, Zeeland, Netherlands", "post_code": "8286 ZT", "email": "tom.hofstede@example.com", "username": "purplezebra297", "dob": "1974-08-21T12:08:31.326Z", "registered_date": "2021-03-17T08:43:27.541Z", "phone": "(0733) 616181", "picture": "https://randomuser.me/api/portraits/med/men/34.jpg"}
{"id": "a5436bcd-fce1-47f7-be3e-097a3599775c", "first_name": "\u062f\u0631\u0633\u0627", "last_name": "\u0633\u0647\u064a\u0644\u064a \u0631\u0627\u062f", "gender": "female", "address": "6056 \u0647\u0644\u0627\u0644 \u0627\u062d\u0645\u0631, \u062e\u0645\u06cc\u0646\u06cc\u200c\u0634\u0647\u0631, \u06cc\u0632\u062f, Iran", "post_code": 94150, "email": "drs.shylyrd@example.com", "username": "blackfish793", "dob": "1964-01-24T04:50:04.081Z", "registered_date": "2012-03-03T19:26:19.459Z", "phone": "036-75107536", "picture": "https://randomuser.me/api/portraits/med/women/39.jpg"}
{"id": "07556eeb-1f5b-45f9-ba74-b9b51efe52dd", "first_name": "Nadia", "last_name": "Opseth", "gender": "female", "address": "3320 Skabos vei, Lang\u00f8rjan, Tr\u00f8ndelag, Norway", "post_code": "5036", "email": "nadia.opseth@example.com", "username": "bigdog344", "dob": "1998-06-05T16:45:36.374Z", "registered_date": "2019-05-18T10:55:33.530Z", "phone": "70017997", "picture": "https://randomuser.me/api/portraits/med/women/93.jpg"}
...
```
En Airflow se pueden comprobar el correcto funcionamiento de igual manera:
<img width="948" alt="Resultado final graph" src="https://github.com/user-attachments/assets/0efffcb2-e44c-4ff6-918e-52cd2b0a3ab0"> 

<img width="944" alt="Event_log" src="https://github.com/user-attachments/assets/d79d64c6-2374-4924-88a0-3433ef73428c">

<img width="946" alt="Event_log_kafka" src="https://github.com/user-attachments/assets/64522e96-b312-4a80-bb09-830d31ad74ca">


Karfka consumer:
<img width="953" alt="Kafka_Consumer" src="https://github.com/user-attachments/assets/1413ffbd-be20-447b-980f-1d84096a013e">


