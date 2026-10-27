# Laptop Price Prediction

A machine-learning project that estimates a laptop's price from its hardware and
configuration. It includes a Streamlit app for interactive predictions and a
Jupyter notebook with exploratory data analysis and model training.

## Features

- Predict a price from a laptop's brand, type, RAM, weight, display, CPU, storage,
  GPU, and operating system.
- Explore the data preparation and regression experiments in
  [`laptop_price_EDA.ipynb`](./laptop_price_EDA.ipynb).
- Use the fitted preprocessing and regression pipeline saved in `model/pipe.pkl`.

## Requirements

- Python (use a version compatible with the pinned packages in
  [`requirements.txt`](./requirements.txt))
- The project files, including `model/df.pkl` and `model/pipe.pkl`

## Setup and run

Run these commands from the project directory in PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m streamlit run app.py --server.address=0.0.0.0 --server.port=8501
```

Streamlit prints a local URL in the terminal when the app starts. Open that URL
in a browser. The app loads its trained artifacts from the `model/` directory.

To open the app from another device on the same Wi-Fi or LAN, keep the app
running, find the host computer's IPv4 address with `ipconfig`, then visit
`http://<host-ipv4-address>:8501` on that device. Allow inbound TCP port 8501
through the host's firewall on a trusted private network if prompted. Do not
expose this app directly to the public internet.

## Run with Docker

Build and run the image from the project directory:

```powershell
docker build -t laptop-price-predictor .
docker run --rm -p 8501:8501 laptop-price-predictor
```

Open `http://localhost:8501` in your browser. From another device on the same
Wi-Fi or LAN, use `http://<host-ipv4-address>:8501`, replacing the placeholder
with the Docker host's IPv4 address. The image includes the app and `model/`;
the notebook, dataset, and local virtual environment are excluded from the build
context. It installs the pinned runtime dependencies from
`requirements-docker.txt`; `requirements.txt` remains the full project
environment.

## Using the predictor

Choose the laptop's configuration with the app's input controls and select
**Predict Price**. The app builds the display's pixels-per-inch value from the
selected resolution and screen size, passes the features to the saved pipeline,
and converts the model's log-price prediction back to the original price scale.

The estimate depends on the training data and model; it is not a live market
quote or a guarantee of a laptop's sale price.

## Project files

| File | Description |
| --- | --- |
| `app.py` | Streamlit user interface and prediction logic |
| `laptop_price_EDA.ipynb` | Data exploration, feature preparation, and model experiments |
| `data/laptop_data.csv` | Laptop specifications and target prices used for analysis |
| `model/df.pkl` | Processed dataframe used to populate the app's selection options |
| `model/pipe.pkl` | Fitted preprocessing and stacked regression pipeline |
| `requirements.txt` | Pinned dependencies for analysis and local use |
| `requirements-docker.txt` | Pinned runtime dependencies used to build the Docker image |

## Model workflow

The notebook prepares laptop specification features and groups some raw
categories, including CPU, GPU, and operating system. It trains on log-transformed
prices, uses a train/test split, and compares regression approaches. The
exported pipeline applies one-hot encoding to categorical features and combines
random forest, gradient boosting, XGBoost, and extra trees regressors in a
stacking regressor.

To retrain or change the model, work through the notebook and run its export
cells. Place the exported `df.pkl` and `pipe.pkl` in `model/` and keep them
compatible with the app's expected features and installed dependency versions.