#!/bin/bash
# Скрипт для вывода характеристик ПК и сетевых интерфейсов в формате
# Дата; Имя учетной записи; Доменное имя ПК; Характеристики ПК
# Таблица сетевых интерфейсов: N, Имя, MAC, IP адрес, Скорость соединения

# Получаем текущую дату и время
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Получаем имя учетной записи
USER=$(whoami)

# Получаем доменное имя ПК
HOST=$(hostname -f)

# Получаем информацию о процессоре
CPU_MODEL=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F': ' '{print $2}')
CPU_ARCH=$(arch)
CPU_FREQ=$(cat /proc/cpuinfo | grep -m 1 "cpu MHz" | uniq | awk -F': ' '{print $2}')
CPU_CORES=$(lscpu | grep "Core(s) per socket" | awk -F':              ' '{print $2}')
CPU_THREADS=$(lscpu | grep "Thread(s) per core" | awk -F':              ' '{print $2}')

# Получаем информацию об оперативной памяти
RAM_TOTAL=$(free -hm | grep "Mem:" | awk '{print $2}')
RAM_AVAILABLE=$(free -hm | grep "Mem:" | awk '{print $7}')

# Получаем информацию о жестком диске
DISK_TOTAL=$(df -h / --output=size | awk 'NR==2')
DISK_AVAILABLE=$(df -h / --output=avail | awk 'NR==2')
DISK_MOUNT=$(df -h / --output=target | awk 'NR==2')
SWAP_TOTAL=$(free -hm | grep "Swap:" | awk '{print $2}')
SWAP_AVAILABLE=$(free -hm | grep "Swap:" | awk '{print $4}')

# Выводим информацию на экран в нужном формате
echo "Дата: $DATE"
echo "Имя учетной записи: $USER"
echo "Доменное имя ПК: $HOST"
echo "Процессор:"
echo "*   Модель: $CPU_MODEL"
echo "*   Архитектура: $CPU_ARCH"
echo "*   Тактовая частота: $CPU_FREQ MHz"
echo "*   Количество ядер: $CPU_CORES"
echo "*   Количество потоков на одно ядро: $CPU_THREADS"
echo "Оперативная память:"
echo "*   Всего: $RAM_TOTAL"
echo "*   Доступно: $RAM_AVAILABLE"
echo "Жесткий диск:"
echo "*   Всего: $DISK_TOTAL"
echo "*   Доступно: $DISK_AVAILABLE"
echo "*   Смонтировано в корневую директорию /: $DISK_MOUNT"
echo "*   SWAP всего: $SWAP_TOTAL"
echo "*   SWAP доступно: $SWAP_AVAILABLE"

interfaces=($(ifconfig -a | grep -E "^[a-zA-Z0-9]" | awk -F': ' '{print $1}'))

printf "+----+--------------+---------------------------+-------------------+-----------+\n"
printf "| %2s | %15s | %30s | %22s | %9s  |\n" "N" "Имя" "MAC адрес" "IP адрес" "Скорость"
printf "+----+--------------+---------------------------+-------------------+-----------+\n"

for (( i=0; i<${#interfaces[@]}; i++ )) do
    name=${interfaces[$i]}
    mac=$(ifconfig $name | grep -oP 'ether \K[0-9a-fA-F]{2}(:[0-9a-fA-F]{2}){5}')
    ip=$(ifconfig $name | grep -oP 'inet \K[\d\.]+')
    if [[ "$name" == "lo" ]] then
        speed=""
    else
        speed=$(speedtest-cli --simple | grep Download | awk '{print $2}')
    fi
    printf "| %2d | %12s | %25s | %17s | %9s |\n" "$(($i + 1))" "$name" "$mac" "$ip" "$speed"
    printf "+----+--------------+---------------------------+-------------------+-----------+\n"
done
