# Importar las bibliotecas necesarias de AWS Glue
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

from pyspark.sql.session import SparkSession
from pyspark.sql.types import *
from pyspark.sql.functions import expr,col

from delta.tables import DeltaTable

from boto3 import client

import sys

# Crear un contexto de Spark y Glue
sc = SparkContext()
glueContext = GlueContext(sc)
logger = glueContext.get_logger()

args = getResolvedOptions(sys.argv,
                          [
                           'file_to_process'
                           ]
                          )

logger.info("#=# Creating Spark session")
spark = (
    SparkSession
    .builder
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
    .getOrCreate()
    )
file = args["file_to_process"]
source_data_location = file
spark_df = spark.read.parquet(source_data_location)

delta_table_location = "s3://hx-datainitiative-processed/deltalake/finance/price_data/"
delta_table = DeltaTable.forPath(spark,delta_table_location)

final_df = (delta_table.alias("target").merge(
    source=spark_df.alias("source"),
    condition=expr("target.date = source.date and target.ticker = source.ticker"))
    .whenMatchedUpdateAll()
    .whenNotMatchedInsertAll()
    .execute()
)