import subprocess
import psutil
import time
import csv
from datetime import datetime
import os

# COMANDO EJECUCION: python3 medir_despliegue.py

CSV_FILE = "resultados_despliegue.csv"
ITERACIONES = 10
PLAYBOOK_COMMAND = [
    "sudo", "ANSIBLE_ROLES_PATH=ansible/roles", "ansible-playbook",
    "ansible/playbooks/deploy_diinf.yml", "-i", "ansible/inventory/hosts.ini"
]

def ejecutar_comando(comando, mostrar_output=True):
    print(f"\nEjecutando: {' '.join(comando)}")
    proceso = subprocess.Popen(" ".join(comando), shell=True)
    proceso.communicate()
    if proceso.returncode != 0:
        print(f"Error al ejecutar: {' '.join(comando)}")
    return proceso.returncode

def limpiar_entorno():
    print("Limpiando entorno completamente para una iteración limpia...")
    ejecutar_comando(["sudo", "docker-compose", "down", "--volumes", "--remove-orphans"])
    ejecutar_comando(["sudo", "docker", "image", "prune", "-af"])
    ejecutar_comando(["sudo", "docker", "volume", "prune", "-f"])
    ejecutar_comando(["sudo", "docker", "network", "prune", "-f"])
    ejecutar_comando(["sudo", "rm", "-f", "/etc/nginx/sites-enabled/interaction-site.conf"])
    ejecutar_comando(["sudo", "unlink", "/etc/nginx/sites-enabled/interaction-site.conf"])
    ejecutar_comando(["sudo", "systemctl", "restart", "nginx"])

def medir_recursos_y_tiempo():
    print("Midiendo recursos durante el despliegue...")
    inicio = time.time()
    proceso = subprocess.Popen(" ".join(PLAYBOOK_COMMAND), shell=True)
    
    uso_cpu_total = 0.0
    memoria_max = 0.0
    uso_disco_inicio = psutil.disk_usage('/').used
    
    while proceso.poll() is None:
        uso_cpu_total += psutil.cpu_percent(interval=1)
        memoria = psutil.virtual_memory().used / (1024 ** 2)  # MB
        if memoria > memoria_max:
            memoria_max = memoria

    tiempo_total = time.time() - inicio
    uso_disco_fin = psutil.disk_usage('/').used
    diferencia_disco = (uso_disco_fin - uso_disco_inicio) / (1024 ** 2)

    return round(tiempo_total, 2), round(uso_cpu_total, 2), round(memoria_max, 2), round(diferencia_disco, 2)

def main():
    campos = ["Iteración", "Tiempo (s)", "CPU Total (%)", "Memoria Max (MB)", "Uso Disco (MB)"]
    if not os.path.exists(CSV_FILE):
        with open(CSV_FILE, mode='w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(campos)

    print("\nPreparando entorno limpio antes de comenzar las iteraciones...")
    limpiar_entorno()
    
    for i in range(1, ITERACIONES + 1):
        print(f"\n======================= ITERACIÓN {i} =======================")
        tiempo, cpu, ram, disco = medir_recursos_y_tiempo()

        with open(CSV_FILE, mode='a', newline='') as file:
            writer = csv.writer(file)
            writer.writerow([i, tiempo, cpu, ram, disco])

        print("\nContenedores activos tras el despliegue:")
        ejecutar_comando(["sudo", "docker", "ps"])

        if i < ITERACIONES:
            limpiar_entorno()
        else:
            print("Última iteración completada. El entorno queda desplegado.")

    print("\nResultados guardados en:", CSV_FILE)

if __name__ == "__main__":
    main()
