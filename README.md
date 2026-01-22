Для использования этого репозитория небходимо клонировать его в папку 
```bash
cd /home/deck
git clone https://github.com/hhu67/sing-box.git
```
Вы должны положить свой json конфиг в корневую папку репозитория
Запустите convert.py
```
python3 /home/deck/convert.py
```
Создайте пароль sudo, он не будет отображаться при вводе
```bash
passwd
```
введите имя и расширение вашего конфига, и у вас появится 
config.json, далее запустите main.sh
```bash
chmod +x /home/deck/main.sh
./main.sh
```
