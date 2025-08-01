# Refatoração do Gerador de Masmorras

## Visão Geral

Este documento descreve a refatoração do gerador de masmorras para uma estrutura mais profissional e organizada, mantendo todas as regras de negócio originais.

## Estrutura Refatorada

### 1. Enums (`lib/enums/`)

#### `dungeon_tables.dart`
Contém todos os enums para a Tabela 9.1 (Gerando Masmorras):
- `DungeonType` - Tipos de masmorra
- `DungeonBuilder` - Construtores/habitantes
- `DungeonStatus` - Status da masmorra
- `DungeonObjective` - Objetivos da construção
- `DungeonTarget` - O que está sendo protegido
- `DungeonTargetStatus` - Estado do alvo
- `DungeonLocation` - Localização
- `DungeonEntry` - Entrada da masmorra
- `DungeonSize` - Tamanho da masmorra
- `DungeonOccupant` - Ocupantes
- `RumorSubject`, `RumorAction`, `RumorLocation` - Componentes do rumor

#### `room_tables.dart`
Contém todos os enums para a Tabela 9.2 (Salas e Câmaras):
- `RoomType` - Tipos de sala
- `AirCurrent` - Correntes de ar
- `Smell` - Odores
- `Sound` - Sons
- `FoundItem` - Itens encontrados
- `SpecialItem` - Itens especiais
- `CommonRoom` - Salas comuns
- `SpecialRoom` - Salas especiais
- `SpecialRoom2` - Salas especiais 2
- `Monster` - Monstros
- `Trap` - Armadilhas
- `SpecialTrap` - Armadilhas especiais
- `Treasure` - Tesouros
- `SpecialTreasure` - Tesouros especiais
- `MagicItem` - Itens mágicos

### 2. DTOs (`lib/models/dto/`)

#### `dungeon_generation_dto.dart`
- `DungeonGenerationDto` - Representa todos os dados de geração de uma masmorra
- `RoomGenerationDto` - Representa todos os dados de geração de uma sala
- `TreasureDto` - Representa dados de tesouro

### 3. Tabelas (`lib/services/tables/`)

#### `dungeon_table_9_1.dart`
Classe estática que contém todas as tabelas da Tabela 9.1, organizadas por colunas.

#### `room_table_9_2.dart`
Classe estática que contém todas as tabelas da Tabela 9.2, organizadas por colunas.

### 4. Mappers (`lib/mappers/`)

#### `dungeon_mapper.dart`
Responsável por converter entre DTOs e modelos:
- `DungeonMapper.fromDto()` - Converte DungeonGenerationDto para Dungeon
- `DungeonMapper.fromRoomDto()` - Converte RoomGenerationDto para Room

### 5. Gerador Refatorado (`lib/services/`)

#### `dungeon_generator_refactored.dart`
Nova implementação do gerador com:
- Separação clara de responsabilidades
- Uso de enums e DTOs
- Código mais legível e manutenível
- Mantém todas as regras de negócio originais

## Benefícios da Refatoração

### 1. **Estrutura Mais Profissional**
- Separação clara entre dados (enums), lógica de negócio (tabelas) e apresentação (mappers)
- Uso de DTOs para transferência de dados
- Código mais modular e testável

### 2. **Manutenibilidade**
- Mudanças nas tabelas são feitas apenas nos enums correspondentes
- Lógica de geração separada da lógica de apresentação
- Código mais fácil de entender e modificar

### 3. **Extensibilidade**
- Fácil adição de novas tabelas
- Estrutura preparada para futuras funcionalidades
- Padrão consistente para todo o código

### 4. **Type Safety**
- Uso de enums elimina erros de string
- Compilador verifica tipos em tempo de compilação
- Menos bugs relacionados a strings incorretas

## Como Usar

### Uso Básico
```dart
final generator = DungeonGeneratorRefactored();
final dungeon = generator.generate(
  level: 3,
  theme: 'Recuperar artefato',
);
```

### Com Parâmetros Avançados
```dart
final dungeon = generator.generate(
  level: 5,
  theme: 'Explorar ruínas',
  customRoomCount: 8,
  minRooms: 6,
  maxRooms: 12,
);
```

## Comparação com o Código Original

### Antes (Código Original)
- Tudo em uma única classe gigante
- Strings hardcoded espalhadas pelo código
- Lógica de geração misturada com lógica de apresentação
- Difícil de manter e estender

### Depois (Código Refatorado)
- Estrutura modular e organizada
- Enums para type safety
- DTOs para transferência de dados
- Mappers para conversão
- Código mais limpo e profissional

## Regras de Negócio Mantidas

Todas as regras de negócio foram preservadas:
- Rolagem de 2d6 para cada coluna
- Modificadores de tesouro (+1 para armadilhas, +2 para monstros)
- Resolução de referências especiais (Especial…, Especial 2…, etc.)
- Fórmulas de tamanho de masmorra
- Substituição de ocupantes nos rumores
- Todas as tabelas e suas relações

## Estrutura de Arquivos

```
lib/
├── enums/
│   ├── dungeon_tables.dart
│   └── room_tables.dart
├── models/
│   ├── dto/
│   │   └── dungeon_generation_dto.dart
│   ├── dungeon.dart
│   └── room.dart
├── mappers/
│   └── dungeon_mapper.dart
├── services/
│   ├── tables/
│   │   ├── dungeon_table_9_1.dart
│   │   └── room_table_9_2.dart
│   ├── dungeon_generator.dart (original)
│   ├── dungeon_generator_refactored.dart (novo)
│   └── dungeon_generator_example.dart
└── utils/
    ├── dice_roller.dart
    └── treasure_resolver.dart
```

## Próximos Passos

1. **Testes**: Implementar testes unitários para cada componente
2. **Validação**: Adicionar validação de dados nos DTOs
3. **Documentação**: Adicionar documentação mais detalhada
4. **Performance**: Otimizar se necessário
5. **Extensibilidade**: Preparar para futuras tabelas

## Conclusão

A refatoração mantém 100% da funcionalidade original enquanto melhora significativamente a estrutura do código, tornando-o mais profissional, manutenível e extensível. 