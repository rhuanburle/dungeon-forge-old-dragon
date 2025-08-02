# Sistema de Tabelas Refatorado

## Visão Geral

O sistema de tabelas foi completamente refatorado para ser mais organizado, escalável e fácil de manter. A nova estrutura segue um padrão consistente e permite adicionar novas tabelas de forma simples.

## Estrutura de Arquivos

```
lib/
├── enums/
│   └── table_enums.dart          # Todos os enums centralizados
├── tables/
│   ├── base_table.dart           # Classe base para todas as tabelas
│   ├── table_manager.dart        # Gerenciador centralizado
│   ├── dungeon_table.dart        # Tabela 9.1 - Geração de Masmorras
│   ├── room_table.dart           # Tabela 9.2 - Salas e Câmaras
│   ├── rumor_table.dart          # Tabela de Rumores (Colunas 13-15 da 9.1)
│   ├── occupant_table.dart       # Tabela de Ocupantes (Colunas 10-12 da 9.1)
│   └── README.md                 # Esta documentação
```

## Componentes Principais

### 1. BaseTable (base_table.dart)

Classe abstrata que define o padrão para todas as tabelas:

- **tableName**: Nome da tabela
- **description**: Descrição da tabela
- **columnCount**: Número de colunas
- **columns**: Lista de dados para cada coluna
- **getColumnValue()**: Método genérico para obter valores
- **getTableInfo()**: Informações sobre a tabela

### 2. TableWithColumnMethods

Interface que estende BaseTable e fornece métodos específicos para cada coluna:

- `getColumn1()` até `getColumn15()`
- Facilita o acesso direto às colunas
- Mantém type safety

### 3. TableManager (table_manager.dart)

Gerenciador centralizado que:

- Fornece acesso unificado a todas as tabelas
- Implementa padrão Singleton
- Facilita a adição de novas tabelas
- Fornece métodos utilitários

### 4. Enums Centralizados (table_enums.dart)

Todos os enums estão organizados em um único arquivo:

- **Tabela 9.1**: DungeonType, DungeonBuilder, DungeonStatus, etc.
- **Tabela 9.2**: RoomType, AirCurrent, Smell, Sound, etc.
- Cada enum tem uma propriedade `description` para o texto em português

## Tabelas Disponíveis

### 1. DungeonTable (Tabela 9.1)
- **Propósito**: Geração de dados básicos de masmorras
- **Colunas**: 15 colunas com tipo, construtor, status, objetivo, etc.
- **Acesso**: `tableManager.dungeonTable`

### 2. RoomTable (Tabela 9.2)
- **Propósito**: Geração de dados de salas individuais
- **Colunas**: 15 colunas com tipo, ambiente, itens, monstros, etc.
- **Acesso**: `tableManager.roomTable`

### 3. RumorTable (Colunas 13-15 da Tabela 9.1)
- **Propósito**: Geração de rumores sobre a masmorra
- **Colunas**: 3 colunas (sujeito, ação, localização)
- **Acesso**: `tableManager.rumorTable`

### 4. OccupantTable (Colunas 10-12 da Tabela 9.1)
- **Propósito**: Geração de ocupantes da masmorra
- **Colunas**: 3 colunas (ocupante I, ocupante II, líder)
- **Acesso**: `tableManager.occupantTable`

## Como Usar

### Acesso Básico

```dart
final tableManager = TableManager();

// Acessar tabela de masmorras
final dungeonTable = tableManager.dungeonTable;
final type = dungeonTable.getColumn1(roll);

// Acessar tabela de salas
final roomTable = tableManager.roomTable;
final roomType = roomTable.getColumn1(roll);

// Acessar tabela de rumores
final rumorTable = tableManager.rumorTable;
final rumorSubject = rumorTable.getColumn1(roll);

// Acessar tabela de ocupantes
final occupantTable = tableManager.occupantTable;
final occupantI = occupantTable.getColumn1(roll);
```

### Informações das Tabelas

