# Importar las bibliotecas necesarias de AWS Glue
from awsglue.context import GlueContext
from pyspark.context import SparkContext

# Crear un contexto de Spark y Glue
sc = SparkContext()
glueContext = GlueContext(sc)

source_data_location = "s3://ruta/datos_origen"

delta_data_location = "s3://ruta/delta_lake"

database_name = "nombre_basededatos"
table_name = "nombre_tabla"

source_dynamic_frame = glueContext.create_dynamic_frame.from_catalog(database="basededatos_origen", table_name="tabla_origen")

source_data_frame = source_dynamic_frame.toDF()

source_data_frame.write.format("delta").mode("overwrite").save(delta_data_location)

glueContext.create_dynamic_frame.from_catalog(database=database_name, table_name=table_name, transformation_ctx="table").write.format("delta").save(delta_data_location)

print("La tabla Delta Lake ha sido creada exitosamente.")