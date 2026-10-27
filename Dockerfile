FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    STREAMLIT_SERVER_ADDRESS=0.0.0.0 \
    STREAMLIT_SERVER_PORT=8501 \
    STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system app \
    && useradd --system --gid app --create-home app

COPY requirements-docker.txt ./
# The CPU model needs NumPy and SciPy, but not XGBoost's optional NCCL package.
RUN python -m pip install --no-cache-dir -r requirements-docker.txt \
    && python -m pip install --no-cache-dir --no-deps xgboost==3.2.0

COPY --chown=app:app app.py df.pkl pipe.pkl ./

USER app

EXPOSE 8501

CMD ["python", "-m", "streamlit", "run", "app.py"]
