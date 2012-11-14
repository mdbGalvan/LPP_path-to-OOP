require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClassMethods < EdgeCase::Koan
  class Dog
  end

  def test_objects_are_objects
    fido = Dog.new
    assert_equal true, fido.is_a?(Object) # Todo es un objeto
  end

  def test_classes_are_classes
    assert_equal true, Dog.is_a?(Class) # Dog es una clase
  end

  def test_classes_are_objects_too
    assert_equal true, Dog.is_a?(Object) # Todo es un objeto
  end

  def test_objects_have_methods
    fido = Dog.new
    # Tiene 64 métodos, puedes comprobar cuales son con: fido.methodos
    assert fido.methods.size > 60
  end

  def test_classes_have_methods
    # Tiene 105 métodos, puedes comprobar cuales son con: Dog.methodos
    assert Dog.methods.size > 100
  end

  def test_you_can_define_methods_on_individual_objects
    fido = Dog.new
    # Método singleton
    def fido.wag
      :fidos_wag
    end
    assert_equal (:fidos_wag), fido.wag
  end

  def test_other_objects_are_not_affected_by_these_singleton_methods
    fido = Dog.new
    rover = Dog.new
    # Método singleton: exclusivo para el objeto fido
    def fido.wag
      :fidos_wag
    end

    # rover no es el objeto fido, por lo cual no puede usar wag
    assert_raise(NoMethodError) do 
      rover.wag
    end
  end

  # ------------------------------------------------------------------
  
  class Dog2
    def wag # Método de instancia: para los objetos de la clase Dog2
      :instance_level_wag
    end
  end

  # Método singleton: del objeto Dog2 (puesto que Dog2 es clase y es objeto)
  def Dog2.wag
    :class_level_wag
  end

  def test_since_classes_are_objects_you_can_define_singleton_methods_on_them_too
    assert_equal (:class_level_wag), Dog2.wag # Método singleton del objeto Dog2
  end

  def test_class_methods_are_independent_of_instance_methods
    fido = Dog2.new
    assert_equal (:instance_level_wag), fido.wag # Método de instancia
    assert_equal (:class_level_wag), Dog2.wag # Método singleton del objeto Dog2
  end

  # ------------------------------------------------------------------

  class Dog
    # Método name=, name de instancia
    attr_accessor :name 
  end
  # Método singleton: para el objeto Dog3
  def Dog.name
    @name # Variable de instancia de clase
  end

  def test_classes_and_instances_do_not_share_instance_variables
    fido = Dog.new
    fido.name = "Fido"
    assert_equal ("Fido"), fido.name
    assert_equal (nil), Dog.name # No fue inicializada
  end

  # ------------------------------------------------------------------

  class Dog
    def Dog.a_class_method # Método de clase
      :dogs_class_method
    end
  end

  def test_you_can_define_class_methods_inside_the_class
    assert_equal (:dogs_class_method), Dog.a_class_method
  end
      

  # ------------------------------------------------------------------

  LastExpressionInClassStatement = class Dog
                                     21
                                   end
  
  def test_class_statements_return_the_value_of_their_last_expression
    assert_equal (21), LastExpressionInClassStatement
  end

  # ------------------------------------------------------------------

  SelfInsideOfClassStatement = class Dog
                                 self # Clase
                               end

  def test_self_while_inside_class_is_class_object_not_instance
    assert_equal true, Dog == SelfInsideOfClassStatement
  end

  # ------------------------------------------------------------------

  class Dog
    def self.class_method2 # Método de clase
      :another_way_to_write_class_methods
    end
  end

  def test_you_can_use_self_instead_of_an_explicit_reference_to_dog
    assert_equal (:another_way_to_write_class_methods), Dog.class_method2
  end

  # ------------------------------------------------------------------

  class Dog
    class << self
      def another_class_method # Método de clase
        :still_another_way
      end
    end
  end

  def test_heres_still_another_way_to_write_class_methods
    assert_equal (:still_another_way), Dog.another_class_method
  end

  # THINK ABOUT IT:
  #
  # The two major ways to write class methods are:
  #   class Demo
  #     def self.method
  #     end
  #
  #     class << self
  #       def class_methods
  #       end
  #     end
  #   end
  #
  # Which do you prefer and why? Prefiero, la segunda. Ya que así
  # las defino todas juntas. Aunque veo la primera más intuitiva, ya que 
  # no tienes que ir andando buscando << self, y en todo, momento sabes
  # si la self pertenece al objeto o a la clase.
  # Are there times you might prefer one over the other? No

  # ------------------------------------------------------------------

  def test_heres_an_easy_way_to_call_class_methods_from_instance_methods
    fido = Dog.new
    assert_equal (:still_another_way), fido.class.another_class_method
  end

end
