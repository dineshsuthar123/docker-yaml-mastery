-- Create databases for different services
CREATE DATABASE airflow;
CREATE DATABASE mlflow;
CREATE DATABASE superset;
-- Create users
CREATE USER airflow WITH PASSWORD 'airflow';
CREATE USER mlflow WITH PASSWORD 'mlflow';
CREATE USER superset WITH PASSWORD 'superset';
-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;
GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;
GRANT ALL PRIVILEGES ON DATABASE superset TO superset;