from yfinance import Ticker
from pandas import DataFrame, to_datetime
from datetime import datetime
from io import BytesIO
from boto3 import client
from sys import _getframe
from logging import getLogger, info, INFO, warn, error

getLogger().setLevel(INFO)

def error_handler(func):
    def wrapper(*args,**kwargs):
        try:
            func(*args,**kwargs)
            var = args[0]
            prefix = kwargs["prefix"]
            return {
                "uri":f"s3://{var.bucket}/{var.base_prefix}/{prefix}/{var.date}_{var.ticker}.parquet"
            }
        except Exception as e:
            return {
                "ticker": var.ticker,
                "variables":list(kwargs.keys()),
                "error": str(e)
            }
    return wrapper

class DataHandler:
    def __init__(self, **kwargs):
        for key, value in kwargs.items():
            setattr(self, key, value)
        self.s3_client = client("s3")
        self.date = datetime.now().strftime("%Y%m%d")     
          
    @error_handler
    def news_data(self, news: DataFrame):
        json_buffer = BytesIO()
        prefix = _getframe().f_code.co_name  
        (
            news
            .assign(
                date=to_datetime(news["providerPublishTime"],unit="s").dt.date.astype("string"),
                ticker=self.ticker
            )
            .to_json(json_buffer, orient="records")
        )
        self.s3_client.put_object(
            Body=json_buffer.getvalue(),
            Bucket=self.bucket,
            Key=f"{self.base_prefix}/{prefix}/{self.date}_{self.ticker}.json"
        )
    
    @error_handler
    def put_data(self, data_to_load: DataFrame, prefix:str):
        parquet_buffer = BytesIO()      
        (
            data_to_load
            .assign(ticker=self.ticker)
            .rename(columns=lambda x: x.replace(" ", "_").lower())
            .to_parquet(parquet_buffer, index=False)
        )
        self.s3_client.put_object(
            Body=parquet_buffer.getvalue(),
            Bucket=self.bucket,
            Key=f"{self.base_prefix}/{prefix}/{self.date}_{self.ticker}.parquet"
        )


def lambda_handler(event: dict, context):
    handler = DataHandler(**event)
    
    ticker = event.get("ticker")
    data = Ticker(ticker)
    
    news = DataFrame(data.news)
    
    results = {ticker: []}
    # info("#=# Put news")
    # results[ticker].append(handler.news_data(news=news))
    info("#=# Put prices")
    price_data = data.history(interval="1d", period=event.get("period"))
    price_data = price_data.reset_index().assign(Date = lambda x: to_datetime(x["Date"]).dt.date)
    # results[ticker].append(handler.put_data(data_to_load=price_data,prefix="price_data"))
    
    # info("#=# Put financial data")
    # results[ticker].append(handler.put_data(data_to_load=data.financials.transpose(),prefix="financial_data"))
    return handler.put_data(data_to_load=price_data,prefix="price_data")
