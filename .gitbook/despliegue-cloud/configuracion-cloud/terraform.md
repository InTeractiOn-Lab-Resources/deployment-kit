# Terraform

Terraform es una herramienta de **infraestructura como código** (IaC) que permite definir y aprovisionar recursos en la nube de forma automatizada. En este contexto, se utiliza para **crear una infraestructura básica de bajo costo**, que incluye una instancia (Droplet o EC2) con una configuración mínima para ejecutar tu aplicación.

{% hint style="danger" %}
Puedes añadir recursos adicionales como volúmenes separados, direcciones IP elásticas u otros servicios específicos del proveedor.

Sin embargo, esto generará **costos adicionales** y **no ha sido validado con las plantillas actuales**, así que queda a tu criterio integrarlos correctamente si decides hacerlo.
{% endhint %}

## DigitalOcean

<details>

<summary>Definir Droplet</summary>

En el archivo `main.tf` se definen las características principales del Droplet. Por defecto, se utiliza la siguiente configuración básica:

```hcl
resource "digitalocean_droplet" "app" {
  name   = "app"
  region = "nyc3"                      # New York 3
  size   = "s-1vcpu-1gb"               # 1 vCPU, 1GB RAM.
  image  = "ubuntu-22-04-x64"          # Ubuntu 22.04 LTS
  ssh_keys = [var.inline_public_key]

  tags = ["app-droplet"]
}
```

Puedes ajustar la configuración del Droplet según tus necesidades. A continuación, se muestran los campos más comunes que puedes modificar:

#### Cambiar nombre y etiquetas

```hcl
name = "nombre-de-tu-app"
tags = ["nombre-de-tu-app"]
```

#### Cambiar región del datacenter

Puedes ajustar la configuración de la instancia según las necesidades de tu proyecto. A continuación se muestran los campos más comunes que puedes modificar:

```hcl
region = "region-de-tu-preferencia"
```

#### Cambiar la imagen del sistema operativo

Por defecto se usa Ubuntu 22.04, pero puedes seleccionar otra versión si tu aplicación lo requiere, por ejemplo una versión anterior:

```hcl
image = "ubuntu-20-04-x64" # Ubuntu 20.04 LTS
```

#### Ajustar recursos del Droplet

Si el tamaño por defecto (1 vCPU, 1GB RAM) no es suficiente para tu aplicación o necesitas más rendimiento, puedes modificarlo así:

```hcl
size = "s-2vcpu-4gb"       # 2 vCPU, 4 GB RAM
size = "g-4vcpu-16gb"      # 4 vCPU, 16 GB RAM
```

{% hint style="info" %}
Consulta la documentación de [planes de Droplet de DigitalOcean](https://docs.digitalocean.com/products/droplets/details/features/#gpu-droplets) para ver todos los tamaños disponibles.
{% endhint %}

</details>

<details>

<summary>Definir firewall</summary>

En el archivo `main.tf` se define la configuración de seguridad de red del Droplet mediante un recurso de tipo `digitalocean_firewall`.

Por defecto, se aplica un firewall básico que **abre los puertos 22 (SSH), 80 (HTTP) y 443 (HTTPS)** para permitir conexión remota y tráfico web básico.

{% hint style="warning" %}
#### Seguridad y puerto SSH

El **puerto 22 (SSH)** se deja abierto por defecto para que **GitHub Actions** pueda conectarse al Droplet durante el proceso de despliegue.

Una vez finalizado el despliegue, se recomienda **eliminar o restringir** esta regla si no planeas seguir usando GitHub Actions. Tener el puerto SSH abierto permanentemente puede exponer tu servidor a accesos no autorizados.
{% endhint %}

#### Cambiar nombre del firewall

```hcl
name = "nombre-de-tu-firewall"
```

#### Ajustar reglas de entrada (no recomendado)

Puedes personalizar las reglas según los servicios que tu aplicación necesite.\
Por ejemplo, para abrir el puerto 3000:

```hcl
inbound_rule {
  protocol         = "tcp"
  port_range       = "3000"
  source_addresses = ["0.0.0.0/0"]
}
```

{% hint style="danger" %}
**No es necesario ni recomendable modificar las reglas por defecto**, ya que cubren la mayoría de los escenarios de despliegue.

**En especial, no alteres las reglas de salida**, ya que podrías dejar el Droplet sin acceso a internet y afectar el funcionamiento del despliegue y de la aplicación.
{% endhint %}

</details>

## AWS

<details>

<summary>Definir EC2</summary>

En el archivo `main.tf` se define la configuración principal de la instancia EC2 que se va a crear. Por defecto, se utiliza la siguiente configuración básica:

```hcl
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app-instance"
  }
}
```

Puedes ajustar la configuración de la instancia según las necesidades de tu proyecto. A continuación se muestran los campos más comunes que puedes modificar:

#### Cambiar nombre de la instancia

```hcl
tags = {
  Name = "nombre-de-tu-instancia"
}
```

#### Cambiar la región

Para cambiar la región, debes modificar el archivo de variables `variables.tf`y modificar la siguiente sección:

```hcl
variable "aws_region" {
  default = "us-east-1"
}
```

#### Cambiar la AMI (sistema operativo)

Por defecto se usa Ubuntu 22.04 LTS elegible para capa gratuita (`ami-053b0d53c279acc90`). Para modificar esto, debes ir al archivo de variables `variables.tf` :

```hcl
variable "ami_id" {
  default = "ami-id-de-tu-preferencia"
}
```

#### Cambiar el tipo de instancia

Por defecto se utiliza `t2.micro` (gratuita en Free Tier). Si necesitas más rendimiento, puedes cambiar el tipo de instancia en el archivo de variables `variables.tf`:

```hcl
variable "instance_type" {
  default = "t3.small"
}
```

{% hint style="info" %}
Consulta [esta tabla de tipos de instancia](https://aws.amazon.com/es/ec2/instance-types/) para elegir una adecuada a tu aplicación.
{% endhint %}

</details>

<details>

<summary>Definir grupo de seguridad</summary>

En el archivo `main.tf` se define un grupo de seguridad `aws_security_group`, que controla las conexiones entrantes y salientes de tu instancia.

Por defecto, se aplica un grupo de seguridad básico que **abre los puertos 22 (SSH), 80 (HTTP) y 443 (HTTPS)** para permitir conexión remota y tráfico web básico.

{% hint style="warning" %}
#### Seguridad y puerto SSH

El **puerto 22 (SSH)** se deja abierto por defecto para que **GitHub Actions** pueda conectarse a la instancia EC2 durante el proceso de despliegue.

Una vez finalizado el despliegue, se recomienda **eliminar o restringir** esta regla si no planeas seguir usando GitHub Actions. Tener el puerto SSH abierto permanentemente puede exponer tu servidor a accesos no autorizados.
{% endhint %}

#### Cambiar nombre del grupo de seguridad

```hcl
name = "nombre-de-tu-security-group"
```

#### Ajustar reglas de entradas (no recomendado)

Puedes personalizar las reglas según los servicios que tu aplicación necesite.\
Por ejemplo, para abrir el puerto 3000:

```hcl
ingress {
    from_port = 3000
    to_port   = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
```

{% hint style="danger" %}
**No es necesario ni recomendable modificar las reglas por defecto**, ya que cubren la mayoría de los escenarios de despliegue.

**En especial, no alteres las reglas de salida**, ya que podrías dejar la instancia EC2 sin acceso a internet y afectar el funcionamiento del despliegue y de la aplicación.
{% endhint %}

</details>
