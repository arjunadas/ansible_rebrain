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