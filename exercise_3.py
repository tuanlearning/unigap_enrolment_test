import pandas as pd
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python_operator import PythonOperator
from google.cloud import bigquery
import os
import json


os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = '/opt/airflow/credentials/testdbt-424602-cabd43041b7d.json'
default_args = {
    'owner': 'tuanlg',
    'start_date': days_ago(1),
}

project_id = 'testdbt-424602'
dataset_id = 'Analytics'
table = 'employees'


def load_json(ti):
    with open('/opt/airflow/data/data.json') as f:
        result = json.loads(f.read())
    df = pd.DataFrame(data=result)
    df['join_date'] = pd.to_datetime(df['join_date'])
    ti.xcom_push(key='df', value=df)


def write_to_big_query(ti):
    destination_table = f'{project_id}.{dataset_id}.{table}'
    df = ti.xcom_pull(key='df')
    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
        autodetect=True,
    )
    client = bigquery.Client(project=project_id)
    # Write to big query table
    job = client.load_table_from_dataframe(
        df, destination_table, job_config=job_config
    )
    job.result()


dag = DAG(
    dag_id='json_to_big_query',
    default_args=default_args,
    schedule_interval=None,
    tags=['unigap'],
)


load_json = PythonOperator(
    task_id='load_json',
    python_callable=load_json,
    dag=dag,
)

write_to_big_query = PythonOperator(
    task_id='write_to_big_query',
    python_callable=write_to_big_query,
    dag=dag,
)

load_json >> write_to_big_query
