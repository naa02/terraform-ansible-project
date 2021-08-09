# terraform-ansible-project
### Ansible playbook을 통해 wordpress와 mysql 배포 후 Terraform을 통해 AWS EC2에 적용 + RDS
---
- Linux (Debian/RedHat)환경
- Ansible, AWS CLlv2, Terraform 설치 후 진행
- Terraform의 local-exec provisioner를 통해 local의 Ansible과 연동
- SSH 키 인증 연결 필요

    ```jsx
    # 키 생성 방법
    ssh-keygen -f my_sshkey -N ''
    ```

- AWS instance 접속 방법

    ```jsx
    ssh -i my_sshkey ubuntu@[public_ip]
    ```
---

# EC2-Wordpress_with_mysql

### Wordpress, Mysql: aws_instance.my_instance (1개의 EC2)

- AWS 서울 리전의 Ubuntu Server 18.04 LTS 버전의 AMI 이미지 사용
- instance_type: t3.micro (variable.tf에 변수로 지정)
- [security-group.tf](http://security-group.tf) : ssh-22번 포트, Wordpress service-8080번 포트 열어주는 보안 그룹 리소스 정의

### 실행 방법

```jsx
git clone https://github.com/naa02/terraform-ansible-project.git
cd EC2-Wordpress_with_mysql

# terraform 초기화
terraform init

# 유효성 검사
terraform validate

# 실행
terraform apply -auto-approve

# 삭제
terraform destroy
```

### 접속 방법

```jsx
https://[ public_ip ]:8080/wordpress로 접속
```

### 구성

```jsx
── EC2-Wordpress_with_RDS
│   ├── group_vars
│   │   └── all.yaml
│   ├── inventory.ini
│   ├── local.tf
│   ├── main.tf
│   ├── my_sshkey
│   ├── my_sshkey.pub
│   ├── output.tf
│   ├── provider.tf
│   ├── remove.yaml
│   ├── roles
│   │   └── WP
│   │       ├── handlers
│   │       │   └── main
│   │       ├── tasks
│   │       │   ├── Debian
│   │       │   │   └── WP_Debian.yaml
│   │       │   ├── RedHat
│   │       │   │   └── WP_RedHat.yaml
│   │       │   └── main.yaml
│   │       ├── templates
│   │       │   ├── httpd.conf.j2
│   │       │   ├── ports.conf.j2
│   │       │   └── wp-config.php.j2
│   │       └── vars
│   │           └── main.yaml
│   ├── security-group.tf
│   ├── site.yaml
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── variable.tf
```

---

# EC2-Wordpress_with_RDS

### Wordpress: aws_instance.my_instance (EC2)

### Database: aws_db_instance.my_db_instance (RDS)
---

- AWS 서울 리전의 Ubuntu Server 18.04 LTS 버전의 AMI 이미지 사용
- instance_type: t3.micro (variable.tf에 변수로 지정)
- [security-group.tf](http://security-group.tf) : ssh-22번 포트, Wordpress service-8080번 포트, RDS-3306번 포트 열어주는 보안 그룹 리소스 정의
- group_vars/all.yaml에서 RDS의 데이터베이스, 사용자, 암호, host를 변수화해서 roles의 vars/main.yaml에서 이를 참조

### 실행 방법

```jsx
git clone https://github.com/naa02/terraform-ansible-project.git
cd EC2-Wordpress_with_RDS

# terraform 초기화
terraform init

# 유효성 검사
terraform validate

# 실행
terraform apply -auto-approve
```

### 접속 방법

```jsx
https://[ public_ip ]:8080/wordpress로 접속
```

### 구성

```jsx
└── EC2-Wordpress_with_mysql
    ├── group_vars
    │   └── all.yaml
    ├── inventory.ini
    ├── local.tf
    ├── main.tf
    ├── my_sshkey
    ├── my_sshkey.pub
    ├── output.tf
    ├── provider.tf
    ├── remove.yaml
    ├── roles
    │   ├── DB
    │   │   ├── handlers
    │   │   │   └── main.yaml
    │   │   ├── tasks
    │   │   │   ├── Debian
    │   │   │   │   └── DB_Debian.yaml
    │   │   │   ├── RedHat
    │   │   │   │   └── DB_RedHat.yaml
    │   │   │   └── main.yaml
    │   │   ├── templates
    │   │   │   └── mysqld.cnf.j2
    │   │   └── vars
    │   │       └── main.yaml
    │   └── WP
    │       ├── handlers
    │       │   └── main
    │       ├── tasks
    │       │   ├── Debian
    │       │   │   └── WP_Debian.yaml
    │       │   ├── RedHat
    │       │   │   └── WP_RedHat.yaml
    │       │   └── main.yaml
    │       ├── templates
    │       │   ├── httpd.conf.j2
    │       │   ├── ports.conf.j2
    │       │   └── wp-config.php.j2
    │       └── vars
    │           └── main.yaml
    ├── security-group.tf
    ├── site.yaml
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variable.tf
```
