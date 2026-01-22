sudo bash -c '
# 1. Убеждаемся, что папка для правил sudo существует
mkdir -p /etc/sudoers.d/

# 2. Создаем файл службы
cat <<EOF > /etc/systemd/system/sing-box.service
[Unit]
Description=Sing-box VPN Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/home/deck/sing-box/sing-box run -c /home/deck/sing-box/config.json
Restart=always
RestartSec=5
User=root
WorkingDirectory=/home/deck/sing-box

[Install]
WantedBy=multi-user.target
EOF

# 3. Создаем правило NOPASSWD (чтобы не просил пароль)
# Прописываем путь к systemctl и pkill для надежности
echo "deck ALL=(ALL) NOPASSWD: /usr/bin/systemctl start sing-box, /usr/bin/systemctl stop sing-box, /usr/bin/systemctl restart sing-box, /usr/bin/systemctl status sing-box, /usr/bin/pkill -9 sing-box" > /etc/sudoers.d/singbox-rules

# 4. Выставляем правильные права на файл правил (важно, иначе sudo сломается)
chmod 440 /etc/sudoers.d/singbox-rules

# 5. Перезапуск системы сервисов
systemctl daemon-reload
systemctl enable sing-box
systemctl restart sing-box

# 6. Создаем скрипты на рабочем столе
cd /home/deck/Desktop/
echo -e "#!/bin/bash\nsudo systemctl start sing-box\nnotify-send \"VPN\" \"Sing-box ЗАПУЩЕН\"" > VPN_ON.sh
echo -e "#!/bin/bash\nsudo systemctl stop sing-box\nnotify-send \"VPN\" \"Sing-box ОСТАНОВЛЕН\"" > VPN_OFF.sh

# 7. Делаем их исполняемыми
chmod +x VPN_ON.sh VPN_OFF.sh

echo "-------------------------------------------------------"
echo "СИСТЕМА ПОДГОТОВЛЕНА!"
echo "1. Правила sudoers.d созданы (пароль больше не нужен)."
echo "2. Сервис sing-box добавлен в автозапуск."
echo "3. Ярлыки на рабочем столе готовы."
echo "-------------------------------------------------------"
'
