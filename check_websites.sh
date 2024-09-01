#!/bin/bash

if [ -z "$1" ]; then
    echo "Помилка: будь ласка, вкажіть шлях до файлу зі списком сайтів."
    echo "Використання: $0 <шлях_до_файлу>"
    exit 1
fi

websites_file="$1"

if [ ! -f "$websites_file" ]; then
    echo "Помилка: файл '$websites_file' не знайдено."
    exit 1
fi

log_file="website_status.log"

> $log_file

while IFS= read -r website
do
    status_code=$(curl -o /dev/null -s -w "%{http_code}" -L "$website")

    if [ "$status_code" -eq 200 ]; then
        echo "[$website] is UP" | tee -a $log_file
    else
        echo "[$website] is DOWN" | tee -a $log_file
    fi
done < "$websites_file"

echo "Результати перевірки записано у файл $log_file"
