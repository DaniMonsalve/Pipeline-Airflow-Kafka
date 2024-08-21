# Configuración del Pipeline de Airflow

Guía utilizada para configurar un pipeline con Apache Airflow, Apache Kafka y Apache Spark en un entorno WSL.

# Descripción del DAG
El DAG de Airflow, llamado DAG_API_randomuser, automatiza la extracción, transformación y envío de datos desde una API externa ("https://randomuser.me/api/"). La ejecución del DAG sigue estos pasos:

Extracción de Datos (extractor): La primera tarea, get_data, realiza una solicitud HTTP a la API de randomuser.me para obtener datos de usuario en formato JSON. Los datos crudos obtenidos de la API se imprimen en la consola y se almacenan en XCom, lo que permite que las tareas subsiguientes accedan a ellos.

Transformación de Datos (transformacion): La segunda tarea, format_data, toma los datos crudos desde XCom y los transforma en un formato estructurado. Se extraen campos específicos como el nombre, dirección, correo electrónico, y otros detalles relevantes del usuario. Los datos formateados se imprimen en la consola y se vuelven a almacenar en XCom para su uso posterior.

Envío a Kafka (envio_kafka): La última tarea, json_serialization, recupera los datos formateados desde XCom y los convierte en una cadena JSON. Esta cadena se envía a un tópico de Kafka denominado airflow-spark usando un productor de Kafka configurado. Esta tarea asegura que los datos procesados estén disponibles para otros sistemas o aplicaciones que consumen mensajes desde Kafka.

<img width="948" alt="Resultado final graph" src="https://github.com/user-attachments/assets/8198ce76-c931-4260-bfaa-a511ca7eb588">


## Estructura del Repositorio
    .
    ├── dags
    │   ├── dag_1
    ├── airflow.cfg
    ├── webserver_config.py
    ├── CONSOLA_OUTPUT.md

## Presentación de resultado:

Acceder al documento CONSOLA_OUTPUT.md para consultar las salidas de la consola y los comentarios asociados a cada comando ejecutado, así como otras evidencias del correcto funcionamiento del proceso.

## 1. Crear y configurar el entorno

```bash
# Crear un directorio para el proyecto y navegar a él
mkdir ~/airflow_pipeline
cd ~/airflow_pipeline

# Crear un entorno virtual
virtualenv venv
source venv/bin/activate

# Establecer la variable de entorno AIRFLOW_HOME
export AIRFLOW_HOME=$(pwd)

# Instalar Apache Airflow
pip install apache-airflow

# Iniciar Airflow en modo standalone (para desarrollo)
airflow standalone

# Descargar Apache Kafka
wget https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz

# Descomprimir el archivo
tar -xzvf kafka_2.12-3.8.0.tgz

# Eliminar el archivo comprimido
rm kafka_2.12-3.8.0.tgz

# Iniciar Zookeeper en una terminal
cd kafka_2.12-3.8.0
bin/zookeeper-server-start.sh config/zookeeper.properties

# En otra terminal, iniciar el servidor Kafka
bin/kafka-server-start.sh config/server.properties

# Crear un nuevo topic
bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092

# Producir un mensaje al topic
bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
# Escribe tu mensaje y presiona Ctrl+D para salir

# Consumir el mensaje desde el topic
bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092

# Descargar Spark
wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz

# Descomprimir el archivo
tar -xzvf spark-3.5.2-bin-hadoop3.tgz

# Eliminar el archivo comprimido
rm spark-3.5.2-bin-hadoop3.tgz

# Renombrar el archivo de configuración
cd spark-3.5.2-bin-hadoop3/conf
mv spark-defaults.conf.template spark-defaults.conf

# Iniciar el master de Spark
cd ..
./sbin/start-master.sh

# Iniciar el worker de Spark
./sbin/start-worker.sh spark://LAPTOP-73U6RBEH:7077

# Crear un nuevo topic para Airflow
cd ~/airflow_pipeline/kafka_2.12-3.8.0
bin/kafka-topics.sh --create --topic airflow-spark --bootstrap-server localhost:9092

# Producir mensajes al topic
bin/kafka-console-producer.sh --topic airflow-spark --bootstrap-server localhost:9092
