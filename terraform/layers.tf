resource "aws_lambda_layer_version" "deltalake" {
  filename    = "../code/layers/delta_layer.zip"
  layer_name  = "hx_deltalake_layer"
  description = "Capa Deltalake para lambdas"

  compatible_runtimes = ["python3.7", "python3.8", "python3.9", "python3.10"]
  source_code_hash =  "${base64sha256("../code/layers/delta_layer.zip")}"
}

resource "aws_lambda_layer_version" "yfinance" {
  filename    = "../code/layers/yfinance.zip"
  layer_name  = "hx_yfinance"
  description = "Capa de YFinance para lambdas"

  compatible_runtimes = ["python3.7", "python3.8", "python3.9", "python3.10"]
  source_code_hash =  "${base64sha256("../code/layers/yfinance.zip")}"
}
