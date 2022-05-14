import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/services/pokemon_service.dart';

class MockPokemonService extends Mock implements PokemonService {}

void main() {
  late PokemonProvider sut;
  late MockPokemonService mockPokemonService;

  setUp(() {
    mockPokemonService = MockPokemonService();
    sut = PokemonProvider(mockPokemonService);
  });

  test("Initial values are correct", () {
    expect(sut.pokemons, []);
    expect(sut.favoritePokemons, []);
    expect(sut.isLoading, false);
    expect(sut.errorResponse, null);
  });

  group('getPokemons', () {
    final pokemonsFromService = [
      Pokemon(name: "Test1", url: apiBaseUrl + "/pokemon/1"),
      Pokemon(name: "Test2", url: apiBaseUrl + "/pokemon/2"),
      Pokemon(name: "Test3", url: apiBaseUrl + "/pokemon/3"),
      Pokemon(name: "Test4", url: apiBaseUrl + "/pokemon/4")
    ];

    void arrangePokemonServiceReturns4Pokemons() {
      when(() => mockPokemonService.getPokemons(0, 4))
          .thenAnswer((_) async => pokemonsFromService);
    }

    test("gets pokemons using the PokemonService", () async {
      arrangePokemonServiceReturns4Pokemons();
      await sut.getPokemons(page: 1, limit: 4);
      verify(() => mockPokemonService.getPokemons(0, 4)).called(1);
    });

    test("""get pokemons indicates loading of data, 
        sets pokemons to the ones from the service,
        indicates that the data is not being loaded anymore""", () async {
      arrangePokemonServiceReturns4Pokemons();
      final future = sut.getPokemons(page: 1, limit: 4);
      expect(sut.isLoading, true);
      await future;
      expect(sut.pokemons, pokemonsFromService);
      expect(sut.isLoading, false);
      verify(() => mockPokemonService.getPokemons(0, 4)).called(1);
    });
  });
}