```dart
// Informações de uma tabela específica
print(tableManager.dungeonTable.getTableInfo());

// Listar todas as tabelas
print(tableManager.getAllTablesInfo());

// Verificar se uma tabela existe
if (tableManager.hasTable('Tabela 9.1 - Geração de Masmorras')) {
  // ...
}
```

### Acesso Genérico

```dart
// Acesso genérico a qualquer coluna
final value = tableManager.dungeonTable.getColumnValue(1, roll);

// Obter todos os valores de uma coluna
final columnValues = tableManager.dungeonTable.getColumnValues(1);
```

## Como Adicionar Novas Tabelas

### 1. Criar os Enums

Adicione os enums necessários em `table_enums.dart`:

```dart
enum NovaTabelaEnum {
  valor1('Descrição 1'),
  valor2('Descrição 2'),
  // ...

  const NovaTabelaEnum(this.description);
  final String description;
}
```

### 2. Criar a Classe da Tabela

Crie uma nova classe que estenda `TableWithColumnMethods`:

```dart
class NovaTabela extends TableWithColumnMethods<dynamic> {
  @override
  String get tableName => 'Nova Tabela';
  
  @override
  String get description => 'Descrição da nova tabela';
  
  @override
  int get columnCount => 5; // Número de colunas
  
  @override
  List<List<dynamic>> get columns => [
    _column1,
    _column2,
    // ...
  ];

  // Definir as colunas
  static const List<NovaTabelaEnum> _column1 = [
    NovaTabelaEnum.valor1,
    NovaTabelaEnum.valor2,
    // ...
  ];

  // Métodos específicos com tipos corretos
  @override
  NovaTabelaEnum getColumn1(int roll) => super.getColumn1(roll) as NovaTabelaEnum;
}
```

### 3. Adicionar ao TableManager

Atualize o `TableManager` para incluir a nova tabela:

```dart
class TableManager {
  // Adicionar instância
  final NovaTabela _novaTabela = NovaTabela();
  
  // Adicionar getter
  NovaTabela get novaTabela => _novaTabela;
  
  // Atualizar allTables
  List<BaseTable> get allTables => [
    _dungeonTable,
    _roomTable,
    _rumorTable,
    _occupantTable,
    _novaTabela, // Adicionar aqui
  ];
}
```

## Vantagens da Nova Estrutura

### 1. **Organização**
- ✅ Todos os enums em um local centralizado
- ✅ Estrutura de arquivos clara e consistente
- ✅ Separação entre lógica de tabelas e enums
- ✅ **Consolidação**: Uma única pasta `tables/` em vez de duas

### 2. **Escalabilidade**
- ✅ Fácil adição de novas tabelas
- ✅ Padrão consistente para todas as tabelas
- ✅ Gerenciador centralizado

### 3. **Manutenibilidade**
- ✅ Código mais limpo e organizado
- ✅ Menos duplicação de código
- ✅ Type safety melhorado
- ✅ Documentação clara

### 4. **Flexibilidade**
- ✅ Acesso genérico e específico às colunas
- ✅ Métodos utilitários centralizados
- ✅ Fácil extensão de funcionalidades

### 5. **Consistência**
- ✅ Padrão uniforme para todas as tabelas
- ✅ Nomenclatura consistente
- ✅ Estrutura previsível

## Migração

A migração foi feita de forma que:

1. **Enums antigos** foram movidos para `table_enums.dart`
2. **Tabelas antigas** foram refatoradas para usar o novo padrão
3. **Serviços** foram atualizados para usar o `TableManager`
4. **Compatibilidade** foi mantida com o código existente
5. **Consolidação** de todas as tabelas em uma única pasta `lib/tables/`

## Próximos Passos

Para adicionar novas tabelas no futuro:

1. Adicionar enums em `table_enums.dart`
2. Criar classe da tabela seguindo o padrão
3. Adicionar ao `TableManager`
4. Atualizar serviços se necessário

Esta estrutura torna o sistema muito mais organizado e preparado para futuras expansões! 