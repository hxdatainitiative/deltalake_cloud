# Importar las bibliotecas necesarias de AWS Glue
from awsglue.context import GlueContext
from pyspark.context import SparkContext

from pyspark.sql.session import SparkSession
from pyspark.sql.types import *

# Crear un contexto de Spark y Glue
sc = SparkContext()
glueContext = GlueContext(sc)
logger = glueContext.get_logger()

logger.info("#=# Creating Spark session")
spark = SparkSession \
.builder \
.config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
.config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
.getOrCreate()

source_data_location = "s3://hx-datainitiative-drop-zone/deltalake/data/financial/yfinance/price_data/"

logger.info("#=# Read parquet from source")
spark_df = spark.read.parquet(source_data_location)

delta_data_location = "s3://hx-datainitiative-processed/deltalake/finance/price_data/"

logger.info("#=# Writing tables to processed location")
spark_df.repartition("date").write.format("delta").mode("append").partitionBy("date").save(delta_data_location)