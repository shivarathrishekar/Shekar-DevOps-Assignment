FROM python:3.12.7-slim-bookworm AS builder
WORKDIR /app
COPY app.py .
RUN python -m py_compile app.py

FROM python:3.12.7-slim-bookworm AS runtime
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
RUN useradd --system --uid 10001 --no-create-home appuser
COPY --from=builder --chown=10001:10001 /app/app.py /app/app.py
USER 10001:10001
EXPOSE 8080
CMD ["python", "/app/app.py"]
