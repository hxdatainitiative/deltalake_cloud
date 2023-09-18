import boto3

def lambda_handler(event, context):
    # Obtener los datos del evento
    table_name = event['table_name']
    operation = event['operation']
    data = event['data']

    # Crear una instancia del cliente AWS Glue DataBrew
    glue_client = boto3.client('glue')

    # Iniciar la transacción en la tabla Delta Lake
    transaction_id = glue_client.start_transaction(DatabaseName='database_name', TableName=table_name)

    try:
        # Realizar la operación de inserción o actualización
        if operation == 'insert':
            glue_client.insert_into_table(DatabaseName='database_name', TableName=table_name, TransactionId=transaction_id, RowData=data)
        elif operation == 'update':
            glue_client.update_table(DatabaseName='database_name', TableName=table_name, TransactionId=transaction_id, RowData=data)
        else:
            raise ValueError('Operación no válida. Se espera "insert" o "update".')

        # Confirmar la transacción
        glue_client.commit_transaction(DatabaseName='database_name', TableName=table_name, TransactionId=transaction_id)

        # Devolver una respuesta exitosa
        return {
            'statusCode': 200,
            'body': 'Transacción completada exitosamente.'
        }

    except Exception as e:
        # Revertir la transacción en caso de error
        glue_client.rollback_transaction(DatabaseName='database_name', TableName=table_name, TransactionId=transaction_id)

        # Devolver una respuesta de error
        return {
            'statusCode': 500,
            'body': f'Error en la transacción: {str(e)}'
        }
