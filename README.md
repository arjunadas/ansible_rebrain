практика по курсу 
https://my.rebrainme.com/course/ansible/


- name: Remove apt lock file
  file:
    state: absent
    path: 
	  - "/var/cache/apt/archives/lock"
	  - "/var/lib/dpkg/lock-frontend"	
