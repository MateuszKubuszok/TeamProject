# Pozwala na generowanie metod dostępu do poszczególnych bitów danego pola poprzez symbole.
#
# Wykorzystuje moduł SymbolInteger.
#
# Wymaga umieszczenia w kodzie klasy na początku:
#   extend  SymbolInteger
#   extend  MultipleBoolField
# następnie utworzenia listy symboli metodą:
#   define_symbols [ ..symbole.. ]
# a na końcu:
#   bool_accessors :lista, :pole_z_bitami
module MultipleBoolField
  # Tworzy metody bitów danego pola.
  #
  # @param [class]  klass       klasa, którą rozszerzamy
  # @param [symbol] source      nazwa listy symboli modułu SymbolInteger
  # @param [symbol] field_name  nazwa pola dla którego bitów tworzymy metody
  def bool_accessors_for klass, source, field_name
    _get_int_for_source             = "get_int_for_#{source.to_s}".to_sym
    _add_to_field_with_source       = "add_to_#{field_name.to_s}_with_#{source.to_s}".to_sym
    _delete_from_field_with_source  = "delete_from_#{field_name.to_s}_with_#{source.to_s}".to_sym
    _get_field_with_source          = "get_#{field_name.to_s}_with_#{source.to_s}".to_sym
    _set_field_with_source          = "set_#{field_name.to_s}_with_#{source.to_s}".to_sym

    # Ustala liczbę odpowadającą pozycji bitu w zapisie binarnym.
    #
    # @param  [symbol]  bool_name   nazwa bitu, który ustalamy
    # @return [integer]             liczba
    define_method _get_int_for_source do |bool_name|
      2**(klass.symbol2int(source, bool_name)-1)
    end

    # Zapala określony bit danego pola.
    #
    # @param [symbol] bool_name   nazwa bitu, który zapalamy
    define_method _add_to_field_with_source do |bool_name|
      get_int_for_source = method _get_int_for_source
      self[field_name] = (self[field_name] | get_int_for_source.call(bool_name))
    end

    # Gasi określony bit danego pola.
    #
    # @param [symbol] bool_name   nazwa bitu, który gasimy
    define_method _delete_from_field_with_source do |bool_name|
      get_int_for_source = method _get_int_for_source
      value = get_int_for_source.call bool_name
      self[field_name] = (self[field_name] ^ value) if (self[field_name] & value) > 0
    end

    # Pobiera określony bit danego pola.
    #
    # @param  [symbol]  bool_name   nazwa bitu, który pobieramy
    # @return [boolean]             true jeśli bit jest zapalony
    define_method _get_field_with_source do |bool_name|
      self[field_name] ||= 0
      get_int_for_source = method _get_int_for_source
      (self[field_name] & get_int_for_source.call(bool_name)) > 0
    end

    # Ustawia określony bit danego pola.
    #
    # @param [symbol] bool_name   nazwa bitu, który ustawiamy
    define_method _set_field_with_source do |bool_name, value|
      self[field_name] ||= 0
      if value == true || value == "1"
        add_to_field_with_source = method _add_to_field_with_source
        add_to_field_with_source.call bool_name
      else
        delete_from_field_with_source = method _delete_from_field_with_source
        delete_from_field_with_source.call bool_name
      end
    end

    klass.symbols(source).each do |_bool_name|
      # Pobiera wartość bitu.
      #
      # @return [boolean] true jeśli bit jest zapalony
      define_method _bool_name do
        get_field_with_source = method _get_field_with_source
        get_field_with_source.call _bool_name
      end

      # Ustala wartość bitu.
      #
      # @param [boolean] true jeśli bit ma zostać zapalony
      define_method (_bool_name.to_s+"=") do |value|
        set_field_with_source = method _set_field_with_source
        set_field_with_source.call _bool_name, value
      end
    end
  end
end

# Skraca zapis.
#
# Zamienia:
#   bool_accessors_for self, source, bool_name
# na:
#   bool_accessors source, bool_name
class ActiveRecord::Base
  define_singleton_method :bool_accessors do |source, bool_name|
    bool_accessors_for self, source, bool_name
  end
end