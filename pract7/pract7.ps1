
cd /home/user/task
git clone https://gitlab.rebrainme.com/workshops/devopsv2/ansible-tasks-repos/DVPS-ANS-07.git


before:
user@ansiblejinja2-yqbfd:~/task/DVPS-ANS-07$ md5sum /home/user/task/DVPS-ANS-07/products.yaml
fdef9d90e60a37ffb769fb8161e4e0d8  products.yaml


after:
fdef9d90e60a37ffb769fb8161e4e0d8  /home/user/task/DVPS-ANS-07/products.yaml


nano /home/user/task/inventory.yaml

all:
  hosts:
    web01: #Ubuntu
      ansible_host: 10.131.0.16

  vars:
    ansible_user: user
    ansible_password: hgtaijp

  children:
    webservers:
      hosts:
        web01
    dbservers:
      hosts:
        db01
		
		
nano /home/user/task/site.yaml

- hosts: web01
  become: true

  vars:
  vars_files:
    - /home/user/task/DVPS-ANS-07/products.yaml
  tasks:
  - name: Update apt and Install nginx
    ansible.builtin.apt:
      pkg:
      - apt
      - nginx
      state: latest
      update_cache: yes

  - name: Start and enable nginx service
    service:
      name: nginx
      state: started
      enabled: yes

  - name: Copy Nginx configuration file
    ansible.builtin.template:
      src: /home/user/task/DVPS-ANS-07/nginx.conf
      dest: /etc/nginx/nginx.conf
      mode: '0644'
    notify:
     - nginx reload                        # Вызов обработчика

  - name: Remove files default and index.nginx-debian.html
    ansible.builtin.file:
      path: '{{ item.src }}'
      state: absent
    loop:
      - { src: /etc/nginx/sites-enabled/default }
      - { src: /var/www/html/index.nginx-debian.html }
    notify:
     - nginx reload

  - name: Copy site.conf.j2
    ansible.builtin.template:
      src: /home/user/task/DVPS-ANS-07/site.conf.j2
      dest: /etc/nginx/sites-available/site.conf
      mode: '0644'

  - name: Create a symbolic link
    ansible.builtin.file:
      src: /etc/nginx/sites-available/site.conf
      dest: /etc/nginx/sites-enabled/site.conf
      state: link
    notify:
     - nginx reload

  - name: "create static pages"
    ansible.builtin.template:
      src: /home/user/task/static.j2
      dest: /var/www/html/{{ item.name | lower }}.html
    with_items: "{{ products }}"

  - name: "create index page"
    ansible.builtin.template:
      src: /home/user/task/index.j2
      dest: /var/www/html/index.html
    with_items: "{{ products }}"

  handlers:                               # Обработчик, который указывает веб-серверу перечитать конфигурацию
    - name: nginx reload
      service:
        name: nginx
        state: reloaded

	  

###

###
nano /home/user/task/index.j2

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .product-list {
            list-style-type: none;
            padding: 0;
        }
        .product-list li {
            margin: 10px 0;
        }
        .product-list a {
            text-decoration: none;
            color: #007BFF;
        }
        .product-list a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Product List</h1>
    <ul class="product-list">
	            {% for item in products | sort(attribute='name') %}
                <li><a href="{{ item.name | lower }}.html">{{ item.name | capitalize }}</a></li>
				{% endfor %}
            </ul>
</body>
</html>

###
nano /home/user/task/static.j2

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Карточка товара</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            max-width: 300px;
            padding: 20px;
            text-align: center;
        }
        .card h2 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .card p {
            color: #666;
            font-size: 14px;
            margin: 5px 0;
        }
        .card .price {
            font-size: 20px;
            color: #333;
            margin: 10px 0;
        }
        .card .features {
            text-align: left;
            margin-top: 10px;
        }
        .card .features li {
            margin-bottom: 5px;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            margin-top: 15px;
            border-radius: 5px;
            font-size: 16px;
        }
        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<div class="card">
    <h2>{{ item.name | upper }} </h2>
    <p class="price">{{ item.price }} {{ item.currency }}</p>
    <p>Serving {{ item.serving }} {{ item.measure }}</p>
    <p>Description: {{ item.description }} </p>
    <a href="index.html" class="button">Back</a>
</div>

</body>
</html>

<#
ответ ментора:
 вот такая строчка должна быть
 
 products: "{{ lookup('file', '/home/user/task/DVPS-ANS-07/products.yaml') | from_yaml }}"

 Мы просто считываете файл как строку, а не как yaml структуру
#>