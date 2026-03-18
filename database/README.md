# Database Dump — Eon Pro API

Dump do banco de dados de produção (`iaeon_db` no PostgreSQL).

## Conteúdo

| Tabela | Dados incluídos |
|--------|----------------|
| `Bot` | ✅ Dados completos |
| `Plan` | ✅ Dados completos |
| `PlanBot` | ✅ Dados completos |
| `Setting` | ✅ Dados completos |
| `Subscription` | ✅ Dados completos |
| `CourseLesson` | ✅ Dados completos |
| `CourseModule` | ✅ Dados completos |
| `User` | ⚠️ Apenas schema (sem dados — senhas omitidas) |
| `SmtpConfig` | ⚠️ Apenas schema (sem dados — credenciais omitidas) |
| `WebhookLog` | ⚠️ Apenas schema (sem dados — logs omitidos) |

## Restaurar banco de dados

```bash
# 1. Criar o banco se não existir
psql -U postgres -c "CREATE DATABASE iaeon_db;"
psql -U postgres -c "CREATE USER iaeon WITH PASSWORD 'sua_senha';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE iaeon_db TO iaeon;"

# 2. Restaurar o dump
PGPASSWORD='sua_senha' psql -U iaeon -h 127.0.0.1 -d iaeon_db < database/eonpro-db-dump.sql
```

## Gerar novo dump de produção

```bash
PGPASSWORD='senha' pg_dump -U iaeon -h 127.0.0.1 -d iaeon_db \
  --no-owner --no-privileges \
  --exclude-table-data='"User"' \
  --exclude-table-data='"SmtpConfig"' \
  --exclude-table-data='"WebhookLog"' \
  > database/eonpro-db-dump.sql
```
