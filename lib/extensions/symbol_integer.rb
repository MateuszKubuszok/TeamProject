# Pozwala konwertować symbole (i idp. im stringi) na liczby i odwrotnie.
#
# Wymaga umieszczenia w kodzie klasy na początku:
#   extend SymbolInteger
# a następnie wywołania funkcji define_symbols zanim użyjemy którejś z innych metod dołączonych przez klasę dla danego powiązania.
module SymbolInteger
  # Definiuje powiązanie liczb z symbolami dla danego "uchwytu" (symbolu).
  #
  # @param [class]  klass     klasa, dla której pobieramy powiązania
  # @param [symbol] list_name uchwyt do powiązania
  # @param [array]  array     tablica zawierająca liczy jako indeksy i symbole jako wartości
  def _define_symbols klass, list_name, array
    klass.symbol_list_collection ||= {}

    symbols = {}
    if !array.respond_to? :each
      symbols = { 1 => array }
    elsif array.respond_to? :each_index
      array.each_index { |index| symbols[index+1] = array[index] }
    elsif array.respond_to? :each_pair
      symbols = array
    end

    symbol_list_collection[list_name] = symbols
  end

  # Zwraca liczbę dla danego symbolu.
  #
  # @param  [class]   klass     klasa, dla której pobieramy powiązania
  # @param  [symbol]  list_name uchwyt do powiązania
  # @param  [integer] int       liczba do skonwertowania
  # @return [symbol]            symbol
  def _int2symbol klass, list_name, int
    klass.symbol_list_collection[list_name].blank? ? 0 : klass.symbol_list_collection[list_name][int]
  end

  # Zwraca symbol dla danej liczby.
  #
  # @param  [class]   klass     klasa, dla której pobieramy powiązania
  # @param  [symbol]  list_name uchwyt do powiązania
  # @param  [symbol]  _symbol   liczba do skonwertowania
  # @return [integer]           liczba
  def _symbol2int klass, list_name, _symbol
    return 0 if klass.symbol_list_collection[list_name].blank?
    int = klass.symbol_list_collection[list_name].key _symbol.to_sym
    int.nil? ? 0 : int
  end

  # Zwraca listę symboli
  #
  # @param  [class]   klass     klasa, dla której pobieramy powiązania
  # @param  [symbol]  list_name uchwyt do powiązania
  # @return [array]             lista symboli
  def _symbols klass, list_name
    klass.symbol_list_collection[list_name].blank? ? {} : klass.symbol_list_collection[list_name].values
  end

  # Zwraca łączną liczbę powiązań dla danego uchwytu.
  #
  # @param  [class]   klass     klasa, dla której pobieramy powiązania
  # @param  [symbol]  list_name uchwyt do powiązania
  # @return [integer]           liczba powiązań
  def _symbols_quantity klass, list_name
    klass.symbol_list_collection[list_name].blank? ? 0 : klass.symbol_list_collection[list_name].count
  end

  # Tworzy getter i setter pól symboli pola intów.
  #
  # @param  [class]   klass             klasa, dla której pobieramy powiązania
  # @param  [symbol]  symbol_field_name nazwa gettera/settera symboli
  # @param  [symbol]  field_name        nazwa pola intów
  # @param  [symbol]  list_name         uchwyt do powiązania
  def _sym_accessor klass, symbol_field_name, field_name, list_name
    # Tworzy getter symboli symbol_field_name dla pola field_name.
    #
    # @return [symbol] symbol z listy list_name
    define_method symbol_field_name do
      klass.int2symbol(list_name, read_attribute(field_name))
    end

    # Tworzy setter symboli symbol_field_name dla pola field_name.
    #
    # @param [symbol] value symbol z listy list_name
    define_method (symbol_field_name.to_s+"=").to_sym do |value|
      write_attribute(field_name, klass.symbol2int(list_name, value))
    end
  end
end

# Skraca zapis.
#
# Zamienia:
#   _define_symbols   self, list_name, array
#   _int2symbol       self, list_name, int
#   _symbol2int       self, list_name, symbol
#   _symbols          self, list_name
#   _symbols_quantity self, list_name
#   _sym_accessor     self, symbol_field_name, field_name, list_name
# na:
#   define_symbols    list_name, array
#   int2symbol        list_name, int
#   symbol2int        list_name, symbol
#   symbols           list_name
#   symbols_quantity  list_name
#   sym_accessor      symbol_field_name, field_name, list_name
class ActiveRecord::Base
  class << self
    attr_accessor :symbol_list_collection
  end

  define_singleton_method(:define_symbols)    { |list_name, array| _define_symbols self, list_name, array }
  define_singleton_method(:int2symbol)        { |list_name, int| _int2symbol self, list_name, int }
  define_singleton_method(:symbol2int)        { |list_name, symbol| _symbol2int self, list_name, symbol }
  define_singleton_method(:symbols)           { |list_name| _symbols self, list_name }
  define_singleton_method(:symbols_quantity)  { |list_name| _symbols_quantity self, list_name }
  define_singleton_method(:sym_accessor)      { |symbol_field_name, field_name, list_name| _sym_accessor self, symbol_field_name, field_name, list_name }
end