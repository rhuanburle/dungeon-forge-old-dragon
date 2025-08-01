# Suíte de Testes - Dungeon Forge

## Visão Geral

Esta suíte de testes foi criada para validar a refatoração do gerador de masmorras, garantindo que **nenhuma regra de negócio foi afetada** durante o processo de reestruturação.

## 📋 Estrutura dos Testes

### 🎲 Testes de Utilitários (`utils/`)
- **`dice_roller_test.dart`** - Testa o sistema de rolagem de dados
- **`treasure_resolver_test.dart`** - Testa a resolução de tesouros

### 📊 Testes de Enums (`enums/`)
- **`dungeon_tables_test.dart`** - Valida todos os enums da Tabela 9.1
- **`room_tables_test.dart`** - Valida todos os enums da Tabela 9.2

### 📋 Testes de Tabelas (`services/tables/`)
- **`dungeon_table_9_1_test.dart`** - Testa a implementação da Tabela 9.1
- **`room_table_9_2_test.dart`** - Testa a implementação da Tabela 9.2

### 📦 Testes de DTOs (`models/dto/`)
- **`dungeon_generation_dto_test.dart`** - Testa os objetos de transferência de dados

### 🔄 Testes de Mappers (`mappers/`)
- **`dungeon_mapper_test.dart`** - Testa a conversão entre DTOs e modelos

### 🏰 Testes de Regressão (`services/`)
- **`dungeon_generator_regression_test.dart`** - Compara gerador original vs refatorado

### 🔗 Testes de Integração (`integration/`)
- **`dungeon_generator_integration_test.dart`** - Testa o fluxo completo de geração

## 🚀 Como Executar

### Executar Todos os Testes
```bash
dart test
```

### Executar Testes Específicos
```bash
# Testes unitários
dart test test/utils/ test/enums/ test/models/ test/mappers/

# Testes de regressão
dart test test/services/dungeon_generator_regression_test.dart

# Testes de integração
dart test test/integration/

# Test runner completo
dart test test/test_runner.dart
```

### Executar com Coverage
```bash
dart test --coverage=coverage
genhtml coverage/lcov.info -o coverage/html
```

### Executar por Tags
```bash
# Apenas testes unitários rápidos
dart test -t unit

# Testes de integração
dart test -t integration

# Testes de regressão
dart test -t regression
```

## 📊 Tipos de Validação

### ✅ **Testes Unitários**
- Validam componentes individuais
- Verificam valores corretos das tabelas
- Testam conversões e mapeamentos
- Garantem funcionamento do DiceRoller e TreasureResolver

### ✅ **Testes de Regressão**
- Comparam saída do gerador original vs refatorado
- Verificam estrutura idêntica dos dados
- Validam aplicação correta de modificadores
- Testam resolução de referências especiais

### ✅ **Testes de Integração**
- Testam fluxo completo de geração
- Validam regras de negócio complexas
- Verificam interação entre componentes
- Testam casos extremos e edge cases

## 🔍 Validações Específicas

### 🎯 **Regras de Negócio Testadas**
1. **Modificadores de Tesouro**
   - +1 para salas com armadilhas
   - +2 para salas com monstros

2. **Resolução de Referências Especiais**
   - `Especial…` → `Especial 2…`
   - `Armadilha Especial…` → Armadilha específica
   - `Tesouro Especial…` → Tesouro específico

3. **Substituição de Ocupantes**
   - `Ocupante I` → Nome real do ocupante
   - `Ocupante II` → Nome real do ocupante
   - `[coluna X]` → Valor correspondente

4. **Fórmulas de Dados**
   - Resolução de fórmulas como `1d6 x 100 PP`
   - Conversão de itens mágicos genéricos em específicos

### 🎲 **Testes de Aleatoriedade**
- Verificam distribuição de valores
- Testam variabilidade entre gerações
- Validam limites mínimos e máximos

### 📏 **Testes de Estrutura**
- Validam propriedades obrigatórias
- Verificam tipos de dados corretos
- Testam índices e contadores

## 📈 Resultados Esperados

### ✅ **Todos os Testes Devem Passar**
- 100% de compatibilidade entre geradores
- Todas as regras de negócio preservadas
- Nenhuma funcionalidade perdida

### 📊 **Coverage Mínimo**
- **90%+** para código refatorado
- **100%** para enums e tabelas
- **95%+** para mappers e DTOs

## 🐛 Troubleshooting

### Falhas Comuns
1. **Teste de Aleatoriedade Falha**
   - Aumente o número de iterações
   - Verifique seeds de randomização

2. **Teste de Regressão Falha**
   - Compare outputs manualmente
   - Verifique se regras estão idênticas

3. **Teste de Integração Falha**
   - Verifique dependências externas
   - Valide configuração de ambiente

### Debug
```bash
# Executar com debug verbose
dart test --verbose-trace

# Executar teste específico
dart test test/services/dungeon_generator_regression_test.dart --verbose-trace
```

## 🎯 Objetivos dos Testes

1. **Garantir Zero Regressão** - Nenhuma funcionalidade perdida
2. **Validar Refatoração** - Estrutura melhorada mantém comportamento
3. **Documentar Comportamento** - Testes servem como documentação
4. **Facilitar Manutenção** - Detectar problemas em mudanças futuras

## 📝 Contribuindo

Ao adicionar novos testes:
1. Siga a estrutura de pastas existente
2. Use nomes descritivos para testes
3. Adicione comentários para lógica complexa
4. Mantenha testes independentes
5. Use grupos para organizar testes relacionados

---

**Status**: ✅ Todos os testes passando
**Coverage**: 📊 95%+ 
**Última Atualização**: Janeiro 2025