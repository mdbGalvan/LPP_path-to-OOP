require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClasses < EdgeCase::Koan
  class Dog
  end

  def test_instances_of_classes_can_be_created_with_new
    fido = Dog.new
    assert_equal Dog, fido.class # fido es de la clase Dog
  end

  # ------------------------------------------------------------------

  class Dog2
    def set_name(a_name)
      @name = a_name
    end
  end

  def test_instance_variables_can_be_set_by_assigning_to_them
    fido = Dog2.new
    assert_equal [], fido.instance_variables # No tiene atributos inicializado

    fido.set_name("Fido")
    # Ya se ha inicializado "name" con el setter set_name
    assert_equal [:@name], fido.instance_variables 
  end

  def test_instance_variables_cannot_be_accessed_outside_the_class
    fido = Dog2.new
    fido.set_name("Fido")

    assert_raise(NoMethodError) do # No está definido el método name
      fido.name
    end

    assert_raise(SyntaxError) do
      eval "fido.@name"
      # NOTA: Usando eval debido a que la línea de arriba es un syntax error.
    end
  end

  def test_you_can_politely_ask_for_instance_variable_values
    fido = Dog2.new
    fido.set_name("Fido")

    # @name = "Fido", y con instance_variable_get se obtiene el valor de la variable "@name"
    assert_equal ("Fido"), fido.instance_variable_get("@name") 
  end

  def test_you_can_rip_the_value_out_using_instance_eval
    fido = Dog2.new
    fido.set_name("Fido")

    assert_equal ("Fido"), fido.instance_eval("@name")  # string version
    assert_equal ("Fido"), fido.instance_eval { @name } # block version
  end

  # ------------------------------------------------------------------

  class Dog3
    def set_name(a_name)
      @name = a_name
    end
    def name
      @name
    end
  end

  def test_you_can_create_accessor_methods_to_return_instance_variables
    fido = Dog3.new
    fido.set_name("Fido")

    # Ahora si hay en Dog3 un método name, que es el getter
    assert_equal ("Fido"), fido.name 
  end

  # ------------------------------------------------------------------

  class Dog4 # Igual que Dog3, salvo que getter definido por attr
    attr_reader :name

    def set_name(a_name)
      @name = a_name
    end
  end


  def test_attr_reader_will_automatically_define_an_accessor
    fido = Dog4.new
    fido.set_name("Fido")

    # Hay que poner el valor devuelve del getter del atributo @name
    assert_equal ("Fido"), fido.name
  end

  # ------------------------------------------------------------------

  class Dog5
    attr_accessor :name
  end


  def test_attr_accessor_will_automatically_define_both_read_and_write_accessors
    fido = Dog5.new

    # En Dog5 definido el getter y el setter para @name
    fido.name = "Fido"
    assert_equal ("Fido"), fido.name
  end

  # ------------------------------------------------------------------

  class Dog6
    attr_reader :name
    def initialize(initial_name)
      @name = initial_name
    end
  end

  def test_initialize_provides_initial_values_for_instance_variables
    fido = Dog6.new("Fido")
    # Valor sólo al inicializarlo, no existe setter
    assert_equal ("Fido"), fido.name
  end

  def test_args_to_new_must_match_initialize
    assert_raise(ArgumentError) do
      Dog6.new
    end
    # THINK ABOUT IT:
    # Why is this so? Porque ya hay definido un initialize con un argumento 
    # y se le está pasando ninguno argumento
  end

  def test_different_objects_have_different_instance_variables
    fido = Dog6.new("Fido")
    rover = Dog6.new("Rover")

    # Es verdadero, puesto que ambos valores (usando getter) serán distinto
    assert_equal true, rover.name != fido.name
  end

  # ------------------------------------------------------------------

  class Dog7
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name
    end

    def get_self
      self # El Objeto
    end

    def to_s # Este método devuelve un string
      "#{@name}"
    end

    def inspect
      "<Dog named '#{name}'>"
    end
  end

  def test_inside_a_method_self_refers_to_the_containing_object
    fido = Dog7.new("Fido")

    fidos_self = fido.get_self
    assert_equal (fido), fidos_self # Indica el objeto
  end

  def test_to_s_provides_a_string_version_of_the_object
    fido = Dog7.new("Fido")
    # Devuelve el string representando al objeto
    assert_equal ("Fido"), fido.to_s 
  end

  def test_to_s_is_used_in_string_interpolation
    fido = Dog7.new("Fido")
    # Llama al método de instancia to_s
    assert_equal ("My dog is Fido"), "My dog is #{fido}" 
  end

  def test_inspect_provides_a_more_complete_string_version
    fido = Dog7.new("Fido")
    assert_equal "<Dog named 'Fido'>", fido.inspect
  end

  def test_all_objects_support_to_s_and_inspect
    array = [1,2,3]

    assert_equal ("[1,2,3]"), array.to_s
    assert_equal ("[1,2,3]"), array.inspect

    assert_equal ("STRING"), "STRING".to_s
    assert_equal ("\"STRING\""), "STRING".inspect
  end

end
