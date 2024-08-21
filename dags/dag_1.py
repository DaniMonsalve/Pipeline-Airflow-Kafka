import uuid
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from confluent_kafka import Producer
import json
import requests

def get_data(**kwargs):
    res = requests.get("https://randomuser.me/api/")
    res = res.json()
    res = res['results'][0]

    # Imprimir los datos en crudo
    print("Datos crudos obtenidos de la API:")
    print(res)

    # Poner los datos en XCom para que estén disponibles para las siguientes tareas
    kwargs['ti'].xcom_push(key='raw_data', value=res)

def format_data(**kwargs):
    ti = kwargs['ti']
    res = ti.xcom_pull(task_ids='extractor', key='raw_data')
    if not isinstance(res, dict):
        raise ValueError("El valor obtenido no es un diccionario.")

    data = {}
    location = res.get('location', {})
    data['id'] = str(uuid.uuid4())
    data['first_name'] = res.get('name', {}).get('first', '')
    data['last_name'] = res.get('name', {}).get('last', '')
    data['gender'] = res.get('gender', '')
    data['address'] = f"{str(location.get('street', {}).get('number', ''))} {location.get('street', {}).get('name', '')}, " \
                      f"{location.get('city', '')}, {location.get('state', '')}, {location.get('country', '')}"
    data['post_code'] = location.get('postcode', '')
    data['email'] = res.get('email', '')
    data['username'] = res.get('login', {}).get('username', '')
    data['dob'] = res.get('dob', {}).get('date', '')
    data['registered_date'] = res.get('registered', {}).get('date', '')
    data['phone'] = res.get('phone', '')
    data['picture'] = res.get('picture', {}).get('medium', '')

    # Imprimir los datos formateados
    print("Datos formateados:")
    print(data)

    # Poner los datos formateados en XCom para que estén disponibles para las siguientes tareas
    ti.xcom_push(key='formatted_data', value=data)

def json_serialization(**kwargs):
    ti = kwargs['ti']
    json_data = ti.xcom_pull(task_ids='transformacion', key='formatted_data')
    if json_data:
        producer_config = {
            'bootstrap.servers': 'localhost:9092',
            'client.id': 'airflow'
        }
        producer = Producer(producer_config)
        json_message = json.dumps(json_data)
        producer.produce('airflow-spark', value=json_message)
        producer.flush()
    else:
        print("No se pudo obtener el JSON de datos")

# Definición del DAG
dag = DAG (
    "DAG_API_randomuser",
    schedule_interval=timedelta(minutes=1),  # Cambiado a minutos para pruebas
    start_date=datetime(2024, 8, 20),
    catchup=False  # Opcional: para evitar ejecutar tareas pasadas al iniciar
)

# Definición de las tareas
task1 = PythonOperator(
    task_id='extractor',
    python_callable=get_data,
    dag=dag,
    provide_context=True,
)

task2 = PythonOperator(
    task_id='transformacion',
    python_callable=format_data,
    dag=dag,
    provide_context=True,
)

task3 = PythonOperator(
    task_id='envio_kafka',
    python_callable=json_serialization,
    dag=dag,
    provide_context=True,
)

# Establecer el orden de las tareas
task1 >> task2 >> task3
