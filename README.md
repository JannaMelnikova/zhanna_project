Требование по запуску

1. На всех серверах должен быть доступ по SSH
2. На всех серверах должен быть один пользователь с одинаковым паролем и правами SUDO
3. Необходимые хосты прописать в /inventories/hosts 
4. Запустить ./start.sh для первоначальной настройки всех серверов. ( туда включено копирование id_key.pub, установка docker, python и т.д. для работы Ansible)

Настройка app - серверов:
ansible-playbook playbook.yml -b -K --extra-vars "USER=$USER"  -i ./inventories --tags="app"

Настройка web - сервера:
ansible-playbook playbook.yml -b -K --extra-vars "USER=$USER"  -i ./inventories --tags="web"


Настройка всего:
ansible-playbook playbook.yml -b -K --extra-vars "USER=$USER"  -i ./inventories --tags="all"
