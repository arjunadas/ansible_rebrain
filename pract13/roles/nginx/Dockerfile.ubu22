# Используем последнюю версию Ubuntu как базовый образ
FROM ubuntu:22.04

# Обновляем список пакетов и устанавливаем Python
RUN apt-get update && \
    apt-get install -y python3 python3-pip sudo && \
    apt-get clean
