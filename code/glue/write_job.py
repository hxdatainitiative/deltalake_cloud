# Importar las bibliotecas necesarias de AWS Glue
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

from pyspark.sql.session import SparkSession
from pyspark.sql.types import *

import sys

# Crear un contexto de Spark y Glue
sc = SparkContext()
glueContext = GlueContext(sc)
logger = glueContext.get_logger()

args = getResolvedOptions(sys.argv,['file_to_process'])
file = args["file_to_process"]

logger.info("#=# Creating Spark session")
spark = SparkSession \
.builder \
.config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
.config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
.getOrCreate()

if file!="-":
    source_data_location = file
else:
    source_data_location = "s3://hx-datainitiative-drop-zone/deltalake/data/financial/yfinance/price_data/"

logger.info("#=# Read parquet from source")
spark_df = spark.read.parquet(source_data_location)
spark_df = spark_df.dropDuplicates()

delta_data_location = "s3://hx-datainitiative-processed/deltalake/finance/price_data/"

logger.info("#=# Writing tables to processed location")
       
spark_df.write\
        .format("delta")\
        .mode("append")\
        .option("mergeSchema", "true")\
        .partitionBy("ticker")\
        .save(delta_data_location)