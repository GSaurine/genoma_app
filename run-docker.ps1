# =========================================
# Script PowerShell para executar Docker
# Genoma App - Executar toda a aplicação
# =========================================

Write-Host " Iniciando Genoma App com Docker..." -ForegroundColor Cyan

# Verificar se Docker está instalado
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker não está instalado! Por favor, instale o Docker Desktop." -ForegroundColor Red
    exit 1
}

# Verificar se Docker Compose está disponível
if (!(Get-Command docker-compose -ErrorAction SilentlyContinue) -and !(docker compose version 2>$null)) {
    Write-Host "Docker Compose não está disponível!" -ForegroundColor Red
    exit 1
}

# Criar arquivo .env se não existir
if (!(Test-Path .env)) {
    if (Test-Path DOCKER_ENV_TEMPLATE.txt) {
        Copy-Item DOCKER_ENV_TEMPLATE.txt .env
        Write-Host " Arquivo .env criado a partir do template." -ForegroundColor Green
    } else {
        Write-Host " Arquivo .env não encontrado. Usando valores padrão." -ForegroundColor Yellow
    }
}

# Menu de opções
Write-Host ""
Write-Host " Opções disponíveis:" -ForegroundColor Cyan
Write-Host "  1. Iniciar todos os containers (MySQL + Backend + Frontend)"
Write-Host "  2. Iniciar apenas o MySQL"
Write-Host "  3. Iniciar apenas o Backend"
Write-Host "  4. Iniciar apenas o Frontend"
Write-Host "  5. Parar todos os containers"
Write-Host "  6. Ver logs dos containers"
Write-Host "  7. Reconstruir containers"
Write-Host "  8. Limpar containers e volumes (Reset completo)"
Write-Host "  0. Sair"
Write-Host ""

$opcao = Read-Host "Digite a opção desejada"

switch ($opcao) {
    "1" {
        Write-Host " Iniciando todos os containers..." -ForegroundColor Yellow
        docker-compose up -d
        Write-Host " Containers iniciados!" -ForegroundColor Green
        Write-Host ""
        Write-Host " Acessos:" -ForegroundColor Cyan
        Write-Host "   Frontend: http://localhost:8080" -ForegroundColor White
        Write-Host "   Backend API: http://localhost:3000" -ForegroundColor White
        Write-Host "   MySQL: localhost:3306" -ForegroundColor White
    }
    "2" {
        Write-Host " Iniciando MySQL..." -ForegroundColor Yellow
        docker-compose up -d mysql
        Write-Host " MySQL iniciado na porta 3306" -ForegroundColor Green
    }
    "3" {
        Write-Host " Iniciando Backend..." -ForegroundColor Yellow
        docker-compose up -d backend
        Write-Host " Backend iniciado na porta 3000" -ForegroundColor Green
    }
    "4" {
        Write-Host " Iniciando Frontend..." -ForegroundColor Yellow
        docker-compose up -d frontend
        Write-Host " Frontend iniciado na porta 8080" -ForegroundColor Green
    }
    "5" {
        Write-Host " Parando todos os containers..." -ForegroundColor Yellow
        docker-compose down
        Write-Host " Containers parados." -ForegroundColor Green
    }
    "6" {
        Write-Host " Logs dos containers (Ctrl+C para sair):" -ForegroundColor Yellow
        docker-compose logs -f
    }
    "7" {
        Write-Host " Reconstruindo containers..." -ForegroundColor Yellow
        docker-compose down
        docker-compose build --no-cache
        docker-compose up -d
        Write-Host " Containers reconstruídos!" -ForegroundColor Green
    }
    "8" {
        Write-Host " ATENÇÃO: Isso vai apagar TODOS os dados!" -ForegroundColor Red
        $confirm = Read-Host "Digite 'SIM' para confirmar"
        if ($confirm -eq "SIM") {
            docker-compose down -v
            docker system prune -f
            Write-Host " Containers e volumes removidos." -ForegroundColor Green
        } else {
            Write-Host " Operação cancelada." -ForegroundColor Yellow
        }
    }
    "0" {
        Write-Host " Até logo!" -ForegroundColor Cyan
        exit 0
    }
    Default {
        Write-Host "Opção inválida!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")