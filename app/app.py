from confluent_kafka import Consumer, KafkaError
import couchdb
import json

# Configuración del consumidor de Kafka
consumer_config = {
    'bootstrap.servers': 'localhost:9092',  
    'group.id': 'my_consumer_group',       
    'auto.offset.reset': 'earliest'         
}

# Configuración de CouchDB
couchdb_server = 'http://localhost:5984/'
couchdb_database = 'kafka_data'  # Nombre de la base de datos en CouchDB
couchdb_user = 'admin'           # Usuario de CouchDB
couchdb_password = 'admin'       # Contraseña de CouchDB

# Conectar a CouchDB
couch = couchdb.Server(couchdb_server)
couch.resource.credentials = (couchdb_user, couchdb_password)

# Verificar si la base de datos existe, si no, crearla
if couchdb_database not in couch:
    couch.create(couchdb_database)

db = couch[couchdb_database]

# Crear consumidor de Kafka
consumer = Consumer(consumer_config)
consumer.subscribe(['airflow-spark'])

try:
    while True:
        msg = consumer.poll(1.0)  # Espera por mensajes durante 1 segundo

        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                print('Llegamos al final del tema')
            else:
                print(f'Error al recibir mensaje: {msg.error().str()}')
        else:
            # Procesa el mensaje JSON recibido
            json_data = msg.value().decode('utf-8')
            print(f'Mensaje JSON recibido: {json_data}')
            
            # Guardar el mensaje en CouchDB
            try:
                # Convertir a un diccionario
                document = json.loads(json_data)
                
                # Guardar en CouchDB
                db.save(document)
                print('Mensaje guardado en CouchDB.')
                
            except json.JSONDecodeError as e:
                print(f'Error al decodificar JSON: {e}')
            except Exception as e:
                print(f'Error al guardar en CouchDB: {e}')

except KeyboardInterrupt:
    pass

finally:
    consumer.close()
